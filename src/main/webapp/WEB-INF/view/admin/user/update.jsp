<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="utf-8" />
                <meta http-equiv="X-UA-Compatible" content="IE=edge" />
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
                <meta name="description" content="LongLeeDev - Dự án laptopshop" />
                <meta name="author" content="LongLeeDev" />
                <title>Update User - LongLeeDev</title>
                <link href="/css/styles.css" rel="stylesheet" />
                <style>
                    /* Custom confirm modal - Admin */
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
                    $(document).ready(() => {
                        const avatarFile = $("#avatarFile");
                        const orgImage = "${newUser.avatar}";
                        if (orgImage) {
                            const urlImage = "/images/avatar/" + orgImage;
                            $("#avatarPreview").attr("src", urlImage);
                            $("#avatarPreview").css({ "display": "block" });
                        }
                        avatarFile.change(function (e) {
                            const imgURL = URL.createObjectURL(e.target.files[0]);
                            $("#avatarPreview").attr("src", imgURL);
                            $("#avatarPreview").css({ "display": "block" });
                        });
                    });
                </script>
                <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
            </head>

            <body class="sb-nav-fixed">
                <jsp:include page="../layout/header.jsp" />
                <div id="layoutSidenav">
                    <jsp:include page="../layout/sidebar.jsp" />
                    <div id="layoutSidenav_content">
                        <main>
                            <div class="container-fluid px-4">
                                <h1 class="mt-4">Manage Update Users</h1>
                                <ol class="breadcrumb mb-4">
                                    <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                                    <li class="breadcrumb-item active">Update Users</li>
                                </ol>
                                <div class="mt-5">
                                    <div class="row">
                                        <div class="col-md-6 col-12 mx-auto">
                                            <h3>Update a user</h3>
                                            <hr />
                                            <form:form method="post" action="/admin/user/update"
                                                modelAttribute="newUser" class="row" enctype="multipart/form-data">

                                                <div class="mb-3" style="display: none;">
                                                    <label class="form-label">Id:</label>
                                                    <form:input type="text" class="form-control" path="id" />
                                                </div>
                                                <%-- Hidden email: field disabled=true không gửi khi submit, cần hidden để binding/validation không lỗi --%>
                                                <form:hidden path="email" />
                                                <div class="mb-3">
                                                    <label class="form-label">Email:</label>
                                                    <input type="email" class="form-control" value="${newUser.email}" disabled="readonly" />
                                                </div>
                                                <div class="mb-3 col-12 col-md-6">
                                                    <c:set var="errorPhone">
                                                        <form:errors path="phone" />
                                                    </c:set>
                                                    <label class="form-label">Phone number:</label>
                                                    <form:input type="text"
                                                        class="form-control ${not empty errorPhone? 'is-invalid':''}"
                                                        path="phone" />
                                                    <form:errors path="phone" cssClass="invalid-feedback" />
                                                </div>
                                                <div class="mb-3 col-12 col-md-6">
                                                    <c:set var="errorEmail">
                                                        <form:errors path="fullName" />
                                                    </c:set>
                                                    <label class="form-label">Full Name:</label>
                                                    <form:input type="text"
                                                        class="form-control ${not empty errorEmail? 'is-invalid':''}"
                                                        path="fullName" />
                                                    <form:errors path="fullName" cssClass="invalid-feedback" />
                                                </div>
                                                <div class="mb-3 col-12">
                                                    <label class="form-label">Address:</label>
                                                    <form:input type="text" class="form-control" path="address" />
                                                </div>

                                                <div class="mb-3 col-12 col-md-6">
                                                    <label class="form-label">Role:</label>
                                                    <form:select class="form-select" path="role.name">
                                                        <form:option value="ADMIN">ADMIN</form:option>
                                                        <form:option value="USER">USER</form:option>
                                                    </form:select>
                                                </div>
                                                <%-- Hidden avatar path: giữ avatar cũ khi không chọn file mới --%>
                                                <form:hidden path="avatar" />
                                                <div class="mb-3 col-12 col-md-6">
                                                    <label for="avatarFile" class="form-label">Avatar:</label>
                                                    <input class="form-control" type="file" id="avatarFile"
                                                        accept=".png, .jpg, .jpeg" name="hoidanitFile" />
                                                </div>

                                                <div class="col-12 mb-3">
                                                    <img style="max-height: 250px; display: none;" alt="avatar preview"
                                                        id="avatarPreview" />
                                                </div>
                                                <c:if test="${not empty newUser.avatar}">
                                                    <div class="col-12 mb-3">
                                                        <button type="button" class="btn btn-outline-danger btn-sm" id="btnRemoveAvatar" data-csrf-name="${_csrf.parameterName}" data-csrf-value="${_csrf.token}" data-user-id="${newUser.id}">
                                                            <i class="fas fa-trash-alt me-1"></i>Xóa avatar
                                                        </button>
                                                    </div>
                                                </c:if>
                                                <div class="col-12 mb-5">
                                                    <button type="submit" class="btn btn-warning">Update</button>
                                                </div>
                                            </form:form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </main>
                        <jsp:include page="../layout/footer.jsp" />
                    </div>
                </div>

                <!-- Custom confirm modal: xóa avatar user (Admin) -->
                <div id="confirmRemoveAvatarOverlay" class="confirm-overlay">
                    <div class="confirm-box">
                        <div class="confirm-header">
                            <div class="confirm-icon"><i class="fas fa-user-minus"></i></div>
                            <h4>Xóa ảnh đại diện</h4>
                        </div>
                        <div class="confirm-body">
                            Xóa ảnh đại diện của user này?
                        </div>
                        <div class="confirm-footer">
                            <button type="button" class="confirm-btn confirm-btn-cancel" id="confirmRemoveAvatarCancel">Hủy</button>
                            <button type="button" class="confirm-btn confirm-btn-ok" id="confirmRemoveAvatarOk"><i class="fas fa-trash-alt me-1"></i>Xóa</button>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
                    crossorigin="anonymous"></script>
                <script src="/js/scripts.js"></script>
                <script>
                    (function () {
                        var overlay = document.getElementById('confirmRemoveAvatarOverlay');
                        var btnCancel = document.getElementById('confirmRemoveAvatarCancel');
                        var btnOk = document.getElementById('confirmRemoveAvatarOk');
                        var btn = document.getElementById('btnRemoveAvatar');

                        function hideConfirm() {
                            if (overlay) overlay.classList.remove('show');
                        }

                        function submitRemoveAvatar() {
                            var form = document.createElement('form');
                            form.method = 'post';
                            form.action = '/admin/user/remove-avatar';
                            var csrfName = btn.getAttribute('data-csrf-name');
                            var csrfValue = btn.getAttribute('data-csrf-value');
                            if (csrfName && csrfValue) {
                                var input = document.createElement('input');
                                input.type = 'hidden';
                                input.name = csrfName;
                                input.value = csrfValue;
                                form.appendChild(input);
                            }
                            var idInput = document.createElement('input');
                            idInput.type = 'hidden';
                            idInput.name = 'id';
                            idInput.value = btn.getAttribute('data-user-id') || '';
                            form.appendChild(idInput);
                            document.body.appendChild(form);
                            form.submit();
                        }

                        if (btn) {
                            btn.onclick = function () {
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
                    })();
                </script>

            </body>

            </html>