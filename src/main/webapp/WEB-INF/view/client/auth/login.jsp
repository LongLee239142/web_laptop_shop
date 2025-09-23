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
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #4e73df 0%, #224abe 100%);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card {
            border-radius: 1rem;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }

        .form-control {
            border-radius: 0.5rem;
            padding-left: 2.5rem;
        }

        .form-control:focus {
            border-color: #4e73df;
            box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }

        .btn-primary {
            background-color: #4e73df;
            border: none;
            border-radius: 0.5rem;
            transition: all 0.3s;
        }

        .btn-primary:hover {
            background-color: #2e59d9;
            transform: scale(1.02);
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-5">
                <div class="card shadow-lg border-0 mt-5">
                    <div class="card-header bg-white text-center">
                        <h3 class="my-3 fw-bold text-primary">
                            <i class="fas fa-laptop me-2"></i>Laptopshop Login
                        </h3>
                    </div>
                    <div class="card-body px-4">
                        <form method="post" action="/login">
                            <c:if test="${param.error != null}">
                                <div class="alert alert-danger py-2">❌ Invalid email or password.</div>
                            </c:if>
                            <c:if test="${param.logout != null}">
                                <div class="alert alert-success py-2">✅ Logout success.</div>
                            </c:if>

                            <!-- Email -->
                            <div class="mb-3 position-relative">
                                <span class="input-icon"><i class="fas fa-envelope"></i></span>
                                <input class="form-control" type="email" placeholder="Email address" name="username"
                                    required />
                            </div>

                            <!-- Password -->
                            <div class="mb-3 position-relative">
                                <span class="input-icon"><i class="fas fa-lock"></i></span>
                                <input class="form-control" type="password" placeholder="Password" name="password"
                                    required />
                            </div>

                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                            <div class="d-grid mt-4">
                                <button class="btn btn-primary btn-lg">Login</button>
                            </div>
                        </form>
                    </div>
                    <div class="card-footer text-center bg-white">
                        <small>
                            <a href="/register" class="text-decoration-none">Need an account? Sign up!</a>
                            <br />
                            <a href="/forgot-password" class="text-decoration-none">Forgot password?</a>
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
