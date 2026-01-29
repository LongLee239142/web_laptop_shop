package vn.longlee.laptopshop.controller.client;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import vn.longlee.laptopshop.domain.User;
import vn.longlee.laptopshop.service.ImageService;
import vn.longlee.laptopshop.service.UploadService;
import vn.longlee.laptopshop.service.UserService;

@Controller
public class AccountController {
    private final UserService userService;
    private final UploadService uploadService;
    private final ImageService imageService;

    public AccountController(UserService userService, UploadService uploadService, ImageService imageService) {
        this.userService = userService;
        this.uploadService = uploadService;
        this.imageService = imageService;
    }

    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()
                && !"anonymousUser".equals(authentication.getName())) {
            String email = authentication.getName();
            return userService.getUserByEmail(email);
        }
        return null;
    }

    @GetMapping("/account")
    public String getProfilePage(Model model) {
        User user = getCurrentUser();
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", user);
        return "client/account/profile";
    }

    @GetMapping("/account/edit")
    public String getEditPage(Model model) {
        User user = getCurrentUser();
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", user);
        return "client/account/edit";
    }

    @PostMapping("/account/update")
    public String postUpdate(
            @RequestParam("hoidanitFile") MultipartFile file,
            @ModelAttribute("user") @Valid User formUser,
            BindingResult bindingResult,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentUser();
        if (currentUser == null) {
            return "redirect:/login";
        }

        if (bindingResult.hasErrors()) {
            if (formUser.getId() == 0) formUser.setId(currentUser.getId());
            if (formUser.getEmail() == null || formUser.getEmail().isEmpty()) formUser.setEmail(currentUser.getEmail());
            if (formUser.getPassword() == null || formUser.getPassword().isEmpty()) formUser.setPassword(currentUser.getPassword());
            if (formUser.getAvatar() == null && currentUser.getAvatar() != null) formUser.setAvatar(currentUser.getAvatar());
            model.addAttribute("user", formUser);
            return "client/account/edit";
        }

        User userToUpdate = userService.getUserById(currentUser.getId());
        if (userToUpdate == null) {
            return "redirect:/account";
        }

        if (!file.isEmpty()) {
            String oldAvatar = userToUpdate.getAvatar();
            if (oldAvatar != null && !oldAvatar.isEmpty()) {
                imageService.deleteImage(oldAvatar, "avatar");
            }
            String avatar = uploadService.handleSaveUploadFile(file, "avatar");
            if (avatar != null && !avatar.isEmpty()) {
                userToUpdate.setAvatar(avatar);
            }
        } else if (formUser.getAvatar() != null && !formUser.getAvatar().isEmpty()) {
            userToUpdate.setAvatar(formUser.getAvatar());
        }

        userToUpdate.setFullName(formUser.getFullName());
        userToUpdate.setPhone(formUser.getPhone());
        userToUpdate.setAddress(formUser.getAddress());

        userService.handleSaveUser(userToUpdate);

        session.setAttribute("fullName", userToUpdate.getFullName());
        session.setAttribute("avatar", userToUpdate.getAvatar());
        int sum = userToUpdate.getCart() == null ? 0 : userToUpdate.getCart().getSum();
        session.setAttribute("sum", sum);

        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật thông tin thành công!");
        return "redirect:/account";
    }
}
