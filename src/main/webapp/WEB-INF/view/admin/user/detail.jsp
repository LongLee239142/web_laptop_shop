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
    <title>Chi tiết người dùng - Laptopshop Admin</title>
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
                    <h1 class="mt-4">Chi tiết người dùng</h1>
                    <ol class="breadcrumb mb-4">
                        <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                        <li class="breadcrumb-item"><a href="/admin/user">Người dùng</a></li>
                        <li class="breadcrumb-item active">ID ${id}</li>
                    </ol>
                    <div class="row">
                        <div class="col-12 col-md-8 col-lg-6 mx-auto">
                            <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
                                <div class="card-body text-center py-4 bg-light">
                                    <c:choose>
                                        <c:when test="${not empty user.avatar}">
                                            <img class="rounded-circle shadow" src="/images/avatar/${user.avatar}"
                                                alt="Avatar" style="width: 140px; height: 140px; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="rounded-circle bg-secondary d-inline-flex align-items-center justify-content-center text-white"
                                                style="width: 140px; height: 140px;">
                                                <i class="fas fa-user fa-4x"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <h5 class="mt-3 mb-0 fw-bold text-primary">${user.fullName}</h5>
                                    <span class="badge ${user.role.name == 'ADMIN' ? 'bg-danger' : 'bg-secondary'} mt-2">${user.role.name}</span>
                                </div>
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item d-flex align-items-center">
                                        <i class="fas fa-hashtag text-muted me-3" style="width: 24px;"></i>
                                        <span class="text-muted small me-2">ID:</span>
                                        <strong>${user.id}</strong>
                                    </li>
                                    <li class="list-group-item d-flex align-items-center">
                                        <i class="fas fa-envelope text-muted me-3" style="width: 24px;"></i>
                                        <span class="text-muted small me-2">Email:</span>
                                        ${user.email}
                                    </li>
                                    <li class="list-group-item d-flex align-items-center">
                                        <i class="fas fa-user text-muted me-3" style="width: 24px;"></i>
                                        <span class="text-muted small me-2">Họ tên:</span>
                                        ${user.fullName}
                                    </li>
                                    <li class="list-group-item d-flex align-items-center">
                                        <i class="fas fa-map-marker-alt text-muted me-3" style="width: 24px;"></i>
                                        <span class="text-muted small me-2">Địa chỉ:</span>
                                        ${user.address}
                                    </li>
                                    <li class="list-group-item d-flex align-items-center">
                                        <i class="fas fa-phone text-muted me-3" style="width: 24px;"></i>
                                        <span class="text-muted small me-2">SĐT:</span>
                                        ${user.phone}
                                    </li>
                                    <li class="list-group-item d-flex align-items-center">
                                        <i class="fas fa-user-tag text-muted me-3" style="width: 24px;"></i>
                                        <span class="text-muted small me-2">Vai trò:</span>
                                        <span class="badge ${user.role.name == 'ADMIN' ? 'bg-danger' : 'bg-secondary'}">${user.role.name}</span>
                                    </li>
                                </ul>
                                <div class="card-footer bg-white border-0 py-3 d-flex gap-2 justify-content-center flex-wrap">
                                    <a href="/admin/user/update/${id}" class="btn btn-warning btn-sm">
                                        <i class="fas fa-edit me-1"></i>Sửa
                                    </a>
                                    <a href="/admin/user" class="btn btn-outline-secondary btn-sm">
                                        <i class="fas fa-arrow-left me-1"></i>Quay lại
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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="/js/scripts.js"></script>
</body>

</html>
