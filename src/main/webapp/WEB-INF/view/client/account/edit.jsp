<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>Chỉnh sửa tài khoản - Laptopshop</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="/client/css/bootstrap.min.css" rel="stylesheet">
    <link href="/client/css/style.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script>
        $(document).ready(function () {
            var orgImage = "${user.avatar}";
            if (orgImage) {
                $("#avatarPreview").attr("src", "/images/avatar/" + orgImage).css("display", "block");
            }
            $("#avatarFile").change(function (e) {
                if (e.target.files && e.target.files[0]) {
                    var url = URL.createObjectURL(e.target.files[0]);
                    $("#avatarPreview").attr("src", url).css("display", "block");
                }
            });
        });
    </script>
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
                    <li class="breadcrumb-item"><a href="/account">Tài khoản</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Chỉnh sửa</li>
                </ol>
            </nav>

            <div class="row justify-content-center">
                <div class="col-lg-6">
                    <div class="card shadow-sm border-0 rounded-3">
                        <div class="card-header bg-warning text-dark py-3">
                            <h5 class="mb-0"><i class="fas fa-user-edit me-2"></i>Chỉnh sửa thông tin</h5>
                        </div>
                        <div class="card-body p-4">
                            <form:form method="post" action="/account/update" modelAttribute="user" class="row g-3"
                                enctype="multipart/form-data">

                                <form:hidden path="id" />
                                <form:hidden path="email" />
                                <form:hidden path="password" />
                                <form:hidden path="avatar" />

                                <div class="col-12">
                                    <label class="form-label text-muted">Email</label>
                                    <input type="email" class="form-control" value="${user.email}" readonly disabled />
                                </div>

                                <div class="col-md-6">
                                    <c:set var="errFullName"><form:errors path="fullName" /></c:set>
                                    <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                                    <form:input path="fullName" class="form-control ${not empty errFullName ? 'is-invalid' : ''}"
                                        placeholder="Họ và tên" />
                                    <form:errors path="fullName" cssClass="invalid-feedback" />
                                </div>

                                <div class="col-md-6">
                                    <c:set var="errPhone"><form:errors path="phone" /></c:set>
                                    <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                    <form:input path="phone" class="form-control ${not empty errPhone ? 'is-invalid' : ''}"
                                        placeholder="0xxxxxxxxx" />
                                    <form:errors path="phone" cssClass="invalid-feedback" />
                                </div>

                                <div class="col-12">
                                    <c:set var="errAddress"><form:errors path="address" /></c:set>
                                    <label class="form-label">Địa chỉ <span class="text-danger">*</span></label>
                                    <form:input path="address" class="form-control ${not empty errAddress ? 'is-invalid' : ''}"
                                        placeholder="Địa chỉ" />
                                    <form:errors path="address" cssClass="invalid-feedback" />
                                </div>

                                <div class="col-12">
                                    <label class="form-label">Ảnh đại diện</label>
                                    <input class="form-control" type="file" id="avatarFile" accept=".png,.jpg,.jpeg"
                                        name="hoidanitFile" />
                                    <div class="mt-2">
                                        <img id="avatarPreview" alt="Preview" style="max-height: 180px; display: none;"
                                            class="rounded shadow" />
                                    </div>
                                </div>

                                <div class="col-12 pt-2">
                                    <button type="submit" class="btn btn-warning">
                                        <i class="fas fa-save me-1"></i>Cập nhật
                                    </button>
                                    <a href="/account" class="btn btn-outline-secondary ms-2">Hủy</a>
                                </div>
                            </form:form>
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
            var spinner = document.getElementById('spinner');
            if (spinner) spinner.classList.remove('show');
        });
    </script>
</body>

</html>
