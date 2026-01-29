<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Navbar start -->
<div class="container-fluid fixed-top px-0 shadow-sm" style="background: #fff; z-index: 1030;">
    <div class="container">
        <nav class="navbar navbar-expand-xl navbar-light py-3">
            <a href="/" class="navbar-brand d-flex align-items-center me-xl-5 me-3">
                <span class="text-primary fw-bold fs-4"><i class="fas fa-laptop me-2"></i>Laptopshop</span>
            </a>
            <button class="navbar-toggler border-0 py-2" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarCollapse">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0 gap-1 gap-xl-2">
                    <li class="nav-item">
                        <a href="/" class="nav-link px-4 py-2 rounded fw-medium text-dark">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a href="/products" class="nav-link px-4 py-2 rounded fw-medium text-dark">Sản phẩm</a>
                    </li>
                </ul>
                <div class="d-flex align-items-center gap-3">
                    <c:if test="${not empty pageContext.request.userPrincipal}">
                        <a href="/cart" class="btn btn-outline-primary position-relative btn-sm py-2 px-3" title="Giỏ hàng">
                            <i class="fas fa-shopping-cart"></i>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 0.7rem;">${sessionScope.sum}</span>
                        </a>
                        <div class="dropdown">
                            <a href="#" class="btn btn-outline-secondary btn-sm py-2 px-3 dropdown-toggle d-flex align-items-center" id="dropdownMenuUser" data-bs-toggle="dropdown" aria-expanded="false" title="Tài khoản">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.avatar}">
                                        <img src="/images/avatar/${sessionScope.avatar}" alt="" class="rounded-circle me-2" style="width: 28px; height: 28px; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <span class="rounded-circle bg-primary text-white d-inline-flex align-items-center justify-content-center me-2" style="width: 28px; height: 28px; font-size: 0.85rem;"><i class="fas fa-user"></i></span>
                                    </c:otherwise>
                                </c:choose>
                                <span class="d-none d-md-inline">${sessionScope.fullName}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 rounded-3 p-0 overflow-hidden" style="min-width: 280px;" aria-labelledby="dropdownMenuUser">
                                <li class="bg-light text-center py-4 px-3">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.avatar}">
                                            <img src="/images/avatar/${sessionScope.avatar}" alt="" class="rounded-circle shadow-sm" style="width: 80px; height: 80px; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <span class="rounded-circle bg-primary text-white d-inline-flex align-items-center justify-content-center" style="width: 80px; height: 80px; font-size: 2rem;"><i class="fas fa-user"></i></span>
                                        </c:otherwise>
                                    </c:choose>
                                    <p class="mb-0 mt-2 fw-semibold text-dark">${sessionScope.fullName}</p>
                                    <c:if test="${sessionScope.role == 'ADMIN'}">
                                        <span class="badge bg-danger mt-1">ADMIN</span>
                                    </c:if>
                                </li>
                                <li><hr class="dropdown-divider my-0"></li>
                                <li><a class="dropdown-item py-2" href="/account"><i class="fas fa-user-cog me-2 text-muted"></i>Tài khoản</a></li>
                                <li><a class="dropdown-item py-2" href="/order-history"><i class="fas fa-history me-2 text-muted"></i>Lịch sử mua hàng</a></li>
                                <c:if test="${sessionScope.role == 'ADMIN'}">
                                    <li><a class="dropdown-item py-2" href="/admin"><i class="fas fa-cog me-2 text-muted"></i>Quản trị</a></li>
                                </c:if>
                                <li><hr class="dropdown-divider my-0"></li>
                                <li>
                                    <form action="/logout" method="post" class="mb-0">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <button type="submit" class="dropdown-item py-2 text-danger"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</button>
                                    </form>
                                </li>
                            </ul>
                        </div>
                    </c:if>
                    <c:if test="${empty pageContext.request.userPrincipal}">
                        <a href="/cart" class="btn btn-outline-primary btn-sm py-2 px-3" title="Giỏ hàng"><i class="fas fa-shopping-cart"></i></a>
                        <a href="/login" class="btn btn-primary btn-sm py-2 px-3">Đăng nhập</a>
                        <a href="/register" class="btn btn-outline-secondary btn-sm py-2 px-3">Đăng ký</a>
                    </c:if>
                </div>
            </div>
        </nav>
    </div>
</div>
<!-- Navbar End -->
