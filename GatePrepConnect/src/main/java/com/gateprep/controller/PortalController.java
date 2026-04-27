package com.gateprep.controller;

import com.gateprep.model.Doubt;
import com.gateprep.model.Material;
import com.gateprep.model.User;
import com.gateprep.repository.DoubtRepository;
import com.gateprep.repository.MaterialRepository;
import com.gateprep.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class PortalController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DoubtRepository doubtRepository;

    @Autowired
    private MaterialRepository materialRepository;

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
    public String dashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/";

        if ("STUDENT".equals(user.getRole())) {
            List<Doubt> myDoubts = doubtRepository.findByStudentIdOrderByCreatedAtDesc(user.getId());
            model.addAttribute("myDoubts", myDoubts);
        } else {
            List<Doubt> allPending = doubtRepository.findAllByOrderByCreatedAtDesc();
            model.addAttribute("allDoubts", allPending);
        }
        return "dashboard";
    }

    @GetMapping("/materials")
    public String materials(HttpSession session, Model model) {
        if (session.getAttribute("user") == null) return "redirect:/";
        
        List<Material> materials = materialRepository.findAllByOrderByUploadedAtDesc();
        model.addAttribute("materials", materials);
        return "materials";
    }

    @PostMapping("/ask-doubt")
    public String askDoubt(@ModelAttribute Doubt doubt, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"STUDENT".equals(user.getRole())) return "redirect:/";

        doubt.setStudent(user);
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
}
