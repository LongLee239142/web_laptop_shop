# 📊 GIẢI THÍCH CHỨC NĂNG VÀ NHIỆM VỤ CÁC BẢNG TRONG HỆ THỐNG

## 🗂️ TỔNG QUAN
Hệ thống Laptop Shop sử dụng 9 bảng chính để quản lý người dùng, sản phẩm, giỏ hàng, đơn hàng và các tính năng hỗ trợ.

---

## 1️⃣ BẢNG `users` (Người dùng)

### 📋 Chức năng:
Lưu trữ thông tin tài khoản của người dùng trong hệ thống (khách hàng và admin).

### 🔑 Các trường chính:
- `id` (PK): Mã định danh duy nhất
- `email`: Email đăng nhập (unique, có validation)
- `password`: Mật khẩu đã mã hóa
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

### 💼 Nhiệm vụ:
- Quản lý thông tin đăng nhập và xác thực
- Phân quyền người dùng (USER/ADMIN)
- Liên kết với giỏ hàng và đơn hàng của user

---

## 2️⃣ BẢNG `roles` (Vai trò)

### 📋 Chức năng:
Định nghĩa các vai trò/quyền trong hệ thống (USER, ADMIN).

### 🔑 Các trường chính:
- `id` (PK): Mã định danh
- `name`: Tên vai trò (ví dụ: "USER", "ADMIN")
- `description`: Mô tả vai trò

### 🔗 Quan hệ:
- **One-to-Many** với `users`: Một role có nhiều users

### 💼 Nhiệm vụ:
- Phân quyền truy cập hệ thống
- Kiểm soát quyền admin và user thường

---

## 3️⃣ BẢNG `products` (Sản phẩm)

### 📋 Chức năng:
Lưu trữ thông tin chi tiết về các sản phẩm laptop trong cửa hàng.

### 🔑 Các trường chính:
- `id` (PK): Mã sản phẩm
- `name`: Tên sản phẩm
- `price`: Giá bán (phải > 0)
- `image`: Đường dẫn ảnh sản phẩm
- `detailDesc`: Mô tả chi tiết (MEDIUMTEXT)
- `shortDesc`: Mô tả ngắn gọn
- `quantity`: Số lượng tồn kho (phải > 0)
- `sold`: Số lượng đã bán
- `factory`: Hãng sản xuất (ASUS, Dell, HP, Lenovo, Apple, Acer, LG)
- `target`: Phân loại mục đích sử dụng (GAMING, SINHVIEN-VANPHONG, THIET-KE-DO-HOA, MONG-NHE, DOANH-NHAN)

### 🔗 Quan hệ:
- **One-to-Many** với `cart_detail`: Một sản phẩm có thể có trong nhiều giỏ hàng
- **One-to-Many** với `order_detail`: Một sản phẩm có thể có trong nhiều đơn hàng

### 💼 Nhiệm vụ:
- Quản lý danh mục sản phẩm
- Theo dõi tồn kho và số lượng đã bán
- Hỗ trợ tìm kiếm và lọc sản phẩm theo hãng, giá, mục đích sử dụng

---

## 4️⃣ BẢNG `carts` (Giỏ hàng)

### 📋 Chức năng:
Lưu trữ giỏ hàng của mỗi người dùng (mỗi user có một giỏ hàng).

### 🔑 Các trường chính:
- `id` (PK): Mã giỏ hàng
- `sum`: Tổng số sản phẩm trong giỏ hàng
- `user_id` (FK): Tham chiếu đến `users`

### 🔗 Quan hệ:
- **Many-to-One** với `users`: Nhiều giỏ hàng thuộc về một user (thực tế là One-to-One)
- **One-to-Many** với `cart_detail`: Một giỏ hàng có nhiều chi tiết sản phẩm

### 💼 Nhiệm vụ:
- Quản lý giỏ hàng tạm thời trước khi đặt hàng
- Theo dõi số lượng sản phẩm trong giỏ
- Xóa giỏ hàng sau khi đặt hàng thành công

---

## 5️⃣ BẢNG `cart_detail` (Chi tiết giỏ hàng)

### 📋 Chức năng:
Lưu trữ từng sản phẩm và số lượng trong giỏ hàng.

### 🔑 Các trường chính:
- `id` (PK): Mã chi tiết
- `quantity`: Số lượng sản phẩm
- `price`: Giá tại thời điểm thêm vào giỏ (để tránh thay đổi giá)
- `cart_id` (FK): Tham chiếu đến `carts`
- `product_id` (FK): Tham chiếu đến `products`

### 🔗 Quan hệ:
- **Many-to-One** với `carts`: Nhiều chi tiết thuộc một giỏ hàng
- **Many-to-One** với `products`: Nhiều chi tiết có thể cùng một sản phẩm

### 💼 Nhiệm vụ:
- Lưu trữ chi tiết từng sản phẩm trong giỏ hàng
- Lưu giá tại thời điểm thêm vào giỏ (bảo vệ khách hàng khỏi thay đổi giá)
- Quản lý số lượng sản phẩm user muốn mua

---

## 6️⃣ BẢNG `orders` (Đơn hàng)

### 📋 Chức năng:
Lưu trữ thông tin đơn hàng sau khi khách hàng thanh toán.

