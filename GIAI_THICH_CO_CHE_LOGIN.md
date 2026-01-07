# 🔐 GIẢI THÍCH CƠ CHẾ LOGIN

## 📋 TỔNG QUAN

Hệ thống sử dụng **Spring Security** để xử lý xác thực và phân quyền. Cơ chế login bao gồm:
- Form-based authentication
- BCrypt password encoding
- Session management
- Role-based access control (RBAC)
- Remember Me functionality

---

## 🔄 QUY TRÌNH TỔNG QUAN

```
1. User truy cập trang login
2. User nhập email và password
3. Spring Security xử lý form login
4. CustomUserDetailsService load user từ database
5. DaoAuthenticationProvider xác thực mật khẩu
6. CustomSuccessHandler xử lý sau khi login thành công
7. Lưu thông tin user vào session
8. Redirect theo role (USER → /, ADMIN → /admin)
```

---

## 📝 CHI TIẾT TỪNG BƯỚC

### **BƯỚC 1: User truy cập trang login**

#### **Controller: `HomePageController.getLoginPage()`**

```java
@GetMapping("/login")
public String getLoginPage(Model model) {
    return "client/auth/login";
}
```

**Logic:**
- Hiển thị form login tại `/login`
- Form được Spring Security xử lý tự động
- Không cần xử lý logic phức tạp ở đây

**Form Login (login.jsp):**
```html
<form method="post" action="/login">
    <input type="text" name="username" placeholder="Email" />
    <input type="password" name="password" placeholder="Password" />
    <input type="checkbox" name="remember-me" /> Remember me
    <button type="submit">Đăng nhập</button>
</form>
```

**Lưu ý:**
- Spring Security mặc định sử dụng `username` và `password` làm tên field
- Action là `/login` (Spring Security tự động xử lý)

---

### **BƯỚC 2: Cấu hình Spring Security**

#### **Configuration: `SecurityConfiguration.filterChain()`**

```java
@Bean
SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
    http
        .authorizeHttpRequests(authorize -> authorize
            .requestMatchers("/", "/login", "/product/**", 
                "/register", "/forgot-password", "/reset-password", 
                "/client/**", "/css/**", "/js/**", "/images/**")
            .permitAll()  // Cho phép truy cập không cần đăng nhập
            
            .requestMatchers("/admin/**").hasRole("ADMIN")  // Chỉ ADMIN mới vào được
            
            .anyRequest().authenticated())  // Các request khác cần đăng nhập
        
        .formLogin(formLogin -> formLogin
            .loginPage("/login")           // Trang login
            .failureUrl("/login?error")    // Redirect khi login thất bại
            .successHandler(CustomSuccessHandler())  // Xử lý khi login thành công
            .permitAll())
        
        .sessionManagement((sessionManagement) -> sessionManagement
            .sessionCreationPolicy(SessionCreationPolicy.ALWAYS)  // Luôn tạo session
            .maximumSessions(1)            // Chỉ cho phép 1 session/user
            .maxSessionsPreventsLogin(false))  // Session mới sẽ đăng xuất session cũ
        
        .rememberMe(r -> r.rememberMeServices(rememberMeServices()))
        
        .logout(logout -> logout
            .deleteCookies("JSESSIONID")
            .invalidateHttpSession(true));
    
    return http.build();
}
```

**Các cấu hình quan trọng:**

1. **Phân quyền truy cập:**
   - `/`, `/login`, `/register`, `/product/**`: Không cần đăng nhập
   - `/admin/**`: Chỉ ADMIN mới vào được
   - Các URL khác: Cần đăng nhập

2. **Form Login:**
   - Trang login: `/login`
   - URL thất bại: `/login?error`
   - Success handler: `CustomSuccessHandler`

3. **Session Management:**
   - Luôn tạo session khi login
   - Chỉ cho phép 1 session/user
   - Session mới sẽ đăng xuất session cũ

4. **Remember Me:**
   - Cho phép user giữ đăng nhập sau khi đóng browser

---

### **BƯỚC 3: Spring Security xử lý form login**

