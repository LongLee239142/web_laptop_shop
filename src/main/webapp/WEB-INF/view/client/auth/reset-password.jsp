<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Đặt lại mật khẩu - Laptopshop</title>
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

        .reset-password-container {
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

        .form-control.is-invalid {
            border-color: #dc3545;
            background: #fff5f5;
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

        .alert-danger {
            background: rgba(220, 53, 69, 0.1);
            color: #dc3545;
            border-left: 4px solid #dc3545;
        }

        .invalid-feedback {
            display: block;
            color: #dc3545;
            font-size: 0.8rem;
            margin-top: 0.5rem;
            font-weight: 500;
        }

        .password-strength {
            margin-top: 0.5rem;
            font-size: 0.8rem;
            color: #666;
        }

        .password-strength.weak {
            color: #dc3545;
        }

        .password-strength.medium {
            color: #ffc107;
        }

        .password-strength.strong {
            color: #28a745;
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

            .reset-password-container {
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
    <div class="reset-password-container">
        <div class="card">
            <div class="card-header">
                <h3>
                    <i class="fas fa-lock"></i>Đặt lại mật khẩu
                </h3>
            </div>
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle me-2"></i>${error}
                    </div>
                </c:if>

                <p style="color: #666; margin-bottom: 1.5rem; line-height: 1.6;">
                    Vui lòng nhập mật khẩu mới cho tài khoản của bạn.
                </p>

                <form method="post" action="/reset-password" id="resetPasswordForm">
                    <input type="hidden" name="token" value="${token}" />
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                    <div class="form-group">
                        <label for="password">Mật khẩu mới</label>
                        <div class="position-relative">
                            <span class="input-icon"><i class="fas fa-lock"></i></span>
                            <input class="form-control" type="password" placeholder="Nhập mật khẩu mới" 
                                name="password" id="password" required minlength="6" />
                        </div>
                        <div class="password-strength" id="passwordStrength"></div>
                        <div class="invalid-feedback" id="passwordError" style="display: none;"></div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Xác nhận mật khẩu</label>
                        <div class="position-relative">
                            <span class="input-icon"><i class="fas fa-lock"></i></span>
                            <input class="form-control" type="password" placeholder="Nhập lại mật khẩu" 
                                name="confirmPassword" id="confirmPassword" required minlength="6" />
                        </div>
                        <div class="invalid-feedback" id="confirmPasswordError" style="display: none;"></div>
                    </div>

                    <div class="form-group">
                        <button class="btn-submit" type="submit">
                            <i class="fas fa-check me-2"></i>Đặt lại mật khẩu
                        </button>
                    </div>
                </form>
            </div>
            <div class="card-footer">
                <small>
                    <a href="/login"><i class="fas fa-arrow-left me-1"></i>Quay lại đăng nhập</a>
                </small>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('resetPasswordForm');
            const passwordInput = document.getElementById('password');
            const confirmPasswordInput = document.getElementById('confirmPassword');
            const submitBtn = form.querySelector('.btn-submit');
            const passwordStrength = document.getElementById('passwordStrength');
            const passwordError = document.getElementById('passwordError');
            const confirmPasswordError = document.getElementById('confirmPasswordError');

            // Password strength indicator
            passwordInput.addEventListener('input', function() {
                const password = this.value;
                let strength = '';
                let strengthClass = '';

                if (password.length === 0) {
                    strength = '';
                } else if (password.length < 6) {
                    strength = 'Mật khẩu quá ngắn (tối thiểu 6 ký tự)';
                    strengthClass = 'weak';
                } else if (password.length < 8) {
                    strength = 'Mật khẩu yếu';
                    strengthClass = 'weak';
                } else if (password.length < 12) {
                    strength = 'Mật khẩu trung bình';
                    strengthClass = 'medium';
                } else {
                    strength = 'Mật khẩu mạnh';
                    strengthClass = 'strong';
                }

                passwordStrength.textContent = strength;
                passwordStrength.className = 'password-strength ' + strengthClass;
            });

            // Confirm password validation
            confirmPasswordInput.addEventListener('input', function() {
                if (this.value !== passwordInput.value) {
                    this.classList.add('is-invalid');
                    confirmPasswordError.textContent = 'Mật khẩu xác nhận không khớp';
                    confirmPasswordError.style.display = 'block';
                } else {
                    this.classList.remove('is-invalid');
                    confirmPasswordError.style.display = 'none';
                }
            });

            // Enter key support
            [passwordInput, confirmPasswordInput].forEach(input => {
                input.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter' || e.keyCode === 13) {
                        e.preventDefault();
                        submitBtn.click();
                    }
                });
            });

            // Form validation
            form.addEventListener('submit', function(e) {
                let isValid = true;

                // Validate password
                if (passwordInput.value.length < 6) {
                    passwordInput.classList.add('is-invalid');
                    passwordError.textContent = 'Mật khẩu phải có ít nhất 6 ký tự';
                    passwordError.style.display = 'block';
                    isValid = false;
                } else {
                    passwordInput.classList.remove('is-invalid');
                    passwordError.style.display = 'none';
                }

                // Validate confirm password
                if (confirmPasswordInput.value !== passwordInput.value) {
                    confirmPasswordInput.classList.add('is-invalid');
                    confirmPasswordError.textContent = 'Mật khẩu xác nhận không khớp';
                    confirmPasswordError.style.display = 'block';
                    isValid = false;
                } else {
                    confirmPasswordInput.classList.remove('is-invalid');
                    confirmPasswordError.style.display = 'none';
                }

                if (!isValid) {
                    e.preventDefault();
                    // Focus on first invalid field
                    if (passwordInput.classList.contains('is-invalid')) {
                        passwordInput.focus();
                    } else if (confirmPasswordInput.classList.contains('is-invalid')) {
                        confirmPasswordInput.focus();
                    }
                    return false;
                }

                // Show loading state
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xử lý...';
            });
        });
    </script>
</body>

</html>

