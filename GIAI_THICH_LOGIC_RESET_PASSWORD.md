# 🔐 GIẢI THÍCH LOGIC RESET MẬT KHẨU

## 📋 TỔNG QUAN

Hệ thống reset mật khẩu sử dụng cơ chế **Token-based Password Reset** với các tính năng bảo mật:
- Token duy nhất (UUID) cho mỗi yêu cầu reset
- Token có thời hạn (30 giây - có vẻ là lỗi, nên là 30 giờ)
- Token chỉ sử dụng một lần
- Mật khẩu được mã hóa bằng BCrypt

---

## 🔄 QUY TRÌNH TỔNG QUAN

```
1. User quên mật khẩu → Nhập email
2. Hệ thống tạo token và gửi email
3. User click link trong email
4. Hệ thống xác thực token
5. User nhập mật khẩu mới
6. Hệ thống cập nhật mật khẩu và đánh dấu token đã dùng
```

---

## 📝 CHI TIẾT TỪNG BƯỚC

### **BƯỚC 1: User yêu cầu reset mật khẩu**

#### **Controller: `PasswordResetController.processForgotPassword()`**

```java
@PostMapping("/forgot-password")
public String processForgotPassword(
    @RequestParam("email") String email,
    HttpServletRequest request,
    RedirectAttributes redirectAttributes)
```

**Logic xử lý:**

1. **Kiểm tra email có tồn tại:**
   ```java
   User user = userService.getUserByEmail(email);
   if (user == null) {
       // Không tiết lộ thông tin user có tồn tại hay không (bảo mật)
       redirectAttributes.addFlashAttribute("message",
           "Không tồn tại người dùng với email đã gửi!");
       return "redirect:/forgot-password";
   }
   ```
   - **Bảo mật**: Luôn trả về cùng một thông báo dù email có tồn tại hay không
   - Ngăn chặn kẻ tấn công biết được email nào tồn tại trong hệ thống

2. **Tạo base URL:**
   ```java
   String baseUrl = request.getRequestURL().toString()
       .replace(request.getRequestURI(), "");
   ```
   - Lấy URL gốc của website (ví dụ: `http://localhost:8080`)
   - Dùng để tạo link reset password trong email

3. **Tạo token và gửi email:**
   ```java
   passwordResetService.createPasswordResetTokenForUser(user, baseUrl);
   ```

4. **Thông báo thành công:**
   ```java
   redirectAttributes.addFlashAttribute("message",
       "Chúng tôi đã gửi liên kết khôi phục mật khẩu đến email của bạn...");
   ```

---

### **BƯỚC 2: Tạo token và gửi email**

#### **Service: `PasswordResetService.createPasswordResetTokenForUser()`**

```java
@Transactional
public void createPasswordResetTokenForUser(User user, String baseUrl)
```

**Logic xử lý:**

1. **Xóa các token cũ của user:**
   ```java
   tokenRepository.deleteByUserEmail(user.getEmail());
   ```
   - **Lý do**: Mỗi user chỉ nên có một token hợp lệ tại một thời điểm
   - Ngăn chặn việc có nhiều link reset cùng lúc
   - Đảm bảo token mới nhất là token hợp lệ

2. **Tạo token mới (UUID):**
   ```java
   String token = UUID.randomUUID().toString();
   ```
   - **UUID**: Tạo chuỗi ngẫu nhiên duy nhất (ví dụ: `550e8400-e29b-41d4-a716-446655440000`)
   - **Bảo mật**: Không thể đoán được token
   - **Duy nhất**: Xác suất trùng lặp cực kỳ thấp

3. **Tạo thời gian hết hạn:**
   ```java
   LocalDateTime expiryDate = LocalDateTime.now().plusSeconds(TOKEN_EXPIRY_HOURS);
   ```
   - **Lưu ý**: Code hiện tại dùng `plusSeconds(30)` - có vẻ là lỗi, nên là `plusHours(30)`
   - Token có thời hạn để tăng tính bảo mật
   - Sau khi hết hạn, token không thể sử dụng

4. **Lưu token vào database:**
   ```java
   PasswordResetToken resetToken = new PasswordResetToken(token, user, expiryDate);
   tokenRepository.save(resetToken);
   ```
   - Lưu vào bảng `password_reset_tokens`
   - Liên kết với user thông qua `user_id`

