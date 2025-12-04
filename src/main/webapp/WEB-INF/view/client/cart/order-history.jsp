<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title> Lịch sử mua hàng - Laptopshop</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="" name="keywords">
    <meta content="" name="description">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link
        href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Raleway:wght@600;800&display=swap"
        rel="stylesheet">

    <!-- Icon Font Stylesheet -->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css"
        rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="/client/lib/lightbox/css/lightbox.min.css" rel="stylesheet">
    <link href="/client/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

    <!-- Customized Bootstrap Stylesheet -->
    <link href="/client/css/bootstrap.min.css" rel="stylesheet">

    <!-- Template Stylesheet -->
    <link href="/client/css/style.css" rel="stylesheet">
</head>

<body>

    <!-- Spinner Start -->
    <div id="spinner"
        class="show w-100 vh-100 bg-white position-fixed translate-middle top-50 start-50  d-flex align-items-center justify-content-center">
        <div class="spinner-grow text-primary" role="status"></div>
    </div>
    <!-- Spinner End -->

    <jsp:include page="../layout/header.jsp" />

    <!-- Cart Page Start -->
    <div class="container-fluid py-5">
        <div class="container py-5">
            <div class="mb-3">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="/">Home</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Lịch sử mua hàng</li>
                    </ol>
                </nav>
            </div>

            <div class="table-responsive">
                <table class="table table-striped align-middle shadow-sm border rounded-3">
                    <thead class="table-primary">
                        <tr>
                            <th scope="col">Sản phẩm</th>
                            <th scope="col">Tên</th>
                            <th scope="col">Giá cả</th>
                            <th scope="col">Số lượng</th>
                            <th scope="col">Thành tiền</th>
                            <th scope="col">Trạng thái</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:if test="${ empty orders}">
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">
                                    Không có đơn hàng nào được tạo
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach var="order" items="${orders}">
                            <!-- ORDER HEADER -->
                            <tr class="table-light">
                                <td colspan="6" class="py-3">
                                    <div class="d-flex justify-content-between align-items-center px-2">
                                        <div class="fw-bold text-primary">
                                            🧾 Order ID: ${order.id}
                                        </div>

                                        <div class="fw-bold text-success">
                                            Tổng tiền:
                                            <span class="text-danger">
                                                <fmt:formatNumber value="${order.totalPrice}" />
                                            </span> đ
                                        </div>

                                        <span class="badge bg-info text-dark px-3 py-2">
                                            ${order.status}
                                        </span>
                                    </div>
                                </td>
                            </tr>

                            <!-- ORDER DETAILS -->
                            <c:forEach var="orderDetail" items="${order.orderDetails}">
                                <tr class="hover-row">
                                    <th scope="row">
                                        <div class="d-flex align-items-center">
                                            <img src="/images/imageProduct/${orderDetail.product.image}"
                                                class="img-fluid rounded-3 shadow-sm"
                                                style="width: 80px; height: 80px; object-fit: cover;">
                                        </div>
                                    </th>

                                    <td class="fw-semibold">
                                        <div class="mb-0 mt-4">
                                            <a href="/product/${orderDetail.product.id}" target="_blank"
                                                class="text-decoration-none text-dark">
                                                ${orderDetail.product.name}
                                            </a>
                                        </div>
                                    </td>

                                    <td>
                                        <p class="mb-0 mt-4 text-primary fw-bold">
                                            <fmt:formatNumber type="number" value="${orderDetail.price}" /> đ
                                        </p>
                                    </td>

                                    <td>
                                        <div class="input-group quantity mt-4" style="width: 100px;">
                                            <input type="text"
                                                class="form-control form-control-sm text-center border-0 bg-light"
                                                value="${orderDetail.quantity}">
                                        </div>
                                    </td>

                                    <td>
                                        <p class="mb-0 mt-4 text-danger fw-bold">
                                            <fmt:formatNumber type="number"
                                                value="${orderDetail.price * orderDetail.quantity}" /> đ
                                        </p>
                                    </td>
                                    <td></td>
                                </tr>
                            </c:forEach>

                        </c:forEach>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
    <!-- Cart Page End -->

    <jsp:include page="../layout/footer.jsp" />

    <!-- Back to Top -->
    <a href="#" class="btn btn-primary border-3 border-primary rounded-circle back-to-top"><i
            class="fa fa-arrow-up"></i></a>

    <!-- JavaScript Libraries -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/client/lib/easing/easing.min.js"></script>
    <script src="/client/lib/waypoints/waypoints.min.js"></script>
    <script src="/client/lib/lightbox/js/lightbox.min.js"></script>
    <script src="/client/lib/owlcarousel/owl.carousel.min.js"></script>

    <!-- Template Javascript -->
    <script src="/client/js/main.js"></script>
</body>

<style>
    /* Nâng cấp giao diện bảng */
    .table {
        border-radius: 12px !important;
        overflow: hidden;
        background: #fff;
    }

    tbody tr.hover-row:hover {
        background: #f1f7ff !important;
        transition: 0.25s;
    }

    img.rounded-3 {
        transition: 0.25s;
    }

    img.rounded-3:hover {
        transform: scale(1.05);
    }
</style>

</html>
