package vn.longlee.laptopshop.controller.client;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import java.util.Optional;
import org.springframework.data.domain.Sort;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import vn.longlee.laptopshop.domain.Cart;
import vn.longlee.laptopshop.domain.CartDetail;
import vn.longlee.laptopshop.domain.Product;
import vn.longlee.laptopshop.domain.Product_;
import vn.longlee.laptopshop.domain.User;
import vn.longlee.laptopshop.domain.dto.ProductCriteriaDTO;
import vn.longlee.laptopshop.service.ProductService;
import vn.longlee.laptopshop.service.UserService;
import vn.longlee.laptopshop.service.VNPayService;
import vn.longlee.laptopshop.service.MoMoService;

@Controller
public class ItemController {
    private final ProductService productService;
    private final UserService userService;
    private final VNPayService vnPayService;
    private final MoMoService moMoService;

    public ItemController(ProductService productService, UserService userService, VNPayService vnPayService, MoMoService moMoService) {
        this.productService = productService;
        this.userService = userService;
        this.vnPayService = vnPayService;
        this.moMoService = moMoService;
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
        this.productService.handleAddProductToCart(email, productId, session, 1);
        return "redirect:/";
    }

    @GetMapping("/cart")
    public String getCartPage(Model model, HttpServletRequest request) {
        User currentUser = new User();// null
        HttpSession session = request.getSession(false);
        long id = (long) session.getAttribute("id");
        currentUser.setId(id);
        Cart cart = this.productService.fetchByUser(currentUser);
        List<CartDetail> cartDetails = cart == null ? new ArrayList<CartDetail>() : cart.getCartDetails();
        double totalPrice = 0;
        for (CartDetail cd : cartDetails) {
            totalPrice += cd.getPrice() * cd.getQuantity();
        }

        model.addAttribute("cartDetails", cartDetails);
        model.addAttribute("totalPrice", totalPrice);

        model.addAttribute("cart", cart);
        return "client/cart/showcart";
    }

    @GetMapping("/checkout")
    public String getCheckOutPage(Model model, HttpServletRequest request) {
        User currentUser = new User();// null
        HttpSession session = request.getSession(false);
        long id = (long) session.getAttribute("id");
        currentUser.setId(id);

        Cart cart = this.productService.fetchByUser(currentUser);

        List<CartDetail> cartDetails = cart == null ? new ArrayList<CartDetail>() : cart.getCartDetails();

        double totalPrice = 0;
        for (CartDetail cd : cartDetails) {
            totalPrice += cd.getPrice() * cd.getQuantity();
        }

        model.addAttribute("cartDetails", cartDetails);
        model.addAttribute("totalPrice", totalPrice);

        return "client/cart/checkout";
    }

    @PostMapping("/confirm-checkout")
    public String getCheckOutPage(@ModelAttribute("cart") Cart cart) {
        List<CartDetail> cartDetails = cart == null ? new ArrayList<CartDetail>() : cart.getCartDetails();
        this.productService.handleUpdateCartBeforeCheckout(cartDetails);
        return "redirect:/checkout";
    }

    // @PostMapping("/confirm-checkout")

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

    @PostMapping("/place-order")
    public String handlePlaceOrder(
            HttpServletRequest request,
            @RequestParam("receiverName") String receiverName,
            @RequestParam("receiverAddress") String receiverAddress,
            @RequestParam("receiverPhone") String receiverPhone) {
        User currentUser = new User();// null
        HttpSession session = request.getSession(false);
        long id = (long) session.getAttribute("id");
        currentUser.setId(id);
        this.productService.handlePlaceOrder(currentUser, session,
                receiverName, receiverAddress, receiverPhone);
        return "redirect:/thanks";
    }

    @GetMapping("/thanks")
    public String getThankYouPage(Model model) {

        return "client/cart/thanks";
    }

    @PostMapping("/add-product-from-view-detail")
    public String handleAddProductFromViewDetail(
            @RequestParam("id") long id,
            @RequestParam("quantity") long quantity,
            HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        String email = (String) session.getAttribute("email");
        this.productService.handleAddProductToCart(email, id, session, quantity);
        return "redirect:/product/" + id;
    }

