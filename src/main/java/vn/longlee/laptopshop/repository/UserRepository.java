package vn.longlee.laptopshop.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.longlee.laptopshop.domain.User;

import java.util.List;

//crud: create, read, update, delete
@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    User save(User mrLee);

    void deleteById(long id);

    List<User> findOneByEmail(String email);

    Page<User> findAll(Pageable page);

    User findById(long id); // null

    boolean existsByEmail(String email);

    User findByEmail(String email);

    List<User> findAll();
}
