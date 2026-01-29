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
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* === Featured Products Section Redesign === */
        .featured-section {
            background: linear-gradient(180deg, #f8fafc 0%, #f1f5f9 50%, #fff 100%);
            padding: 4rem 0 5rem;
            font-family: 'Plus Jakarta Sans', 'Open Sans', sans-serif;
        }
        .featured-section .section-header {
            margin-bottom: 2.5rem;
        }
        .featured-section .section-label {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--bs-primary);
            font-size: 0.85rem;
            font-weight: 600;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            margin-bottom: 0.5rem;
        }
        .featured-section .section-label i {
            font-size: 1rem;
        }
        .featured-section .section-title {
            font-family: 'Plus Jakarta Sans', 'Raleway', sans-serif;
            font-size: clamp(1.75rem, 4vw, 2.25rem);
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 0.35rem;
            letter-spacing: -0.02em;
        }
        .featured-section .section-desc {
            color: #64748b;
            font-size: 1rem;
            margin-bottom: 0;
        }
        .featured-section .btn-view-all {
            background: linear-gradient(135deg, var(--bs-primary) 0%, #0d6efd 100%);
            color: #fff;
            border: none;
            padding: 0.6rem 1.4rem;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.9rem;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .featured-section .btn-view-all:hover {
            color: #fff;
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(13, 110, 253, 0.35);
        }
        .featured-section .product-card {
            background: #fff;
            border-radius: 16px;
            overflow: hidden;
            border: 1px solid #e2e8f0;
            height: 100%;
            transition: transform 0.3s ease, box-shadow 0.3s ease, border-color 0.3s ease;
        }
        .featured-section .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08);
            border-color: transparent;
        }
        .featured-section .product-card .card-img-wrap {
            position: relative;
            height: 200px;
            overflow: hidden;
            background: #f8fafc;
        }
        .featured-section .product-card .card-img-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .featured-section .product-card:hover .card-img-wrap img {
            transform: scale(1.08);
        }
        .featured-section .product-card .card-badge {
            position: absolute;
            top: 12px;
            left: 12px;
            background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
            color: #fff;
            font-size: 0.7rem;
            font-weight: 700;
            padding: 0.35rem 0.65rem;
            border-radius: 8px;
            letter-spacing: 0.02em;
            box-shadow: 0 2px 8px rgba(34, 197, 94, 0.4);
        }
        .featured-section .product-card .card-body {
            padding: 1.15rem 1.25rem;
        }
        .featured-section .product-card .card-title {
            font-size: 0.95rem;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 0.35rem;
            line-height: 1.35;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .featured-section .product-card .card-desc {
            font-size: 0.8rem;
            color: #64748b;
            margin-bottom: 0.75rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .featured-section .product-card .card-price {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--bs-primary);
            margin-bottom: 0;
        }
        .featured-section .product-card .card-footer {
            padding: 0 1.25rem 1.25rem;
            background: transparent;
            border: none;
        }
        .featured-section .product-card .btn-add-cart {
            width: 100%;
            padding: 0.55rem 1rem;
            border-radius: 10px;
            font-weight: 600;
            font-size: 0.85rem;
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #e2e8f0;
            transition: background 0.2s, color 0.2s, border-color 0.2s;
        }
        .featured-section .product-card .btn-add-cart:hover {
            background: var(--bs-primary);
            color: #fff;
            border-color: var(--bs-primary);
        }
        .featured-section .product-card a {
            text-decoration: none;
            color: inherit;
        }
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
    <section class="container-fluid featured-section">
        <div class="container">
            <div class="row align-items-end justify-content-between section-header">
                <div class="col-auto">
                    <div class="section-label">
                        <i class="fas fa-star"></i>
                        <span>Nổi bật</span>
                    </div>
                    <h1 class="section-title">Sản phẩm nổi bật</h1>
                    <p class="section-desc">Laptop chính hãng, giá tốt — giao nhanh, bảo hành chính thức</p>
                </div>
                <div class="col-auto mt-3 mt-md-0">
                    <a href="/products" class="btn btn-view-all">
                        <i class="fas fa-th-large me-2"></i>Xem tất cả
                    </a>
                </div>
            </div>
            <div class="row g-4">
                <c:forEach var="product" items="${products}">
                    <div class="col-sm-6 col-lg-4 col-xl-3">
                        <div class="card product-card">
                            <a href="/product/${product.id}">
                                <div class="card-img-wrap">
                                    <img src="/images/imageProduct/${product.image}" alt="${product.name}">
                                    <span class="card-badge">Laptop</span>
                                </div>
                                <div class="card-body">
                                    <h6 class="card-title">${product.name}</h6>
                                    <p class="card-desc">${product.shortDesc}</p>
                                    <p class="card-price">
                                        <fmt:formatNumber type="number" value="${product.price}" pattern="#,##0" /> đ
                                    </p>
                                </div>
                            </a>
                            <div class="card-footer">
                                <form action="/add-product-to-cart/${product.id}" method="post" class="mb-0">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <button type="submit" class="btn btn-add-cart">
                                        <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>
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