package vn.longlee.laptopshop.service;

import jakarta.servlet.http.HttpServletRequest;

public interface MoMoService {
    String createPaymentUrl(double amount, String orderInfo, HttpServletRequest request);
    boolean verifyPayment(String partnerCode, String orderId, String requestId, String amount, String orderInfo, String orderType, String transId, String resultCode, String message, String payType, String signature);
} 