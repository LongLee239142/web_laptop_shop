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
                            <h1 class="mt-4">Quản lý người dùng</h1>
                            <ol class="breadcrumb mb-4">
                                <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                                <li class="breadcrumb-item active">Người dùng</li>
                            </ol>
                                <div class="mt-5">
                                    <!-- Alert Messages -->
                                    <c:if test="${not empty successMessage}">
                                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                                            <i class="fas fa-check-circle me-2"></i>
                                            ${successMessage}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                        </div>
                                    </c:if>
                                    
                                    <c:if test="${not empty errorMessage}">
                                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            ${errorMessage}
                                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                        </div>
                                    </c:if>
                                    
                                    <div class="row">
                                        <div class="col-12 mx-auto">
                                            <div class="card border-0 shadow-sm rounded-3">
                                                <div class="card-header bg-white py-3 border-0 border-bottom">
                                                    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                                                        <h5 class="mb-0 fw-semibold"><i class="fas fa-users me-2 text-primary"></i>Danh sách người dùng</h5>
                                                        <a href="/admin/user/create" class="btn btn-primary btn-sm">
                                                            <i class="fas fa-plus me-1"></i>Tạo người dùng
                                                        </a>
                                                    </div>
                                                </div>
                                                <div class="card-body p-0">
                                                    <div class="table-responsive">
                                                        <table class="table table-hover table-striped align-middle mb-0">
                                                            <thead class="table-dark">
                                                                <tr>
                                                                    <th class="text-center" style="width: 60px;">ID</th>
                                                                    <th>Email</th>
                                                                    <th>Họ tên</th>
                                                                    <th class="text-center" style="width: 100px;">Role</th>
                                                                    <th class="text-center" style="width: 220px;">Thao tác</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach var="user" items="${users1}">
                                                                    <tr>
                                                                        <td class="text-center fw-semibold">${user.id}</td>
                                                                        <td>${user.email}</td>
                                                                        <td>${user.fullName}</td>
                                                                        <td class="text-center">
                                                                            <span class="badge ${user.role.name == 'ADMIN' ? 'bg-danger' : 'bg-secondary'}">${user.role.name}</span>
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <a href="/admin/user/${user.id}" class="btn btn-sm btn-outline-success" title="Xem"><i class="fas fa-eye"></i></a>
                                                                            <a href="/admin/user/update/${user.id}" class="btn btn-sm btn-outline-warning mx-1" title="Sửa"><i class="fas fa-edit"></i></a>
                                                                            <a href="/admin/user/delete/${user.id}" class="btn btn-sm btn-outline-danger" title="Xóa"><i class="fas fa-trash-alt"></i></a>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                                <c:if test="${totalPage > 1}">
                                                    <div class="card-footer bg-white border-0 py-3">
                                                        <nav aria-label="Phân trang">
                                                            <ul class="pagination pagination-sm justify-content-center mb-0">
                                                                <li class="page-item ${currentPage eq 1 ? 'disabled' : ''}">
                                                                    <a class="page-link" href="/admin/user?page=${currentPage - 1}" ${currentPage eq 1 ? 'tabindex="-1"' : ''}>Trước</a>
                                                                </li>
                                                                <c:forEach begin="1" end="${totalPage}" varStatus="loop">
                                                                    <li class="page-item ${loop.index eq currentPage ? 'active' : ''}">
                                                                        <a class="page-link" href="/admin/user?page=${loop.index}">${loop.index}</a>
                                                                    </li>
                                                                </c:forEach>
                                                                <li class="page-item ${currentPage eq totalPage ? 'disabled' : ''}">
                                                                    <a class="page-link" href="/admin/user?page=${currentPage + 1}" ${currentPage eq totalPage ? 'tabindex="-1"' : ''}>Sau</a>
                                                                </li>
                                                            </ul>
                                                        </nav>
                                                    </div>
                                                </c:if>
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
                
                <!-- Auto-hide alerts -->
                <script>
                    setTimeout(function() {
                        var alerts = document.querySelectorAll('.alert');
                        alerts.forEach(function(alert) {
                            var bsAlert = new bootstrap.Alert(alert);
                            bsAlert.close();
                        });
                    }, 5000);
                </script>

            </body>

        </html>