Khi user submit form login, Spring Security sẽ:

1. **Nhận request POST `/login`**
2. **Lấy thông tin từ form:**
   - `username` (email)
   - `password`
   - `remember-me` (optional)

3. **Tạo `UsernamePasswordAuthenticationToken`**

4. **Gọi `DaoAuthenticationProvider` để xác thực**

---

### **BƯỚC 4: Load user từ database**

#### **Service: `CustomUserDetailsService.loadUserByUsername()`**

```java
@Service
public class CustomUserDetailsService implements UserDetailsService {
    public final UserService userService;

    @Override
    public UserDetails loadUserByUsername(String username) 
            throws UsernameNotFoundException {
        // username ở đây thực chất là email
        vn.longlee.laptopshop.domain.User user = 
            this.userService.getUserByEmail(username);
        
        if (user == null) {
            throw new UsernameNotFoundException("User not found");
        }
        
        // Tạo UserDetails object cho Spring Security
        return new User(
            user.getEmail(),                    // username
            user.getPassword(),                 // password (đã mã hóa BCrypt)
            Collections.singletonList(
                new SimpleGrantedAuthority("ROLE_" + user.getRole().getName())
            )  // Role: ROLE_USER hoặc ROLE_ADMIN
        );
    }
}
```

**Logic xử lý:**

1. **Nhận username (thực chất là email):**
   - Spring Security truyền `username` từ form
   - Trong hệ thống này, `username` = `email`

2. **Tìm user trong database:**
   ```java
   User user = this.userService.getUserByEmail(username);
   ```
   - Gọi `UserService.getUserByEmail()`
   - Truy vấn database: `UserRepository.findByEmail(email)`

3. **Kiểm tra user tồn tại:**
   - Nếu `user == null` → Throw `UsernameNotFoundException`
   - Spring Security sẽ redirect về `/login?error`

4. **Tạo UserDetails object:**
   ```java
   return new User(
       user.getEmail(),           // Username
       user.getPassword(),        // Password (BCrypt hash)
       authorities                // Roles
   );
   ```
   - `User` là class của Spring Security (không phải domain User)
   - Chứa thông tin cần thiết để xác thực

5. **Tạo Authorities (Roles):**
   ```java
   new SimpleGrantedAuthority("ROLE_" + user.getRole().getName())
   ```
   - Nếu role.name = "USER" → Authority = "ROLE_USER"
   - Nếu role.name = "ADMIN" → Authority = "ROLE_ADMIN"
   - **Lưu ý**: Spring Security yêu cầu prefix "ROLE_"

---

### **BƯỚC 5: Xác thực mật khẩu**

#### **Provider: `DaoAuthenticationProvider`**

```java
@Bean
public DaoAuthenticationProvider authProvider(
        PasswordEncoder passwordEncoder,
        UserDetailsService userDetailsService) {
    DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
    authProvider.setUserDetailsService(userDetailsService);
    authProvider.setPasswordEncoder(passwordEncoder);
    return authProvider;
}
```

**Logic xác thực:**

1. **Nhận `UsernamePasswordAuthenticationToken`** từ form login
   - Chứa: `username` (email) và `password` (plain text)

2. **Load UserDetails:**
   - Gọi `CustomUserDetailsService.loadUserByUsername(email)`
   - Lấy `UserDetails` chứa password đã mã hóa

3. **So sánh mật khẩu:**
   ```java
   passwordEncoder.matches(rawPassword, encodedPassword)
   ```
   - `rawPassword`: Mật khẩu user nhập (plain text)
   - `encodedPassword`: Mật khẩu trong database (BCrypt hash)
   - Sử dụng BCrypt để so sánh

4. **Kết quả:**
   - **Thành công**: Tạo `Authentication` object
   - **Thất bại**: Throw `BadCredentialsException` → Redirect `/login?error`

**BCrypt Password Encoder:**
```java
@Bean
public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
}
```
- Mã hóa mật khẩu bằng BCrypt
- Tự động salt và hash
- Không thể reverse (one-way hash)

---

