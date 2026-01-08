package vn.longlee.laptopshop.service.validator;

import org.springframework.stereotype.Service;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import vn.longlee.laptopshop.domain.dto.CreateUserDTO;
import vn.longlee.laptopshop.service.UserService;

@Service
public class CreateUserValidator implements ConstraintValidator<CreateUserChecked, CreateUserDTO> {

    public final UserService userService;

    public CreateUserValidator(UserService userService) {
        this.userService = userService;
    }

    @Override
    public boolean isValid(CreateUserDTO dto, ConstraintValidatorContext context) {
        boolean valid = true;

        // Check if password fields match
        if (dto.getPassword() != null && dto.getConfirmPassword() != null 
            && !dto.getPassword().equals(dto.getConfirmPassword())) {
            context.buildConstraintViolationWithTemplate("Passwords must match")
                    .addPropertyNode("confirmPassword")
                    .addConstraintViolation()
                    .disableDefaultConstraintViolation();
            valid = false;
        }

        // Check email existence
        if (dto.getEmail() != null && this.userService.checkEmailExist(dto.getEmail())) {
            context.buildConstraintViolationWithTemplate("Email has existed.")
                    .addPropertyNode("email")
                    .addConstraintViolation()
                    .disableDefaultConstraintViolation();
            valid = false;
        }

        // Validate that either fullName or (firstName + lastName) is provided
        boolean hasFullName = dto.getFullName() != null && !dto.getFullName().trim().isEmpty();
        boolean hasFirstName = dto.getFirstName() != null && !dto.getFirstName().trim().isEmpty();
        
        if (!hasFullName && !hasFirstName) {
            context.buildConstraintViolationWithTemplate("Either fullName or firstName must be provided")
                    .addPropertyNode("fullName")
                    .addConstraintViolation()
                    .disableDefaultConstraintViolation();
            valid = false;
        }

        // Validate fullName length if provided
        if (hasFullName && dto.getFullName().trim().length() < 2) {
            context.buildConstraintViolationWithTemplate("Full Name must be more than 2 characters")
                    .addPropertyNode("fullName")
                    .addConstraintViolation()
                    .disableDefaultConstraintViolation();
            valid = false;
        }

        // Validate firstName length if provided
        if (hasFirstName && dto.getFirstName().trim().length() < 2) {
            context.buildConstraintViolationWithTemplate("FirstName must have a minimum of 2 characters")
                    .addPropertyNode("firstName")
                    .addConstraintViolation()
                    .disableDefaultConstraintViolation();
            valid = false;
        }

        // Validate phone format if provided
        if (dto.getPhone() != null && !dto.getPhone().trim().isEmpty()) {
            String phonePattern = "^0\\d{9,10}$";
            if (!dto.getPhone().matches(phonePattern)) {
                context.buildConstraintViolationWithTemplate("Invalid phone number")
                        .addPropertyNode("phone")
                        .addConstraintViolation()
                        .disableDefaultConstraintViolation();
                valid = false;
            }
        }

        // Validate address if provided
        if (dto.getAddress() != null && dto.getAddress().trim().isEmpty()) {
            context.buildConstraintViolationWithTemplate("Invalid address")
                    .addPropertyNode("address")
                    .addConstraintViolation()
                    .disableDefaultConstraintViolation();
            valid = false;
        }

        return valid;
    }
}

