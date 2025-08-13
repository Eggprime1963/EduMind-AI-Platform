package tech.nguyenstudy0504.learningplatform.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String root() {
        return "forward:/home";
    }

    @GetMapping("/home")
    public String home() {
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
