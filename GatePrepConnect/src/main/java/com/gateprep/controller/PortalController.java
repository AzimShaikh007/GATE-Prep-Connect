package com.gateprep.controller;

import com.gateprep.model.Comment;
import com.gateprep.model.Doubt;
import com.gateprep.model.Material;
import com.gateprep.model.MaterialRating;
import com.gateprep.model.User;
import com.gateprep.repository.CommentRepository;
import com.gateprep.repository.DoubtRepository;
import com.gateprep.repository.MaterialRatingRepository;
import com.gateprep.repository.MaterialRepository;
import com.gateprep.repository.UserRepository;
import com.gateprep.service.NotificationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@Controller
public class PortalController {

    @Autowired private UserRepository userRepository;
    @Autowired private DoubtRepository doubtRepository;
    @Autowired private MaterialRepository materialRepository;
    @Autowired private CommentRepository commentRepository;
    @Autowired private MaterialRatingRepository ratingRepository;
    @Autowired private NotificationService notificationService;

    // ── Helpers ─────────────────────────────────────────────────────────────

    private User sessionUser(HttpSession session) {
        return (User) session.getAttribute("user");
    }

    private boolean isAdmin(User u) {
        return u != null && "ADMIN".equals(u.getRole());
    }

    // ── Authentication ───────────────────────────────────────────────────────

    @GetMapping("/")
    public String index(HttpSession session) {
        if (sessionUser(session) != null) return "redirect:/dashboard";
        return "login";
    }