    @GetMapping("/products")
    public String getProductPage(Model model,
            ProductCriteriaDTO productCriteriaDTO,
            HttpServletRequest request) {
        int page = 1;
        try {
            if (productCriteriaDTO.getPage().isPresent()) {
                page = Integer.valueOf(productCriteriaDTO.getPage().get());
            } else {
                page = 1;
            }

        } catch (Exception e) {
            // TODO: handle exception
        }
        Pageable pageable = PageRequest.of(page - 1, 6);
        if (productCriteriaDTO.getSort() != null && productCriteriaDTO.getSort().isPresent()) {
            String sort = productCriteriaDTO.getSort().get();
            if (sort.equals("gia-tang-dan")) {
                pageable = PageRequest.of(page - 1, 3, Sort.by(Product_.PRICE).ascending());
            } else if (sort.equals("gia-giam-dan")) {
                pageable = PageRequest.of(page - 1, 3, Sort.by(Product_.PRICE).descending());
            } else {
                pageable = PageRequest.of(page - 1, 3);
            }
        }
        Page<Product> prs = this.productService.getAllProducts(pageable, productCriteriaDTO);
        List<Product> listProducts = prs.getContent().size() > 0 ? prs.getContent()
                : new ArrayList<Product>();
        String qs = request.getQueryString();
        if (qs != null && !qs.isBlank()) {
            qs = qs.replace("page=" + page, "");
        }
        model.addAttribute("products", listProducts);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPage", prs.getTotalPages());
        model.addAttribute("queryString", qs);
        return "client/product/show";
    }

    @PostMapping("/payment/vnpay")
    public String processVNPayPayment(
            HttpServletRequest request,
            @RequestParam("receiverName") String receiverName,
            @RequestParam("receiverAddress") String receiverAddress,
            @RequestParam("receiverPhone") String receiverPhone,
            @RequestParam(value = "paymentType", defaultValue = "card") String paymentType) {
        
        User currentUser = new User();
        HttpSession session = request.getSession(false);
        long id = (long) session.getAttribute("id");
        currentUser.setId(id);
        
        Cart cart = this.productService.fetchByUser(currentUser);
        List<CartDetail> cartDetails = cart == null ? new ArrayList<CartDetail>() : cart.getCartDetails();
        
        double totalPrice = 0;
        for (CartDetail cd : cartDetails) {
            totalPrice += cd.getPrice() * cd.getQuantity();
        }

        String orderInfo = "Thanh toan don hang " + System.currentTimeMillis();
        String paymentUrl;
        
        if ("qr".equals(paymentType)) {
            paymentUrl = vnPayService.createQRPaymentUrl(totalPrice, orderInfo, request);
        } else {
            paymentUrl = vnPayService.createPaymentUrl(totalPrice, orderInfo, request);
        }
        
        // Lưu thông tin đơn hàng vào session để xử lý sau khi thanh toán
        session.setAttribute("orderInfo", orderInfo);
        session.setAttribute("receiverName", receiverName);
        session.setAttribute("receiverAddress", receiverAddress);
        session.setAttribute("receiverPhone", receiverPhone);
        
        return "redirect:" + paymentUrl;
    }

    @GetMapping("/payment/vnpay/return")
    public String vnpayReturn(
            HttpServletRequest request,
            @RequestParam("vnp_ResponseCode") String vnp_ResponseCode,
            @RequestParam("vnp_TxnRef") String vnp_TxnRef,
            @RequestParam("vnp_TransactionNo") String vnp_TransactionNo,
            @RequestParam("vnp_SecureHash") String vnp_SecureHash) {
        
        boolean paymentSuccess = vnPayService.verifyPayment(vnp_TxnRef, vnp_ResponseCode, vnp_TransactionNo, vnp_SecureHash);
        
        if (paymentSuccess) {
            HttpSession session = request.getSession(false);
            String receiverName = (String) session.getAttribute("receiverName");
            String receiverAddress = (String) session.getAttribute("receiverAddress");
            String receiverPhone = (String) session.getAttribute("receiverPhone");
            
            User currentUser = new User();
            long id = (long) session.getAttribute("id");
            currentUser.setId(id);
            
            this.productService.handlePlaceOrder(currentUser, session, receiverName, receiverAddress, receiverPhone);
            return "redirect:/thanks";
        }
        
        return "redirect:/checkout?error=payment_failed";
    }

