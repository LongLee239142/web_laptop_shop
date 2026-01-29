package vn.longlee.laptopshop.config;

import java.io.IOException;
import java.util.Collection;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Đồng bộ role vào session nếu chưa có (vd: user đăng nhập trước khi có lưu role).
 * Giúp dropdown client hiển thị "Quay về trang Admin" cho admin mà không cần đăng xuất/đăng nhập lại.
 */
public class SessionRoleSyncFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("role") == null) {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && auth.getPrincipal() != null
                    && !"anonymousUser".equals(auth.getPrincipal().toString())) {
                Collection<? extends GrantedAuthority> authorities = auth.getAuthorities();
                boolean isAdmin = authorities != null && authorities.stream()
                        .map(GrantedAuthority::getAuthority)
                        .anyMatch("ROLE_ADMIN"::equals);
                session.setAttribute("role", isAdmin ? "ADMIN" : "USER");
            }
        }
        filterChain.doFilter(request, response);
    }
}
