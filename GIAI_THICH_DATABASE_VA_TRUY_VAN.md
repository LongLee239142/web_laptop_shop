# 📊 GIẢI THÍCH CÁC BẢNG DATABASE VÀ CÁCH TRUY VẤN

## 🗂️ TỔNG QUAN
Hệ thống Laptop Shop sử dụng **9 bảng chính** để quản lý toàn bộ hoạt động của cửa hàng. Mỗi bảng có nhiệm vụ cụ thể và được truy vấn thông qua Spring Data JPA Repository.

---

## 1️⃣ BẢNG `users` (Người dùng)

### 📋 Nhiệm vụ:
- **Lưu trữ thông tin tài khoản** của tất cả người dùng (khách hàng và admin)
- **Xác thực đăng nhập** và phân quyền truy cập
- **Liên kết trung tâm** với các bảng khác trong hệ thống

### 🔑 Các trường chính:
- `id` (PK, AUTO_INCREMENT): Mã định danh duy nhất
- `email` (UNIQUE): Email đăng nhập, có validation format
- `password`: Mật khẩu đã mã hóa bằng BCrypt
- `fullName`: Họ và tên đầy đủ
- `address`: Địa chỉ
- `phone`: Số điện thoại (format: 0xxxxxxxxx)
- `avatar`: Đường dẫn ảnh đại diện
- `role_id` (FK): Tham chiếu đến bảng `roles`

### 🔗 Quan hệ:
- **Many-to-One** với `roles`: Một user có một role (USER hoặc ADMIN)
- **One-to-One** với `carts`: Mỗi user có một giỏ hàng
- **One-to-Many** với `orders`: Một user có nhiều đơn hàng
- **One-to-Many** với `chat_history`: Một user có nhiều lịch sử chat
- **One-to-Many** với `password_reset_tokens`: Một user có thể có nhiều token reset password

### 💻 Các truy vấn chính (UserRepository):
```java
// Tìm user theo email (dùng cho đăng nhập)
User findByEmail(String email);

// Kiểm tra email đã tồn tại chưa (dùng cho đăng ký)
boolean existsByEmail(String email);

// Tìm user theo ID
User findById(long id);

// Lấy tất cả users có phân trang
Page<User> findAll(Pageable page);

// Lưu user mới hoặc cập nhật
User save(User user);

// Xóa user
void deleteById(long id);
```

### 🎯 Các trường hợp sử dụng:
- **Đăng nhập**: `findByEmail()` để tìm user và xác thực mật khẩu
- **Đăng ký**: `existsByEmail()` để kiểm tra email đã tồn tại, sau đó `save()` để tạo user mới
- **Quản lý user**: Admin dùng `findAll()` để xem danh sách, `deleteById()` để xóa user
- **Lấy thông tin**: `findById()` để lấy thông tin user khi xem profile hoặc đơn hàng

---

## 2️⃣ BẢNG `roles` (Vai trò)

### 📋 Nhiệm vụ:
- **Định nghĩa các vai trò/quyền** trong hệ thống (USER, ADMIN)
- **Phân quyền truy cập** các chức năng của hệ thống
- **Bảo mật** bằng cách kiểm soát quyền admin và user thường

### 🔑 Các trường chính:
- `id` (PK): Mã định danh
- `name`: Tên vai trò (ví dụ: "USER", "ADMIN")
- `description`: Mô tả vai trò

### 🔗 Quan hệ:
- **One-to-Many** với `users`: Một role có nhiều users

### 💻 Các truy vấn chính (RoleRepository):
```java
// Tìm role theo tên (dùng khi đăng ký user mới)
Role findByName(String name);
```

### 🎯 Các trường hợp sử dụng:
- **Đăng ký user mới**: Tự động gán role "USER" bằng cách `findByName("USER")`
- **Phân quyền**: Spring Security kiểm tra role của user để cho phép truy cập các trang admin

---

