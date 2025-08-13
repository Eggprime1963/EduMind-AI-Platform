package tech.nguyenstudy0504.learningplatform.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@Configuration
@EnableWebSecurity
@Order(1)
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .csrf(csrf -> csrf.disable())
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(authz -> authz
                .requestMatchers(
                    new AntPathRequestMatcher("/"),
                    new AntPathRequestMatcher("/home"),
                    new AntPathRequestMatcher("/health"),
                    new AntPathRequestMatcher("/status"),
                    new AntPathRequestMatcher("/index.jsp"),
                    new AntPathRequestMatcher("/login"),
                    new AntPathRequestMatcher("/register"),
                    new AntPathRequestMatcher("/browse"),
                    new AntPathRequestMatcher("/api/auth/**"),
                    new AntPathRequestMatcher("/api/courses"),
                    new AntPathRequestMatcher("/api/courses/**"),
                    new AntPathRequestMatcher("/api/lectures/**"),
                    new AntPathRequestMatcher("/api/courses/search"),
                    new AntPathRequestMatcher("/api/courses/category/**"),
                    new AntPathRequestMatcher("/api/courses/categories"),
                    new AntPathRequestMatcher("/api/courses/instructor/*"),
                    new AntPathRequestMatcher("/*.jsp"),
                    new AntPathRequestMatcher("/*.html"),
                    new AntPathRequestMatcher("/css/**"),
                    new AntPathRequestMatcher("/js/**"),
                    new AntPathRequestMatcher("/image/**"),
                    new AntPathRequestMatcher("/images/**"),
                    new AntPathRequestMatcher("/static/**"),
                    new AntPathRequestMatcher("/WEB-INF/**"),
                    new AntPathRequestMatcher("/h2-console/**"),
                    new AntPathRequestMatcher("/actuator/**"),
                    new AntPathRequestMatcher("/actuator/health"),
                    new AntPathRequestMatcher("/error"),
                    new AntPathRequestMatcher("/favicon.ico"),
                    new AntPathRequestMatcher("/password-reset.html")
                ).permitAll()
                .anyRequest().authenticated()
            );

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOriginPatterns(Arrays.asList("*"));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(Arrays.asList("*"));
        configuration.setAllowCredentials(true);
        
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
