package vn.hoidanit.laptopshop.service;

import jakarta.servlet.http.HttpServletRequest;

public interface VNPayService {
    String createPaymentUrl(double amount, String orderInfo, HttpServletRequest request);
    String createPaymentUrl(double amount, String orderInfo, HttpServletRequest request, String bankCode);
    String createQRPaymentUrl(double amount, String orderInfo, HttpServletRequest request);
    boolean verifyPayment(String vnp_TxnRef, String vnp_ResponseCode, String vnp_TransactionNo, String vnp_SecureHash);
} 