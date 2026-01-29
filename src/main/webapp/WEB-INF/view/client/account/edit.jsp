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
    <style>
        /* Custom confirm modal */
        .confirm-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.45);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1050;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.25s ease, visibility 0.25s ease;
        }
        .confirm-overlay.show {
            opacity: 1;
            visibility: visible;
        }
        .confirm-box {
            background: #fff;
            border-radius: 16px;
            max-width: 400px;
            width: 90%;
            box-shadow: 0 24px 48px rgba(0, 0, 0, 0.2);
            transform: scale(0.9);
            transition: transform 0.25s ease;
            overflow: hidden;
        }
        .confirm-overlay.show .confirm-box {
            transform: scale(1);
        }
        .confirm-box .confirm-header {
            background: linear-gradient(135deg, #ffc107 0%, #ff9800 100%);
            color: #212529;
            padding: 20px 24px;
            text-align: center;
        }
        .confirm-box .confirm-header .confirm-icon {
            font-size: 2.5rem;
            margin-bottom: 8px;
            opacity: 0.95;
        }
        .confirm-box .confirm-header h4 {
            margin: 0;
            font-size: 1.2rem;
            font-weight: 600;
        }
        .confirm-box .confirm-body {
            padding: 24px;
            text-align: center;
            color: #495057;
            font-size: 0.95rem;
            line-height: 1.5;
        }
        .confirm-box .confirm-footer {
            padding: 16px 24px;
            display: flex;
            gap: 12px;
            justify-content: center;
            border-top: 1px solid #eee;
            background: #f8f9fa;
        }
        .confirm-box .confirm-btn {
            min-width: 100px;
            padding: 10px 20px;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.9rem;
            cursor: pointer;
            transition: transform 0.15s, box-shadow 0.15s;
        }
        .confirm-box .confirm-btn:hover {
            transform: translateY(-1px);
        }
        .confirm-box .confirm-btn-cancel {
            background: #e9ecef;
            color: #495057;
        }
        .confirm-box .confirm-btn-cancel:hover {
            background: #dee2e6;
        }
        .confirm-box .confirm-btn-ok {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: #fff;
        }
        .confirm-box .confirm-btn-ok:hover {
            box-shadow: 0 4px 14px rgba(220, 53, 69, 0.4);
        }
    </style>
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
                    $("#noAvatarHint").hide();
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
                                <c:if test="${not empty user.avatar}"><form:hidden path="avatar" /></c:if>
                                <c:if test="${empty user.avatar}"><input type="hidden" name="avatar" value="" /></c:if>

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
                                    <input class="form-control" type="file" id="avatarFile" accept="image/png,image/jpeg,image/jpg,.png,.jpg,.jpeg"
                                        name="hoidanitFile" />
                                    <div class="mt-2" id="avatarPreviewWrap">
                                        <img id="avatarPreview" alt="Preview" style="max-height: 180px; display: none;"
                                            class="rounded shadow" />
                                        <c:if test="${empty user.avatar}">
                                            <p class="text-muted small mb-0 mt-2" id="noAvatarHint">Chưa có ảnh. Chọn file bên trên để tải ảnh lên.</p>
                                        </c:if>
                                    </div>
                                    <c:if test="${not empty user.avatar}">
                                        <button type="button" class="btn btn-outline-danger btn-sm mt-2" id="btnRemoveAvatar" data-csrf-name="${_csrf.parameterName}" data-csrf-value="${_csrf.token}">
                                            <i class="fas fa-trash-alt me-1"></i>Xóa ảnh đại diện
                                        </button>
                                    </c:if>
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

    <!-- Custom confirm modal: xóa ảnh đại diện -->
    <div id="confirmRemoveAvatarOverlay" class="confirm-overlay">
        <div class="confirm-box">
            <div class="confirm-header">
                <div class="confirm-icon"><i class="fas fa-user-minus"></i></div>
                <h4>Xóa ảnh đại diện</h4>
            </div>
            <div class="confirm-body">
                Bạn có chắc muốn xóa ảnh đại diện?
            </div>
            <div class="confirm-footer">
                <button type="button" class="confirm-btn confirm-btn-cancel" id="confirmRemoveAvatarCancel">Hủy</button>
                <button type="button" class="confirm-btn confirm-btn-ok" id="confirmRemoveAvatarOk"><i class="fas fa-trash-alt me-1"></i>Xóa</button>
            </div>
        </div>
    </div>

    <jsp:include page="../layout/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var spinner = document.getElementById('spinner');
            if (spinner) spinner.classList.remove('show');

            var overlay = document.getElementById('confirmRemoveAvatarOverlay');
            var btnCancel = document.getElementById('confirmRemoveAvatarCancel');
            var btnOk = document.getElementById('confirmRemoveAvatarOk');
            var btnRemove = document.getElementById('btnRemoveAvatar');

            function hideConfirm() {
                if (overlay) overlay.classList.remove('show');
            }

            function submitRemoveAvatar() {
                var form = document.createElement('form');
                form.method = 'post';
                form.action = '/account/remove-avatar';
                var csrfName = btnRemove.getAttribute('data-csrf-name');
                var csrfValue = btnRemove.getAttribute('data-csrf-value');
                if (csrfName && csrfValue) {
                    var input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = csrfName;
                    input.value = csrfValue;
                    form.appendChild(input);
                }
                document.body.appendChild(form);
                form.submit();
            }

            if (btnRemove) {
                btnRemove.onclick = function () {
                    if (overlay) overlay.classList.add('show');
                };
            }
            if (btnCancel) btnCancel.onclick = hideConfirm;
            if (btnOk) btnOk.onclick = function () { hideConfirm(); submitRemoveAvatar(); };

            if (overlay) {
                overlay.onclick = function (e) {
                    if (e.target === overlay) hideConfirm();
                };
            }
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape' && overlay && overlay.classList.contains('show')) hideConfirm();
            });
        });
    </script>
</body>

</html>
