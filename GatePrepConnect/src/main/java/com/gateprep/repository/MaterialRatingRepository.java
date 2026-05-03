package com.gateprep.repository;

import com.gateprep.model.MaterialRating;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface MaterialRatingRepository extends JpaRepository<MaterialRating, Long> {

    List<MaterialRating> findByMaterialIdOrderByCreatedAtDesc(Long materialId);

    Optional<MaterialRating> findByMaterialIdAndUserId(Long materialId, Long userId);

    /** Average star rating for a material (returns null if no ratings yet) */
    @Query("SELECT AVG(r.stars) FROM MaterialRating r WHERE r.material.id = :materialId")
    Double findAvgStarsByMaterialId(@Param("materialId") Long materialId);

    long countByMaterialId(Long materialId);
}
