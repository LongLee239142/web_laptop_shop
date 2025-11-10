<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Forgot Password - Laptopshop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    <style>
        * {
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
        }

        .forgot-password-container {
            width: 100%;
            max-width: 450px;
            margin: 0 auto;
        }

        .card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
        }

        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 2rem 2rem 1.5rem;
            text-align: center;
        }

        .card-header h3 {
            color: white;
            margin: 0;
            font-size: 1.75rem;
            font-weight: 600;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .card-header i {
            font-size: 1.5rem;
            margin-right: 0.5rem;
        }

        .card-body {
            padding: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #333;
            font-weight: 500;
            font-size: 0.9rem;
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #667eea;
            z-index: 2;
            font-size: 1rem;
        }

        .form-control {
            border: 2px solid #e1e5e9;
            border-radius: 12px;
            padding: 12px 15px 12px 45px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f8f9fa;
            height: 50px;
        }

        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            background: white;
            outline: none;
        }

        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 12px;
            color: white;
            font-size: 1.1rem;
            font-weight: 600;
            padding: 15px 30px;
            width: 100%;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            height: 55px;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
            color: white;
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        .card-footer {
            background: #f8f9fa;
            border: none;
            padding: 1.5rem 2rem;
            text-align: center;
        }

        .card-footer a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
            display: inline-block;
            margin: 0.25rem 0;
        }

        .card-footer a:hover {
            color: #764ba2;
            text-decoration: underline;
        }

        .alert {
            border: none;
            border-radius: 12px;
            padding: 1rem;
            margin-bottom: 1.5rem;
            font-weight: 500;
            animation: slideDown 0.3s ease-out;
        }

        .alert-success {
            background: rgba(40, 167, 69, 0.1);
            color: #28a745;
            border-left: 4px solid #28a745;
        }

        .alert-danger {
            background: rgba(220, 53, 69, 0.1);
            color: #dc3545;
            border-left: 4px solid #dc3545;
        }

        .alert-info {
            background: rgba(23, 162, 184, 0.1);
            color: #17a2b8;
            border-left: 4px solid #17a2b8;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 768px) {
            body {
                padding: 0.5rem;
                align-items: flex-start;
                padding-top: 1rem;
            }

            .forgot-password-container {
                max-width: 100%;
            }

            .card-header {
                padding: 1.5rem 1.5rem 1rem;
            }

            .card-header h3 {
                font-size: 1.5rem;
            }

            .card-body {
                padding: 1.5rem;
            }

            .form-control {
                font-size: 16px;
                height: 48px;
            }

            .btn-submit {
                height: 50px;
                font-size: 1rem;
            }
        }
    </style>
</head>

<body>
    <div class="forgot-password-container">
        <div class="card">
            <div class="card-header">
                <h3>
                    <i class="fas fa-key"></i>Forgot Password?
                </h3>
            </div>
            <div class="card-body">
                <c:if test="${not empty message}">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>${message}
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle me-2"></i>${error}
                    </div>
                </c:if>

                <p style="color: #666; margin-bottom: 1.5rem; line-height: 1.6;">
                    Nhập địa chỉ email của bạn. Chúng tôi sẽ gửi cho bạn một liên kết để đặt lại mật khẩu.
                </p>

                <form method="post" action="/forgot-password" id="forgotPasswordForm">
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <div class="position-relative">
                            <span class="input-icon"><i class="fas fa-envelope"></i></span>
                            <input class="form-control" type="email" placeholder="Enter your email address" 
                                name="email" id="email" required />
                        </div>
                    </div>

                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                    <div class="form-group">
                        <button class="btn-submit" type="submit">
                            <i class="fas fa-paper-plane me-2"></i>Gửi liên kết khôi phục
                        </button>
                    </div>
                </form>
            </div>
            <div class="card-footer">
                <small>
                    <a href="/login"><i class="fas fa-arrow-left me-1"></i>Back to Login</a>
                </small>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('forgotPasswordForm');
            const emailInput = document.getElementById('email');
            const submitBtn = form.querySelector('.btn-submit');

            // Enter key support
            emailInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter' || e.keyCode === 13) {
                    e.preventDefault();
                    submitBtn.click();
                }
            });

            // Form validation
            form.addEventListener('submit', function(e) {
                const email = emailInput.value.trim();
                
                if (!email) {
                    e.preventDefault();
                    emailInput.focus();
                    return false;
                }

                // Basic email validation
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    e.preventDefault();
                    alert('Vui lòng nhập địa chỉ email hợp lệ.');
                    emailInput.focus();
                    return false;
                }

                // Show loading state
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang gửi...';
            });

            // Auto-hide alerts after 5 seconds
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    alert.style.transform = 'translateY(-10px)';
                    setTimeout(() => {
                        alert.remove();
                    }, 300);
                }, 5000);
            });
        });
    </script>
</body>

</html>

