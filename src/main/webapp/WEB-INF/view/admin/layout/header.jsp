<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
    <a class="navbar-brand ps-3" href="/admin">
        <i class="fas fa-laptop me-2"></i>Laptopshop Admin
    </a>
    <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0 text-white" id="sidebarToggle" href="#!">
        <i class="fas fa-bars"></i>
    </button>
    <div class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
        <c:if test="${not empty pageContext.request.userPrincipal}">
            <span class="text-white-50 small me-2">
                <i class="fas fa-user-circle me-1"></i>
                <c:out value="${pageContext.request.userPrincipal.name}" />
            </span>
        </c:if>
    </div>
    <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
        <c:if test="${not empty pageContext.request.userPrincipal}">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle text-white" id="navbarDropdown" href="#" role="button"
                    data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fas fa-user fa-fw"></i>
                </a>
                <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="navbarDropdown">
                    <li><a class="dropdown-item" href="/"><i class="fas fa-home me-2"></i>Về trang chủ</a></li>
                    <li><hr class="dropdown-divider" /></li>
                    <li>
                        <form action="/logout" method="post" class="mb-0">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <button type="submit" class="dropdown-item text-danger">
                                <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                            </button>
                        </form>
                    </li>
                </ul>
            </li>
        </c:if>
        <c:if test="${empty pageContext.request.userPrincipal}">
            <li class="nav-item">
                <a class="nav-link text-white" href="/login"><i class="fas fa-sign-in-alt me-1"></i>Đăng nhập</a>
            </li>
        </c:if>
    </ul>
</nav>