## 3️⃣ BẢNG `products` (Sản phẩm)

### 📋 Nhiệm vụ:
- **Lưu trữ thông tin chi tiết** về các sản phẩm laptop trong cửa hàng
- **Quản lý tồn kho** và số lượng đã bán
- **Hỗ trợ tìm kiếm và lọc** sản phẩm theo nhiều tiêu chí

### 🔑 Các trường chính:
- `id` (PK, AUTO_INCREMENT): Mã sản phẩm
- `name`: Tên sản phẩm
- `price` (CHECK > 0): Giá bán
- `image`: Đường dẫn ảnh sản phẩm
- `detailDesc` (MEDIUMTEXT): Mô tả chi tiết
- `shortDesc`: Mô tả ngắn gọn
- `quantity` (CHECK >= 1): Số lượng tồn kho
- `sold`: Số lượng đã bán
- `factory`: Hãng sản xuất (ASUS, Dell, HP, Lenovo, Apple, Acer, LG)
- `target`: Phân loại mục đích sử dụng (GAMING, SINHVIEN-VANPHONG, THIET-KE-DO-HOA, MONG-NHE, DOANH-NHAN)

### 🔗 Quan hệ:
- **One-to-Many** với `cart_detail`: Một sản phẩm có thể có trong nhiều giỏ hàng
- **One-to-Many** với `order_detail`: Một sản phẩm có thể có trong nhiều đơn hàng

### 💻 Các truy vấn chính (ProductRepository):
```java
// Tìm sản phẩm theo ID
Product findById(long id);

// Lấy tất cả sản phẩm có phân trang
Page<Product> findAll(Pageable page);

// Tìm kiếm và lọc sản phẩm với Specification (lọc theo factory, target, price)
Page<Product> findAll(Specification<Product> spec, Pageable page);

// Lưu sản phẩm mới hoặc cập nhật
Product save(Product product);

// Xóa sản phẩm
void deleteById(long id);
```

### 🎯 Các trường hợp sử dụng:
- **Hiển thị danh sách sản phẩm**: `findAll(Pageable)` để phân trang
- **Tìm kiếm và lọc**: `findAll(Specification, Pageable)` để lọc theo:
  - Hãng sản xuất (factory): ASUS, Dell, Apple...
  - Mục đích sử dụng (target): GAMING, SINHVIEN-VANPHONG...
  - Khoảng giá (price): Dưới 10 triệu, 10-20 triệu, trên 20 triệu...
- **Xem chi tiết sản phẩm**: `findById()` để hiển thị thông tin đầy đủ
- **Quản lý sản phẩm**: Admin dùng `save()` để thêm/sửa, `deleteById()` để xóa
- **Cập nhật tồn kho**: Khi có đơn hàng, giảm `quantity` và tăng `sold`

---

## 4️⃣ BẢNG `carts` (Giỏ hàng)

### 📋 Nhiệm vụ:
- **Lưu trữ giỏ hàng** của mỗi người dùng (mỗi user có một giỏ hàng)
- **Quản lý giỏ hàng tạm thời** trước khi đặt hàng
- **Theo dõi số lượng sản phẩm** trong giỏ hàng

### 🔑 Các trường chính:
- `id` (PK): Mã giỏ hàng
- `sum`: Tổng số sản phẩm trong giỏ hàng
- `user_id` (FK): Tham chiếu đến `users`

### 🔗 Quan hệ:
- **Many-to-One** với `users`: Mỗi giỏ hàng thuộc về một user (thực tế là One-to-One)
- **One-to-Many** với `cart_detail`: Một giỏ hàng có nhiều chi tiết sản phẩm

### 💻 Các truy vấn chính (CartRepository):
```java
// Tìm giỏ hàng của user
Cart findByUser(User user);

// Lưu giỏ hàng
Cart save(Cart cart);
```