5. **Tạo link reset và gửi email:**
   ```java
   String resetLink = baseUrl + "/reset-password?token=" + token;
   emailService.sendPasswordResetEmail(user.getEmail(), resetLink);
   ```
   - Link có dạng: `http://localhost:8080/reset-password?token=550e8400-e29b-41d4-a716-446655440000`
   - Gửi email chứa link này đến user

---

### **BƯỚC 3: Gửi email reset password**

#### **Service: `EmailService.sendPasswordResetEmail()`**

```java
public void sendPasswordResetEmail(String to, String resetLink)
```

**Logic xử lý:**

1. **Tạo email:**
   ```java
   SimpleMailMessage message = new SimpleMailMessage();
   message.setFrom(fromEmail);  // Email gửi đi (từ application.properties)
   message.setTo(to);            // Email người nhận
   message.setSubject("Khôi phục mật khẩu - Laptopshop");
   ```

2. **Nội dung email:**
   ```
   Xin chào,
   
   Bạn đã yêu cầu khôi phục mật khẩu cho tài khoản của mình.
   
   Vui lòng nhấp vào liên kết sau để đặt lại mật khẩu:
   [resetLink]
   
   Liên kết này sẽ hết hạn sau 1 giờ.
   
   Nếu bạn không yêu cầu khôi phục mật khẩu, vui lòng bỏ qua email này.
   ```

3. **Gửi email:**
   ```java
   mailSender.send(message);
   ```
   - Sử dụng `JavaMailSender` của Spring
   - Cấu hình SMTP trong `application.properties`

---

### **BƯỚC 4: User click link và hiển thị form reset**

#### **Controller: `PasswordResetController.showResetPasswordPage()`**

```java
@GetMapping("/reset-password")
public String showResetPasswordPage(
    @RequestParam("token") String token,
    Model model,
    RedirectAttributes redirectAttributes)
```

**Logic xử lý:**

1. **Lấy token từ database:**
   ```java
   Optional<PasswordResetToken> resetToken = passwordResetService.getToken(token);
   ```
   - Tìm token trong bảng `password_reset_tokens`
   - Trả về `Optional` để xử lý trường hợp không tìm thấy

2. **Kiểm tra token có tồn tại:**
   ```java
   if (resetToken.isEmpty()) {
       redirectAttributes.addFlashAttribute("error", 
           "Liên kết khôi phục mật khẩu không hợp lệ.");
       return "redirect:/forgot-password";
   }
   ```
   - Nếu token không tồn tại → Token không hợp lệ hoặc đã bị xóa

3. **Xác thực token:**
   ```java
   PasswordResetToken tokenEntity = resetToken.get();
   if (!passwordResetService.validateToken(tokenEntity)) {
       redirectAttributes.addFlashAttribute("error", 
           "Liên kết khôi phục mật khẩu đã hết hạn hoặc đã được sử dụng.");
       return "redirect:/forgot-password";
   }
   ```

4. **Hiển thị form reset password:**
   ```java
   model.addAttribute("token", token);
   return "client/auth/reset-password";
   ```
   - Truyền token vào view để dùng khi submit form

---

### **BƯỚC 5: Xác thực token**

#### **Service: `PasswordResetService.validateToken()`**

```java
public boolean validateToken(PasswordResetToken resetToken) {
    return resetToken != null 
        && !resetToken.isUsed() 
        && !resetToken.isExpired();
}
```

**Logic kiểm tra:**

1. **Token không null:**
   - Đảm bảo token tồn tại

2. **Token chưa được sử dụng:**
   ```java
   !resetToken.isUsed()
   ```
   - Kiểm tra flag `used` trong database
   - Mỗi token chỉ dùng được một lần

3. **Token chưa hết hạn:**
   ```java
   !resetToken.isExpired()
   ```
   - Method `isExpired()` trong `PasswordResetToken`:
   ```java
   public boolean isExpired() {
       return LocalDateTime.now().isAfter(expiryDate);
   }
   ```
   - So sánh thời gian hiện tại với `expiryDate`

**Kết quả:**
- `true`: Token hợp lệ → Cho phép reset password
- `false`: Token không hợp lệ → Từ chối

---

### **BƯỚC 6: User nhập mật khẩu mới**

#### **Controller: `PasswordResetController.processResetPassword()`**

```java
@PostMapping("/reset-password")
public String processResetPassword(
    @RequestParam("token") String token,
    @RequestParam("password") String password,
    @RequestParam("confirmPassword") String confirmPassword,
    RedirectAttributes redirectAttributes)
```

**Logic xử lý:**

