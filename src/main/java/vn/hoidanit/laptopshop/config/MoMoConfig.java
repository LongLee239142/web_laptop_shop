package vn.hoidanit.laptopshop.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MoMoConfig {
    @Value("${momo.partnerCode}")    // Mã đối tác
    private String partnerCode;
    
    @Value("${momo.accessKey}")      // Khóa truy cập
    private String accessKey;
    
    @Value("${momo.secretKey}")      // Khóa bí mật
    private String secretKey;
    
    @Value("${momo.returnUrl}")      // URL callback
    private String returnUrl;
    
    @Value("${momo.notifyUrl}")      // URL thông báo
    private String notifyUrl;
    
    @Value("${momo.paymentUrl}")     // URL thanh toán
    private String paymentUrl;

    public String getPartnerCode() {
        return partnerCode;
    }

    public String getAccessKey() {
        return accessKey;
    }

    public String getSecretKey() {
        return secretKey;
    }

    public String getReturnUrl() {
        return returnUrl;
    }

    public String getNotifyUrl() {
        return notifyUrl;
    }

    public String getPaymentUrl() {
        return paymentUrl;
    }
} 