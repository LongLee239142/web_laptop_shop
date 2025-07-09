package vn.longlee.laptopshop.domain.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import vn.longlee.laptopshop.service.validator.RegisterChecked;

@RegisterChecked
public class RegisterDTO {

    @Size(min = 3, message = "FirstName must have a minimum of 3 characters ")
    private String firstName;

    private String lastName;

    @Email(message = "Email is not valid", regexp = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")
    private String email;

    private String password;

    // @StrongPassword
    @Size(min = 3, message = "Password must have a minimum of 3 characters ")
    private String confirmPassword;

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getConfirmPassword() {
        return confirmPassword;
    }

    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }

}
