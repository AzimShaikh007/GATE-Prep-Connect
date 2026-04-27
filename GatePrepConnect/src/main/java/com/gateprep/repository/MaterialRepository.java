package com.gateprep.repository;

import com.gateprep.model.Material;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface MaterialRepository extends JpaRepository<Material, Long> {
    List<Material> findAllByOrderByUploadedAtDesc();
    List<Material> findBySubjectOrderByUploadedAtDesc(String subject);
}
