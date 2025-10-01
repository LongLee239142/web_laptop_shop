<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Login - Laptopshop</title>
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

        .login-container {
            width: 100%;
            max-width: 400px;
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

        .btn-login {
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

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
            color: white;
        }

        .btn-login:active {
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

        .alert-success {
            background: rgba(40, 167, 69, 0.1);
            color: #28a745;
            border-left: 4px solid #28a745;
        }

        /* Mobile responsiveness */
        @media (max-width: 768px) {
            body {
                padding: 0.5rem;
                align-items: flex-start;
                padding-top: 1rem;
            }

            .login-container {
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
                font-size: 16px; /* Prevents zoom on iOS */
                height: 48px;
            }

            .btn-login {
                height: 50px;
                font-size: 1rem;
            }
        }

        @media (max-width: 576px) {
            .card-header {
                padding: 1rem 1rem 0.75rem;
            }

            .card-header h3 {
                font-size: 1.25rem;
            }

            .card-body {
                padding: 1rem;
            }

            .form-group {
                margin-bottom: 1.25rem;
            }

            .form-control {
                height: 45px;
                padding: 10px 12px 10px 40px;
            }

            .input-icon {
                left: 12px;
                font-size: 0.9rem;
            }

            .btn-login {
                height: 48px;
                font-size: 0.95rem;
                padding: 12px 20px;
            }

            .alert {
                padding: 0.75rem;
                font-size: 0.9rem;
            }
        }

        /* Extra small screens */
        @media (max-width: 375px) {
            .card-body {
                padding: 0.75rem;
            }

            .form-group {
                margin-bottom: 1rem;
            }

            .alert {
                padding: 0.5rem;
                font-size: 0.85rem;
            }
        }

        /* Animation for form elements */
        .form-group {
            animation: fadeInUp 0.6s ease-out;
        }

        .form-group:nth-child(1) { animation-delay: 0.1s; }
        .form-group:nth-child(2) { animation-delay: 0.2s; }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
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

        /* Loading state */
        .btn-login:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
        }

        .btn-login.loading {
            position: relative;
            color: transparent;
        }

        .btn-login.loading::after {
            content: '';
            position: absolute;
            width: 20px;
            height: 20px;
            top: 50%;
            left: 50%;
            margin-left: -10px;
            margin-top: -10px;
            border: 2px solid #ffffff;
            border-radius: 50%;
            border-top-color: transparent;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }
    </style>
</head>

<body>
    <div class="login-container">
        <div class="card">
            <div class="card-header">
                <h3>
                    <i class="fas fa-laptop"></i>Laptopshop Login
                </h3>
            </div>
            <div class="card-body">
                <form method="post" action="/login" id="loginForm">
                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-triangle me-2"></i>Invalid email or password.
                        </div>
                    </c:if>
                    <c:if test="${param.logout != null}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle me-2"></i>Logout successful.
                        </div>
                    </c:if>
                    <c:if test="${registrationSuccess != null}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle me-2"></i>${registrationSuccess}
                        </div>
                    </c:if>

                    <!-- Email -->
                    <div class="form-group">
                        <label for="username">Email Address</label>
                        <div class="position-relative">
                            <span class="input-icon"><i class="fas fa-envelope"></i></span>
                            <input class="form-control" type="email" placeholder="Enter your email address" 
                                name="username" id="username" required />
                        </div>
                    </div>

                    <!-- Password -->
                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="position-relative">
                            <span class="input-icon"><i class="fas fa-lock"></i></span>
                            <input class="form-control" type="password" placeholder="Enter your password" 
                                name="password" id="password" required />
                        </div>
                    </div>

                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                    <div class="form-group">
                        <button class="btn-login" type="submit">
                            <i class="fas fa-sign-in-alt me-2"></i>Login
                        </button>
                    </div>
                </form>
            </div>
            <div class="card-footer">
                <small>
                    <a href="/register">Need an account? Sign up!</a>
                    <br />
                    <a href="/forgot-password">Forgot password?</a>
                </small>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Enhanced login form handling
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('loginForm');
            const submitBtn = form.querySelector('.btn-login');
            const inputs = form.querySelectorAll('.form-control');
            
            // Add real-time validation feedback
            inputs.forEach(input => {
                input.addEventListener('blur', function() {
                    validateField(this);
                });
                
                input.addEventListener('input', function() {
                    // Remove any error states when user starts typing
                    if (this.classList.contains('is-invalid')) {
                        this.classList.remove('is-invalid');
                    }
                });
            });
            
            // Form submission with loading state
            form.addEventListener('submit', function(e) {
                let isValid = true;
                
                // Validate all fields
                inputs.forEach(input => {
                    if (!validateField(input)) {
                        isValid = false;
                    }
                });
                
                if (isValid) {
                    // Show loading state
                    submitBtn.classList.add('loading');
                    submitBtn.disabled = true;
                    
                    // Debug: Log form data
                    const formData = new FormData(form);
                    console.log('Login attempt:', {
                        email: formData.get('username'),
                        password: formData.get('password').length + ' characters'
                    });
                    
                    // Re-enable after 5 seconds (in case of slow response)
                    setTimeout(() => {
                        submitBtn.classList.remove('loading');
                        submitBtn.disabled = false;
                    }, 5000);
                } else {
                    e.preventDefault();
                    // Focus on first invalid field
                    const firstInvalid = form.querySelector('.form-control.is-invalid');
                    if (firstInvalid) {
                        firstInvalid.focus();
                        firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                }
            });
            
            function validateField(field) {
                const value = field.value.trim();
                let isValid = true;
                
                // Basic validation rules
                if (field.hasAttribute('required') && !value) {
                    isValid = false;
                } else if (field.type === 'email' && value && !isValidEmail(value)) {
                    isValid = false;
                } else if (field.type === 'password' && value && value.length < 2) {
                    isValid = false;
                }
                
                // Update field appearance
                if (isValid) {
                    field.classList.remove('is-invalid');
                    field.classList.add('is-valid');
                } else {
                    field.classList.remove('is-valid');
                    field.classList.add('is-invalid');
                }
                
                return isValid;
            }
            
            function isValidEmail(email) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return emailRegex.test(email);
            }
            
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
            
            // Debug: Check if there are any validation errors
            console.log('Login form initialized. Password validation: minimum 2 characters');
            
            // Add enter key support for form submission
            inputs.forEach(input => {
                input.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        form.dispatchEvent(new Event('submit'));
                    }
                });
            });
        });
    </script>
</body>

</html>
