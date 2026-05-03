package com.gateprep.service;

import com.gateprep.model.Doubt;
import com.gateprep.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NotificationService {

    @Autowired(required = false)
    private JavaMailSender mailSender;

    @Value("${spring.mail.username:noreply@gateprep.local}")
    private String fromAddress;

    // ── 1. Notify student that their doubt was resolved ─────────────────────

    @Async
    public void sendDoubtResolvedNotification(Doubt doubt) {
        if (mailSender == null) return;
        try {
            SimpleMailMessage msg = new SimpleMailMessage();
            msg.setFrom(fromAddress);
            msg.setTo(doubt.getStudent().getEmail());
            msg.setSubject("[GATE Prep Connect] Your doubt has been resolved ✅");
            msg.setText(
                "Hi " + doubt.getStudent().getName() + ",\n\n" +
                "Great news! Your doubt titled \"" + doubt.getTitle() + "\" has been answered by " +
                doubt.getAnsweredBy().getName() + ".\n\n" +
                "Answer:\n" + doubt.getAnswerText() + "\n\n" +
                "Log in to GATE Prep Connect to view the full discussion and leave feedback.\n\n" +
                "Best regards,\nGATE Prep Connect Team"
            );
            mailSender.send(msg);
        } catch (MailException e) {
            // Log but do not crash the application
            System.err.println("[NotificationService] Failed to send resolved email: " + e.getMessage());
        }
    }

    // ── 2. Send a weekly digest of pending doubts to a senior ───────────────

    @Async
    public void sendWeeklyDigest(User senior, List<Doubt> pendingDoubts) {
        if (mailSender == null || pendingDoubts.isEmpty()) return;
        try {
            StringBuilder body = new StringBuilder();
            body.append("Hi ").append(senior.getName()).append(",\n\n");
            body.append("Here is your weekly summary of unanswered doubts on GATE Prep Connect:\n\n");
            for (int i = 0; i < pendingDoubts.size(); i++) {
                Doubt d = pendingDoubts.get(i);
                body.append(i + 1).append(". [").append(d.getSubject()).append("] ")
                    .append(d.getTitle()).append("\n");
            }
            body.append("\nLog in to help your peers and grow your reputation!\n\n");
            body.append("Best regards,\nGATE Prep Connect Team");

            SimpleMailMessage msg = new SimpleMailMessage();
            msg.setFrom(fromAddress);
            msg.setTo(senior.getEmail());
            msg.setSubject("[GATE Prep Connect] Weekly Digest — " + pendingDoubts.size() + " doubts need your help");
            msg.setText(body.toString());
            mailSender.send(msg);
        } catch (MailException e) {
            System.err.println("[NotificationService] Failed to send digest email: " + e.getMessage());
        }
    }
}