1. **Validate mật khẩu:**
   ```java
   if (password == null || password.length() < 6) {
       redirectAttributes.addFlashAttribute("error", 
           "Mật khẩu phải có ít nhất 6 ký tự.");
       return "redirect:/reset-password?token=" + token;
   }
   ```
   - Kiểm tra độ dài tối thiểu

2. **Xác nhận mật khẩu khớp:**
   ```java
   if (!password.equals(confirmPassword)) {
       redirectAttributes.addFlashAttribute("error", 
           "Mật khẩu xác nhận không khớp.");
       return "redirect:/reset-password?token=" + token;
   }
   ```
   - Đảm bảo user nhập đúng mật khẩu

3. **Xác thực token lại:**
   ```java
   Optional<PasswordResetToken> resetToken = passwordResetService.getToken(token);
   if (resetToken.isEmpty()) {
       // Token không tồn tại
       return "redirect:/forgot-password";
   }
   
   PasswordResetToken tokenEntity = resetToken.get();
   if (!passwordResetService.validateToken(tokenEntity)) {
       // Token đã hết hạn hoặc đã dùng
       return "redirect:/forgot-password";
   }
   ```
   - **Quan trọng**: Xác thực lại token trước khi đổi mật khẩu
   - Ngăn chặn token bị thay đổi giữa chừng

4. **Mã hóa và cập nhật mật khẩu:**
   ```java
   User user = tokenEntity.getUser();
   String hashedPassword = passwordEncoder.encode(password);
   user.setPassword(hashedPassword);
   userService.handleSaveUser(user);
   ```
   - Lấy user từ token
   - Mã hóa mật khẩu bằng BCrypt
   - Lưu mật khẩu mới vào database

5. **Đánh dấu token đã sử dụng:**
   ```java
   passwordResetService.markTokenAsUsed(tokenEntity);
   ```
   - Set `used = true` trong database
   - Token không thể dùng lại

6. **Thông báo thành công:**
   ```java
   redirectAttributes.addFlashAttribute("success", 
       "Mật khẩu đã được đặt lại thành công. Vui lòng đăng nhập.");
   return "redirect:/login";
   ```

---

### **BƯỚC 7: Đánh dấu token đã sử dụng**

#### **Service: `PasswordResetService.markTokenAsUsed()`**

```java
@Transactional
public void markTokenAsUsed(PasswordResetToken resetToken) {
    resetToken.setUsed(true);
    tokenRepository.save(resetToken);
}
```

**Logic:**
- Set flag `used = true`
- Lưu vào database
- Token không thể dùng lại lần sau

---

## 🗄️ CẤU TRÚC DATABASE

### **Bảng `password_reset_tokens`**

| Trường | Kiểu | Mô tả |
|--------|------|-------|
| `id` | BIGINT (PK) | Mã định danh |
| `token` | VARCHAR(255) | Token duy nhất (UUID) |
| `user_id` | BIGINT (FK) | Tham chiếu đến `users.id` |
| `expiryDate` | DATETIME | Thời gian hết hạn |
| `used` | BOOLEAN | Đã sử dụng chưa |

### **Quan hệ:**
- **Many-to-One** với `users`: Nhiều token có thể thuộc một user

---

## 🔒 CÁC TÍNH NĂNG BẢO MẬT

### 1. **Token ngẫu nhiên (UUID)**
- Không thể đoán được token
- Mỗi token là duy nhất

### 2. **Token có thời hạn**
- Token tự động hết hạn sau một khoảng thời gian
- Giảm rủi ro nếu token bị lộ

### 3. **Token chỉ dùng một lần**
- Sau khi reset password, token được đánh dấu `used = true`
- Không thể dùng lại token cũ

### 4. **Xóa token cũ khi tạo mới**
- Mỗi user chỉ có một token hợp lệ tại một thời điểm
- Token mới sẽ thay thế token cũ

### 5. **Mật khẩu được mã hóa**
- Sử dụng BCrypt để mã hóa mật khẩu
- Không lưu mật khẩu dạng plain text

### 6. **Không tiết lộ thông tin**
- Luôn trả về cùng một thông báo dù email có tồn tại hay không
- Ngăn chặn kẻ tấn công biết được email nào tồn tại

### 7. **Xác thực token nhiều lần**
- Xác thực khi hiển thị form
- Xác thực lại khi submit form
- Ngăn chặn token bị thay đổi giữa chừng

---

## 📊 SƠ ĐỒ LUỒNG XỬ LÝ

