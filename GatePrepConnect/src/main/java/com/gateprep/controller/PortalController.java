package com.gateprep.controller;

import com.gateprep.model.Comment;
import com.gateprep.model.Doubt;
import com.gateprep.model.Material;
import com.gateprep.model.User;
import com.gateprep.repository.CommentRepository;
import com.gateprep.repository.DoubtRepository;
import com.gateprep.repository.MaterialRepository;
import com.gateprep.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
public class PortalController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DoubtRepository doubtRepository;

    @Autowired
    private MaterialRepository materialRepository;

    @Autowired
    private CommentRepository commentRepository;

    // --- Authentication --- //

    @GetMapping("/")
    public String index(HttpSession session) {
        if (session.getAttribute("user") != null) {
            return "redirect:/dashboard";
        }
        return "login";
    }

    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute User user, Model model) {
        if (userRepository.findByEmail(user.getEmail()) != null) {
            model.addAttribute("error", "Email already exists");
            return "register";
        } 
        userRepository.save(user);
        model.addAttribute("success", "Registration successful. Please login.");
        return "login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email, @RequestParam String password, HttpSession session, Model model) {
        User user = userRepository.findByEmail(email);
        if (user != null && user.getPassword().equals(password)) {
            session.setAttribute("user", user);
            return "redirect:/dashboard";
        }
        model.addAttribute("error", "Invalid credentials");
        return "login";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    // --- Dashboard & Features --- //

    @GetMapping("/dashboard")
    public String dashboard(@RequestParam(required = false) String query,
                            @RequestParam(required = false) String subject,
                            @RequestParam(required = false) String status,
                            HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/";

        // Community feed: all users can see all doubts and comment on them
        List<Doubt> allDoubts = doubtRepository.searchDoubts(query, subject, status);
        model.addAttribute("allDoubts", allDoubts);

        // Students also get their personal "My Doubts" panel
        if ("STUDENT".equals(user.getRole())) {
            List<Doubt> myDoubts = doubtRepository.searchMyDoubts(user.getId(), query, subject, status);
            model.addAttribute("myDoubts", myDoubts);
        }

        model.addAttribute("query", query);
        model.addAttribute("subject", subject);
        model.addAttribute("status", status);

        return "dashboard";
    }

    @GetMapping("/materials")
    public String materials(@RequestParam(required = false) String query,
                            @RequestParam(required = false) String subject,
                            HttpSession session, Model model) {
        if (session.getAttribute("user") == null) return "redirect:/";
        
        List<Material> materials = materialRepository.searchMaterials(query, subject);
        model.addAttribute("materials", materials);
        model.addAttribute("query", query);
        model.addAttribute("subject", subject);
        
        return "materials";
    }

    @PostMapping("/ask-doubt")
    public String askDoubt(@ModelAttribute Doubt doubt,
                           @RequestParam(value = "tagsInput", required = false) String tagsInput,
                           HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"STUDENT".equals(user.getRole())) return "redirect:/";

        doubt.setStudent(user);

        // Parse comma/space-separated tags
        if (tagsInput != null && !tagsInput.isBlank()) {
            Set<String> tags = Arrays.stream(tagsInput.split("[,\\s]+"))
                    .map(String::trim)
                    .filter(t -> !t.isEmpty())
                    .map(t -> t.startsWith("#") ? t : "#" + t)
                    .collect(Collectors.toCollection(HashSet::new));
            doubt.setTags(tags);
        }

        doubtRepository.save(doubt);
        return "redirect:/dashboard";
    }

    @PostMapping("/answer-doubt")
    public String answerDoubt(@RequestParam Long doubtId, @RequestParam String answerText, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"SENIOR".equals(user.getRole())) return "redirect:/";

        Doubt doubt = doubtRepository.findById(doubtId).orElse(null);
        if (doubt != null) {
            doubt.setAnswerText(answerText);
            doubt.setAnsweredBy(user);
            doubt.setStatus("RESOLVED");
            doubtRepository.save(doubt);
        }
        return "redirect:/dashboard";
    }

    // --- Phase 2: Comment on a Doubt --- //

    @PostMapping("/add-comment")
    public String addComment(@RequestParam Long doubtId,
                             @RequestParam String text,
                             HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/";

        Doubt doubt = doubtRepository.findById(doubtId).orElse(null);
        if (doubt != null && !text.isBlank()) {
            Comment comment = new Comment();
            comment.setText(text);
            comment.setUser(user);
            comment.setDoubt(doubt);
            commentRepository.save(comment);
        }
        return "redirect:/dashboard";
    }

    // --- Phase 2: Upvote an answer & update senior reputation --- //

    @PostMapping("/upvote")
    public String upvote(@RequestParam Long doubtId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/";

        Doubt doubt = doubtRepository.findById(doubtId).orElse(null);
        if (doubt != null && "RESOLVED".equals(doubt.getStatus()) && doubt.getAnsweredBy() != null) {
            Set<User> upvoters = doubt.getUpvoters();
            // Toggle: if already upvoted, remove; otherwise add
            boolean alreadyUpvoted = upvoters.stream().anyMatch(u -> u.getId().equals(user.getId()));
            if (!alreadyUpvoted) {
                upvoters.add(user);
                // Award +1 reputation to the senior who answered
                User senior = userRepository.findById(doubt.getAnsweredBy().getId()).orElse(null);
                if (senior != null) {
                    senior.setReputation(senior.getReputation() + 1);
                    userRepository.save(senior);
                }
            } else {
                upvoters.removeIf(u -> u.getId().equals(user.getId()));
                // Remove -1 reputation
                User senior = userRepository.findById(doubt.getAnsweredBy().getId()).orElse(null);
                if (senior != null) {
                    senior.setReputation(Math.max(0, senior.getReputation() - 1));
                    userRepository.save(senior);
                }
            }
            doubt.setUpvoters(upvoters);
            doubtRepository.save(doubt);

            // Refresh session user if the upvoter is the senior themselves (edge case guard)
            User sessionUser = (User) session.getAttribute("user");
            if (sessionUser.getId().equals(doubt.getAnsweredBy().getId())) {
                User refreshed = userRepository.findById(sessionUser.getId()).orElse(sessionUser);
                session.setAttribute("user", refreshed);
            }
        }
        return "redirect:/dashboard";
    }

    // --- Phase 2: Mark a doubt as Duplicate --- //

    @PostMapping("/mark-duplicate")
    public String markDuplicate(@RequestParam Long doubtId,
                                @RequestParam Long originalDoubtId,
                                HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"SENIOR".equals(user.getRole())) return "redirect:/";

        Doubt doubt = doubtRepository.findById(doubtId).orElse(null);
        Doubt original = doubtRepository.findById(originalDoubtId).orElse(null);
        if (doubt != null && original != null && !doubtId.equals(originalDoubtId)) {
            doubt.setDuplicateOfId(originalDoubtId);
            doubt.setStatus("RESOLVED"); // auto-resolve the duplicate
            doubtRepository.save(doubt);
        }
        return "redirect:/dashboard";
    }

    @PostMapping("/upload-material")
    public String uploadMaterial(@ModelAttribute Material material, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"SENIOR".equals(user.getRole())) return "redirect:/";

        material.setUploadedBy(user);
        materialRepository.save(material);
        return "redirect:/materials";
    }

    @GetMapping("/report")
    public String report(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/";

        List<Doubt> allDoubts = doubtRepository.findAll();
        long resolved = allDoubts.stream().filter(d -> "RESOLVED".equals(d.getStatus())).count();
        long pending = allDoubts.size() - resolved;
        long totalMaterials = materialRepository.count();

        model.addAttribute("totalDoubts", allDoubts.size());
        model.addAttribute("resolvedDoubts", resolved);
        model.addAttribute("pendingDoubts", pending);
        model.addAttribute("totalMaterials", totalMaterials);
        
        return "report";
    }

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/";

        if ("STUDENT".equals(user.getRole())) {
            List<Doubt> myDoubts = doubtRepository.findByStudentIdOrderByCreatedAtDesc(user.getId());
            model.addAttribute("myDoubts", myDoubts);
            
            long resolvedCount = myDoubts.stream().filter(d -> "RESOLVED".equals(d.getStatus())).count();
            model.addAttribute("resolvedCount", resolvedCount);
            model.addAttribute("pendingCount", myDoubts.size() - resolvedCount);
        } else if ("SENIOR".equals(user.getRole())) {
            long answeredDoubtsCount = doubtRepository.countByAnsweredById(user.getId());
            long materialsUploadedCount = materialRepository.countByUploadedById(user.getId());
            
            model.addAttribute("answeredDoubtsCount", answeredDoubtsCount);
            model.addAttribute("materialsUploadedCount", materialsUploadedCount);
            
            List<Doubt> myAnsweredDoubts = doubtRepository.findByAnsweredByIdOrderByCreatedAtDesc(user.getId());
            List<Material> myMaterials = materialRepository.findByUploadedByIdOrderByUploadedAtDesc(user.getId());
            
            model.addAttribute("myAnsweredDoubts", myAnsweredDoubts);
            model.addAttribute("myMaterials", myMaterials);
        }
        
        return "profile";
    }
}
