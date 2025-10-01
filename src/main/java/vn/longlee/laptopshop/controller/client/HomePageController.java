package vn.longlee.laptopshop.controller.client;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import vn.longlee.laptopshop.domain.Order;
import vn.longlee.laptopshop.domain.Product;
import vn.longlee.laptopshop.domain.User;
import vn.longlee.laptopshop.domain.dto.RegisterDTO;
import vn.longlee.laptopshop.service.OrderService;
import vn.longlee.laptopshop.service.ProductService;
import vn.longlee.laptopshop.service.UserService;

@Controller
public class HomePageController {

    private final ProductService productService;
    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final OrderService orderService;

    public HomePageController(
            ProductService productService,
            UserService userService, OrderService orderService,
            PasswordEncoder passwordEncoder) {
        this.productService = productService;
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
        this.orderService = orderService;
    }

    @GetMapping("/")
    public String getHomePage(Model model, HttpServletRequest request) {
        Pageable pageable = PageRequest.of(0, 8);
        Page<Product> products = this.productService.getAllProducts(pageable);
        List<Product> listProducts = products.getContent();
        model.addAttribute("products", listProducts);
        // HttpSession session = request.getSession();
        return "client/homepage/show";
    }

    @GetMapping("/register")
    public String getRegisterPage(Model model) {
        model.addAttribute("registerUser", new RegisterDTO());
        return "client/auth/register";
    }

    @PostMapping("/register")
    public String handleRegister(
            @ModelAttribute("registerUser") @Valid RegisterDTO registerDTO,
            BindingResult bindingResult,
            RedirectAttributes redirectAttributes,
            Model model) {

        // validate
        if (bindingResult.hasErrors()) {
            return "client/auth/register";
        }

        User user = this.userService.registerDTOtoUser(registerDTO);

        String hashPassword = this.passwordEncoder.encode(user.getPassword());

        user.setPassword(hashPassword);
        user.setRole(this.userService.getRoleByName("USER"));
        // save
        this.userService.handleSaveUser(user);
        redirectAttributes.addFlashAttribute("registrationSuccess", "Đăng ký tài khoản thành công! Vui lòng đăng nhập để tiếp tục.");
        return "redirect:/login";

    }

    @GetMapping("/login")
    public String getLoginPage(Model model) {

        return "client/auth/login";
    }

    @PostMapping("/register-alert")
    public String handleRegisterWithAlert(
            @ModelAttribute("registerUser") @Valid RegisterDTO registerDTO,
            BindingResult bindingResult,
            Model model) {

        // validate
        if (bindingResult.hasErrors()) {
            return "client/auth/register";
        }

        User user = this.userService.registerDTOtoUser(registerDTO);

        String hashPassword = this.passwordEncoder.encode(user.getPassword());

        user.setPassword(hashPassword);
        user.setRole(this.userService.getRoleByName("USER"));
        // save
        this.userService.handleSaveUser(user);
        
        // Option 2: Show success message on register page
        model.addAttribute("registrationSuccess", "Đăng ký tài khoản thành công! Vui lòng đăng nhập để tiếp tục.");
        model.addAttribute("registerUser", new RegisterDTO()); // Reset form
        return "client/auth/register";

    }

    @GetMapping("/access-deny")
    public String getDenyPage(Model model) {

        return "client/auth/deny";
    }

    @GetMapping("/order-history")
    public String getOrderHistoryPage(Model model, HttpServletRequest request) {
        User currentUser = new User();// null
        HttpSession session = request.getSession(false);
        long id = (long) session.getAttribute("id");
        currentUser.setId(id);

        List<Order> orders = this.orderService.fetchByUser(currentUser);
        model.addAttribute("orders", orders);

        return "client/cart/order-history";
    }

}