### 🔑 Các trường chính:
- `id` (PK): Mã đơn hàng
- `totalPrice`: Tổng giá trị đơn hàng
- `receiverName`: Tên người nhận
- `receiverAddress`: Địa chỉ nhận hàng
- `receiverPhone`: Số điện thoại người nhận
- `status`: Trạng thái đơn hàng (PENDING, PROCESSING, SHIPPED, DELIVERED, CANCELLED)
- `user_id` (FK): Tham chiếu đến `users`

### 🔗 Quan hệ:
- **Many-to-One** với `users`: Nhiều đơn hàng thuộc một user
- **One-to-Many** với `order_detail`: Một đơn hàng có nhiều chi tiết sản phẩm

### 💼 Nhiệm vụ:
- Lưu trữ thông tin đơn hàng đã đặt
- Quản lý trạng thái đơn hàng (đang xử lý, đang giao, đã giao, đã hủy)
- Lưu thông tin giao hàng (có thể khác với thông tin user)

---

## 7️⃣ BẢNG `order_detail` (Chi tiết đơn hàng)

### 📋 Chức năng:
Lưu trữ chi tiết từng sản phẩm trong đơn hàng.

### 🔑 Các trường chính:
- `id` (PK): Mã chi tiết
- `quantity`: Số lượng sản phẩm đã mua
- `price`: Giá tại thời điểm đặt hàng
- `order_id` (FK): Tham chiếu đến `orders`
- `product_id` (FK): Tham chiếu đến `products`

### 🔗 Quan hệ:
- **Many-to-One** với `orders`: Nhiều chi tiết thuộc một đơn hàng
- **Many-to-One** với `products`: Nhiều chi tiết có thể cùng một sản phẩm

### 💼 Nhiệm vụ:
- Lưu trữ chi tiết sản phẩm đã mua trong đơn hàng
- Lưu giá tại thời điểm đặt hàng (lịch sử giá)
- Tính tổng giá trị đơn hàng

---

## 8️⃣ BẢNG `chat_history` (Lịch sử chat)

### 📋 Chức năng:
Lưu trữ lịch sử cuộc trò chuyện giữa user và chatbot.

### 🔑 Các trường chính:
- `id` (PK): Mã lịch sử
- `userMessage`: Tin nhắn của người dùng
- `botResponse`: Phản hồi của chatbot
- `timestamp`: Thời gian gửi tin nhắn
- `user_id` (FK, nullable): Tham chiếu đến `users` (có thể null nếu user chưa đăng nhập)

### 🔗 Quan hệ:
- **Many-to-One** với `users`: Nhiều lịch sử chat thuộc một user (có thể null)

### 💼 Nhiệm vụ:
- Lưu trữ lịch sử trò chuyện với chatbot
- Hỗ trợ hiển thị lại lịch sử chat khi user mở lại chatbot
- Phân tích và cải thiện chatbot dựa trên dữ liệu

---

## 9️⃣ BẢNG `password_reset_tokens` (Token đặt lại mật khẩu)

### 📋 Chức năng:
Lưu trữ token để đặt lại mật khẩu khi user quên mật khẩu.

### 🔑 Các trường chính:
- `id` (PK): Mã token
- `token`: Token duy nhất để reset password
- `user_id` (FK): Tham chiếu đến `users`
- `expiryDate`: Thời gian hết hạn của token
- `used`: Đánh dấu token đã được sử dụng chưa

### 🔗 Quan hệ:
- **Many-to-One** với `users`: Nhiều token có thể thuộc một user (user có thể yêu cầu reset nhiều lần)

### 💼 Nhiệm vụ:
- Bảo mật quá trình đặt lại mật khẩu
- Đảm bảo token chỉ sử dụng một lần và có thời hạn
- Ngăn chặn tấn công brute force

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

## 📝 GHI CHÚ QUAN TRỌNG

1. **Cascade Operations**: 
   - Khi xóa user, cần xử lý cascade cho các bảng liên quan
   - Khi xóa product, cần kiểm tra xem có đơn hàng nào đang sử dụng không

2. **Data Integrity**:
   - `cart_detail` và `order_detail` lưu giá tại thời điểm thêm vào giỏ/đặt hàng để bảo vệ khách hàng
   - `status` trong `orders` nên sử dụng enum hoặc constants để đảm bảo tính nhất quán

3. **Performance**:
   - Các bảng có quan hệ Many-to-Many nên được index đúng cách
   - `products` nên có index trên `factory`, `target`, `price` để tối ưu tìm kiếm

4. **Security**:
   - `password` trong `users` phải được mã hóa (BCrypt)
   - `token` trong `password_reset_tokens` phải là random và unique

---

## 🎯 TÓM TẮT CHỨC NĂNG CHÍNH

| Bảng | Chức năng chính | Quan hệ chính |
|------|----------------|---------------|
| `users` | Quản lý tài khoản | Trung tâm, liên kết với hầu hết các bảng |
| `roles` | Phân quyền | Liên kết với users |
| `products` | Quản lý sản phẩm | Liên kết với cart_detail và order_detail |
| `carts` | Giỏ hàng tạm | Liên kết với users và cart_detail |
| `cart_detail` | Chi tiết giỏ hàng | Liên kết carts và products |
| `orders` | Đơn hàng | Liên kết với users và order_detail |
| `order_detail` | Chi tiết đơn hàng | Liên kết orders và products |
| `chat_history` | Lịch sử chatbot | Liên kết với users (nullable) |
| `password_reset_tokens` | Reset mật khẩu | Liên kết với users |

---

*Tài liệu này mô tả cấu trúc database của hệ thống Laptop Shop, được tạo tự động từ các Entity classes.*

