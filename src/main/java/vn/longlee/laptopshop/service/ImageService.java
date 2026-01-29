package vn.longlee.laptopshop.service;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.stereotype.Service;

import jakarta.servlet.ServletContext;

@Service
public class ImageService {
    private final ServletContext servletContext;

    public ImageService(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    /**
     * Xóa file ảnh trong thư mục (cùng vị trí lưu với UploadService).
     *
     * @param fileName     tên file (vd: 1234567890-avatar.png)
     * @param targetFolder tên thư mục (vd: "avatar")
     * @return true nếu xóa thành công hoặc file không tồn tại
     */
    public boolean deleteImage(String fileName, String targetFolder) {
        if (fileName == null || fileName.isEmpty()) {
            return true;
        }
        String rootPath = servletContext.getRealPath("/resources/images");
        if (rootPath == null) {
            return false;
        }
        File dir = new File(rootPath + File.separator + targetFolder);
        Path filePath = Paths.get(dir.getAbsolutePath(), fileName);
        try {
            if (Files.exists(filePath)) {
                Files.delete(filePath);
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
