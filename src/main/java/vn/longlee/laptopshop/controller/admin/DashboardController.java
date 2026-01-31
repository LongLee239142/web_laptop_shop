package vn.longlee.laptopshop.controller.admin;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import vn.longlee.laptopshop.service.OrderService;
import vn.longlee.laptopshop.service.ProductService;
import vn.longlee.laptopshop.service.UserService;

@Controller
public class DashboardController {
    private static final int RECENT_ORDERS_LIMIT = 10;
    /** Ngưỡng 1 tỷ VND: từ đây trở lên hiển thị dạng "X.XX tỷ đ". */
    private static final double ONE_BILLION = 1_000_000_000;

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
        double totalRevenue = this.orderService.getTotalRevenue();
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("revenueDisplay", formatRevenueDisplay(totalRevenue));
        model.addAttribute("revenueFull", formatRevenueFull(totalRevenue));
        model.addAttribute("recentOrders", this.orderService.getRecentOrders(RECENT_ORDERS_LIMIT));
        return "admin/dashboard/show";
    }

    /**
     * Chuỗi hiển thị doanh thu: nếu >= 1 tỷ thì dạng "X.XX tỷ đ", còn lại dạng "X,XXX,XXX đ".
     */
    private String formatRevenueDisplay(double amount) {
        if (amount >= ONE_BILLION) {
            return String.format(Locale.US, "%.2f tỷ đ", amount / ONE_BILLION);
        }
        DecimalFormat df = new DecimalFormat("#,##0", new DecimalFormatSymbols(Locale.US));
        return df.format(Math.round(amount)) + " đ";
    }

    /**
     * Chuỗi đầy đủ (số có dấu phẩy) dùng cho tooltip.
     */
    private String formatRevenueFull(double amount) {
        DecimalFormat df = new DecimalFormat("#,##0", new DecimalFormatSymbols(Locale.US));
        return df.format(Math.round(amount));
    }
}
