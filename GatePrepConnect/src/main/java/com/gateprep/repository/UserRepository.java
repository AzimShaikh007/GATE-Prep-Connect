package com.gateprep.repository;

import com.gateprep.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByEmail(String email);
    List<User> findAllByOrderByNameAsc();
    List<User> findByRoleOrderByReputationDesc(String role);
}
