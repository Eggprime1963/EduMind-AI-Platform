package tech.nguyenstudy0504.learningplatform.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import tech.nguyenstudy0504.learningplatform.repository.CourseRepository;
import tech.nguyenstudy0504.learningplatform.repository.UserRepository;

@Controller
public class HomeController {

    @Autowired
    private CourseRepository courseRepository;
    
    @Autowired
    private UserRepository userRepository;

    @GetMapping("/")
    public String root(Model model) {
        try {
            // Test database connectivity
            long userCount = userRepository.count();
            long courseCount = courseRepository.count();
            model.addAttribute("userCount", userCount);
            model.addAttribute("courseCount", courseCount);
            model.addAttribute("dbStatus", "Connected");
        } catch (Exception e) {
            model.addAttribute("dbStatus", "Connection Error: " + e.getMessage());
            model.addAttribute("userCount", 0);
            model.addAttribute("courseCount", 0);
        }
        return "forward:/home";
    }

    @GetMapping("/home")
    public String home(Model model) {
        try {
            // Test database connectivity
            long userCount = userRepository.count();
            long courseCount = courseRepository.count();
            model.addAttribute("userCount", userCount);
            model.addAttribute("courseCount", courseCount);
            model.addAttribute("dbStatus", "Connected");
        } catch (Exception e) {
            model.addAttribute("dbStatus", "Connection Error: " + e.getMessage());
            model.addAttribute("userCount", 0);
            model.addAttribute("courseCount", 0);
        }
        return "WEB-INF/jsp/homePage.jsp";
    }

    @GetMapping("/login")
    public String login() {
        return "WEB-INF/jsp/login.jsp";
    }

    @GetMapping("/register")
    public String register() {
        return "WEB-INF/jsp/register.jsp";
    }

    @GetMapping("/browse")
    public String browse() {
        return "WEB-INF/jsp/browse.jsp";
    }
}
