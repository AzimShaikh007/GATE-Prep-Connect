package com.gateprep.model;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "comments")
public class Comment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition="TEXT")
    private String text;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "doubt_id")
    private Doubt doubt;

    private Date createdAt;

    public Comment() {
        this.createdAt = new Date();
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getText() { return text; }
    public void setText(String text) { this.text = text; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Doubt getDoubt() { return doubt; }
    public void setDoubt(Doubt doubt) { this.doubt = doubt; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
