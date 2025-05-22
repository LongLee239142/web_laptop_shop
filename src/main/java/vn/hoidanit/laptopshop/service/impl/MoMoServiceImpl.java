package vn.hoidanit.laptopshop.service.impl;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpServletRequest;
import vn.hoidanit.laptopshop.config.MoMoConfig;
import vn.hoidanit.laptopshop.service.MoMoService;

@Service
public class MoMoServiceImpl implements MoMoService {

    @Autowired
    private MoMoConfig moMoConfig;

    @Override
    public String createPaymentUrl(double amount, String orderInfo, HttpServletRequest request) {
        try {
            String orderId = String.valueOf(System.currentTimeMillis());
            String requestId = String.valueOf(System.currentTimeMillis());
            String extraData = "";

            Map<String, String> rawHash = new HashMap<>();
            rawHash.put("partnerCode", moMoConfig.getPartnerCode());
            rawHash.put("orderId", orderId);
            rawHash.put("requestId", requestId);
            rawHash.put("amount", String.valueOf((long) amount));
            rawHash.put("orderInfo", orderInfo);
            rawHash.put("orderType", "momo_wallet");
            rawHash.put("transId", String.valueOf(System.currentTimeMillis()));
            rawHash.put("resultCode", "0");
            rawHash.put("message", "success");
            rawHash.put("payType", "qr");
            rawHash.put("signature", "");

            String signature = generateSignature(rawHash);
            rawHash.put("signature", signature);

            StringBuilder query = new StringBuilder();
            Iterator<Map.Entry<String, String>> itr = rawHash.entrySet().iterator();
            while (itr.hasNext()) {
                Map.Entry<String, String> entry = itr.next();
                query.append(URLEncoder.encode(entry.getKey(), StandardCharsets.US_ASCII.toString()));
                query.append('=');
                query.append(URLEncoder.encode(entry.getValue(), StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    query.append('&');
                }
            }

            return moMoConfig.getPaymentUrl() + "?" + query.toString();
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("Error creating MoMo payment URL", e);
        }
    }

    @Override
    public boolean verifyPayment(String partnerCode, String orderId, String requestId, String amount,
            String orderInfo, String orderType, String transId, String resultCode, String message,
            String payType, String signature) {
        try {
            Map<String, String> rawHash = new HashMap<>();
            rawHash.put("partnerCode", partnerCode);
            rawHash.put("orderId", orderId);
            rawHash.put("requestId", requestId);
            rawHash.put("amount", amount);
            rawHash.put("orderInfo", orderInfo);
            rawHash.put("orderType", orderType);
            rawHash.put("transId", transId);
            rawHash.put("resultCode", resultCode);
            rawHash.put("message", message);
            rawHash.put("payType", payType);

            String expectedSignature = generateSignature(rawHash);
            return expectedSignature.equals(signature);
        } catch (Exception e) {
            return false;
        }
    }

    private String generateSignature(Map<String, String> rawHash) throws NoSuchAlgorithmException, InvalidKeyException, UnsupportedEncodingException {
        List<String> fieldNames = new ArrayList<>(rawHash.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        for (String fieldName : fieldNames) {
            String fieldValue = rawHash.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(fieldValue);
                hashData.append('&');
            }
        }
        hashData.append("accessKey=").append(moMoConfig.getAccessKey());

        Mac mac = Mac.getInstance("HmacSHA256");
        SecretKeySpec secretKeySpec = new SecretKeySpec(moMoConfig.getSecretKey().getBytes(StandardCharsets.UTF_8), "HmacSHA256");
        mac.init(secretKeySpec);
        byte[] hash = mac.doFinal(hashData.toString().getBytes(StandardCharsets.UTF_8));

        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        return hexString.toString();
    }
} 