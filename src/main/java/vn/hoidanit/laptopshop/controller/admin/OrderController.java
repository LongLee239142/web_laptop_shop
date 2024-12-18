package vn.hoidanit.laptopshop.controller.admin;

import java.util.List;
import java.util.Optional;

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

import jakarta.validation.Valid;
import vn.hoidanit.laptopshop.domain.Order;
import vn.hoidanit.laptopshop.domain.OrderDetail;
import vn.hoidanit.laptopshop.service.OrderDetailService;
import vn.hoidanit.laptopshop.service.OrderService;

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

        } catch (Exception e) {
            // TODO: handle exception
        }
        Pageable pageable = PageRequest.of(page - 1, 5);
        Page<Order> orders = this.orderService.getAllOrders(pageable);
        List<Order> listOrders = orders.getContent();
        model.addAttribute("orders", listOrders);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPage", orders.getTotalPages());
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
    public String postDeleteUser(Model model, @ModelAttribute("newOrder") Order order) {
        Order curOrder = this.orderService.getOrderById(order.getId());
        for (OrderDetail orderDetail : curOrder.getOrderDetails()) {
            this.orderDetailService.deleteOrderDetailById(orderDetail.getId());
        }
        this.orderService.deleteOrderById(order.getId());
        return "redirect:/admin/order";
    }
}
