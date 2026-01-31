<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <meta name="description" content="LongLeeDev - Dự án laptopshop" />
    <meta name="author" content="LongLeeDev" />
    <title>Dashboard - Laptopshop Admin</title>
    <link href="/css/styles.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        .dashboard-stat-card { min-height: 100%; }
        .dashboard-stat-card .card-body { min-height: 110px; padding: 1.25rem 1rem; display: flex; align-items: center; }
        .dashboard-stat-card .card-footer { padding: 0.65rem 1rem; text-align: center; }
        .dashboard-stat-card .stat-value { font-size: 1.75rem; line-height: 1.2; word-break: keep-all; }
    </style>
</head>

<body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />
    <div id="layoutSidenav">
        <jsp:include page="../layout/sidebar.jsp" />
        <div id="layoutSidenav_content">
            <main>
                <div class="container-fluid px-4">
                    <h1 class="mt-4">Dashboard</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item active">Tổng quan</li>
                    </ol>

                    <!-- Thống kê tổng quan -->
                    <div class="row g-4 mb-4">
                        <div class="col-xl-3 col-md-6">
                            <div class="card border-0 shadow-sm overflow-hidden dashboard-stat-card" style="border-radius: 12px;">
                                <div class="card-body bg-primary text-white">
                                    <div class="flex-shrink-0 me-3">
                                        <div class="rounded-circle bg-white bg-opacity-25 p-3">
                                            <i class="fas fa-users fa-2x"></i>
                                        </div>
                                    </div>
                                    <div>
                                        <h6 class="text-white-50 mb-1 text-uppercase small mb-0">Người dùng</h6>
                                        <div class="stat-value fw-bold">${countUser}</div>
                                    </div>
                                </div>
                                <div class="card-footer bg-primary bg-opacity-10 border-0">
                                    <a class="small text-primary text-decoration-none fw-semibold stretched-link" href="/admin/user">
                                        Xem chi tiết <i class="fas fa-arrow-right ms-1 small"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card border-0 shadow-sm overflow-hidden dashboard-stat-card" style="border-radius: 12px;">
                                <div class="card-body bg-warning text-dark">
                                    <div class="flex-shrink-0 me-3">
                                        <div class="rounded-circle bg-dark bg-opacity-10 p-3">
                                            <i class="fas fa-laptop fa-2x"></i>
                                        </div>
                                    </div>
                                    <div>
                                        <h6 class="text-dark opacity-75 mb-1 text-uppercase small mb-0">Sản phẩm</h6>
                                        <div class="stat-value fw-bold">${countProduct}</div>
                                    </div>
                                </div>
                                <div class="card-footer bg-warning bg-opacity-10 border-0">
                                    <a class="small text-dark text-decoration-none fw-semibold stretched-link" href="/admin/product">
                                        Xem chi tiết <i class="fas fa-arrow-right ms-1 small"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card border-0 shadow-sm overflow-hidden dashboard-stat-card" style="border-radius: 12px;">
                                <div class="card-body bg-success text-white">
                                    <div class="flex-shrink-0 me-3">
                                        <div class="rounded-circle bg-white bg-opacity-25 p-3">
                                            <i class="fas fa-shopping-cart fa-2x"></i>
                                        </div>
                                    </div>
                                    <div>
                                        <h6 class="text-white-50 mb-1 text-uppercase small mb-0">Đơn hàng</h6>
                                        <div class="stat-value fw-bold">${countOrder}</div>
                                    </div>
                                </div>
                                <div class="card-footer bg-success bg-opacity-10 border-0">
                                    <a class="small text-success text-decoration-none fw-semibold stretched-link" href="/admin/order">
                                        Xem chi tiết <i class="fas fa-arrow-right ms-1 small"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="card border-0 shadow-sm overflow-hidden dashboard-stat-card" style="border-radius: 12px;">
                                <div class="card-body bg-info text-white">
                                    <div class="flex-shrink-0 me-3">
                                        <div class="rounded-circle bg-white bg-opacity-25 p-3">
                                            <i class="fas fa-coins fa-2x"></i>
                                        </div>
                                    </div>
                                    <div>
                                        <h6 class="text-white-50 mb-1 text-uppercase small mb-0">Doanh thu</h6>
                                        <div class="stat-value fw-bold text-nowrap" title="${revenueFull} đ">${revenueDisplay}</div>
                                    </div>
                                </div>
                                <div class="card-footer bg-info bg-opacity-10 border-0">
                                    <a class="small text-info text-decoration-none fw-semibold stretched-link" href="/admin/order">
                                        Xem chi tiết <i class="fas fa-arrow-right ms-1 small"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Đơn hàng gần đây -->
                    <div class="card border-0 shadow-sm rounded-3">
                        <div class="card-header bg-white py-3 border-0 border-bottom d-flex justify-content-between align-items-center">
                            <h5 class="mb-0 fw-semibold"><i class="fas fa-clock me-2 text-primary"></i>Đơn hàng gần đây</h5>
                            <a href="/admin/order" class="btn btn-sm btn-outline-primary">Xem tất cả</a>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="text-center" style="width: 70px;">ID</th>
                                            <th>Khách hàng</th>
                                            <th class="text-end" style="width: 140px;">Tổng tiền</th>
                                            <th class="text-center" style="width: 120px;">Trạng thái</th>
                                            <th class="text-center" style="width: 100px;">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:if test="${empty recentOrders}">
                                            <tr>
                                                <td colspan="5" class="text-center py-4 text-muted">Chưa có đơn hàng nào</td>
                                            </tr>
                                        </c:if>
                                        <c:forEach var="order" items="${recentOrders}">
                                            <tr>
                                                <td class="text-center fw-semibold">${order.id}</td>
                                                <td>${order.user != null ? order.user.fullName : order.receiverName}</td>
                                                <td class="text-end fw-semibold text-success" style="white-space: nowrap;">
                                                    <fmt:formatNumber type="number" value="${order.totalPrice}" pattern="#,##0" />&#8239;đ
                                                </td>
                                                <td class="text-center">
                                                    <span class="badge bg-info text-dark">${order.status}</span>
                                                </td>
                                                <td class="text-center">
                                                    <a href="/admin/order/${order.id}" class="btn btn-sm btn-outline-primary" title="Chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="../layout/footer.jsp" />
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
        crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
</body>

</html>