```
┌─────────────┐
│ User nhập   │
│ email       │
└──────┬──────┘
       │
       ▼
┌─────────────────────────┐
│ Kiểm tra email tồn tại? │
└──────┬──────────────────┘
       │
   ┌───┴───┐
   │  Có   │  Không
   │       │
   ▼       ▼
┌──────────────────┐  ┌──────────────────┐
│ Xóa token cũ     │  │ Thông báo lỗi    │
│ Tạo token mới    │  │ (không tiết lộ)  │
│ Lưu vào DB       │  └──────────────────┘
│ Gửi email        │
└──────┬───────────┘
       │
       ▼
┌──────────────────┐
│ User click link  │
│ trong email      │
└──────┬───────────┘
       │
       ▼
┌─────────────────────────┐
│ Xác thực token?         │
│ - Tồn tại?              │
│ - Chưa hết hạn?         │
│ - Chưa dùng?            │
└──────┬──────────────────┘
       │
   ┌───┴───┐
   │  OK   │  Lỗi
   │       │
   ▼       ▼
┌──────────────────┐  ┌──────────────────┐
│ Hiển thị form    │  │ Redirect về      │
│ reset password   │  │ forgot-password  │
└──────┬───────────┘  └──────────────────┘
       │
       ▼
┌──────────────────┐
│ User nhập        │
│ mật khẩu mới     │
└──────┬───────────┘
       │
       ▼
┌─────────────────────────┐
│ Validate mật khẩu?       │
│ - Độ dài >= 6?          │
│ - Xác nhận khớp?        │
│ - Token còn hợp lệ?     │
└──────┬──────────────────┘
       │
   ┌───┴───┐
   │  OK   │  Lỗi
   │       │
   ▼       ▼
┌──────────────────┐  ┌──────────────────┐
│ Mã hóa mật khẩu  │  │ Hiển thị lỗi     │
│ Cập nhật DB      │  │ và giữ form      │
│ Đánh dấu token   │  └──────────────────┘
│ đã dùng          │
└──────┬───────────┘
       │
       ▼
┌──────────────────┐
│ Redirect về      │
│ /login           │
└──────────────────┘
```

---

## 🐛 LƯU Ý VÀ CẢI THIỆN

### **Lỗi phát hiện:**

1. **Thời gian hết hạn sai:**
   ```java
   // Code hiện tại (SAI):
   LocalDateTime expiryDate = LocalDateTime.now().plusSeconds(TOKEN_EXPIRY_HOURS);
   
   // Nên sửa thành:
   LocalDateTime expiryDate = LocalDateTime.now().plusHours(TOKEN_EXPIRY_HOURS);
   ```
   - Hiện tại: Token hết hạn sau 30 giây
   - Nên: Token hết hạn sau 30 giờ (hoặc 1 giờ)

2. **Thông báo email không khớp:**
   - Email nói "hết hạn sau 1 giờ"
   - Nhưng code set 30 giây (hoặc 30 giờ nếu sửa)

### **Cải thiện đề xuất:**

1. **Thêm rate limiting:**
   - Giới hạn số lần yêu cầu reset trong một khoảng thời gian
   - Ngăn chặn spam email

2. **Logging:**
   - Ghi log các lần reset password
   - Theo dõi bất thường

3. **Email template:**
   - Sử dụng HTML email thay vì plain text
   - Thêm logo và styling

4. **Xóa token hết hạn tự động:**
   - Tạo scheduled job để xóa token cũ
   - Giữ database sạch sẽ

---

## 📝 TÓM TẮT

### **Các thành phần chính:**

1. **Controller**: `PasswordResetController`
   - Xử lý request từ user
   - Validate input
   - Redirect và hiển thị thông báo

2. **Service**: `PasswordResetService`
   - Tạo và quản lý token
   - Xác thực token
   - Đánh dấu token đã dùng

3. **Service**: `EmailService`
   - Gửi email reset password

4. **Entity**: `PasswordResetToken`
   - Lưu trữ token trong database
   - Kiểm tra token hết hạn

5. **Repository**: `PasswordResetTokenRepository`
   - Truy vấn token từ database

### **Quy trình chính:**

1. User yêu cầu reset → Tạo token → Gửi email
2. User click link → Xác thực token → Hiển thị form
3. User nhập mật khẩu → Validate → Cập nhật → Đánh dấu token đã dùng

---

*Tài liệu này giải thích chi tiết logic reset mật khẩu trong hệ thống Laptop Shop.*

