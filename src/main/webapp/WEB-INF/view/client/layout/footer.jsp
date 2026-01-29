<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Footer Start -->
<footer class="container-fluid bg-dark text-white-50 pt-5 mt-5">
    <div class="container py-5">
        <div class="row g-4 pb-4 mb-4 border-bottom border-secondary">
            <div class="col-lg-4">
                <a href="/" class="text-decoration-none">
                    <h5 class="text-primary mb-2"><i class="fas fa-laptop me-2"></i>Laptopshop</h5>
                    <p class="mb-0 small">Sản phẩm chính hãng – Giá tốt nhất</p>
                </a>
            </div>
            <div class="col-lg-2 col-md-4">
                <h6 class="text-light mb-3">Liên kết</h6>
                <ul class="list-unstyled small">
                    <li class="mb-2"><a href="/" class="text-white-50 text-decoration-none">Trang chủ</a></li>
                    <li class="mb-2"><a href="/products" class="text-white-50 text-decoration-none">Sản phẩm</a></li>
                    <c:if test="${not empty pageContext.request.userPrincipal}">
                        <li class="mb-2"><a href="/account" class="text-white-50 text-decoration-none">Tài khoản</a></li>
                        <li class="mb-2"><a href="/order-history" class="text-white-50 text-decoration-none">Đơn hàng</a></li>
                    </c:if>
                </ul>
            </div>
            <div class="col-lg-3 col-md-4">
                <h6 class="text-light mb-3">Hỗ trợ</h6>
                <ul class="list-unstyled small">
                    <li class="mb-2"><i class="fas fa-truck me-2 text-primary"></i>Giao hàng nhanh</li>
                    <li class="mb-2"><i class="fas fa-shield-alt me-2 text-primary"></i>Thanh toán an toàn</li>
                    <li class="mb-2"><i class="fas fa-undo me-2 text-primary"></i>Đổi trả 30 ngày</li>
                </ul>
            </div>
            <div class="col-lg-3 col-md-4">
                <h6 class="text-light mb-3">Liên hệ</h6>
                <p class="small mb-2">Long Lee Dev</p>
                <a href="https://www.facebook.com/long.phewn.758/?locale=vi_VN" target="_blank" class="text-white-50 text-decoration-none me-3"><i class="fab fa-facebook-f"></i></a>
                <a href="https://www.instagram.com/long.phewn.758/" target="_blank" class="text-white-50 text-decoration-none"><i class="fab fa-instagram"></i></a>
            </div>
        </div>
    </div>
    <div class="container-fluid py-3 border-top border-secondary">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6 text-center text-md-start small mb-2 mb-md-0">
                    <span class="text-white-50">&copy; Long Lee Dev 2025. All rights reserved.</span>
                </div>
                <div class="col-md-6 text-center text-md-end small text-white-50">
                    Laptopshop – Dự án demo
                </div>
            </div>
        </div>
    </div>
</footer>
<!-- Footer End -->
