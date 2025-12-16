package vn.longlee.laptopshop.controller.admin;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.validation.Valid;
import vn.longlee.laptopshop.domain.User;
import vn.longlee.laptopshop.service.ImageService;
import vn.longlee.laptopshop.service.UploadService;
import vn.longlee.laptopshop.service.UserService;

@Controller
public class UserController {
    private final UserService userService;
    private final UploadService uploadService;
    private final PasswordEncoder PasswordEncoder;
    private final ImageService imageService;

    public UserController(
            UserService userService,
            UploadService uploadService,
            PasswordEncoder PasswordEncoder,
            ImageService imageService) {
        this.userService = userService;
        this.uploadService = uploadService;
        this.PasswordEncoder = PasswordEncoder;
        this.imageService = imageService;
    }

    // Helper method to get current logged-in user
    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            String email = authentication.getName();
            return this.userService.getUserByEmail(email);
        }
        return null;
    }

    @GetMapping("/admin/user")
    public String getUserPage(Model model, @RequestParam("page") Optional<String> pageOptional) {
        int page = 1;
        try {
            if (pageOptional.isPresent()) {
                page = Integer.parseInt(pageOptional.get());
            } else {
                page = 1;
            }

        } catch (NumberFormatException | NullPointerException e) {
            page = 1;
        }
        Pageable pageable = PageRequest.of(page - 1, 5);
        Page<User> users = this.userService.getAllUsers(pageable);
        List<User> listUsers = users.getContent();
        int totalPages = Math.max(1, users.getTotalPages()); // Đảm bảo totalPages >= 1
        model.addAttribute("users1", listUsers);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPage", totalPages);
        return "admin/user/show";
    }

    @GetMapping("/admin/user/{id}")
    public String getUserDetailPage(Model model, @PathVariable long id) {
        User user = this.userService.getUserById(id);
        model.addAttribute("user", user);
        model.addAttribute("id", id);
        return "admin/user/detail";
    }

    @GetMapping("/admin/user/create") // GET
    public String getCreateUserPage(Model model) {
        model.addAttribute("newUser", new User());
        return "admin/user/create";
    }

    @PostMapping(value = "/admin/user/create")
    public String createUserPage(Model model,
            @ModelAttribute("newUser") @Valid User mrlee,
            BindingResult newUserBindingResult,
            @RequestParam("hoidanitFile") MultipartFile file) {
        // validate
        if (newUserBindingResult.hasErrors()) {
            return "admin/user/create";
        }

        String avatar = this.uploadService.handleSaveUploadFile(file, "avatar");
        String hashPassword = this.PasswordEncoder.encode(mrlee.getPassword());
        mrlee.setAvatar(avatar);
        mrlee.setPassword(hashPassword);
        mrlee.setRole(this.userService.getRoleByName(mrlee.getRole().getName()));
        this.userService.handleSaveUser(mrlee);
        // save
        return "redirect:/admin/user";
    }

    @GetMapping("/admin/user/update/{id}") // GET
    public String getUpdateUserPage(Model model, @PathVariable long id) {
        User currentUser = this.userService.getUserById(id);
        model.addAttribute("newUser", currentUser);
        return "admin/user/update";
    }

    @PostMapping("/admin/user/update")
    public String postUpdateUser(Model model, @ModelAttribute("newUser") @Valid User mrlee,
            BindingResult newUserBindingResult,
            @RequestParam("hoidanitFile") MultipartFile file,
            RedirectAttributes redirectAttributes) {
        // validate
        if (newUserBindingResult.hasErrors()) {
            return "admin/user/update";
        }
        
        User currentLoggedInUser = getCurrentUser();
        User currentUser = this.userService.getUserById(mrlee.getId());
        
        if (currentUser != null) {
            // Kiểm tra nếu admin đang cố gắng đổi role của chính mình
            if (currentLoggedInUser != null && currentLoggedInUser.getId() == currentUser.getId()) {
                if (!currentUser.getRole().getName().equals(mrlee.getRole().getName())) {
                    redirectAttributes.addFlashAttribute("errorMessage", "Bạn không thể thay đổi role của chính mình!");
                    return "redirect:/admin/user";
                }
            }
            
            if (!file.isEmpty()) {
                String avatar = this.uploadService.handleSaveUploadFile(file, "avatar");
                currentUser.setAvatar(avatar);
            }
            currentUser.setAddress(mrlee.getAddress());
            currentUser.setFullName(mrlee.getFullName());
            currentUser.setPhone(mrlee.getPhone());
            currentUser.setRole(this.userService.getRoleByName(mrlee.getRole().getName()));

            this.userService.handleSaveUser(currentUser);
            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật người dùng thành công!");
        }
        return "redirect:/admin/user";
    }

    @GetMapping("/admin/user/delete/{id}")
    public String getDeleteUserPage(Model model, @PathVariable long id) {
        model.addAttribute("id", id);
        model.addAttribute("newUser", new User());
        return "admin/user/delete";
    }

    @PostMapping("/admin/user/delete")
    public String postDeleteUser(Model model, @ModelAttribute("newUser") User mrLee,
            RedirectAttributes redirectAttributes) {
        try {
            User currentLoggedInUser = getCurrentUser();
            User userToDelete = this.userService.getUserById(mrLee.getId());
            
            // Kiểm tra nếu admin đang cố gắng xóa chính mình
            if (currentLoggedInUser != null && currentLoggedInUser.getId() == userToDelete.getId()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Bạn không thể xóa tài khoản của chính mình!");
                return "redirect:/admin/user";
            }
            
            this.userService.deleteAUser(userToDelete.getId());
            if(userToDelete.getAvatar() != null){this.imageService.deleteImage(userToDelete.getAvatar(), "avatar");}
            redirectAttributes.addFlashAttribute("successMessage", "Xóa người dùng thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể xóa người dùng: ");
        }
        return "redirect:/admin/user";
    }

}