    @GetMapping("/register")
    public String registerPage() { return "register"; }

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
    public String login(@RequestParam String email, @RequestParam String password,
                        HttpSession session, Model model) {
        User user = userRepository.findByEmail(email);
        if (user != null && user.getPassword().equals(password)) {
            if (user.isBanned()) {
                model.addAttribute("error", "Your account has been suspended. Contact an administrator.");
                return "login";
            }
            session.setAttribute("user", user);
            if (isAdmin(user)) return "redirect:/admin";
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

    // ── Dashboard ────────────────────────────────────────────────────────────

    @GetMapping("/dashboard")
    public String dashboard(@RequestParam(required = false) String query,
                            @RequestParam(required = false) String subject,
                            @RequestParam(required = false) String status,
                            HttpSession session, Model model) {
        User user = sessionUser(session);
        if (user == null) return "redirect:/";

        List<Doubt> allDoubts = doubtRepository.searchDoubts(query, subject, status);
        model.addAttribute("allDoubts", allDoubts);

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
        User user = sessionUser(session);
        if (user == null) return "redirect:/";

        List<Material> materials = materialRepository.searchMaterials(query, subject);
        model.addAttribute("materials", materials);
        model.addAttribute("query", query);
        model.addAttribute("subject", subject);

        // Build avg-rating and count maps for the view
        Map<Long, Double> avgRatings   = new HashMap<>();
        Map<Long, Long>   ratingCounts = new HashMap<>();
        Map<Long, Boolean> userRated   = new HashMap<>();
        for (Material m : materials) {
            Double avg = ratingRepository.findAvgStarsByMaterialId(m.getId());
            avgRatings.put(m.getId(), avg != null ? avg : 0.0);
            ratingCounts.put(m.getId(), ratingRepository.countByMaterialId(m.getId()));
            userRated.put(m.getId(),
                ratingRepository.findByMaterialIdAndUserId(m.getId(), user.getId()).isPresent());
        }
        model.addAttribute("avgRatings",   avgRatings);
        model.addAttribute("ratingCounts", ratingCounts);
        model.addAttribute("userRated",    userRated);

        return "materials";
    }

    @PostMapping("/ask-doubt")
    public String askDoubt(@ModelAttribute Doubt doubt,
                           @RequestParam(value = "tagsInput", required = false) String tagsInput,
                           HttpSession session) {
        User user = sessionUser(session);
        if (user == null || !"STUDENT".equals(user.getRole())) return "redirect:/";

        doubt.setStudent(user);
        if (tagsInput != null && !tagsInput.isBlank()) {
            Set<String> tags = Arrays.stream(tagsInput.split("[,\\s]+"))
                    .map(String::trim).filter(t -> !t.isEmpty())
                    .map(t -> t.startsWith("#") ? t : "#" + t)
                    .collect(Collectors.toCollection(HashSet::new));
            doubt.setTags(tags);
        }
        doubtRepository.save(doubt);
        return "redirect:/dashboard";
    }

    @PostMapping("/answer-doubt")
    public String answerDoubt(@RequestParam Long doubtId, @RequestParam String answerText,
                              HttpSession session) {
        User user = sessionUser(session);
        if (user == null || !"SENIOR".equals(user.getRole())) return "redirect:/";

        Doubt doubt = doubtRepository.findById(doubtId).orElse(null);
        if (doubt != null) {
            doubt.setAnswerText(answerText);
            doubt.setAnsweredBy(user);
            doubt.setStatus("RESOLVED");
            doubtRepository.save(doubt);
            // Phase 3 – notify student via email
            notificationService.sendDoubtResolvedNotification(doubt);
        }
        return "redirect:/dashboard";
    }

    // ── Phase 2: Comments ────────────────────────────────────────────────────

    @PostMapping("/add-comment")
    public String addComment(@RequestParam Long doubtId, @RequestParam String text,
                             HttpSession session) {
        User user = sessionUser(session);
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

    // ── Phase 2: Upvote ──────────────────────────────────────────────────────

    @PostMapping("/upvote")
    public String upvote(@RequestParam Long doubtId, HttpSession session) {
        User user = sessionUser(session);
        if (user == null) return "redirect:/";

        Doubt doubt = doubtRepository.findById(doubtId).orElse(null);
        if (doubt != null && "RESOLVED".equals(doubt.getStatus()) && doubt.getAnsweredBy() != null) {
            // Fetch managed user to avoid detached entity issues
            User managedUser = userRepository.findById(user.getId()).orElse(user);
            Set<User> upvoters = doubt.getUpvoters();
            
            boolean alreadyUpvoted = upvoters.stream().anyMatch(u -> u.getId().equals(managedUser.getId()));
            User senior = userRepository.findById(doubt.getAnsweredBy().getId()).orElse(null);
            
            if (!alreadyUpvoted) {
                upvoters.add(managedUser);
                if (senior != null) {
                    int rep = (senior.getReputation() == null) ? 0 : senior.getReputation();
                    senior.setReputation(rep + 1);
                    userRepository.save(senior);
                }
            } else {
                upvoters.removeIf(u -> u.getId().equals(managedUser.getId()));
                if (senior != null) {
                    int rep = (senior.getReputation() == null) ? 0 : senior.getReputation();
                    senior.setReputation(Math.max(0, rep - 1));
                    userRepository.save(senior);
                }
            }
            doubtRepository.save(doubt);
            
            // Sync session if the upvoted user is the current user (e.g. upvoting their own answer, though JSP hide it)
            if (senior != null && managedUser.getId().equals(senior.getId())) {
                session.setAttribute("user", senior);
            }
        }
        return "redirect:/dashboard";
    }

    // ── Phase 2: Mark Duplicate ──────────────────────────────────────────────

    @PostMapping("/mark-duplicate")
    public String markDuplicate(@RequestParam Long doubtId, @RequestParam Long originalDoubtId,
                                HttpSession session) {
        User user = sessionUser(session);
        if (user == null || !"SENIOR".equals(user.getRole())) return "redirect:/";

        Doubt doubt    = doubtRepository.findById(doubtId).orElse(null);
        Doubt original = doubtRepository.findById(originalDoubtId).orElse(null);
        if (doubt != null && original != null && !doubtId.equals(originalDoubtId)) {
            doubt.setDuplicateOfId(originalDoubtId);
            doubt.setStatus("RESOLVED");
            doubtRepository.save(doubt);
        }
        return "redirect:/dashboard";
    }

    @PostMapping("/upload-material")
    public String uploadMaterial(@ModelAttribute Material material, HttpSession session) {
        User user = sessionUser(session);
        if (user == null || !"SENIOR".equals(user.getRole())) return "redirect:/";
        material.setUploadedBy(user);
        materialRepository.save(material);
        return "redirect:/materials";
    }

    // ── Phase 3: Material Ratings & Reviews ──────────────────────────────────

    @PostMapping("/rate-material")
    public String rateMaterial(@RequestParam Long materialId,
                               @RequestParam int stars,
                               @RequestParam(required = false) String review,
                               HttpSession session) {
        User user = sessionUser(session);
        if (user == null) return "redirect:/";

        Material material = materialRepository.findById(materialId).orElse(null);
        if (material == null) return "redirect:/materials";

        // Upsert: edit existing rating if the user already rated
        MaterialRating rating = ratingRepository.findByMaterialIdAndUserId(materialId, user.getId())
                .orElse(new MaterialRating());
        rating.setMaterial(material);
        rating.setUser(user);
        rating.setStars(Math.max(1, Math.min(5, stars)));
        rating.setReview(review != null && !review.isBlank() ? review.trim() : null);
        ratingRepository.save(rating);

        return "redirect:/materials";
    }

    @GetMapping("/material-reviews/{materialId}")
    public String materialReviews(@PathVariable Long materialId, HttpSession session, Model model) {
        User user = sessionUser(session);
        if (user == null) return "redirect:/";

        Material material = materialRepository.findById(materialId).orElse(null);
        if (material == null) return "redirect:/materials";

        List<MaterialRating> reviews = ratingRepository.findByMaterialIdOrderByCreatedAtDesc(materialId);
        Double avg = ratingRepository.findAvgStarsByMaterialId(materialId);

        model.addAttribute("material",    material);
        model.addAttribute("reviews",     reviews);
        model.addAttribute("avgRating",   avg != null ? avg : 0.0);
        model.addAttribute("ratingCount", ratingRepository.countByMaterialId(materialId));
        ratingRepository.findByMaterialIdAndUserId(materialId, user.getId())
                .ifPresent(r -> model.addAttribute("myRating", r));

        return "material-reviews";
    }

    // ── Phase 3: Admin Dashboard ──────────────────────────────────────────────

    @GetMapping("/admin")
    public String adminDashboard(HttpSession session, Model model) {
        User user = sessionUser(session);
        if (user == null || !isAdmin(user)) return "redirect:/";

        List<User>     allUsers     = userRepository.findAllByOrderByNameAsc();
        List<Doubt>    allDoubts    = doubtRepository.findAll();
        List<Material> allMaterials = materialRepository.findAll();

        long bannedUsers    = allUsers.stream().filter(User::isBanned).count();
        long resolvedDoubts = allDoubts.stream().filter(d -> "RESOLVED".equals(d.getStatus())).count();

        model.addAttribute("allUsers",       allUsers);
        model.addAttribute("allDoubts",      allDoubts);
        model.addAttribute("allMaterials",   allMaterials);
        model.addAttribute("totalUsers",     allUsers.size());
        model.addAttribute("bannedUsers",    bannedUsers);
        model.addAttribute("totalDoubts",    allDoubts.size());
        model.addAttribute("resolvedDoubts", resolvedDoubts);
        model.addAttribute("totalMaterials", allMaterials.size());

        return "admin";
    }

    @PostMapping("/admin/ban-user")
    public String banUser(@RequestParam Long userId, HttpSession session) {
        User admin = sessionUser(session);
        if (admin == null || !isAdmin(admin)) return "redirect:/";

        userRepository.findById(userId).ifPresent(u -> {
            u.setBanned(!u.isBanned()); // toggle
            userRepository.save(u);
        });
        return "redirect:/admin";
    }

    @PostMapping("/admin/delete-doubt")
    public String deleteDoubt(@RequestParam Long doubtId, HttpSession session) {
        User admin = sessionUser(session);
        if (admin == null || !isAdmin(admin)) return "redirect:/";
        doubtRepository.deleteById(doubtId);
        return "redirect:/admin";
    }

    @PostMapping("/admin/delete-material")
    public String deleteMaterial(@RequestParam Long materialId, HttpSession session) {
        User admin = sessionUser(session);
        if (admin == null || !isAdmin(admin)) return "redirect:/";
        materialRepository.deleteById(materialId);
        return "redirect:/admin";
    }

    // ── Report ───────────────────────────────────────────────────────────────

    @GetMapping("/report")
    public String report(HttpSession session, Model model) {
        User user = sessionUser(session);
        if (user == null) return "redirect:/";

        List<Doubt> allDoubts = doubtRepository.findAll();
        long resolved = allDoubts.stream().filter(d -> "RESOLVED".equals(d.getStatus())).count();

        model.addAttribute("totalDoubts",    allDoubts.size());
        model.addAttribute("resolvedDoubts", resolved);
        model.addAttribute("pendingDoubts",  allDoubts.size() - resolved);
        model.addAttribute("totalMaterials", materialRepository.count());

        // Phase 3 – leaderboard
        List<User> topSeniors = userRepository.findByRoleOrderByReputationDesc("SENIOR")
                .stream().limit(5).collect(Collectors.toList());
        model.addAttribute("topSeniors", topSeniors);

        return "report";
    }

    // ── Profile ──────────────────────────────────────────────────────────────

    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User user = sessionUser(session);
        if (user == null) return "redirect:/";

        if ("STUDENT".equals(user.getRole())) {
            List<Doubt> myDoubts = doubtRepository.findByStudentIdOrderByCreatedAtDesc(user.getId());
            long resolvedCount = myDoubts.stream().filter(d -> "RESOLVED".equals(d.getStatus())).count();
            model.addAttribute("myDoubts",      myDoubts);
            model.addAttribute("resolvedCount", resolvedCount);
            model.addAttribute("pendingCount",  myDoubts.size() - resolvedCount);
        } else if ("SENIOR".equals(user.getRole())) {
            long answeredCount  = doubtRepository.countByAnsweredById(user.getId());
            long materialsCount = materialRepository.countByUploadedById(user.getId());
            model.addAttribute("answeredDoubtsCount",    answeredCount);
            model.addAttribute("materialsUploadedCount", materialsCount);
            model.addAttribute("myAnsweredDoubts",       doubtRepository.findByAnsweredByIdOrderByCreatedAtDesc(user.getId()));
            model.addAttribute("myMaterials",            materialRepository.findByUploadedByIdOrderByUploadedAtDesc(user.getId()));
        }

        return "profile";
    }
}
