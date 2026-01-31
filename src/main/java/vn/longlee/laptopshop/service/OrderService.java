package vn.longlee.laptopshop.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import vn.longlee.laptopshop.domain.Order;
import vn.longlee.laptopshop.domain.User;
import vn.longlee.laptopshop.repository.OrderRepository;

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

    /**
     * Tổng doanh thu từ tất cả đơn hàng.
     */
    public double getTotalRevenue() {
        return getAllOrders().stream()
                .mapToDouble(Order::getTotalPrice)
                .sum();
    }

    /**
     * Danh sách đơn hàng mới nhất (sắp xếp theo id giảm dần).
     *
     * @param limit số lượng đơn hàng cần lấy
     */
    public List<Order> getRecentOrders(int limit) {
        return orderRepository
                .findAll(PageRequest.of(0, limit, Sort.by(Sort.Direction.DESC, "id")))
                .getContent();
    }
}
