package vn.longlee.laptopshop.controller.admin;

import java.util.List;
import java.util.Optional;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.validation.Valid;
import vn.longlee.laptopshop.domain.Order;
import vn.longlee.laptopshop.domain.OrderDetail;
import vn.longlee.laptopshop.service.OrderDetailService;
import vn.longlee.laptopshop.service.OrderService;

@Controller
public class OrderController {
    public final OrderService orderService;
    public final OrderDetailService orderDetailService;

    public OrderController(OrderService orderService, OrderDetailService orderDetailService) {
        this.orderService = orderService;
        this.orderDetailService = orderDetailService;
    }

    @GetMapping("/admin/order")
    public String getOrderPage(Model model, @RequestParam("page") Optional<String> pageOptional) {
        int page = 1;
        try {
            if (pageOptional.isPresent()) {
                page = Integer.valueOf(pageOptional.get());
            } else {
                page = 1;
            }

        } catch (NumberFormatException | NullPointerException e) {
            page = 1;
        }
        Pageable pageable = PageRequest.of(page - 1, 5);
        Page<Order> orders = this.orderService.getAllOrders(pageable);
        List<Order> listOrders = orders.getContent();
        int totalPages = Math.max(1, orders.getTotalPages()); // Đảm bảo totalPages >= 1
        model.addAttribute("orders", listOrders);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPage", totalPages);
        return "admin/order/show";
    }

    @GetMapping("/admin/order/{id}")
    public String getUserDetailPage(Model model, @PathVariable int id) {
        Order order = this.orderService.getOrderById(id);
        List<OrderDetail> orderDetails = order.getOrderDetails();
        model.addAttribute("orderDetails", orderDetails);
        model.addAttribute("id", id);
        return "admin/order/detail";
    }

    @GetMapping("/admin/order/update/{id}")
    public String getUserUpdatePage(Model model, @PathVariable int id) {
        Order newOrder = this.orderService.getOrderById(id);
        model.addAttribute("newOrder", newOrder);
        model.addAttribute("id", id);
        return "admin/order/update";
    }

    @PostMapping("/admin/order/update")
    public String postUpdateUser(Model model, @ModelAttribute("newOrder") @Valid Order order,
            BindingResult newProductBindingResult) {
        if (newProductBindingResult.hasErrors()) {
            return "admin/order/update";
        }
        Order currentOrder = this.orderService.getOrderById(order.getId());
        if (currentOrder != null) {
            currentOrder.setStatus(order.getStatus());
        }
        return "redirect:/admin/order";
    }

    @GetMapping("/admin/order/delete/{id}")
    public String getDeleteOrderPage(Model model, @PathVariable long id) {
        model.addAttribute("id", id);
        model.addAttribute("newOrder", new Order());
        return "admin/order/delete";
    }

    @PostMapping("/admin/order/delete")
    public String postDeleteUser(Model model, @ModelAttribute("newOrder") Order order, RedirectAttributes redirectAttributes) {
        try {
            Order curOrder = this.orderService.getOrderById(order.getId());
            for (OrderDetail orderDetail : curOrder.getOrderDetails()) {
                this.orderDetailService.deleteOrderDetailById(orderDetail.getId());
            }
            this.orderService.deleteOrderById(order.getId());
            redirectAttributes.addFlashAttribute("successMessage", "Xóa đơn hàng thành công!");
            return "redirect:/admin/order";
        } catch (DataIntegrityViolationException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể xóa đơn hàng này!");
            return "redirect:/admin/order";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Có lỗi xảy ra khi xóa đơn hàng: " + e.getMessage());
            return "redirect:/admin/order";
        }
    }
}
