package com.gateprep.repository;

import com.gateprep.model.Material;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface MaterialRepository extends JpaRepository<Material, Long> {
    List<Material> findAllByOrderByUploadedAtDesc();
    List<Material> findBySubjectOrderByUploadedAtDesc(String subject);
    
    long countByUploadedById(Long seniorId);
    List<Material> findByUploadedByIdOrderByUploadedAtDesc(Long seniorId);

    @org.springframework.data.jpa.repository.Query("SELECT m FROM Material m WHERE " +
           "(:query IS NULL OR :query = '' OR LOWER(m.title) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(m.description) LIKE LOWER(CONCAT('%', :query, '%'))) AND " +
           "(:subject IS NULL OR :subject = '' OR m.subject = :subject) " +
           "ORDER BY m.uploadedAt DESC")
    List<Material> searchMaterials(@org.springframework.data.repository.query.Param("query") String query, 
                                   @org.springframework.data.repository.query.Param("subject") String subject);
}
