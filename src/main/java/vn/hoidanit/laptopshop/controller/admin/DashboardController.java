package vn.hoidanit.laptopshop.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import vn.hoidanit.laptopshop.service.OrderService;
import vn.hoidanit.laptopshop.service.ProductService;
import vn.hoidanit.laptopshop.service.UserService;

@Controller
public class DashboardController {
    public final OrderService orderService;
    public final ProductService productService;
    public final UserService userService;

    public DashboardController(OrderService orderService, ProductService productService,
            UserService userService) {
        this.orderService = orderService;
        this.productService = productService;
        this.userService = userService;
    }

    @GetMapping("/admin")
    public String getDashboard(Model model) {
        model.addAttribute("countUser", this.userService.getAllUsers().size());
        model.addAttribute("countProduct", this.productService.getAllProducts().size());
        model.addAttribute("countOrder", this.orderService.getAllOrders().size());
        return "admin/dashboard/show";
    }
}
