package vn.longlee.laptopshop.service.impl;

import java.io.UnsupportedEncodingException;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import jakarta.servlet.http.HttpServletRequest;
import vn.longlee.laptopshop.config.MoMoConfig;
import vn.longlee.laptopshop.service.MoMoService;

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

            // Convert amount to long (remove decimal points)
            long amountLong = (long) amount;

            // Tạo raw data theo thứ tự cụ thể
            StringBuilder rawData = new StringBuilder();
            rawData.append("accessKey=").append(moMoConfig.getAccessKey())
                  .append("&amount=").append(amountLong)
                  .append("&extraData=").append(extraData)
                  .append("&ipnUrl=").append(moMoConfig.getNotifyUrl())
                  .append("&orderId=").append(orderId)
                  .append("&orderInfo=").append(orderInfo)
                  .append("&partnerCode=").append(moMoConfig.getPartnerCode())
                  .append("&redirectUrl=").append(moMoConfig.getReturnUrl())
                  .append("&requestId=").append(requestId)
                  .append("&requestType=captureWallet");

            // Debug logs
            System.out.println("MoMo Config:");
            System.out.println("Partner Code: " + moMoConfig.getPartnerCode());
            System.out.println("Access Key: " + moMoConfig.getAccessKey());
            System.out.println("Secret Key: " + moMoConfig.getSecretKey());
            System.out.println("Return URL: " + moMoConfig.getReturnUrl());
            System.out.println("Notify URL: " + moMoConfig.getNotifyUrl());
            System.out.println("Payment URL: " + moMoConfig.getPaymentUrl());
            
            System.out.println("Raw Data for Signature: " + rawData.toString());
            
            String signature = generateSignature(rawData.toString());
            System.out.println("Generated Signature: " + signature);

            // Tạo request body
            Map<String, String> body = new HashMap<>();
            body.put("partnerCode", moMoConfig.getPartnerCode());
            body.put("orderId", orderId);
            body.put("requestId", requestId);
            body.put("amount", String.valueOf(amountLong));
            body.put("orderInfo", orderInfo);
            body.put("orderType", "momo_wallet");
            body.put("redirectUrl", moMoConfig.getReturnUrl());
            body.put("ipnUrl", moMoConfig.getNotifyUrl());
            body.put("lang", "vi");
            body.put("extraData", extraData);
            body.put("requestType", "captureWallet");
            body.put("signature", signature);

            System.out.println("MoMo Request Body: " + body);

            // Gửi POST JSON
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<Map<String, String>> httpEntity = new HttpEntity<>(body, headers);
            
            try {
                ResponseEntity<Map> response = restTemplate.postForEntity(
                    moMoConfig.getPaymentUrl(), httpEntity, Map.class);
                
                System.out.println("MoMo Response Status: " + response.getStatusCode());
                System.out.println("MoMo Response Body: " + response.getBody());
                
                Map<String, Object> responseBody = response.getBody();
                if (responseBody != null && responseBody.containsKey("payUrl")) {
                    return responseBody.get("payUrl").toString();
                } else {
                    String errorMessage = "MoMo response does not contain payUrl: " + responseBody;
                    System.out.println(errorMessage);
                    throw new RuntimeException(errorMessage);
                }
            } catch (Exception e) {
                System.out.println("Error calling MoMo API: " + e.getMessage());
                e.printStackTrace();
                throw new RuntimeException("Error calling MoMo API: " + e.getMessage(), e);
            }
        } catch (Exception e) {
            System.out.println("Error in createPaymentUrl: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error creating MoMo payment URL: " + e.getMessage(), e);
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

            String dataToSign = hashData.toString() + "accessKey=" + moMoConfig.getAccessKey();
            String expectedSignature = generateSignature(dataToSign);
            return expectedSignature.equals(signature);
        } catch (Exception e) {
            return false;
        }
    }

    private String generateSignature(String data) throws NoSuchAlgorithmException, InvalidKeyException, UnsupportedEncodingException {
        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKeySpec = new SecretKeySpec(moMoConfig.getSecretKey().getBytes(StandardCharsets.UTF_8), "HmacSHA256");
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
            System.out.println("Error generating signature: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
} 