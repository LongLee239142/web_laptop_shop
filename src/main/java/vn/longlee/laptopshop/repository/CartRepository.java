package vn.longlee.laptopshop.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import vn.longlee.laptopshop.domain.Cart;
import vn.longlee.laptopshop.domain.User;

@Repository
public interface CartRepository extends JpaRepository<Cart, Long> {
    Cart findByUser(User user);

    List<Cart> findProductByUser(User user);

}