### 🎯 Các trường hợp sử dụng:
- **Lấy giỏ hàng**: `findByUser()` để lấy giỏ hàng của user hiện tại
- **Tạo giỏ hàng mới**: Khi user đăng ký, tự động tạo giỏ hàng rỗng
- **Xóa giỏ hàng**: Sau khi đặt hàng thành công, xóa toàn bộ giỏ hàng

---

## 5️⃣ BẢNG `cart_detail` (Chi tiết giỏ hàng)

### 📋 Nhiệm vụ:
- **Lưu trữ từng sản phẩm** và số lượng trong giỏ hàng
- **Lưu giá tại thời điểm thêm vào giỏ** để bảo vệ khách hàng khỏi thay đổi giá
- **Quản lý số lượng sản phẩm** user muốn mua

### 🔑 Các trường chính:
- `id` (PK): Mã chi tiết
- `quantity`: Số lượng sản phẩm
- `price`: Giá tại thời điểm thêm vào giỏ (quan trọng!)
- `cart_id` (FK): Tham chiếu đến `carts`
- `product_id` (FK): Tham chiếu đến `products`

### 🔗 Quan hệ:
- **Many-to-One** với `carts`: Nhiều chi tiết thuộc một giỏ hàng
- **Many-to-One** với `products`: Nhiều chi tiết có thể cùng một sản phẩm

### 💻 Các truy vấn chính (CartDetailRepository):
```java
// Kiểm tra sản phẩm đã có trong giỏ hàng chưa
boolean existsByCartAndProduct(Cart cart, Product product);

// Tìm chi tiết giỏ hàng theo cart và product
CartDetail findByCartAndProduct(Cart cart, Product product);

// Lấy tất cả chi tiết trong giỏ hàng
List<CartDetail> findByCartId(Long id);

// Lưu chi tiết giỏ hàng
CartDetail save(CartDetail cartDetail);

// Xóa chi tiết giỏ hàng
void deleteById(long id);
```

### 🎯 Các trường hợp sử dụng:
- **Thêm sản phẩm vào giỏ**: 
  - Kiểm tra `existsByCartAndProduct()` để xem đã có chưa
  - Nếu có: Tăng `quantity` của chi tiết hiện tại
  - Nếu chưa: Tạo mới `CartDetail` với `price` tại thời điểm hiện tại
- **Xem giỏ hàng**: `findByCartId()` để lấy tất cả sản phẩm trong giỏ
- **Cập nhật số lượng**: `save()` để cập nhật `quantity`
- **Xóa sản phẩm khỏi giỏ**: `deleteById()` để xóa chi tiết

---

## 6️⃣ BẢNG `orders` (Đơn hàng)

### 📋 Nhiệm vụ:
- **Lưu trữ thông tin đơn hàng** sau khi khách hàng thanh toán
- **Quản lý trạng thái đơn hàng** (PENDING, PROCESSING, SHIPPED, DELIVERED, CANCELLED)
- **Lưu thông tin giao hàng** (có thể khác với thông tin user)

### 🔑 Các trường chính:
- `id` (PK, AUTO_INCREMENT): Mã đơn hàng
- `totalPrice`: Tổng giá trị đơn hàng
- `receiverName`: Tên người nhận
- `receiverAddress`: Địa chỉ nhận hàng
- `receiverPhone`: Số điện thoại người nhận
- `status`: Trạng thái đơn hàng
- `user_id` (FK): Tham chiếu đến `users`

### 🔗 Quan hệ:
- **Many-to-One** với `users`: Nhiều đơn hàng thuộc một user
- **One-to-Many** với `order_detail`: Một đơn hàng có nhiều chi tiết sản phẩm

### 💻 Các truy vấn chính (OrderRepository):
```java
// Lấy tất cả đơn hàng có phân trang
Page<Order> findAll(Pageable page);

// Tìm đơn hàng theo ID
Order findById(long id);

// Tìm tất cả đơn hàng của một user
List<Order> findByUser(User user);

// Lưu đơn hàng mới
Order save(Order order);

// Xóa đơn hàng
void deleteById(long id);
```

