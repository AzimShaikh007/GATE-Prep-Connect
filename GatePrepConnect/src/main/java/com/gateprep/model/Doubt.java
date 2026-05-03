package com.gateprep.model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "doubts")
public class Doubt {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    
    @Column(columnDefinition="TEXT")
    private String description;
    
    private String subject; // e.g., "Computer Science", "Mechanical"
    
    @ManyToOne
    @JoinColumn(name = "student_id")
    private User student;

    @ManyToOne
    @JoinColumn(name = "senior_id", nullable = true)
    private User answeredBy;
    
    @Column(columnDefinition="TEXT")
    private String answerText;
    
    private String status; // "PENDING", "RESOLVED"
    
    private Date createdAt;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "doubt_tags", joinColumns = @JoinColumn(name = "doubt_id"))
    @Column(name = "tag")
    private java.util.Set<String> tags = new java.util.HashSet<>();

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(name = "doubt_upvotes",
            joinColumns = @JoinColumn(name = "doubt_id"),
            inverseJoinColumns = @JoinColumn(name = "user_id"))
    private java.util.Set<User> upvoters = new java.util.HashSet<>();

    private Long duplicateOfId;

    @OneToMany(mappedBy = "doubt", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    @OrderBy("createdAt ASC")
    private java.util.List<Comment> comments = new java.util.ArrayList<>();

    public Doubt() {
        this.createdAt = new Date();
        this.status = "PENDING";
    }

    public java.util.Set<String> getTags() { return tags; }
    public void setTags(java.util.Set<String> tags) { this.tags = tags; }

    public java.util.Set<User> getUpvoters() { return upvoters; }
    public void setUpvoters(java.util.Set<User> upvoters) { this.upvoters = upvoters; }

    public Long getDuplicateOfId() { return duplicateOfId; }
    public void setDuplicateOfId(Long duplicateOfId) { this.duplicateOfId = duplicateOfId; }

    public java.util.List<Comment> getComments() { return comments; }
    public void setComments(java.util.List<Comment> comments) { this.comments = comments; }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public User getStudent() { return student; }
    public void setStudent(User student) { this.student = student; }

    public User getAnsweredBy() { return answeredBy; }
    public void setAnsweredBy(User answeredBy) { this.answeredBy = answeredBy; }

    public String getAnswerText() { return answerText; }
    public void setAnswerText(String answerText) { this.answerText = answerText; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