### **BƯỚC 6: Xử lý sau khi login thành công**

#### **Handler: `CustomSuccessHandler.onAuthenticationSuccess()`**

```java
@Override
public void onAuthenticationSuccess(
        HttpServletRequest request, 
        HttpServletResponse response,
        Authentication authentication) throws IOException, ServletException {
    
    // 1. Xác định URL redirect dựa trên role
    String targetUrl = determineTargetUrl(authentication);
    
    // 2. Redirect đến URL đó
    if (response.isCommitted()) {
        return;
    }
    redirectStrategy.sendRedirect(request, response, targetUrl);
    
    // 3. Lưu thông tin user vào session
    clearAuthenticationAttributes(request, authentication);
}
```

**Logic xử lý:**

1. **Xác định URL redirect:**
   ```java
   protected String determineTargetUrl(final Authentication authentication) {
       Map<String, String> roleTargetUrlMap = new HashMap<>();
       roleTargetUrlMap.put("ROLE_USER", "/");      // User → Trang chủ
       roleTargetUrlMap.put("ROLE_ADMIN", "/admin"); // Admin → Trang admin
       
       final Collection<? extends GrantedAuthority> authorities = 
           authentication.getAuthorities();
       
       for (final GrantedAuthority grantedAuthority : authorities) {
           String authorityName = grantedAuthority.getAuthority();
           if (roleTargetUrlMap.containsKey(authorityName)) {
               return roleTargetUrlMap.get(authorityName);
           }
       }
       
       throw new IllegalStateException();
   }
   ```
   - Lấy role từ `Authentication`
   - Map role → URL:
     - `ROLE_USER` → `/` (trang chủ)
     - `ROLE_ADMIN` → `/admin` (trang admin)

2. **Redirect đến URL:**
   - Sử dụng `RedirectStrategy` để redirect

3. **Lưu thông tin vào session:**
   ```java
   protected void clearAuthenticationAttributes(
           HttpServletRequest request, 
           Authentication authentication) {
       HttpSession session = request.getSession();
       
       // Xóa exception nếu có
       session.removeAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);
       
       // Lấy email từ authentication
       String email = authentication.getName();
       
       // Query user từ database
       User user = this.userService.getUserByEmail(email);
       
       if (user != null) {
           // Lưu thông tin user vào session
           session.setAttribute("fullName", user.getFullName());
           session.setAttribute("avatar", user.getAvatar());
           session.setAttribute("id", user.getId());
           session.setAttribute("email", user.getEmail());
           
           // Lưu số lượng sản phẩm trong giỏ hàng
           int sum = user.getCart() == null ? 0 : user.getCart().getSum();
           session.setAttribute("sum", sum);
       }
   }
   ```

**Thông tin lưu vào session:**
- `fullName`: Tên đầy đủ
- `avatar`: Đường dẫn ảnh đại diện
- `id`: ID của user
- `email`: Email
- `sum`: Số lượng sản phẩm trong giỏ hàng

---

### **BƯỚC 7: Redirect theo role**

Sau khi login thành công:

- **USER** → Redirect đến `/` (trang chủ)
- **ADMIN** → Redirect đến `/admin` (trang admin dashboard)

---

## 🔒 CÁC TÍNH NĂNG BẢO MẬT

### 1. **BCrypt Password Encoding**
- Mật khẩu được mã hóa bằng BCrypt
- Tự động salt (mỗi lần hash khác nhau)
- One-way hash (không thể reverse)

### 2. **Session Management**
- Chỉ cho phép 1 session/user
- Session mới sẽ đăng xuất session cũ
- Ngăn chặn đăng nhập từ nhiều thiết bị

### 3. **Role-Based Access Control (RBAC)**
- Phân quyền dựa trên role
- `/admin/**` chỉ ADMIN mới vào được
- Sử dụng `hasRole("ADMIN")` trong SecurityConfiguration

### 4. **Remember Me**
- Cho phép user giữ đăng nhập sau khi đóng browser
- Sử dụng cookie để lưu thông tin
- `SpringSessionRememberMeServices` với `setAlwaysRemember(true)`

