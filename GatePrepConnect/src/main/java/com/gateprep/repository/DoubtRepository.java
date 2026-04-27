package com.gateprep.repository;

import com.gateprep.model.Doubt;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface DoubtRepository extends JpaRepository<Doubt, Long> {
    List<Doubt> findByStudentIdOrderByCreatedAtDesc(Long studentId);
    List<Doubt> findBySubjectOrderByCreatedAtDesc(String subject);
    List<Doubt> findAllByOrderByCreatedAtDesc();
}
