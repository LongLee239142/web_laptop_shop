package vn.longlee.laptopshop.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import vn.longlee.laptopshop.domain.Product;
import java.util.List;

//crud: create, read, update, delete
@Repository
public interface ProductRepository extends JpaRepository<Product, Long>,
    JpaSpecificationExecutor<Product> {

  Product save(Product mrLee);

  void deleteById(long id);

  Product findById(long id); // null

  Page<Product> findAll(Pageable page);

  Page<Product> findAll(Specification<Product> spec,Pageable page);
}
