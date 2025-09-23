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
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #36d1dc 0%, #5b86e5 100%);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card {
            border-radius: 1rem;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }
        .input-icon-user {
            position: absolute;
            left: 28px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d; /* xanh */
        }

        .input-icon-lock {
            position: absolute;
            left: 28px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;/* xanh ngọc */
        }

        .form-control {
            border-radius: 0.5rem;
            padding-left: 2.5rem;
        }

        .form-control:focus {
            border-color: #36d1dc;
            box-shadow: 0 0 0 0.2rem rgba(91, 134, 229, 0.25);
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }

        .btn-primary {
            background-color: #5b86e5;
            border: none;
            border-radius: 0.5rem;
            transition: all 0.3s;
        }

        .btn-primary:hover {
            background-color: #4776e6;
            transform: scale(1.02);
        }

        .invalid-feedback {
            display: block;
            font-size: 0.9rem;
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-7">
                <div class="card shadow-lg border-0 mt-5">
                    <div class="card-header bg-white text-center">
                        <h3 class="my-3 fw-bold text-primary">
                            <i class="fas fa-user-plus me-2"></i>Create Account
                        </h3>
                    </div>
                    <div class="card-body px-4">
                        <form:form method="post" action="/register" modelAttribute="registerUser">

                            <!-- First / Last name -->
                            <div class="row mb-3">
                                <div class="col-md-6 position-relative">
                                    <span class="input-icon-user"><i class="fas fa-user"></i></span>
                                    <form:input class="form-control ${not empty errorFirstName ? 'is-invalid' : ''}"
                                        type="text" placeholder="First name" path="firstName" />
                                    <form:errors path="firstName" cssClass="invalid-feedback" />
                                </div>
                                <div class="col-md-6 position-relative">
                                    <span class="input-icon-user"><i class="fas fa-user"></i></span>
                                    <form:input class="form-control" type="text" placeholder="Last name"
                                        path="lastName" />
                                </div>
                            </div>

                            <!-- Email -->
                            <div class="mb-3 position-relative">
                                <span class="input-icon"><i class="fas fa-envelope"></i></span>
                                <form:input class="form-control ${not empty errorEmail ? 'is-invalid' : ''}"
                                    type="email" placeholder="Email address" path="email" />
                                <form:errors path="email" cssClass="invalid-feedback" />
                            </div>

                            <!-- Password / Confirm -->
                            <div class="row mb-3">
                                <div class="col-md-6 position-relative">
                                    <span class="input-icon-lock"><i class="fas fa-lock"></i></span>
                                    <form:password class="form-control ${not empty errorPassword ? 'is-invalid' : ''}"
                                        placeholder="Password" path="password" />
                                    <form:errors path="password" cssClass="invalid-feedback" />
                                </div>
                                <div class="col-md-6 position-relative">
                                    <span class="input-icon-lock"><i class="fas fa-lock"></i></span>
                                    <form:password class="form-control" placeholder="Confirm password"
                                        path="confirmPassword" />
                                    <form:errors path="confirmPassword" cssClass="invalid-feedback" />
                                </div>
                            </div>

                            <div class="d-grid mt-4">
                                <button class="btn btn-primary btn-lg">
                                    Create Account
                                </button>
                            </div>
                        </form:form>
                    </div>
                    <div class="card-footer text-center bg-white">
                        <small>
                            Already have an account?
                            <a href="/login" class="text-decoration-none">Login here</a>
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
