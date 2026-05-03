package com.gateprep.repository;

import com.gateprep.model.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findByDoubtIdOrderByCreatedAtAsc(Long doubtId);
}
