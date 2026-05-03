package com.gateprep.repository;

import com.gateprep.model.Doubt;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface DoubtRepository extends JpaRepository<Doubt, Long> {
    List<Doubt> findByStudentIdOrderByCreatedAtDesc(Long studentId);
    List<Doubt> findBySubjectOrderByCreatedAtDesc(String subject);
    List<Doubt> findAllByOrderByCreatedAtDesc();
    
    long countByAnsweredById(Long seniorId);
    List<Doubt> findByAnsweredByIdOrderByCreatedAtDesc(Long seniorId);

    @org.springframework.data.jpa.repository.Query("SELECT d FROM Doubt d WHERE " +
           "d.student.id = :studentId AND " +
           "(:query IS NULL OR :query = '' OR LOWER(d.title) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(d.description) LIKE LOWER(CONCAT('%', :query, '%'))) AND " +
           "(:subject IS NULL OR :subject = '' OR d.subject = :subject) AND " +
           "(:status IS NULL OR :status = '' OR d.status = :status) " +
           "ORDER BY d.createdAt DESC")
    List<Doubt> searchMyDoubts(@org.springframework.data.repository.query.Param("studentId") Long studentId, 
                               @org.springframework.data.repository.query.Param("query") String query, 
                               @org.springframework.data.repository.query.Param("subject") String subject, 
                               @org.springframework.data.repository.query.Param("status") String status);

    @org.springframework.data.jpa.repository.Query("SELECT d FROM Doubt d WHERE " +
           "(:query IS NULL OR :query = '' OR LOWER(d.title) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(d.description) LIKE LOWER(CONCAT('%', :query, '%'))) AND " +
           "(:subject IS NULL OR :subject = '' OR d.subject = :subject) AND " +
           "(:status IS NULL OR :status = '' OR d.status = :status) " +
           "ORDER BY d.createdAt DESC")
    List<Doubt> searchDoubts(@org.springframework.data.repository.query.Param("query") String query, 
                             @org.springframework.data.repository.query.Param("subject") String subject, 
                             @org.springframework.data.repository.query.Param("status") String status);
}
