package vn.longlee.laptopshop.service.impl;

import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import vn.longlee.laptopshop.domain.User;
import vn.longlee.laptopshop.entity.ChatHistory;
import vn.longlee.laptopshop.repository.ChatHistoryRepository;
import vn.longlee.laptopshop.service.ChatService;

@Service
public class ChatServiceImpl implements ChatService {
    private static final Logger logger = LoggerFactory.getLogger(ChatServiceImpl.class);

    @Autowired
    private ChatHistoryRepository chatHistoryRepository;

    private static final Map<Pattern, String> PATTERNS = new LinkedHashMap<>();
    private static final Map<String, List<String>> PRODUCT_INFO = new HashMap<>();
    private static final Random RANDOM = new Random();


    static {
        // Khởi tạo thông tin sản phẩm
        initializeProductInfo();
        
        // Khởi tạo các pattern
        initializePatterns();
    }

    private static void initializeProductInfo() {
        // Dell
        PRODUCT_INFO.put("dell", Arrays.asList(
            "Dell XPS 13: Laptop cao cấp, màn hình 13 inch, pin trên 10 tiếng",
            "Dell Latitude: Dòng laptop doanh nhân bền bỉ, bảo mật cao",
            "Dell Gaming: Hiệu năng mạnh mẽ, tản nhiệt tốt"
        ));

        // HP
        PRODUCT_INFO.put("hp", Arrays.asList(
            "HP Spectre: Thiết kế sang trọng, hiệu năng ổn định",
            "HP Envy: Cân bằng giữa giá thành và tính năng",
            "HP Pavilion: Phù hợp học tập, văn phòng"
        ));

        // Lenovo
        PRODUCT_INFO.put("lenovo", Arrays.asList(
            "Lenovo ThinkPad: Bền bỉ, bàn phím tốt nhất phân khúc",
            "Lenovo Legion: Gaming cao cấp, tản nhiệt hiệu quả",
            "Lenovo Ideapad: Giá rẻ, phù hợp sinh viên"
        ));

        // Apple
        PRODUCT_INFO.put("apple", Arrays.asList(
            "MacBook Air M1: Mỏng nhẹ, pin trên 15 tiếng, hiệu năng cao",
            "MacBook Air M2: Thiết kế mới, màn hình Liquid Retina, hiệu năng vượt trội",
            "MacBook Pro 14: Chip M2 Pro/Max, màn hình Mini LED, dành cho người dùng chuyên nghiệp",
            "MacBook Pro 16: Màn hình lớn, hiệu năng cao nhất dòng Mac, tản nhiệt tốt"
        ));

        PRODUCT_INFO.put("macbook", PRODUCT_INFO.get("apple")); // Alias for Apple products
    }

