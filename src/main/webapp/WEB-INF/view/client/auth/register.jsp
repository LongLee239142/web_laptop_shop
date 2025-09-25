<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <title>Register - Laptopshop</title>
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

        .register-container {
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
            animation: shake 0.5s ease-in-out;
        }

        .form-control.is-invalid:focus {
            border-color: #dc3545;
            box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1);
            background: #fff5f5;
        }

        .invalid-feedback {
            display: block;
            color: #dc3545;
            font-size: 0.8rem;
            margin-top: 0.5rem;
            font-weight: 500;
            line-height: 1.4;
            padding: 0.25rem 0.5rem;
            background: rgba(220, 53, 69, 0.1);
            border-radius: 6px;
            border-left: 3px solid #dc3545;
            animation: slideDown 0.3s ease-out;
            word-wrap: break-word;
            overflow-wrap: break-word;
            hyphens: auto;
        }

        /* Error message container to prevent layout shift */
        .error-container {
            min-height: 0;
            margin-top: 0.5rem;
            transition: all 0.3s ease;
        }

        .error-container:empty {
            min-height: 0;
            margin-top: 0;
        }

        /* Shake animation for invalid inputs */
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-2px); }
            20%, 40%, 60%, 80% { transform: translateX(2px); }
        }

        /* Slide down animation for error messages */
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
                max-height: 0;
            }
            to {
                opacity: 1;
                transform: translateY(0);
                max-height: 100px;
            }
        }

        /* Success state styling */
        .form-control.is-valid {
            border-color: #28a745;
            background: #f8fff9;
        }

        .form-control.is-valid:focus {
            border-color: #28a745;
            box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.1);
            background: #f8fff9;
        }

        .valid-feedback {
            display: block;
            color: #28a745;
            font-size: 0.8rem;
            margin-top: 0.5rem;
            font-weight: 500;
            line-height: 1.4;
            padding: 0.25rem 0.5rem;
            background: rgba(40, 167, 69, 0.1);
            border-radius: 6px;
            border-left: 3px solid #28a745;
            animation: slideDown 0.3s ease-out;
        }

        .btn-register {
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

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
            color: white;
        }

        .btn-register:active {
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
        }

        .card-footer a:hover {
            color: #764ba2;
            text-decoration: underline;
        }

        /* Mobile responsiveness */
        @media (max-width: 768px) {
            body {
                padding: 0.5rem;
                align-items: flex-start;
                padding-top: 1rem;
            }

            .register-container {
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

            .btn-register {
                height: 50px;
                font-size: 1rem;
            }

            /* Mobile validation error styling */
            .invalid-feedback {
                font-size: 0.75rem;
                padding: 0.2rem 0.4rem;
                margin-top: 0.4rem;
                line-height: 1.3;
            }

            .error-container {
                margin-top: 0.4rem;
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

            .btn-register {
                height: 48px;
                font-size: 0.95rem;
                padding: 12px 20px;
            }

            /* Small mobile validation error styling */
            .invalid-feedback {
                font-size: 0.7rem;
                padding: 0.15rem 0.3rem;
                margin-top: 0.3rem;
                line-height: 1.2;
                border-radius: 4px;
            }

            .error-container {
                margin-top: 0.3rem;
            }

            /* Ensure error messages don't break layout on very small screens */
            .form-group {
                min-height: auto;
            }

            .form-group .position-relative {
                min-height: auto;
            }
        }

        /* Extra small screens */
        @media (max-width: 375px) {
            .invalid-feedback {
                font-size: 0.65rem;
                padding: 0.1rem 0.25rem;
                margin-top: 0.25rem;
                word-break: break-word;
            }

            .card-body {
                padding: 0.75rem;
            }

            .form-group {
                margin-bottom: 1rem;
            }
        }

        /* Animation for form elements */
        .form-group {
            animation: fadeInUp 0.6s ease-out;
        }

        .form-group:nth-child(1) { animation-delay: 0.1s; }
        .form-group:nth-child(2) { animation-delay: 0.2s; }
        .form-group:nth-child(3) { animation-delay: 0.3s; }
        .form-group:nth-child(4) { animation-delay: 0.4s; }

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
    </style>
</head>

<body>
    <div class="register-container">
        <div class="card">
            <div class="card-header">
                <h3>
                    <i class="fas fa-user-plus"></i>Create Account
                </h3>
            </div>
            <div class="card-body">
                <form:form method="post" action="/register" modelAttribute="registerUser">
                    <!-- First / Last name -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="firstName">First Name</label>
                                <div class="position-relative">
                                    <span class="input-icon"><i class="fas fa-user"></i></span>
                                    <form:input class="form-control ${not empty errorFirstName ? 'is-invalid' : ''}"
                                        type="text" placeholder="Enter your first name" path="firstName" id="firstName" />
                                </div>
                                <div class="error-container">
                                    <form:errors path="firstName" cssClass="invalid-feedback" />
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="lastName">Last Name</label>
                                <div class="position-relative">
                                    <span class="input-icon"><i class="fas fa-user"></i></span>
                                    <form:input class="form-control" type="text" placeholder="Enter your last name"
                                        path="lastName" id="lastName" />
                                </div>
                                <div class="error-container">
                                    <form:errors path="lastName" cssClass="invalid-feedback" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Email -->
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <div class="position-relative">
                            <span class="input-icon"><i class="fas fa-envelope"></i></span>
                            <form:input class="form-control ${not empty errorEmail ? 'is-invalid' : ''}"
                                type="email" placeholder="Enter your email address" path="email" id="email" />
                        </div>
                        <div class="error-container">
                            <form:errors path="email" cssClass="invalid-feedback" />
                        </div>
                    </div>

                    <!-- Password / Confirm -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="password">Password</label>
                                <div class="position-relative">
                                    <span class="input-icon"><i class="fas fa-lock"></i></span>
                                    <form:password class="form-control ${not empty errorPassword ? 'is-invalid' : ''}"
                                        placeholder="Enter your password" path="password" id="password" />
                                </div>
                                <div class="error-container">
                                    <form:errors path="password" cssClass="invalid-feedback" />
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="confirmPassword">Confirm Password</label>
                                <div class="position-relative">
                                    <span class="input-icon"><i class="fas fa-lock"></i></span>
                                    <form:password class="form-control" placeholder="Confirm your password"
                                        path="confirmPassword" id="confirmPassword" />
                                </div>
                                <div class="error-container">
                                    <form:errors path="confirmPassword" cssClass="invalid-feedback" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <button class="btn-register" type="submit">
                            <i class="fas fa-user-plus me-2"></i>Create Account
                        </button>
                    </div>
                </form:form>
            </div>
            <div class="card-footer">
                <small>
                    Already have an account?
                    <a href="/login">Login here</a>
                </small>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Enhanced validation handling
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form');
            const inputs = form.querySelectorAll('.form-control');
            
            // Add real-time validation feedback
            inputs.forEach(input => {
                input.addEventListener('blur', function() {
                    validateField(this);
                });
                
                input.addEventListener('input', function() {
                    // Remove error state when user starts typing
                    if (this.classList.contains('is-invalid')) {
                        this.classList.remove('is-invalid');
                        const errorContainer = this.closest('.form-group').querySelector('.error-container');
                        if (errorContainer) {
                            errorContainer.style.display = 'none';
                        }
                    }
                });
            });
            
            // Form submission validation
            form.addEventListener('submit', function(e) {
                let isValid = true;
                
                inputs.forEach(input => {
                    if (!validateField(input)) {
                        isValid = false;
                    }
                });
                
                if (!isValid) {
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
                const fieldName = field.getAttribute('path');
                let isValid = true;
                let errorMessage = '';
                
                // Basic validation rules
                if (field.hasAttribute('required') && !value) {
                    errorMessage = 'This field is required';
                    isValid = false;
                } else if (fieldName === 'firstName' && value && value.length < 2) {
                    errorMessage = 'First name must have a minimum of 2 characters';
                    isValid = false;
                } else if (fieldName === 'email' && value && !isValidEmail(value)) {
                    errorMessage = 'Please enter a valid email address';
                    isValid = false;
                } else if (fieldName === 'password' && value && value.length < 6) {
                    errorMessage = 'Password must have a minimum of 6 characters';
                    isValid = false;
                } else if (fieldName === 'confirmPassword' && value) {
                    const password = document.querySelector('input[path="password"]').value;
                    if (value !== password) {
                        errorMessage = 'Passwords do not match';
                        isValid = false;
                    }
                }
                
                // Update field appearance
                if (isValid) {
                    field.classList.remove('is-invalid');
                    field.classList.add('is-valid');
                } else {
                    field.classList.remove('is-valid');
                    field.classList.add('is-invalid');
                }
                
                // Update error message
                const errorContainer = field.closest('.form-group').querySelector('.error-container');
                if (errorContainer) {
                    if (isValid) {
                        errorContainer.style.display = 'none';
                    } else {
                        errorContainer.style.display = 'block';
                        const errorElement = errorContainer.querySelector('.invalid-feedback');
                        if (errorElement) {
                            errorElement.textContent = errorMessage;
                        }
                    }
                }
                
                return isValid;
            }
            
            function isValidEmail(email) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                return emailRegex.test(email);
            }
        });
    </script>
</body>

</html>
