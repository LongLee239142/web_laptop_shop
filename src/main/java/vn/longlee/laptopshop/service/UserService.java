package vn.longlee.laptopshop.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import vn.longlee.laptopshop.domain.Role;
import vn.longlee.laptopshop.domain.User;
import vn.longlee.laptopshop.domain.dto.CreateUserDTO;
import vn.longlee.laptopshop.repository.RoleRepository;
import vn.longlee.laptopshop.repository.UserRepository;

@Service
public class UserService {
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;

    public UserService(UserRepository userRepository,
            RoleRepository roleRepository) {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
    }

    public Page<User> getAllUsers(Pageable page) {
        return this.userRepository.findAll(page);
    }

    public List<User> getAllUsers() {
        return this.userRepository.findAll();
    }

    public List<User> getAllUsersByEmail(String email) {
        return this.userRepository.findOneByEmail(email);
    }

    public User handleSaveUser(User user) {
        User mrLong = this.userRepository.save(user);
        System.out.println(mrLong);
        return mrLong;
    }

    public User getUserById(long id) {
        return this.userRepository.findById(id);
    }

    public void deleteAUser(long id) {
        this.userRepository.deleteById(id);
    }

    public Role getRoleByName(String name) {
        return this.roleRepository.findByName(name);
    }

    public boolean checkEmailExist(String email) {
        return this.userRepository.existsByEmail(email);
    }

    public User getUserByEmail(String email) {
        return this.userRepository.findByEmail(email);
    }

    /**
     * Convert CreateUserDTO to User entity
     * This method handles both admin and client user creation
     * 
     * @param dto CreateUserDTO containing user information
     * @return User entity ready to be saved
     */
    public User createUserDTOtoUser(CreateUserDTO dto) {
        User user = new User();
        
        // Set fullName: use fullName if provided, otherwise combine firstName + lastName
        if (dto.getFullName() != null && !dto.getFullName().trim().isEmpty()) {
            user.setFullName(dto.getFullName());
        } else if (dto.getFirstName() != null && !dto.getFirstName().trim().isEmpty()) {
            String lastName = dto.getLastName() != null ? dto.getLastName() : "";
            user.setFullName((dto.getFirstName() + " " + lastName).trim());
        }
        
        user.setEmail(dto.getEmail());
        user.setPassword(dto.getPassword()); // Will be hashed by controller
        user.setAddress(dto.getAddress());
        user.setPhone(dto.getPhone());
        
        return user;
    }
}
