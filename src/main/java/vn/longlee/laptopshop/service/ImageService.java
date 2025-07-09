package vn.longlee.laptopshop.service;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import org.springframework.stereotype.Service;

@Service
public class ImageService {

    public boolean deleteImage(String fileName, String targetFolder) {
        String directory = "/resources/images" + targetFolder;
        Path filePath = Paths.get(directory, fileName);

        try {
            Files.delete(filePath);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
