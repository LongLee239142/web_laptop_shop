package vn.longlee.laptopshop.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class VNPayConfig {
    @Value("${vnpay.vnp_TmnCode}")      // Mã website tại VNPAY
    private String vnp_TmnCode;
    
    @Value("${vnpay.vnp_HashSecret}")   // Chuỗi bí mật
    private String vnp_HashSecret;
    
    @Value("${vnpay.vnp_Url}")          // URL thanh toán VNPay
    private String vnp_Url;
    
    @Value("${vnpay.vnp_ReturnUrl}")    // URL callback sau khi thanh toán
    private String vnp_ReturnUrl;

    public String getVnp_TmnCode() {
        return vnp_TmnCode;
    }

    public String getVnp_HashSecret() {
        return vnp_HashSecret;
    }

    public String getVnp_Url() {
        return vnp_Url;
    }

    public String getVnp_ReturnUrl() {
        return vnp_ReturnUrl;
    }
} 