<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="utf-8">
                    <title> Thanh toán - Laptopshop</title>
                    <meta content="width=device-width, initial-scale=1.0" name="viewport">
                    <meta content="" name="keywords">
                    <meta content="" name="description">

                    <!-- Google Web Fonts -->
                    <link rel="preconnect" href="https://fonts.googleapis.com">
                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Raleway:wght@600;800&display=swap"
                        rel="stylesheet">

                    <!-- Icon Font Stylesheet -->
                    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css"
                        rel="stylesheet">

                    <!-- Libraries Stylesheet -->
                    <link href="/client/lib/lightbox/css/lightbox.min.css" rel="stylesheet">
                    <link href="/client/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">


                    <!-- Customized Bootstrap Stylesheet -->
                    <link href="/client/css/bootstrap.min.css" rel="stylesheet">

                    <!-- Template Stylesheet -->
                    <link href="/client/css/style.css" rel="stylesheet">
                </head>

                <body>

                    <!-- Spinner Start -->
                    <div id="spinner"
                        class="show w-100 vh-100 bg-white position-fixed translate-middle top-50 start-50  d-flex align-items-center justify-content-center">
                        <div class="spinner-grow text-primary" role="status"></div>
                    </div>
                    <!-- Spinner End -->

                    <jsp:include page="../layout/header.jsp" />

                    <!-- Cart Page Start -->
                    <div class="container-fluid py-5">
                        <div class="container py-5">
                            <div class="mb-3">
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb">
                                        <li class="breadcrumb-item"><a href="/">Home</a></li>
                                        <li class="breadcrumb-item active" aria-current="page">Thông tin thanh toán</li>
                                    </ol>
                                </nav>
                            </div>

                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th scope="col">Sản phẩm</th>
                                            <th scope="col">Tên</th>
                                            <th scope="col">Giá cả</th>
                                            <th scope="col">Số lượng</th>
                                            <th scope="col">Thành tiền</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:if test="${ empty cartDetails}">
                                            <tr>
                                                <td colspan="6">
                                                    Không có sản phẩm trong giỏ hàng
                                                </td>
                                            </tr>
                                        </c:if>
                                        <c:forEach var="cartDetail" items="${cartDetails}">

                                            <tr>
                                                <th scope="row">
                                                    <div class="d-flex align-items-center">
                                                        <img src="/images/imageProduct/${cartDetail.product.image}"
                                                            class="img-fluid me-5 rounded-circle"
                                                            style="width: 80px; height: 80px;" alt="">
                                                    </div>
                                                </th>
                                                <td>
                                                    <div class="mb-0 mt-4">
                                                        <a href="/product/${cartDetail.product.id}" target="_blank">
                                                            ${cartDetail.product.name}
                                                        </a>
                                                    </div>
                                                </td>
                                                <td>
                                                    <p class="mb-0 mt-4">
                                                        <fmt:formatNumber type="number" value="${cartDetail.price}" />
                                                    </p>
                                                </td>
                                                <td>
                                                    <div class="input-group quantity mt-4" style="width: 100px;">
                                                        <input type="text"
                                                            class="form-control form-control-sm text-center border-0"
                                                            value="${cartDetail.quantity}" disabled="true">
                                                    </div>
                                                </td>
                                                <td>
                                                    <p class="mb-0 mt-4" data-cart-detail-id="${cartDetail.id}">
                                                        <fmt:formatNumber type="number"
                                                            value="${cartDetail.price * cartDetail.quantity}" /> đ
                                                    </p>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                    </tbody>
                                </table>
                            </div>
                            <c:if test="${not empty cartDetails}">
                                <form:form action="/place-order" method="post" modelAttribute="cart" id="checkoutForm">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <div class="mt-5 row g-4 justify-content-start">
                                        <div class="col-12 col-md-6">
                                            <div class="p-4 ">
                                                <h5>Thông Tin Người Nhận
                                                </h5>
                                                <div class="row">
                                                    <div class="col-12 form-group mb-3">
                                                        <label>Tên người nhận</label>
                                                        <input class="form-control" name="receiverName" required />
                                                    </div>
                                                    <div class="col-12 form-group mb-3">
                                                        <label>Địa chỉ người nhận</label>
                                                        <input class="form-control" name="receiverAddress" required />
                                                    </div>
                                                    <div class="col-12 form-group mb-3">
                                                        <label>Số điện thoại</label>
                                                        <input class="form-control" name="receiverPhone" required />
                                                    </div>
                                                    <div class="mt-4">
                                                        <i class="fas fa-arrow-left"></i>
                                                        <a href="/cart">Quay lại giỏ hàng</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-12 col-md-6">
                                            <div class="bg-light rounded">
                                                <div class="p-4">
                                                    <h1 class="display-6 mb-4">Thông Tin <span class="fw-normal">Thanh
                                                            Toán</span>
                                                    </h1>

                                                    <div class="d-flex justify-content-between">
                                                        <h5 class="mb-0 me-4">Phí vận chuyển</h5>
                                                        <div class="">
                                                            <p class="mb-0">0 đ</p>
                                                        </div>
                                                    </div>
                                                    <div class="mt-3">
                                                        <h5 class="mb-3">Hình thức thanh toán</h5>
                                                        <div class="payment-methods">
                                                            <div class="form-check mb-2">
                                                                <input class="form-check-input" type="radio" name="paymentMethod" id="cod" value="COD" checked>
                                                                <label class="form-check-label" for="cod">
                                                                    Thanh toán khi nhận hàng (COD)
                                                                </label>
                                                            </div>
                                                            <div class="form-check mb-2">
                                                                <input class="form-check-input" type="radio" name="paymentMethod" id="vnpay" value="VNPAY">
                                                                <label class="form-check-label" for="vnpay">
                                                                    <img src="/images/vnpay.png" alt="VNPay" style="height: 20px; margin-right: 5px;">
                                                                    Thanh toán qua VNPay
                                                                </label>
                                                                <div class="vnpay-options ms-4 mt-2" style="display: none;">
                                                                    <div class="form-check mb-2">
                                                                        <input class="form-check-input" type="radio" name="vnpayType" id="vnpayCard" value="card" checked>
                                                                        <label class="form-check-label" for="vnpayCard">
                                                                            <i class="fas fa-credit-card"></i> Thanh toán bằng thẻ
                                                                        </label>
                                                                    </div>
                                                                    <div class="form-check mb-2">
                                                                        <input class="form-check-input" type="radio" name="vnpayType" id="vnpayQR" value="qr">
                                                                        <label class="form-check-label" for="vnpayQR">
                                                                            <i class="fas fa-qrcode"></i> Thanh toán bằng mã QR
                                                                        </label>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="form-check mb-2">
                                                                <input class="form-check-input" type="radio" name="paymentMethod" id="momo" value="MOMO">
                                                                <label class="form-check-label" for="momo">
                                                                    <img src="/images/momo.png" alt="MoMo" style="height: 20px; margin-right: 5px;">
                                                                    Thanh toán qua MoMo
                                                                </label>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div
                                                    class="py-4 mb-4 border-top border-bottom d-flex justify-content-between">
                                                    <h5 class="mb-0 ps-4 me-4">Tổng số tiền</h5>
                                                    <p class="mb-0 pe-4" data-cart-total-price="${totalPrice}">
                                                        <fmt:formatNumber type="number" value="${totalPrice}" />
                                                    </p>
                                                </div>

                                                <button
                                                    class="btn border-secondary rounded-pill px-4 py-3 text-primary text-uppercase mb-4 ms-4"
                                                    type="submit">
                                                    Xác nhận thanh toán
                                                </button>

                                            </div>
                                        </div>
                                    </div>
                                </form:form>
                            </c:if>

                        </div>
                    </div>
                    <!-- Cart Page End -->


                    <jsp:include page="../layout/footer.jsp" />


                    <!-- Back to Top -->
                    <a href="#" class="btn btn-primary border-3 border-primary rounded-circle back-to-top"><i
                            class="fa fa-arrow-up"></i></a>


                    <!-- JavaScript Libraries -->
                    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script src="/client/lib/easing/easing.min.js"></script>
                    <script src="/client/lib/waypoints/waypoints.min.js"></script>
                    <script src="/client/lib/lightbox/js/lightbox.min.js"></script>
                    <script src="/client/lib/owlcarousel/owl.carousel.min.js"></script>

                    <!-- Template Javascript -->
                    <script src="/client/js/main.js"></script>
                    <script>
                        // Wait for DOM to be fully loaded
                        document.addEventListener('DOMContentLoaded', function() {
                            // Get all payment method radio buttons
                            const paymentMethodRadios = document.querySelectorAll('input[name="paymentMethod"]');
                            const vnpayOptions = document.querySelector('.vnpay-options');
                            const vnpayRadio = document.getElementById('vnpay');
                            
                            // Function to show/hide VNPay options
                            function toggleVnpayOptions() {
                                if (vnpayOptions && vnpayRadio) {
                                    vnpayOptions.style.display = vnpayRadio.checked ? 'block' : 'none';
                                }
                            }
                            
                            // Add event listeners to all payment method radios
                            paymentMethodRadios.forEach(function(radio) {
                                radio.addEventListener('change', function() {
                                    toggleVnpayOptions();
                                });
                            });
                            
                            // Initialize on page load
                            toggleVnpayOptions();
                            
                            // Form submission handler
                            const checkoutForm = document.getElementById('checkoutForm');
                            if (checkoutForm) {
                                checkoutForm.addEventListener('submit', function(e) {
                                    e.preventDefault();
                                    
                                    // Validate form fields
                                    const receiverName = document.querySelector('input[name="receiverName"]');
                                    const receiverAddress = document.querySelector('input[name="receiverAddress"]');
                                    const receiverPhone = document.querySelector('input[name="receiverPhone"]');
                                    
                                    if (!receiverName || !receiverName.value.trim()) {
                                        alert('Vui lòng nhập tên người nhận');
                                        receiverName.focus();
                                        return;
                                    }
                                    
                                    if (!receiverAddress || !receiverAddress.value.trim()) {
                                        alert('Vui lòng nhập địa chỉ người nhận');
                                        receiverAddress.focus();
                                        return;
                                    }
                                    
                                    if (!receiverPhone || !receiverPhone.value.trim()) {
                                        alert('Vui lòng nhập số điện thoại');
                                        receiverPhone.focus();
                                        return;
                                    }
                                    
                                    // Get selected payment method
                                    const selectedPaymentMethod = document.querySelector('input[name="paymentMethod"]:checked');
                                    if (!selectedPaymentMethod) {
                                        alert('Vui lòng chọn hình thức thanh toán');
                                        return;
                                    }
                                    
                                    const paymentMethod = selectedPaymentMethod.value;
                                    
                                    // Get CSRF token
                                    const csrfInput = document.querySelector('input[name="${_csrf.parameterName}"]');
                                    const csrfToken = csrfInput ? csrfInput.value : '';
                                    
                                    // Get total price from the data attribute
                                    const totalPriceElement = document.querySelector('[data-cart-total-price]');
                                    if (!totalPriceElement) {
                                        alert('Không tìm thấy tổng tiền. Vui lòng tải lại trang.');
                                        return;
                                    }
                                    
                                    const totalPrice = totalPriceElement.getAttribute('data-cart-total-price');
                                    const orderInfo = "Thanh toan don hang " + new Date().getTime();
                                    
                                    // Create form data
                                    const formData = new FormData();
                                    formData.append('amount', totalPrice);
                                    formData.append('orderInfo', orderInfo);
                                    formData.append('receiverName', receiverName.value.trim());
                                    formData.append('receiverAddress', receiverAddress.value.trim());
                                    formData.append('receiverPhone', receiverPhone.value.trim());
                                    if (csrfToken) {
                                        formData.append('${_csrf.parameterName}', csrfToken);
                                    }
                                    
                                    if (paymentMethod === 'VNPAY') {
                                        // Validate VNPay type is selected
                                        const selectedVnpayType = document.querySelector('input[name="vnpayType"]:checked');
                                        if (!selectedVnpayType) {
                                            alert('Vui lòng chọn loại thanh toán VNPay');
                                            return;
                                        }
                                        
                                        // Add payment type for VNPay
                                        formData.append('paymentType', selectedVnpayType.value);
                                        
                                        // Submit to VNPay endpoint
                                        fetch('/api/payment/vnpay/create', {
                                            method: 'POST',
                                            body: formData,
                                            headers: {
                                                'X-CSRF-TOKEN': csrfToken
                                            }
                                        })
                                        .then(response => {
                                            if (!response.ok) {
                                                return response.json().then(data => {
                                                    throw new Error(data.error || 'Lỗi khi tạo thanh toán VNPay');
                                                });
                                            }
                                            return response.json();
                                        })
                                        .then(data => {
                                            if (data.paymentUrl) {
                                                window.location.href = data.paymentUrl;
                                            } else {
                                                alert('Không nhận được URL thanh toán từ VNPay');
                                            }
                                        })
                                        .catch(error => {
                                            console.error('Error:', error);
                                            alert('Có lỗi xảy ra khi xử lý thanh toán VNPay: ' + error.message);
                                        });
                                    } else if (paymentMethod === 'MOMO') {
                                        // Submit to MoMo endpoint
                                        fetch('/api/payment/momo/create', {
                                            method: 'POST',
                                            body: formData,
                                            headers: {
                                                'X-CSRF-TOKEN': csrfToken
                                            }
                                        })
                                        .then(response => {
                                            if (!response.ok) {
                                                return response.json().then(data => {
                                                    throw new Error(data.error || 'Lỗi khi tạo thanh toán MoMo');
                                                });
                                            }
                                            return response.json();
                                        })
                                        .then(data => {
                                            console.log('MoMo Response:', data);
                                            if (data.paymentUrl) {
                                                window.location.href = data.paymentUrl;
                                            } else {
                                                alert('Có lỗi xảy ra khi tạo URL thanh toán MoMo: ' + (data.error || 'Unknown error'));
                                            }
                                        })
                                        .catch(error => {
                                            console.error('Error details:', error);
                                            alert('Có lỗi xảy ra khi xử lý thanh toán MoMo: ' + error.message);
                                        });
                                    } else {
                                        // Submit to regular order endpoint (COD)
                                        this.action = '/place-order';
                                        this.submit();
                                    }
                                });
                            }
                        });
                    </script>
                </body>

                </html>