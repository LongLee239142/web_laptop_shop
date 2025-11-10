package vn.longlee.laptopshop.controller.client;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import vn.longlee.laptopshop.domain.User;
import vn.longlee.laptopshop.entity.PasswordResetToken;
import vn.longlee.laptopshop.service.PasswordResetService;
import vn.longlee.laptopshop.service.UserService;

@Controller
public class PasswordResetController {

    @Autowired
    private PasswordResetService passwordResetService;

    @Autowired
    private UserService userService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("/forgot-password")
    public String showForgotPasswordPage() {
        return "client/auth/forgot-password";
    }

    @PostMapping("/forgot-password")
    public String processForgotPassword(
            @RequestParam("email") String email,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {

        User user = userService.getUserByEmail(email);
        if (user == null) {
            // Không tiết lộ thông tin user có tồn tại hay không (bảo mật)
            redirectAttributes.addFlashAttribute("message",
                    "Không tồn tại người dùng với email đã gửi!");
            return "redirect:/forgot-password";
        }

        // Tạo base URL
        String baseUrl = request.getRequestURL().toString().replace(request.getRequestURI(), "");
        
        // Tạo token và gửi email
        passwordResetService.createPasswordResetTokenForUser(user, baseUrl);

        redirectAttributes.addFlashAttribute("message",
                "Chúng tôi đã gửi liên kết khôi phục mật khẩu đến email của bạn. Vui lòng kiểm tra hộp thư.");

        return "redirect:/forgot-password";
    }

    @GetMapping("/reset-password")
    public String showResetPasswordPage(
            @RequestParam("token") String token,
            Model model,
            RedirectAttributes redirectAttributes) {

        Optional<PasswordResetToken> resetToken = passwordResetService.getToken(token);

        if (resetToken.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Liên kết khôi phục mật khẩu không hợp lệ.");
            return "redirect:/forgot-password";
        }

        PasswordResetToken tokenEntity = resetToken.get();

        if (!passwordResetService.validateToken(tokenEntity)) {
            redirectAttributes.addFlashAttribute("error", "Liên kết khôi phục mật khẩu đã hết hạn hoặc đã được sử dụng.");
            return "redirect:/forgot-password";
        }

        model.addAttribute("token", token);
        return "client/auth/reset-password";
    }

    @PostMapping("/reset-password")
    public String processResetPassword(
            @RequestParam("token") String token,
            @RequestParam("password") String password,
            @RequestParam("confirmPassword") String confirmPassword,
            RedirectAttributes redirectAttributes) {

        // Validate password
        if (password == null || password.length() < 6) {
            redirectAttributes.addFlashAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự.");
            redirectAttributes.addFlashAttribute("token", token);
            return "redirect:/reset-password?token=" + token;
        }

        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "Mật khẩu xác nhận không khớp.");
            redirectAttributes.addFlashAttribute("token", token);
            return "redirect:/reset-password?token=" + token;
        }

        Optional<PasswordResetToken> resetToken = passwordResetService.getToken(token);

        if (resetToken.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Liên kết khôi phục mật khẩu không hợp lệ.");
            return "redirect:/forgot-password";
        }

        PasswordResetToken tokenEntity = resetToken.get();

        if (!passwordResetService.validateToken(tokenEntity)) {
            redirectAttributes.addFlashAttribute("error", "Liên kết khôi phục mật khẩu đã hết hạn hoặc đã được sử dụng.");
            return "redirect:/forgot-password";
        }

        // Cập nhật mật khẩu
        User user = tokenEntity.getUser();
        String hashedPassword = passwordEncoder.encode(password);
        user.setPassword(hashedPassword);
        userService.handleSaveUser(user);

        // Đánh dấu token đã sử dụng
        passwordResetService.markTokenAsUsed(tokenEntity);

        redirectAttributes.addFlashAttribute("success", "Mật khẩu đã được đặt lại thành công. Vui lòng đăng nhập.");
        return "redirect:/login";
    }
}