    private static void initializePatterns() {
        // Chào hỏi
        PATTERNS.put(Pattern.compile("(?i).*(xin chào|hello|hi|hey|chào).*"), 
            "Xin chào! Tôi có thể giúp gì cho bạn về laptop không?");

        // Hỏi về giá
        PATTERNS.put(Pattern.compile("(?i).*(giá|gia|price|bao nhiêu tiền|chi phí).*"),
            "Mỗi dòng laptop có nhiều mức giá khác nhau. Bạn quan tâm đến dòng laptop nào? (Dell, HP, Lenovo,...)");

        // Hỏi về cấu hình
        PATTERNS.put(Pattern.compile("(?i).*(cấu hình|thông số|spec|configuration).*"),
            "Bạn muốn biết cấu hình của dòng máy nào? Tôi có thể tư vấn chi tiết về CPU, RAM, ổ cứng...");

        // Khuyến mãi
        PATTERNS.put(Pattern.compile("(?i).*(khuyến mãi|khuyen mai|giảm giá|giam gia|ưu đãi|sale).*"),
            "Hiện tại shop đang có chương trình giảm giá 10% cho tất cả laptop, và tặng kèm chuột + balo khi mua laptop gaming!");

        // Bảo hành
        PATTERNS.put(Pattern.compile("(?i).*(bảo hành|bao hanh|warranty).*"),
            "Tất cả laptop tại shop đều được bảo hành chính hãng 12 tháng và 1 đổi 1 trong 30 ngày đầu!");

        // Trả góp
        PATTERNS.put(Pattern.compile("(?i).*(trả góp|tra gop|góp|gop|installment).*"),
            "Shop hỗ trợ trả góp 0% lãi suất qua thẻ tín dụng hoặc công ty tài chính với thời hạn từ 6-12 tháng!");

        // Gaming
        PATTERNS.put(Pattern.compile("(?i).*(gaming|game|chơi game).*"),
            "Shop có nhiều dòng laptop gaming từ phổ thông đến cao cấp. Bạn có ngân sách khoảng bao nhiêu?");

        // Văn phòng
        PATTERNS.put(Pattern.compile("(?i).*(văn phòng|van phong|học tập|hoc tap|làm việc|lam viec).*"),
            "Với nhu cầu văn phòng, học tập, tôi recommend các dòng laptop như Dell Latitude, HP Probook hoặc Lenovo ThinkPad.");

        // Thiết kế đồ họa
        PATTERNS.put(Pattern.compile("(?i).*(thiết kế|thiet ke|đồ họa|do hoa|design|photoshop).*"),
            "Cho công việc thiết kế, tôi gợi ý các dòng laptop có màn hình đẹp như Dell XPS, HP Envy hoặc MacBook Pro.");

        // Apple/MacBook specific patterns
        PATTERNS.put(Pattern.compile("(?i).*(macbook|mac book|mac).*"),
            "MacBook là dòng laptop cao cấp của Apple, nổi tiếng với hiệu năng mạnh mẽ và thời lượng pin tốt. Bạn quan tâm đến model nào?");

        PATTERNS.put(Pattern.compile("(?i).*(m1|m2|apple silicon).*"),
            "Chip M1/M2 là bộ vi xử lý do Apple tự phát triển, mang lại hiệu năng cao và tiết kiệm pin. MacBook M1 có giá từ 22.9tr, M2 từ 29.9tr.");

        PATTERNS.put(Pattern.compile("(?i).*(macos|mac os|hệ điều hành mac).*"),
            "MacOS là hệ điều hành độc quyền của Apple, tối ưu cho MacBook, tích hợp tốt với iPhone/iPad và các thiết bị Apple khác.");

        PATTERNS.put(Pattern.compile("(?i).*(air|macbook air).*"),
            "MacBook Air là dòng laptop mỏng nhẹ của Apple, phù hợp cho di chuyển, học tập và làm việc. Hiện có 2 phiên bản M1 và M2.");

        PATTERNS.put(Pattern.compile("(?i).*(pro|macbook pro).*"),
            "MacBook Pro là dòng cao cấp nhất của Apple, có màn hình Mini LED, hiệu năng mạnh mẽ, phù hợp cho công việc chuyên nghiệp.");

        PATTERNS.put(Pattern.compile("(?i).*(final cut|logic pro|xcode|phần mềm mac).*"),
            "MacBook hỗ trợ các phần mềm chuyên nghiệp như Final Cut Pro, Logic Pro, Xcode... Đặc biệt tối ưu cho công việc sáng tạo.");

        PATTERNS.put(Pattern.compile("(?i).*(touchbar|touch bar|touch id|vân tay mac).*"),
            "MacBook Pro có Touch ID để mở máy bằng vân tay. Các model Pro 14/16 inch mới đã bỏ Touch Bar, thay bằng phím chức năng thường.");

        PATTERNS.put(Pattern.compile("(?i).*(pin macbook|pin mac|dung lượng pin|thời lượng pin mac).*"),
            "MacBook với chip M1/M2 có thời lượng pin rất tốt: Air M1/M2 khoảng 15-18 tiếng, Pro 14/16 inch lên tới 20 tiếng sử dụng.");

        PATTERNS.put(Pattern.compile("(?i).*(windows|cài windows|boot camp|parallels).*mac.*"),
            "MacBook M1/M2 có thể chạy Windows thông qua phần mềm Parallels Desktop hoặc CrossOver, nhưng không hỗ trợ Boot Camp như Intel Mac.");

        PATTERNS.put(Pattern.compile("(?i).*(apple care|bảo hành apple|bao hanh apple).*"),
            "MacBook được bảo hành 12 tháng theo tiêu chuẩn Apple. Bạn có thể mua thêm AppleCare+ để được bảo hành 3 năm và hỗ trợ sửa chữa tốt hơn.");
    }

