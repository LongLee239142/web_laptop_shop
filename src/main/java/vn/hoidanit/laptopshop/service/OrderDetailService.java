package vn.hoidanit.laptopshop.service;

import java.util.List;
import org.springframework.stereotype.Service;

import vn.hoidanit.laptopshop.domain.Order;
import vn.hoidanit.laptopshop.domain.OrderDetail;
import vn.hoidanit.laptopshop.repository.OrderDetailRepository;

@Service
public class OrderDetailService {
    public final OrderDetailRepository orderDetailRepository;

    public OrderDetailService(OrderDetailRepository orderDetailRepository) {
        this.orderDetailRepository = orderDetailRepository;
    }

    public List<OrderDetail> getAllOrders() {
        return this.orderDetailRepository.findAll();
    }

    public OrderDetail getOrderById(long id) {
        return this.orderDetailRepository.findById(id);
    }

    public void deleteOrderDetailById(long id) {
        this.orderDetailRepository.deleteById(id);
    }

    public List<OrderDetail> fetchByOrder(Order order) {
        return this.orderDetailRepository.findByOrder(order);
    }

}