### 5. **CSRF Protection**
- Spring Security tự động bảo vệ CSRF
- Token được tạo tự động cho form

### 6. **Password Validation**
- Mật khẩu phải có độ dài tối thiểu (tùy cấu hình)
- Không lưu mật khẩu plain text

---

## 📊 SƠ ĐỒ LUỒNG XỬ LÝ

```
┌─────────────────┐
│ User truy cập   │
│ /login          │
└────────┬────────┘
         │
         ▼
┌─────────────────────────┐
│ Hiển thị form login    │
│ (HomePageController)   │
└────────┬───────────────┘
         │
         ▼
┌─────────────────────────┐
│ User nhập email/password│
│ và submit form          │
└────────┬───────────────┘
         │
         ▼
┌─────────────────────────┐
│ Spring Security nhận    │
│ POST /login             │
└────────┬───────────────┘
         │
         ▼
┌─────────────────────────┐
│ DaoAuthenticationProvider│
│ xác thực                │
└────────┬───────────────┘
         │
         ▼
┌─────────────────────────┐
│ CustomUserDetailsService│
│ loadUserByUsername()    │
│ - Tìm user theo email   │
│ - Tạo UserDetails       │
└────────┬───────────────┘
         │
         ▼
┌─────────────────────────┐
│ BCrypt so sánh password│
│ - matches()            │
└────────┬───────────────┘
         │
    ┌────┴────┐
    │  OK?    │  Lỗi
    │         │
    ▼         ▼
┌─────────┐ ┌──────────────────┐
│ Thành   │ │ Redirect /login? │
│ công    │ │ error            │
└────┬────┘ └──────────────────┘
     │
     ▼
┌─────────────────────────┐
│ CustomSuccessHandler     │
│ onAuthenticationSuccess()│
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│ determineTargetUrl()     │
│ - ROLE_USER → /         │
│ - ROLE_ADMIN → /admin   │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│ Lưu thông tin vào       │
│ session:                │
│ - fullName, avatar, id  │
│ - email, sum (cart)     │
└────────┬────────────────┘
         │
         ▼
┌─────────────────────────┐
│ Redirect đến targetUrl  │
└─────────────────────────┘
```

---

## 🗄️ CÁC THÀNH PHẦN CHÍNH

### 1. **SecurityConfiguration**
- Cấu hình Spring Security
- Định nghĩa phân quyền, form login, session management

### 2. **CustomUserDetailsService**
- Load user từ database
- Tạo UserDetails object cho Spring Security

### 3. **CustomSuccessHandler**
- Xử lý sau khi login thành công
- Lưu thông tin vào session
- Redirect theo role

### 4. **DaoAuthenticationProvider**
- Xác thực username/password
- So sánh mật khẩu bằng BCrypt

### 5. **PasswordEncoder (BCrypt)**
- Mã hóa và so sánh mật khẩu

### 6. **UserService**
- Service layer để truy vấn user
- `getUserByEmail()` để tìm user

### 7. **UserRepository**
- Repository để truy vấn database
- `findByEmail()` để tìm user theo email

---

## 📝 CÁC TRƯỜNG HỢP XỬ LÝ

### **1. Login thành công (USER)**
```
1. User nhập email/password đúng
2. Xác thực thành công
3. Lưu thông tin vào session
4. Redirect → / (trang chủ)
```

### **2. Login thành công (ADMIN)**
```
1. User nhập email/password đúng
2. Xác thực thành công
3. Lưu thông tin vào session
4. Redirect → /admin (trang admin)
```

### **3. Login thất bại - Email không tồn tại**
```
1. User nhập email không tồn tại
2. CustomUserDetailsService.loadUserByUsername()
   → throw UsernameNotFoundException
3. Spring Security catch exception
4. Redirect → /login?error
```

### **4. Login thất bại - Mật khẩu sai**
```
1. User nhập email đúng, password sai
2. BCrypt.matches() → false
3. DaoAuthenticationProvider throw BadCredentialsException
4. Spring Security catch exception
5. Redirect → /login?error
```

