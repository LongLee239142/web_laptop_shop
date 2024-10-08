package vn.hoidanit.laptopshop.controller.client;

import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import java.util.Optional;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import vn.hoidanit.laptopshop.domain.CartDetail;
import vn.hoidanit.laptopshop.domain.Product;
import vn.hoidanit.laptopshop.domain.User;
import vn.hoidanit.laptopshop.service.ProductService;
import vn.hoidanit.laptopshop.service.UserService;

@Controller
public class ItemController {
    private final ProductService productService;
    private final UserService userService;

    public ItemController(ProductService productService, UserService userService) {
        this.productService = productService;
        this.userService = userService;
    }

    @GetMapping("/product/{id}")
    public String getProductPage(Model model, @PathVariable long id) {
        Product product = this.productService.getProductById(id);
        model.addAttribute("product", product);
        model.addAttribute("id", id);
        return "client/product/detail";
    }

    @PostMapping("/add-product-to-cart/{id}")
    public String addProductToCart(@PathVariable long id, HttpServletRequest request) {
        HttpSession session = request.getSession();
        long productId = id;
        String email = (String) session.getAttribute("email");
        this.productService.handleAddProductToCart(email, productId, session);
        return "redirect:/";
    }

    @GetMapping("/cart")
    public String getCartPage(Model model, HttpServletRequest request) {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        List<CartDetail> cartByUsers = this.productService.getProductInCart(email);
        double totalPrice = 0;
        for (CartDetail cd : cartByUsers) {
            totalPrice += cd.getPrice() * cd.getQuantity();
        }
        model.addAttribute("cartByUsers", cartByUsers);
        model.addAttribute("totalPrice", totalPrice);
        return "client/cart/showcart";
    }

    @PostMapping("/delete-cart-product/{id}")
    public String deleteCartDetail(@PathVariable long id, HttpServletRequest request) {
        HttpSession session = request.getSession();

        String email = (String) session.getAttribute("email");
        User user = this.userService.getUserByEmail(email);

        this.productService.deleteAProductToCart(id, email);

        Optional<List<CartDetail>> cartDetailsOptional = this.productService
                .getProductByICartDetail(user.getCart().getId());

        if (cartDetailsOptional.isPresent()) {
            List<CartDetail> cartDetails = cartDetailsOptional.get();
            int productCount = cartDetails.size();
            user.getCart().setSum(productCount);
            session.setAttribute("sum", productCount);
            if (productCount == 0) {
                this.productService.deleteCartId(user.getCart().getId());
            }
        }

        return "redirect:/cart";
    }

}
