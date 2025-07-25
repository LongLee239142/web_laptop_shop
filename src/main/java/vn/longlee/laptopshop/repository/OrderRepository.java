package vn.longlee.laptopshop.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import vn.longlee.laptopshop.domain.Order;
import vn.longlee.laptopshop.domain.User;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    Order save(Order order);

    void deleteById(long id);

    List<Order> findAll();

    Order findById(long id);

    List<Order> findByUser(User user);

    Page<Order> findAll(Pageable page);
}
