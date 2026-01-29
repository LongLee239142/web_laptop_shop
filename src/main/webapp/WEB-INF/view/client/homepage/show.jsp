<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - Laptopshop</title>

    <!-- CSRF Token -->
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Raleway:wght@600;800&display=swap" rel="stylesheet">

    <!-- Icon Font Stylesheet -->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="/client/lib/lightbox/css/lightbox.min.css" rel="stylesheet">
    <link href="/client/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

    <!-- Customized Bootstrap Stylesheet -->
    <link href="/client/css/bootstrap.min.css" rel="stylesheet">

    <!-- Template Stylesheet -->
    <link href="/client/css/style.css" rel="stylesheet">
    <style>
        .fruite-item:hover { transform: translateY(-6px); box-shadow: 0 0.5rem 1.25rem rgba(0,0,0,0.12) !important; }
    </style>
</head>

<body>

    <!-- Spinner Start -->
    <div id="spinner" class="show w-100 vh-100 bg-white position-fixed translate-middle top-50 start-50  d-flex align-items-center justify-content-center">
        <div class="spinner-grow text-primary" role="status"></div>
    </div>
    <!-- Spinner End -->

    <jsp:include page="../layout/header.jsp" />


    <jsp:include page="../layout/banner.jsp" />




    <!-- Products Section Start -->
    <div class="container-fluid fruite py-5">
        <div class="container py-5">
            <div class="tab-class text-center">
                <div class="row g-4 mb-4">
                    <div class="col-lg-6 text-start">
                        <h1 class="fw-bold text-dark">Sản phẩm nổi bật</h1>
                        <p class="text-muted mb-0">Laptop chính hãng, giá tốt</p>
                    </div>
                    <div class="col-lg-6 text-end d-flex align-items-center justify-content-lg-end">
                        <a href="/products" class="btn btn-primary rounded-pill px-4 py-2">
                            <i class="fas fa-th-large me-2"></i>Xem tất cả
                        </a>
                    </div>
                </div>
                <div class="tab-content">
                    <div id="tab-1" class="tab-pane fade show p-0 active">
                        <div class="row g-4">
                            <c:forEach var="product" items="${products}">
                                <div class="col-md-6 col-lg-4 col-xl-3">
                                    <div class="card border-0 shadow-sm h-100 rounded-3 overflow-hidden fruite-item" style="transition: transform 0.2s, box-shadow 0.2s;">
                                        <a href="/product/${product.id}" class="text-decoration-none text-dark">
                                            <div class="position-relative overflow-hidden bg-light" style="height: 200px;">
                                                <img src="/images/imageProduct/${product.image}" class="img-fluid w-100 h-100" alt="${product.name}" style="object-fit: cover;">
                                                <span class="position-absolute top-0 start-0 m-2 badge bg-primary">Laptop</span>
                                            </div>
                                            <div class="card-body p-3">
                                                <h6 class="card-title fw-semibold mb-2 text-truncate" style="font-size: 0.95rem;">${product.name}</h6>
                                                <p class="small text-muted mb-2 text-truncate" style="font-size: 0.8rem;">${product.shortDesc}</p>
                                                <p class="fw-bold text-primary mb-3 mb-0">
                                                    <fmt:formatNumber type="number" value="${product.price}" pattern="#,##0" /> đ
                                                </p>
                                            </div>
                                        </a>
                                        <div class="card-footer bg-white border-0 pt-0 pb-3 px-3">
                                            <form action="/add-product-to-cart/${product.id}" method="post" class="mb-0">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                                <button type="submit" class="btn btn-outline-primary btn-sm w-100 rounded-pill py-2">
                                                    <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Products Section End -->
       

    <jsp:include page="../layout/feature.jsp" />

    <jsp:include page="../layout/footer.jsp" />

    <!-- Include Chatbot -->
    <jsp:include page="/WEB-INF/view/chatbot.jsp" />

    <!-- Back to Top -->
    <a href="#" class="btn btn-primary border-3 border-primary rounded-circle back-to-top"><i class="fa fa-arrow-up"></i></a>


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

</html>