### 🎯 Các trường hợp sử dụng:
- **Đặt hàng**: 
  - Tạo `Order` mới với status "PENDING"
  - Copy thông tin từ giỏ hàng sang `order_detail`
  - Tính `totalPrice` từ tổng các `order_detail`
  - Xóa giỏ hàng sau khi đặt hàng thành công
- **Xem lịch sử đơn hàng**: User dùng `findByUser()` để xem đơn hàng của mình
- **Quản lý đơn hàng**: Admin dùng `findAll()` để xem tất cả đơn hàng, `findById()` để xem chi tiết
- **Cập nhật trạng thái**: Admin cập nhật `status` khi xử lý đơn hàng

---

## 7️⃣ BẢNG `order_detail` (Chi tiết đơn hàng)

### 📋 Nhiệm vụ:
- **Lưu trữ chi tiết từng sản phẩm** trong đơn hàng
- **Lưu giá tại thời điểm đặt hàng** (lịch sử giá, không bị ảnh hưởng khi giá sản phẩm thay đổi)
- **Tính tổng giá trị đơn hàng** từ các chi tiết

### 🔑 Các trường chính:
- `id` (PK): Mã chi tiết
- `quantity`: Số lượng sản phẩm đã mua
- `price`: Giá tại thời điểm đặt hàng (quan trọng!)
- `order_id` (FK): Tham chiếu đến `orders`
- `product_id` (FK): Tham chiếu đến `products`

### 🔗 Quan hệ:
- **Many-to-One** với `orders`: Nhiều chi tiết thuộc một đơn hàng
- **Many-to-One** với `products`: Nhiều chi tiết có thể cùng một sản phẩm

### 💻 Các truy vấn chính (OrderDetailRepository):
```java
// Lưu chi tiết đơn hàng
OrderDetail save(OrderDetail orderDetail);

// Tìm tất cả chi tiết của một đơn hàng
List<OrderDetail> findByOrder(Order order);
```

### 🎯 Các trường hợp sử dụng:
- **Tạo đơn hàng**: 
  - Copy từng `CartDetail` sang `OrderDetail`
  - Lưu `price` từ `CartDetail` (giá tại thời điểm thêm vào giỏ)
  - Tính `totalPrice` của `Order` = tổng (quantity × price) của tất cả `OrderDetail`
- **Xem chi tiết đơn hàng**: `findByOrder()` để hiển thị danh sách sản phẩm trong đơn hàng
- **Lịch sử giá**: Giá trong `OrderDetail` không thay đổi dù giá sản phẩm có thay đổi sau này

---

## 8️⃣ BẢNG `chat_history` (Lịch sử chat)

### 📋 Nhiệm vụ:
- **Lưu trữ lịch sử cuộc trò chuyện** giữa user và chatbot
- **Hỗ trợ hiển thị lại lịch sử chat** khi user mở lại chatbot
- **Phân tích và cải thiện chatbot** dựa trên dữ liệu

### 🔑 Các trường chính:
- `id` (PK): Mã lịch sử
- `userMessage`: Tin nhắn của người dùng
- `botResponse`: Phản hồi của chatbot
- `timestamp`: Thời gian gửi tin nhắn
- `user_id` (FK, nullable): Tham chiếu đến `users` (có thể null nếu user chưa đăng nhập)

### 🔗 Quan hệ:
- **Many-to-One** với `users`: Nhiều lịch sử chat thuộc một user (có thể null)

### 💻 Các truy vấn chính (ChatHistoryRepository):
```java
// Lưu lịch sử chat
ChatHistory save(ChatHistory chatHistory);

// Tìm lịch sử chat của user
List<ChatHistory> findByUser(User user);

// Tìm lịch sử chat theo user và sắp xếp theo thời gian
List<ChatHistory> findByUserOrderByTimestampAsc(User user);
```

