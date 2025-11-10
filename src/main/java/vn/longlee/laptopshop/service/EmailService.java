package vn.longlee.laptopshop.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    public void sendPasswordResetEmail(String to, String resetLink) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(to);
            message.setSubject("Khôi phục mật khẩu - Laptopshop");
            message.setText("""
                    Xin chào,

                    Bạn đã yêu cầu khôi phục mật khẩu cho tài khoản của mình.

                    Vui lòng nhấp vào liên kết sau để đặt lại mật khẩu:
                    %s

                    Liên kết này sẽ hết hạn sau 1 giờ.

                    Nếu bạn không yêu cầu khôi phục mật khẩu, vui lòng bỏ qua email này.

                    Trân trọng,
                    Đội ngũ Laptopshop
                    """.formatted(resetLink));
            
            mailSender.send(message);
            System.out.println("Email đã được gửi thành công đến: " + to);
        } catch (MailException e) {
            System.err.println("Lỗi khi gửi email: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Không thể gửi email. Vui lòng thử lại sau.", e);
        }
    }
}