    @Override
    public String getReply(String message) {
        return getReply(message, null);
    }

    @Override
    public String getReply(String message, User user) {
        if (message == null || message.trim().isEmpty()) {
            return "Xin lỗi, tôi không nhận được tin nhắn của bạn.";
        }

        try {
            String originalMessage = message;
            message = message.toLowerCase().trim();
            String response = processMessage(message);
            
            // Save chat history to database với user
            ChatHistory chatHistory = new ChatHistory(originalMessage, response, user);
            chatHistoryRepository.save(chatHistory);
            
            return response;
        } catch (Exception e) {
            logger.error("Lỗi xử lý tin nhắn: {}", message, e);
            return "Xin lỗi, có lỗi xảy ra. Bạn vui lòng thử lại sau nhé!";
        }
    }

    private String processMessage(String message) {
        // Kiểm tra thương hiệu
        for (String brand : PRODUCT_INFO.keySet()) {
            if (message.contains(brand)) {
                List<String> products = PRODUCT_INFO.get(brand);
                return products.get(RANDOM.nextInt(products.size()));
            }
        }

        // Kiểm tra các pattern
        for (Map.Entry<Pattern, String> entry : PATTERNS.entrySet()) {
            Matcher matcher = entry.getKey().matcher(message);
            if (matcher.matches()) {
                return entry.getValue();
            }
        }

        return getDefaultResponse();
    }

    private String processContext(String message, String context) {
        // Xử lý câu hỏi dựa trên ngữ cảnh trước đó
        if (context.contains("macbook") || context.contains("mac")) {
            if (message.contains("giá")) {
                return "MacBook có nhiều mức giá khác nhau: Air M1 từ 22.9tr, Air M2 từ 29.9tr, Pro 14 từ 45.9tr.";
            }
            if (message.contains("màu")) {
                return "MacBook có các màu: Bạc, Xám không gian, Vàng (Air), Midnight (Air M2).";
            }
        }
        
        if (context.contains("gaming")) {
            if (message.contains("giá")) {
                return "Laptop gaming có nhiều mức giá: Phổ thông 16-25tr, Cao cấp 25-45tr, Premium trên 45tr.";
            }
            if (message.contains("card") || message.contains("gpu")) {
                return "Laptop gaming thường dùng card NVIDIA RTX series hoặc AMD Radeon RX series.";
            }
        }

        return null;
    }

    private String getDefaultResponse() {
        List<String> defaultResponses = Arrays.asList(
            "Bạn có thể nói rõ hơn được không? Tôi có thể tư vấn về giá cả, cấu hình, khuyến mãi...",
            "Tôi chưa hiểu rõ ý bạn. Bạn cần tư vấn về laptop hãng nào?",
            "Bạn cần tìm laptop cho mục đích gì? Gaming, văn phòng hay đồ họa?",
            "Tôi có thể giúp bạn tìm laptop phù hợp với nhu cầu và ngân sách. Bạn cần tư vấn cụ thể hơn không?"
        );
        return defaultResponses.get(RANDOM.nextInt(defaultResponses.size()));
    }

    public void addPattern(String regex, String response) {
        PATTERNS.put(Pattern.compile(regex), response);
    }

    public void addProductInfo(String brand, List<String> products) {
        PRODUCT_INFO.put(brand.toLowerCase(), products);
    }

    @Override
    public List<ChatHistory> getChatHistory() {
        return chatHistoryRepository.findAllOrderByTimestampDesc();
    }

    @Override
    public List<ChatHistory> getChatHistoryByUser(User user) {
        if (user == null) {
            return List.of();
        }
        return chatHistoryRepository.findByUserOrderByTimestampAsc(user);
    }

    @Override
    public void deleteChatHistoryByUser(User user) {
        if (user != null) {
            chatHistoryRepository.deleteByUser(user);
        }
    }
}