### 🎯 Các trường hợp sử dụng:
- **Lưu chat**: Mỗi khi user gửi tin nhắn, lưu `userMessage` và `botResponse` vào database
- **Hiển thị lịch sử**: Khi user mở chatbot, `findByUserOrderByTimestampAsc()` để hiển thị lại các tin nhắn cũ
- **Chat không đăng nhập**: Nếu user chưa đăng nhập, `user_id` = null nhưng vẫn lưu được lịch sử

---

## 9️⃣ BẢNG `password_reset_tokens` (Token đặt lại mật khẩu)

### 📋 Nhiệm vụ:
- **Lưu trữ token để đặt lại mật khẩu** khi user quên mật khẩu
- **Bảo mật quá trình đặt lại mật khẩu** bằng token duy nhất
- **Đảm bảo token chỉ sử dụng một lần** và có thời hạn

### 🔑 Các trường chính:
- `id` (PK): Mã token
- `token`: Token duy nhất để reset password (UUID)
- `user_id` (FK): Tham chiếu đến `users`
- `expiryDate`: Thời gian hết hạn của token (thường 24 giờ)
- `used`: Đánh dấu token đã được sử dụng chưa (boolean)

### 🔗 Quan hệ:
- **Many-to-One** với `users`: Nhiều token có thể thuộc một user (user có thể yêu cầu reset nhiều lần)

### 💻 Các truy vấn chính (PasswordResetTokenRepository):
```java
// Tìm token theo giá trị token
PasswordResetToken findByToken(String token);

// Tìm token của user
List<PasswordResetToken> findByUser(User user);

// Lưu token mới
PasswordResetToken save(PasswordResetToken token);

// Xóa token đã hết hạn
void deleteByExpiryDateBefore(Date date);
```

### 🎯 Các trường hợp sử dụng:
- **Yêu cầu reset password**: 
  - User nhập email
  - Tạo token mới (UUID), set `expiryDate` = hiện tại + 24 giờ
  - Gửi email chứa link reset với token
  - Lưu vào database
- **Reset password**: 
  - User click link trong email
  - `findByToken()` để tìm token
  - Kiểm tra token chưa hết hạn và chưa được sử dụng
  - Cho phép đổi mật khẩu, đánh dấu `used = true`
- **Dọn dẹp**: Xóa token đã hết hạn bằng `deleteByExpiryDateBefore()`

---

## 🔄 SƠ ĐỒ QUAN HỆ GIỮA CÁC BẢNG

```
users (1) ──< (N) orders ──< (N) order_detail >── (N) products
  │                                                      │
  │ (1)                                                  │
  ├──< (1) carts ──< (N) cart_detail >─────────────────┘
  │
  ├──< (N) chat_history
  │
  ├──< (N) password_reset_tokens
  │
  └──> (N) roles
```

---

## 📝 QUY TRÌNH TRUY VẤN ĐIỂN HÌNH

### 1. **Quy trình đăng ký và tạo giỏ hàng:**
```
1. User nhập thông tin đăng ký
2. UserRepository.existsByEmail() → Kiểm tra email đã tồn tại?
3. RoleRepository.findByName("USER") → Lấy role USER
4. UserRepository.save() → Tạo user mới
5. CartRepository.save() → Tạo giỏ hàng rỗng cho user
```

### 2. **Quy trình thêm sản phẩm vào giỏ hàng:**
```
1. User chọn sản phẩm
2. CartRepository.findByUser() → Lấy giỏ hàng của user
3. CartDetailRepository.existsByCartAndProduct() → Kiểm tra sản phẩm đã có trong giỏ?
   - Nếu có: CartDetailRepository.findByCartAndProduct() → Tăng quantity
   - Nếu chưa: Tạo CartDetail mới với price hiện tại
4. CartDetailRepository.save() → Lưu chi tiết giỏ hàng
5. Cập nhật Cart.sum → Tổng số sản phẩm
```

