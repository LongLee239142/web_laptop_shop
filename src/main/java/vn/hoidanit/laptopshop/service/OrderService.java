package vn.hoidanit.laptopshop.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import vn.hoidanit.laptopshop.domain.Order;
import vn.hoidanit.laptopshop.domain.User;
import vn.hoidanit.laptopshop.repository.OrderRepository;

@Service
public class OrderService {
    public final OrderRepository orderRepository;

    public OrderService(OrderRepository orderRepository) {
        this.orderRepository = orderRepository;
    }

    public List<Order> getAllOrders() {
        return this.orderRepository.findAll();
    }

    public Page<Order> getAllOrders(Pageable page) {
        return this.orderRepository.findAll(page);
    }

    public Order getOrderById(long id) {
        return this.orderRepository.findById(id);
    }

    public Order handleSaveOrder(Order order) {
        Order newOrder = this.orderRepository.save(order);
        return newOrder;
    }

    public void deleteOrderById(long id) {
        this.orderRepository.deleteById(id);
    }

    public List<Order> fetchByUser(User user) {
        return this.orderRepository.findByUser(user);
    }
}
