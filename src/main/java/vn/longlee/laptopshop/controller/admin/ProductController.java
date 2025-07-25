package vn.longlee.laptopshop.controller.admin;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.Valid;
import vn.longlee.laptopshop.domain.Product;
import vn.longlee.laptopshop.service.ProductService;
import vn.longlee.laptopshop.service.UploadService;

@Controller
public class ProductController {
    private final ProductService productService;
    private final UploadService uploadService;

    public ProductController(ProductService productService, UploadService uploadService) {
        this.productService = productService;
        this.uploadService = uploadService;
    }

    @GetMapping("/admin/product")
    public String getUserPage(Model model,
            @RequestParam("page") Optional<String> pageOptional,
            @RequestParam("name") Optional<String> nameOptional) {
        int page = 1;
        try {
            if (pageOptional.isPresent()) {
                page = Integer.valueOf(pageOptional.get());
            } else {
                page = 1;
            }

        } catch (Exception e) {
            // TODO: handle exception
        }
        Pageable pageable = PageRequest.of(page - 1, 5);
        Page<Product> products = this.productService.getAllProducts(pageable);
        List<Product> listProducts = products.getContent();
        model.addAttribute("product_1", listProducts);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPage", products.getTotalPages());
        return "admin/product/show";
    }

    @GetMapping("/admin/product/create") // GET
    public String getCreateUserPage(Model model) {
        model.addAttribute("newProduct", new Product());
        return "admin/product/create";
    }

    @PostMapping(value = "/admin/product/create")
    public String createProductPage(Model model,
            @ModelAttribute("newProduct") @Valid Product hoidanit,
            BindingResult newProductBindingResult,
            @RequestParam("hoidanitFileProduct") MultipartFile file) {
        List<FieldError> errors = newProductBindingResult.getFieldErrors();
        for (FieldError error : errors) {
            System.out.println(">>>>>>>" + error.getField() + " - " + error.getDefaultMessage());
        }
        // validate
        if (newProductBindingResult.hasErrors()) {
            return "/admin/product/create";
        }
        String imageProduct = this.uploadService.handleSaveUploadFile(file, "imageProduct");
        hoidanit.setImage(imageProduct);
        this.productService.handleSaveProduct(hoidanit);
        // save
        return "redirect:/admin/product";
    }

    @GetMapping("/admin/product/delete/{id}")
    public String getDeleteProductPage(Model model, @PathVariable long id) {
        model.addAttribute("id", id);
        model.addAttribute("newProduct", new Product());
        return "admin/product/delete";
    }

    @PostMapping("/admin/product/delete")
    public String postDeleteUser(Model model, @ModelAttribute("newProduct") Product mrLee) {
        this.productService.deleteAProduct(mrLee.getId());
        return "redirect:/admin/product";
    }

    @GetMapping("/admin/product/{id}")
    public String getUserDetailPage(Model model, @PathVariable long id) {
        Product product = this.productService.getProductById(id);
        model.addAttribute("product", product);
        model.addAttribute("id", id);
        return "admin/product/detail";
    }

    @GetMapping("/admin/product/update/{id}") // GET
    public String getUpdateUserPage(Model model, @PathVariable long id) {
        Product currentProduct = this.productService.getProductById(id);
        model.addAttribute("newProduct", currentProduct);
        return "admin/product/update";
    }

    @PostMapping("/admin/product/update")
    public String postUpdateUser(Model model, @ModelAttribute("newProduct") @Valid Product hoidanit,
            BindingResult newProductBindingResult,
            @RequestParam("hoidanitFileProduct") MultipartFile file) {
        if (newProductBindingResult.hasErrors()) {
            return "admin/product/update";
        }

        Product currentProduct = this.productService.getProductById(hoidanit.getId());
        if (currentProduct != null) {
            if (!file.isEmpty()) {
                String img = this.uploadService.handleSaveUploadFile(file, "imageProduct");
                currentProduct.setImage(img);
            }
            currentProduct.setPrice(hoidanit.getPrice());
            currentProduct.setFactory(hoidanit.getFactory());
            currentProduct.setName(hoidanit.getName());
            currentProduct.setDetailDesc(hoidanit.getDetailDesc());
            currentProduct.setQuantity(hoidanit.getQuantity());
            currentProduct.setTarget(hoidanit.getTarget());
            currentProduct.setSold(hoidanit.getSold());
            currentProduct.setShortDesc(hoidanit.getShortDesc());

            // bug here
            this.productService.handleSaveProduct(currentProduct);
        }
        return "redirect:/admin/product";
    }
}