### 3. **Quy trình đặt hàng:**
```
1. User xác nhận đặt hàng
2. CartDetailRepository.findByCartId() → Lấy tất cả sản phẩm trong giỏ
3. Tạo Order mới với status "PENDING"
4. Với mỗi CartDetail:
   - Tạo OrderDetail với price từ CartDetail
   - OrderDetailRepository.save()
   - Giảm Product.quantity, tăng Product.sold
5. Tính Order.totalPrice = tổng (quantity × price) của OrderDetail
6. OrderRepository.save() → Lưu đơn hàng
7. Xóa tất cả CartDetail và Cart
```

### 4. **Quy trình tìm kiếm sản phẩm:**
```
1. User chọn tiêu chí lọc (factory, target, price)
2. ProductService.buildPriceSpecification() → Tạo Specification cho giá
3. ProductSpecs.matchListFactory() → Tạo Specification cho hãng
4. ProductSpecs.matchListTarget() → Tạo Specification cho mục đích
5. Kết hợp các Specification
6. ProductRepository.findAll(Specification, Pageable) → Truy vấn với điều kiện
7. Trả về danh sách sản phẩm đã lọc và phân trang
```

### 5. **Quy trình chat với bot:**
```
1. User gửi tin nhắn
2. ChatService.getReply() → Xử lý tin nhắn và tạo phản hồi
3. ChatHistoryRepository.save() → Lưu userMessage và botResponse
4. Nếu user đã đăng nhập: ChatHistoryRepository.findByUser() → Hiển thị lịch sử
```

---

## 🎯 TÓM TẮT NHIỆM VỤ CÁC BẢNG

| Bảng | Nhiệm vụ chính | Truy vấn quan trọng |
|------|----------------|---------------------|
| `users` | Quản lý tài khoản, xác thực | `findByEmail()`, `existsByEmail()` |
| `roles` | Phân quyền truy cập | `findByName()` |
| `products` | Quản lý sản phẩm, tồn kho | `findAll(Specification, Pageable)`, `findById()` |
| `carts` | Giỏ hàng tạm thời | `findByUser()` |
| `cart_detail` | Chi tiết giỏ hàng, lưu giá | `existsByCartAndProduct()`, `findByCartId()` |
| `orders` | Đơn hàng, quản lý trạng thái | `findByUser()`, `findAll(Pageable)` |
| `order_detail` | Chi tiết đơn hàng, lịch sử giá | `findByOrder()` |
| `chat_history` | Lịch sử chatbot | `findByUserOrderByTimestampAsc()` |
| `password_reset_tokens` | Reset mật khẩu bảo mật | `findByToken()` |

---

## ⚠️ LƯU Ý QUAN TRỌNG

### 1. **Bảo vệ giá sản phẩm:**
- `CartDetail.price` và `OrderDetail.price` lưu giá tại thời điểm thêm vào giỏ/đặt hàng
- Giá này không thay đổi dù `Product.price` có thay đổi sau này
- Bảo vệ khách hàng khỏi việc giá tăng đột ngột

### 2. **Quản lý tồn kho:**
- Khi đặt hàng: Giảm `Product.quantity`, tăng `Product.sold`
- Kiểm tra `quantity > 0` trước khi cho phép thêm vào giỏ hàng

### 3. **Bảo mật:**
- `User.password` phải được mã hóa bằng BCrypt
- `PasswordResetToken.token` phải là UUID ngẫu nhiên và unique
- Token có thời hạn và chỉ dùng một lần

### 4. **Hiệu năng:**
- Sử dụng phân trang (`Pageable`) cho danh sách lớn
- Sử dụng `Specification` để tối ưu truy vấn phức tạp
- Index các trường thường được tìm kiếm: `email`, `factory`, `target`, `price`

---

*Tài liệu này giải thích chi tiết về cấu trúc database và cách truy vấn trong hệ thống Laptop Shop.*

