package vn.hoidanit.laptopshop.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.hoidanit.laptopshop.domain.Product;
import java.util.List;

//crud: create, read, update, delete
@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

    Product save(Product mrLee);

    void deleteById(long id);

    List<Product> findAll();

    Product findById(long id); // null

    Page<Product> findAll(Pageable page);
}
