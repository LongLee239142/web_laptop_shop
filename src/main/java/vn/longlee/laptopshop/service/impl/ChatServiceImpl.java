package vn.longlee.laptopshop.service.impl;

import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
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

/**
 * Chatbot hiểu câu hỏi của user qua 4 bước:
 * 1) Ngữ cảnh: tin nhắn trước (vd. "macbook") + tin hiện tại ("giá bao nhiêu?") → hiểu đang hỏi giá MacBook.
 * 2) Khoảng giá: regex bắt "dưới X triệu", "từ X đến Y triệu" → gợi ý theo tầm tiền.
 * 3) Thương hiệu: message chứa dell/hp/lenovo/apple/macbook → trả lời theo hãng.
 * 4) Pattern: regex match từ khóa (giá, gaming, bảo hành, giao hàng...) → trả lời cố định.
 * Để bot "biết" thêm cách hỏi: thêm từ đồng nghĩa vào regex hoặc vào normalizeMessage().
 */
@Service
public class ChatServiceImpl implements ChatService {
    private static final Logger logger = LoggerFactory.getLogger(ChatServiceImpl.class);

    /** Pattern nhận diện khoảng giá: dưới X triệu, từ X đến Y, khoảng X */
    private static final Pattern PRICE_UNDER = Pattern.compile("(?i).*dưới\\s*(\\d+)\\s*(triệu|tr|triệu đồng)?.*");
    private static final Pattern PRICE_RANGE = Pattern.compile("(?i).*(?:từ\\s*)?(\\d+)\\s*(?:đến|-|–)\\s*(\\d+)\\s*(triệu|tr)?.*");
    private static final Pattern PRICE_ABOUT = Pattern.compile("(?i).*(?:khoảng|tầm|từ)\\s*(\\d+)\\s*(triệu|tr)?.*");

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

        // Hỏi về giá (nhiều cách hỏi: mấy tiền, đắt không, bao nhiêu... đã chuẩn hóa trong normalizeMessage)
        PATTERNS.put(Pattern.compile("(?i).*(giá|gia|price|bao nhiêu tiền|chi phí|mấy tiền|đắt không).*"),
            "Mỗi dòng laptop có nhiều mức giá khác nhau. Bạn quan tâm đến dòng laptop nào? (Dell, HP, Lenovo,...)");

        // Hỏi về cấu hình
        PATTERNS.put(Pattern.compile("(?i).*(cấu hình|thông số|spec|configuration).*"),
            "Bạn muốn biết cấu hình của dòng máy nào? Tôi có thể tư vấn chi tiết về CPU, RAM, ổ cứng...");