### **5. User đã đăng nhập, tạo session mới**
```
1. User đã có session đang active
2. User login từ thiết bị khác
3. Session cũ bị invalidate
4. Session mới được tạo
```

---

## 🔍 CÁCH SỬ DỤNG THÔNG TIN USER SAU KHI LOGIN

### **Lấy thông tin từ Session:**
```java
HttpSession session = request.getSession(false);
if (session != null) {
    String fullName = (String) session.getAttribute("fullName");
    String avatar = (String) session.getAttribute("avatar");
    Long id = (Long) session.getAttribute("id");
    String email = (String) session.getAttribute("email");
    Integer sum = (Integer) session.getAttribute("sum");
}
```

### **Lấy thông tin từ Authentication:**
```java
Authentication authentication = SecurityContextHolder
    .getContext()
    .getAuthentication();

if (authentication != null && authentication.isAuthenticated()) {
    String email = authentication.getName();  // Email
    Collection<? extends GrantedAuthority> authorities = 
        authentication.getAuthorities();  // Roles
}
```

### **Kiểm tra role:**
```java
Authentication authentication = SecurityContextHolder
    .getContext()
    .getAuthentication();

if (authentication != null) {
    boolean isAdmin = authentication.getAuthorities().stream()
        .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
}
```

---

## ⚠️ LƯU Ý QUAN TRỌNG

### 1. **Username = Email**
- Trong hệ thống này, `username` trong form login thực chất là `email`
- `CustomUserDetailsService.loadUserByUsername()` nhận email

### 2. **Role phải có prefix "ROLE_"**
- Spring Security yêu cầu role phải có prefix "ROLE_"
- `ROLE_USER`, `ROLE_ADMIN` (không phải `USER`, `ADMIN`)

### 3. **Session Management**
- Chỉ cho phép 1 session/user
- Session mới sẽ đăng xuất session cũ
- Có thể thay đổi bằng `maxSessionsPreventsLogin(true)`

### 4. **Remember Me**
- `setAlwaysRemember(true)` → Luôn remember
- Có thể tắt hoặc cấu hình thời gian

### 5. **Password Encoding**
- Phải mã hóa password khi đăng ký
- Sử dụng cùng `PasswordEncoder` để so sánh

---

## 🐛 DEBUG VÀ TROUBLESHOOTING

### **Login không thành công:**
1. Kiểm tra email có tồn tại trong database
2. Kiểm tra password có đúng format BCrypt
3. Kiểm tra role có đúng format "ROLE_USER" hoặc "ROLE_ADMIN"
4. Xem log để biết exception cụ thể

### **Redirect không đúng:**
1. Kiểm tra `determineTargetUrl()` trong `CustomSuccessHandler`
2. Kiểm tra role mapping
3. Kiểm tra authorities trong Authentication

### **Session không lưu thông tin:**
1. Kiểm tra `clearAuthenticationAttributes()` có được gọi
2. Kiểm tra session có được tạo
3. Kiểm tra user có tồn tại trong database

---

## 📝 TÓM TẮT

### **Quy trình login:**

1. **User truy cập `/login`** → Hiển thị form
2. **User submit form** → Spring Security nhận request
3. **CustomUserDetailsService** → Load user từ database
4. **DaoAuthenticationProvider** → Xác thực mật khẩu (BCrypt)
5. **CustomSuccessHandler** → Lưu session và redirect
6. **Redirect** → `/` (USER) hoặc `/admin` (ADMIN)

### **Các thành phần chính:**

- **SecurityConfiguration**: Cấu hình Spring Security
- **CustomUserDetailsService**: Load user
- **CustomSuccessHandler**: Xử lý sau login
- **DaoAuthenticationProvider**: Xác thực
- **BCryptPasswordEncoder**: Mã hóa mật khẩu

### **Bảo mật:**

- BCrypt password encoding
- Session management (1 session/user)
- Role-based access control
- CSRF protection
- Remember Me

---

*Tài liệu này giải thích chi tiết cơ chế login trong hệ thống Laptop Shop sử dụng Spring Security.*

