package vn.longlee.laptopshop.domain;

import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * Entity ánh xạ bảng products.
 * Quan hệ: Product (1) ----< CartDetail (N) và OrderDetail (N); FK nằm ở cart_detail.product_id, order_detail.product_id.
 */
@Entity
@Table(name = "products")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Size(min = 2, message = "Name Product cannot be empty")
    private String name;

    @DecimalMin(value = "0.0", inclusive = false, message = "Price must be greater than zero")
    @NotNull(message = "Price cannot be null")
    private double price;

    private String image;

    @NotNull
    @NotEmpty(message = "Cannot be empty")
    @Column(columnDefinition = "MEDIUMTEXT")
    private String detailDesc;

    @Size(min = 2, message = " Cannot be empty")
    private String shortDesc;

    @NotNull(message = "Quantity cannot be null")
    @DecimalMin(value = "0", inclusive = false, message = "Quantity must be greater than zero")
    private long quantity;

    private long sold;
    private String factory;
    private String target;

    /** 1-N với CartDetail: FK product_id nằm ở bảng cart_detail, nên dùng mappedBy */
    @OneToMany(mappedBy = "product")
    private List<CartDetail> cartDetails;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getDetailDesc() {
        return detailDesc;
    }

    public void setDetailDesc(String detailDesc) {
        this.detailDesc = detailDesc;
    }

    public String getShortDesc() {
        return shortDesc;
    }

    public void setShortDesc(String shortDesc) {
        this.shortDesc = shortDesc;
    }

    public long getQuantity() {
        return quantity;
    }

    public void setQuantity(long quantity) {
        this.quantity = quantity;
    }

    public long getSold() {
        return sold;
    }

    public void setSold(long sold) {
        this.sold = sold;
    }

    public String getFactory() {
        return factory;
    }

    public void setFactory(String factory) {
        this.factory = factory;
    }

    public String getTarget() {
        return target;
    }

    public void setTarget(String target) {
        this.target = target;
    }

    @Override
    public String toString() {
        return "Product [id=" + id + ", name=" + name + ", price=" + price + ", image=" + image + ", detailDesc="
                + detailDesc + ", shortDesc=" + shortDesc + ", quantity=" + quantity + ", sold=" + sold + ", factory="
                + factory + ", target=" + target + "]";
    }

    public List<CartDetail> getCartDetails() {
        return cartDetails;
    }

    public void setCartDetails(List<CartDetail> cartDetails) {
        this.cartDetails = cartDetails;
    }

}
