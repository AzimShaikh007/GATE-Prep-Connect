package com.gateprep.model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "material_ratings",
       uniqueConstraints = @UniqueConstraint(columnNames = {"material_id", "user_id"}))
public class MaterialRating {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "material_id", nullable = false)
    private Material material;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    /** 1 – 5 stars */
    private Integer stars;

    @Column(columnDefinition = "TEXT")
    private String review;

    private Date createdAt;

    public MaterialRating() {
        this.createdAt = new Date();
    }

    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Material getMaterial() { return material; }
    public void setMaterial(Material material) { this.material = material; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Integer getStars() { return stars; }
    public void setStars(Integer stars) { this.stars = stars; }

    public String getReview() { return review; }
    public void setReview(String review) { this.review = review; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
