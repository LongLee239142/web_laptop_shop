package vn.longlee.laptopshop.service.impl;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpServletRequest;
import vn.longlee.laptopshop.config.VNPayConfig;
import vn.longlee.laptopshop.service.VNPayService;

@Service
public class VNPayServiceImpl implements VNPayService {

    @Autowired
    private VNPayConfig vnPayConfig;

    @Override
    public String createPaymentUrl(double amount, String orderInfo, HttpServletRequest request) {
        return createPaymentUrl(amount, orderInfo, request, "NCB");
    }

    @Override
    public String createQRPaymentUrl(double amount, String orderInfo, HttpServletRequest request) {
        return createPaymentUrl(amount, orderInfo, request, "");
    }

    @Override
    public String createPaymentUrl(double amount, String orderInfo, HttpServletRequest request, String bankCode) {
        try {
            String vnp_Version = "2.1.0";
            String vnp_Command = "pay";
            String vnp_OrderInfo = orderInfo;
            String orderType = "other";
            long amountInLong = (long) (amount * 100);
            String vnp_TxnRef = String.valueOf(System.currentTimeMillis());
            String vnp_IpAddr = getIpAddress(request);
            String vnp_CreateDate = new SimpleDateFormat("yyyyMMddHHmmss").format(Calendar.getInstance(TimeZone.getTimeZone("GMT+7")).getTime());

            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", vnp_Version);
            vnp_Params.put("vnp_Command", vnp_Command);
            vnp_Params.put("vnp_TmnCode", vnPayConfig.getVnp_TmnCode());
            vnp_Params.put("vnp_Amount", String.valueOf(amountInLong));
            vnp_Params.put("vnp_CurrCode", "VND");
            vnp_Params.put("vnp_BankCode", bankCode);
            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
            vnp_Params.put("vnp_OrderType", orderType);
            vnp_Params.put("vnp_Locale", "vn");
            vnp_Params.put("vnp_ReturnUrl", vnPayConfig.getVnp_ReturnUrl());
            vnp_Params.put("vnp_IpAddr", vnp_IpAddr);
            vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

            List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
            Collections.sort(fieldNames);

            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();

            Iterator<String> itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName = itr.next();
                String fieldValue = vnp_Params.get(fieldName);
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                    query.append('=');
                    query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    if (itr.hasNext()) {
                        query.append('&');
                        hashData.append('&');
                    }
                }
            }

            String queryUrl = query.toString();
            String vnp_SecureHash = hmacSHA512(vnPayConfig.getVnp_HashSecret(), hashData.toString());
            queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
            return vnPayConfig.getVnp_Url() + "?" + queryUrl;
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("Error creating payment URL", e);
        }
    }

    @Override
    public boolean verifyPayment(String vnp_TxnRef, String vnp_ResponseCode, String vnp_TransactionNo, String vnp_SecureHash) {
        // Implement payment verification logic here
        return "00".equals(vnp_ResponseCode);
    }

    private String getIpAddress(HttpServletRequest request) {
        String ipAddress = request.getHeader("X-Forwarded-For");
        if (ipAddress == null) {
            ipAddress = request.getRemoteAddr();
        }
        return ipAddress;
    }

    private String hmacSHA512(String key, String data) {
        try {
            javax.crypto.Mac mac = javax.crypto.Mac.getInstance("HmacSHA512");
            javax.crypto.spec.SecretKeySpec secretKeySpec = new javax.crypto.spec.SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            mac.init(secretKeySpec);
            byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error calculating HMAC-SHA512", e);
        }
    }
} 