<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="utf-8" />
            <meta http-equiv="X-UA-Compatible" content="IE=edge" />
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
            <meta name="description" content="LongLeeDev - Dự án laptopshop" />
            <meta name="author" content="LongLeeDev" />
            <title>Dashboard - LongLeeDev</title>
            <link href="/css/styles.css" rel="stylesheet" />
            <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
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
                            <div class="row g-4">
                                <div class="col-xl-4 col-md-6">
                                    <div class="card border-0 shadow-sm mb-4 overflow-hidden" style="border-radius: 12px;">
                                        <div class="card-body bg-primary text-white d-flex align-items-center">
                                            <div class="flex-shrink-0 me-3">
                                                <div class="rounded-circle bg-white bg-opacity-25 p-3">
                                                    <i class="fas fa-users fa-2x"></i>
                                                </div>
                                            </div>
                                            <div>
                                                <h6 class="text-white-50 mb-1 text-uppercase small">Người dùng</h6>
                                                <h3 class="mb-0 fw-bold">${countUser}</h3>
                                            </div>
                                        </div>
                                        <div class="card-footer bg-primary bg-opacity-10 border-0 py-2">
                                            <a class="small text-primary text-decoration-none fw-semibold stretched-link" href="/admin/user">
                                                Xem chi tiết <i class="fas fa-arrow-right ms-1 small"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xl-4 col-md-6">
                                    <div class="card border-0 shadow-sm mb-4 overflow-hidden" style="border-radius: 12px;">
                                        <div class="card-body bg-warning text-dark d-flex align-items-center">
                                            <div class="flex-shrink-0 me-3">
                                                <div class="rounded-circle bg-dark bg-opacity-10 p-3">
                                                    <i class="fas fa-laptop fa-2x"></i>
                                                </div>
                                            </div>
                                            <div>
                                                <h6 class="text-dark opacity-75 mb-1 text-uppercase small">Sản phẩm</h6>
                                                <h3 class="mb-0 fw-bold">${countProduct}</h3>
                                            </div>
                                        </div>
                                        <div class="card-footer bg-warning bg-opacity-10 border-0 py-2">
                                            <a class="small text-dark text-decoration-none fw-semibold stretched-link" href="/admin/product">
                                                Xem chi tiết <i class="fas fa-arrow-right ms-1 small"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-xl-4 col-md-6">
                                    <div class="card border-0 shadow-sm mb-4 overflow-hidden" style="border-radius: 12px;">
                                        <div class="card-body bg-success text-white d-flex align-items-center">
                                            <div class="flex-shrink-0 me-3">
                                                <div class="rounded-circle bg-white bg-opacity-25 p-3">
                                                    <i class="fas fa-shopping-cart fa-2x"></i>
                                                </div>
                                            </div>
                                            <div>
                                                <h6 class="text-white-50 mb-1 text-uppercase small">Đơn hàng</h6>
                                                <h3 class="mb-0 fw-bold">${countOrder}</h3>
                                            </div>
                                        </div>
                                        <div class="card-footer bg-success bg-opacity-10 border-0 py-2">
                                            <a class="small text-success text-decoration-none fw-semibold stretched-link" href="/admin/order">
                                                Xem chi tiết <i class="fas fa-arrow-right ms-1 small"></i>
                                            </a>
                                        </div>
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