        // Khuyến mãi (có khuyến mãi không, đang sale không...)
        PATTERNS.put(Pattern.compile("(?i).*(khuyến mãi|khuyen mai|giảm giá|giam gia|ưu đãi|sale|có khuyến mãi).*"),
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

        // Cảm ơn, tạm biệt
        PATTERNS.put(Pattern.compile("(?i).*(cảm ơn|cam on|thanks|thank you|cám ơn).*"),
            "Không có gì! Chúc bạn chọn được laptop ưng ý. Nếu cần tư vấn thêm cứ nhắn tôi nhé!");
        PATTERNS.put(Pattern.compile("(?i).*(tạm biệt|tam biet|bye|goodbye|hẹn gặp lại).*"),
            "Tạm biệt! Chúc bạn một ngày tốt lành. Hẹn gặp lại!");

        // Giao hàng, đặt hàng, thanh toán (có ship không, giao bao lâu...)
        PATTERNS.put(Pattern.compile("(?i).*(giao hàng|giao hang|ship|delivery|mất bao lâu|bao lâu có hàng|có ship).*"),
            "Shop giao hàng toàn quốc. Nội thành 1-2 ngày, ngoại thành 2-5 ngày. Miễn phí ship đơn từ 15 triệu!");
        PATTERNS.put(Pattern.compile("(?i).*(đặt hàng|dat hang|mua hàng|mua hang|order|đặt mua).*"),
            "Bạn có thể thêm sản phẩm vào giỏ và thanh toán ngay trên website. Hỗ trợ thanh toán COD, chuyển khoản, VNPay, MoMo.");
        PATTERNS.put(Pattern.compile("(?i).*(thanh toán|thanh toan|payment|trả tiền|tra tien).*"),
            "Shop hỗ trợ: Thanh toán khi nhận hàng (COD), chuyển khoản, VNPay, MoMo. Trả góp 0% qua thẻ tín dụng.");

        // Từ đồng nghĩa: giá rẻ, rẻ, giá tốt
        PATTERNS.put(Pattern.compile("(?i).*(giá rẻ|gia re|rẻ nhất|re nhat|rẻ không|re khong|giá tốt|gia tot|budget).*"),
            "Bạn có ngân sách khoảng bao nhiêu? Tôi gợi ý: dưới 15tr có Lenovo Ideapad, HP Pavilion; 15-25tr có Dell Inspiron, ThinkPad E series.");
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
            String normalized = message.toLowerCase().trim();
            normalized = normalizeMessage(normalized); // Chuẩn hóa từ đồng nghĩa để bot hiểu nhiều cách hỏi

            // Lấy ngữ cảnh: tin nhắn gần nhất của user (để hiểu câu hỏi tiếp theo như "giá bao nhiêu?")
            String contextMessage = null;
            if (user != null) {
                Optional<ChatHistory> last = chatHistoryRepository.findTop1ByUserOrderByTimestampDesc(user);
                contextMessage = last.map(ChatHistory::getUserMessage).orElse(null);
                if (contextMessage != null) {
                    contextMessage = contextMessage.toLowerCase().trim();
                }
            }

            String response = processMessage(normalized, contextMessage);

            ChatHistory chatHistory = new ChatHistory(originalMessage, response, user);
            chatHistoryRepository.save(chatHistory);

            return response;
        } catch (Exception e) {
            logger.error("Lỗi xử lý tin nhắn: {}", message, e);
            return "Xin lỗi, có lỗi xảy ra. Bạn vui lòng thử lại sau nhé!";
        }
    }

    /**
     * Chuẩn hóa câu user: thêm từ khóa "chuẩn" để bot nhận diện đúng intent.
     * Ví dụ: "mấy tiền", "đắt không" → thêm " giá " để pattern "giá" vẫn match.
     */
    private String normalizeMessage(String message) {
        if (message == null || message.isEmpty()) return message;
        String s = " " + message + " ";
        // Giá / tiền
        s = s.replaceAll("(?i)\\bmấy tiền\\b", " giá ");
        s = s.replaceAll("(?i)\\bbao nhiêu tiền\\b", " giá ");
        s = s.replaceAll("(?i)\\bđắt không\\b", " giá ");
        s = s.replaceAll("(?i)\\bcó rẻ không\\b", " giá rẻ ");
        s = s.replaceAll("(?i)\\brẻ không\\b", " giá rẻ ");
        s = s.replaceAll("(?i)\\bcost\\b", " giá ");
        // Khuyến mãi / ship / trả góp / bảo hành
        s = s.replaceAll("(?i)\\bcó khuyến mãi không\\b", " khuyến mãi ");
        s = s.replaceAll("(?i)\\bcó ship không\\b", " giao hàng ");
        s = s.replaceAll("(?i)\\btrả góp được không\\b", " trả góp ");
        s = s.replaceAll("(?i)\\bbảo hành bao lâu\\b", " bảo hành ");
        s = s.replaceAll("(?i)\\bcho hỏi\\b", " ");
        s = s.replaceAll("(?i)\\bcho tôi hỏi\\b", " ");
        s = s.replaceAll("(?i)\\btư vấn giúp\\b", " ");
        return s.trim();
    }

    private String processMessage(String message, String contextMessage) {
        // 1) Ngữ cảnh: câu hỏi follow-up (vd: trước đó hỏi "macbook", giờ hỏi "giá bao nhiêu?")
        if (contextMessage != null && !contextMessage.isEmpty()) {
            String ctxResponse = processContext(message, contextMessage);
            if (ctxResponse != null) {
                return ctxResponse;
            }
        }

        // 2) Nhận diện khoảng giá: "dưới 20 triệu", "từ 15 đến 25 triệu"
        String priceResponse = tryMatchPriceRange(message);
        if (priceResponse != null) {
            return priceResponse;
        }

        // 3) Kiểm tra thương hiệu (kèm từ "giá rẻ" / "rẻ" thì gợi ý theo hãng)
        for (String brand : PRODUCT_INFO.keySet()) {
            if (message.contains(brand)) {
                List<String> products = PRODUCT_INFO.get(brand);
                String base = products.get(RANDOM.nextInt(products.size()));
                if (message.contains("rẻ") || message.contains("re") || message.contains("giá") || message.contains("gia")) {
                    base += " Bạn có thể xem giá và đặt hàng trực tiếp trên website.";
                }
                return base;
            }
        }

        // 4) Kiểm tra các pattern
        for (Map.Entry<Pattern, String> entry : PATTERNS.entrySet()) {
            Matcher matcher = entry.getKey().matcher(message);
            if (matcher.matches()) {
                return entry.getValue();
            }
        }

        return getDefaultResponse();
    }

    /** Gợi ý theo khoảng giá (triệu). */
    private String tryMatchPriceRange(String message) {
        Matcher under = PRICE_UNDER.matcher(message);
        if (under.matches()) {
            int max = Integer.parseInt(under.group(1));
            if (max <= 15) {
                return "Với ngân sách dưới " + max + " triệu, bạn có thể xem Lenovo Ideapad, HP Pavilion, hoặc Dell Inspiron. Đây là các dòng ổn định cho học tập và văn phòng.";
            }
            if (max <= 25) {
                return "Dưới " + max + " triệu có nhiều lựa chọn: Dell Inspiron/Vostro, HP Envy, Lenovo ThinkPad E series, hoặc laptop gaming phổ thông. Bạn ưu tiên văn phòng hay gaming?";
            }
            if (max <= 35) {
                return "Trong tầm dưới " + max + " triệu bạn có thể cân nhắc MacBook Air M1/M2, Dell XPS, HP Spectre, hoặc laptop gaming tầm trung. Bạn cần dùng cho mục đích gì?";
            }
            return "Trên " + max + " triệu shop có nhiều dòng cao cấp: MacBook Pro, Dell XPS 15, gaming RTX 40 series. Bạn muốn tôi gợi ý theo hãng hay theo nhu cầu (đồ họa/gaming/văn phòng)?";
        }

        Matcher range = PRICE_RANGE.matcher(message);
        if (range.matches()) {
            int low = Integer.parseInt(range.group(1));
            int high = Integer.parseInt(range.group(2));
            if (low > high) {
                int t = low; low = high; high = t;
            }
            if (low <= 20 && high <= 25) {
                return "Trong khoảng " + low + "-" + high + " triệu: Lenovo ThinkPad E, Dell Vostro, HP Probook, hoặc laptop gaming RTX 3050. Bạn ưu tiên pin trâu hay hiệu năng gaming?";
            }
            if (low <= 30 && high <= 35) {
                return "Khoảng " + low + "-" + high + " triệu có MacBook Air M1/M2, Dell XPS 13, HP Envy, Lenovo Legion. Bạn cần màn hình lớn hay mỏng nhẹ?";
            }
            return "Khoảng " + low + "-" + high + " triệu có rất nhiều lựa chọn. Bạn đang tìm laptop cho văn phòng, học tập, đồ họa hay gaming?";
        }

        Matcher about = PRICE_ABOUT.matcher(message);
        if (about.matches()) {
            int price = Integer.parseInt(about.group(1));
            return tryMatchPriceRange("dưới " + (price + 5) + " triệu");
        }

        return null;
    }

    /** Xử lý câu hỏi follow-up dựa trên tin nhắn trước (ngữ cảnh). */
    private String processContext(String message, String context) {
        if (context == null) return null;

        // Ngữ cảnh: user vừa hỏi về MacBook/Apple
        if (context.contains("macbook") || context.contains("mac ") || context.contains("apple")) {
            if (message.contains("giá") || message.contains("gia") || message.contains("bao nhiêu") || message.contains("tiền")) {
                return "MacBook có nhiều mức giá: Air M1 từ 22.9tr, Air M2 từ 29.9tr, Pro 14 từ 45.9tr, Pro 16 từ 55tr. Bạn quan tâm model nào?";
            }
            if (message.contains("màu") || message.contains("mau")) {
                return "MacBook có các màu: Bạc, Xám không gian (Starlight/Midnight cho Air M2). Pro thường có Bạc và Xám đen.";
            }
            if (message.contains("pin") || message.contains("pin bao lâu")) {
                return "MacBook M1/M2 pin rất tốt: Air khoảng 15-18 tiếng, Pro 14/16 lên tới 20 tiếng sử dụng thực tế.";
            }
            if (message.contains("có") && (message.contains("không") || message.contains("khong"))) {
                return "Bạn muốn hỏi MacBook còn hàng hay có chương trình gì không? Hiện shop có đủ các dòng Air M1/M2 và Pro 14/16.";
            }
        }

        // Ngữ cảnh: Dell, HP, Lenovo
        if (context.contains("dell") || context.contains("hp") || context.contains("lenovo")) {
            if (message.contains("giá") || message.contains("gia") || message.contains("bao nhiêu") || message.contains("tiền")) {
                String brand = context.contains("dell") ? "Dell" : context.contains("hp") ? "HP" : "Lenovo";
                return brand + " có nhiều phân khúc: từ 12-15tr (Văn phòng), 18-25tr (Cao cấp), 25tr+ (XPS/Spectre/ThinkPad X). Bạn cần tầm giá nào?";
            }
        }

        // Ngữ cảnh: gaming
        if (context.contains("gaming") || context.contains("game")) {
            if (message.contains("giá") || message.contains("gia") || message.contains("bao nhiêu") || message.contains("tiền")) {
                return "Laptop gaming: phổ thông (RTX 3050) 16-22tr, tầm trung (RTX 4060) 25-35tr, cao cấp (RTX 4070+) 38tr trở lên. Bạn chơi game gì là chủ yếu?";
            }
            if (message.contains("card") || message.contains("gpu") || message.contains("vga")) {
                return "Laptop gaming thường dùng card NVIDIA RTX (3050, 4060, 4070...) hoặc AMD Radeon RX. Bạn có ngân sách khoảng bao nhiêu?";
            }
        }

        // Câu hỏi ngắn: "còn không?", "có không?", "thế?"
        if (message.matches("(?i).*(còn không|con khong|có không|co khong|thế|the|sao|bao nhiêu)\\s*\\??\\s*$")) {
            if (context.contains("giá") || context.contains("gia") || context.contains("khuyến mãi")) {
                return "Bạn có thể xem giá và khuyến mãi hiện tại trực tiếp trên từng sản phẩm tại trang chủ. Bạn quan tâm hãng nào để tôi gợi ý cụ thể?";
            }
        }

        return null;
    }

    private String getDefaultResponse() {
        List<String> defaultResponses = Arrays.asList(
            "Bạn có thể nói rõ hơn được không? Tôi có thể tư vấn về giá cả, cấu hình, khuyến mãi, giao hàng...",
            "Bạn đang tìm laptop cho mục đích gì? (Gaming / Văn phòng / Đồ họa / Học tập) hoặc cho tôi biết ngân sách (vd: dưới 20 triệu)?",
            "Bạn quan tâm hãng nào? Dell, HP, Lenovo, MacBook... Hoặc nói \"giá rẻ\", \"gaming\", \"văn phòng\" để tôi gợi ý.",
            "Tôi có thể giúp bạn: so sánh giá, gợi ý theo ngân sách, tư vấn bảo hành/trả góp. Bạn cần hỗ trợ phần nào?"
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