    @PostMapping("/api/payment/vnpay/create")
    @ResponseBody
    public ResponseEntity<?> createVNPayPaymentUrl(
            HttpServletRequest request,
            @RequestParam("amount") double amount,
            @RequestParam("orderInfo") String orderInfo,
            @RequestParam(value = "paymentType", defaultValue = "card") String paymentType) {
        
        try {
            String paymentUrl;
            if ("qr".equals(paymentType)) {
                paymentUrl = vnPayService.createQRPaymentUrl(amount, orderInfo, request);
            } else {
                paymentUrl = vnPayService.createPaymentUrl(amount, orderInfo, request);
            }
            
            Map<String, String> response = new HashMap<>();
            response.put("paymentUrl", paymentUrl);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Failed to create payment URL");
            return ResponseEntity.badRequest().body(error);
        }
    }

    @GetMapping("/api/payment/vnpay/verify")
    @ResponseBody
    public ResponseEntity<?> verifyVNPayPayment(
            @RequestParam("vnp_ResponseCode") String vnp_ResponseCode,
            @RequestParam("vnp_TxnRef") String vnp_TxnRef,
            @RequestParam("vnp_TransactionNo") String vnp_TransactionNo,
            @RequestParam("vnp_SecureHash") String vnp_SecureHash) {
        
        boolean paymentSuccess = vnPayService.verifyPayment(vnp_TxnRef, vnp_ResponseCode, vnp_TransactionNo, vnp_SecureHash);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", paymentSuccess);
        response.put("transactionNo", vnp_TransactionNo);
        
        return ResponseEntity.ok(response);
    }

    @PostMapping("/api/payment/momo/create")
    @ResponseBody
    public ResponseEntity<?> createMoMoPaymentUrl(
            HttpServletRequest request,
            @RequestParam("amount") double amount,
            @RequestParam("orderInfo") String orderInfo) {
        try {
            String paymentUrl = moMoService.createPaymentUrl(amount, orderInfo, request);
            return ResponseEntity.ok(Map.of("paymentUrl", paymentUrl));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/api/payment/momo/return")
    public String momoReturn(
            HttpServletRequest request,
            @RequestParam("partnerCode") String partnerCode,
            @RequestParam("orderId") String orderId,
            @RequestParam("requestId") String requestId,
            @RequestParam("amount") String amount,
            @RequestParam("orderInfo") String orderInfo,
            @RequestParam("orderType") String orderType,
            @RequestParam("transId") String transId,
            @RequestParam("resultCode") String resultCode,
            @RequestParam("message") String message,
            @RequestParam("payType") String payType,
            @RequestParam("signature") String signature) {
        
        boolean isValid = moMoService.verifyPayment(
            partnerCode, orderId, requestId, amount, orderInfo,
            orderType, transId, resultCode, message, payType, signature
        );

        if (isValid && "0".equals(resultCode)) {
            // Payment successful
            HttpSession session = request.getSession(false);
            if (session != null) {
                String receiverName = (String) session.getAttribute("receiverName");
                String receiverAddress = (String) session.getAttribute("receiverAddress");
                String receiverPhone = (String) session.getAttribute("receiverPhone");
                
                User currentUser = new User();
                currentUser.setId((long) session.getAttribute("id"));
                
                this.productService.handlePlaceOrder(currentUser, session,
                    receiverName, receiverAddress, receiverPhone);
            }
            return "redirect:/thanks";
        } else {
            // Payment failed
            return "redirect:/checkout?error=payment_failed";
        }
    }

}
