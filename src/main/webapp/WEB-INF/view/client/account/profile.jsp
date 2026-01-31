<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>Tài khoản của tôi - Laptopshop</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="/client/css/bootstrap.min.css" rel="stylesheet">
    <link href="/client/css/style.css" rel="stylesheet">
</head>

<body>
    <div id="spinner"
        class="show w-100 vh-100 bg-white position-fixed translate-middle top-50 start-50 d-flex align-items-center justify-content-center">
        <div class="spinner-grow text-primary" role="status"></div>
    </div>

    <jsp:include page="../layout/header.jsp" />

    <div class="container-fluid py-5">
        <div class="container py-5">
            <nav aria-label="breadcrumb" class="mb-4">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="/">Home</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Tài khoản của tôi</li>
                </ol>
            </nav>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i><c:out value="${successMessage}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i><c:out value="${errorMessage}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card shadow-sm border-0 rounded-3 overflow-hidden">
                        <div class="card-header bg-primary text-white py-3">
                            <h5 class="mb-0"><i class="fas fa-user me-2"></i>Thông tin tài khoản</h5>
                        </div>
                        <div class="card-body p-4">
                            <div class="row align-items-center mb-4">
                                <div class="col-md-4 text-center">
                                    <c:choose>
                                        <c:when test="${not empty user.avatar}">
                                            <img src="/images/avatar/${user.avatar}" alt="Avatar"
                                                class="rounded-circle shadow" style="width: 150px; height: 150px; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="rounded-circle bg-light d-inline-flex align-items-center justify-content-center"
                                                style="width: 150px; height: 150px;">
                                                <i class="fas fa-user fa-4x text-muted"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="col-md-8">
                                    <h4 class="text-primary">${user.fullName}</h4>
                                    <p class="text-muted mb-1"><i class="fas fa-envelope me-2"></i>${user.email}</p>
                                    <p class="text-muted mb-1"><i class="fas fa-phone me-2"></i>${user.phone}</p>
                                    <p class="text-muted mb-0"><i class="fas fa-map-marker-alt me-2"></i>${user.address}</p>
                                    <a href="/account/edit" class="btn btn-warning mt-3">
                                        <i class="fas fa-edit me-1"></i>Chỉnh sửa thông tin
                                    </a>
                                </div>
                            </div>
                            <hr>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="text-muted small">Họ và tên</label>
                                    <p class="mb-0 fw-semibold">${user.fullName}</p>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="text-muted small">Email</label>
                                    <p class="mb-0 fw-semibold">${user.email}</p>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="text-muted small">Số điện thoại</label>
                                    <p class="mb-0 fw-semibold">${user.phone}</p>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="text-muted small">Địa chỉ</label>
                                    <p class="mb-0 fw-semibold">${user.address}</p>
                                </div>
                            </div>
                            <div class="mt-3">
                                <a href="/order-history" class="btn btn-outline-primary me-2">
                                    <i class="fas fa-history me-1"></i>Lịch sử mua hàng
                                </a>
                                <a href="/" class="btn btn-outline-secondary">Về trang chủ</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../layout/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const spinner = document.getElementById('spinner');
            if (spinner) spinner.classList.remove('show');
        });
    </script>
</body>

</html>
