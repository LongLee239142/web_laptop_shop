package vn.longlee.laptopshop.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.longlee.laptopshop.domain.Order;
import vn.longlee.laptopshop.domain.OrderDetail;

@Repository
public interface OrderDetailRepository extends JpaRepository<OrderDetail, Long> {
    OrderDetail save(OrderDetail orderDetail);

    void deleteById(long id);

    List<OrderDetail> findAll();

    OrderDetail findById(long id);

    List<OrderDetail> findByOrder(Order order);
}
