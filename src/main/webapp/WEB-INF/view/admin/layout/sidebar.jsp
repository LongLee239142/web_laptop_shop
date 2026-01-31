<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div id="layoutSidenav_nav">
    <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
        <div class="sb-sidenav-menu">
            <div class="nav">
                <div class="sb-sidenav-menu-heading">Tổng quan</div>
                <a class="nav-link py-3" href="/admin">
                    <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                    Dashboard
                </a>
                <div class="sb-sidenav-menu-heading">Quản lý</div>
                <a class="nav-link py-3" href="/admin/user">
                    <div class="sb-nav-link-icon"><i class="fas fa-users"></i></div>
                    Người dùng
                </a>
                <a class="nav-link py-3" href="/admin/product">
                    <div class="sb-nav-link-icon"><i class="fas fa-laptop"></i></div>
                    Sản phẩm
                </a>
                <a class="nav-link py-3" href="/admin/order">
                    <div class="sb-nav-link-icon"><i class="fas fa-shopping-cart"></i></div>
                    Đơn hàng
                </a>
            </div>
        </div>
        <div class="sb-sidenav-footer py-3">
            <div class="small">Laptopshop Admin</div>
            <span class="text-white-50">Long Lee Dev</span>
        </div>
    </nav>
</div>
