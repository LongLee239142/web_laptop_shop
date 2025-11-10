package vn.longlee.laptopshop.service;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import vn.longlee.laptopshop.domain.User;
import vn.longlee.laptopshop.entity.PasswordResetToken;
import vn.longlee.laptopshop.repository.PasswordResetTokenRepository;

@Service
public class PasswordResetService {

    @Autowired
    private PasswordResetTokenRepository tokenRepository;

    @Autowired
    private EmailService emailService;

    private static final int TOKEN_EXPIRY_HOURS = 30;

    @Transactional
    public void createPasswordResetTokenForUser(User user, String baseUrl) {
        try {
            // Xóa các token cũ của user
            tokenRepository.deleteByUserEmail(user.getEmail());

            // Tạo token mới
            String token = UUID.randomUUID().toString();
            LocalDateTime expiryDate = LocalDateTime.now().plusSeconds(TOKEN_EXPIRY_HOURS);

            PasswordResetToken resetToken = new PasswordResetToken(token, user, expiryDate);
            tokenRepository.save(resetToken);

            // Gửi email
            String resetLink = baseUrl + "/reset-password?token=" + token;
            emailService.sendPasswordResetEmail(user.getEmail(), resetLink);
        } catch (Exception e) {
            System.err.println("Lỗi khi tạo token reset password: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public Optional<PasswordResetToken> getToken(String token) {
        return tokenRepository.findByToken(token);
    }

    public boolean validateToken(PasswordResetToken resetToken) {
        return resetToken != null && !resetToken.isUsed() && !resetToken.isExpired();
    }

    @Transactional
    public void markTokenAsUsed(PasswordResetToken resetToken) {
        resetToken.setUsed(true);
        tokenRepository.save(resetToken);
    }
}

