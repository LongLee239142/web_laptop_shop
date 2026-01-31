package vn.longlee.laptopshop.domain;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Min;

import java.util.List;

/**
 * Entity ánh xạ bảng carts.
 * Quan hệ: Cart (N) ----> User (1) qua user_id; Cart (1) ----< CartDetail (N) qua mappedBy.
 */
@Entity
@Table(name = "carts")
public class Cart {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Min(value = 0)
    private int sum;

    /** N-1 với User: bảng carts có cột user_id (FK) trỏ tới users.id */
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    /** 1-N với CartDetail: FK cart_id nằm ở bảng cart_detail, nên dùng mappedBy */
    @OneToMany(mappedBy = "cart")
    List<CartDetail> cartDetails;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public int getSum() {
        return sum;
    }

    public void setSum(int sum) {
        this.sum = sum;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<CartDetail> getCartDetails() {
        return cartDetails;
    }

    public void setCartDetails(List<CartDetail> cartDetails) {
        this.cartDetails = cartDetails;
    }

}
