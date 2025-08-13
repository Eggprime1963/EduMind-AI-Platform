package tech.nguyenstudy0504.learningplatform.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.util.HashMap;
import java.util.Map;

@RestController
public class DiagnosticController {

    @Autowired
    private Environment env;
    
    @Autowired
    private DataSource dataSource;
    
    @Value("${DATABASE_URL:not-set}")
    private String databaseUrl;

    @GetMapping("/diagnostic")
    public ResponseEntity<Map<String, Object>> diagnostic() {
        Map<String, Object> info = new HashMap<>();
        
        // Environment variables
        Map<String, String> envVars = new HashMap<>();
        envVars.put("DATABASE_URL", env.getProperty("DATABASE_URL", "not-set"));
        envVars.put("MYSQLUSER", env.getProperty("MYSQLUSER", "not-set"));
        envVars.put("MYSQLPASSWORD", env.getProperty("MYSQLPASSWORD", "not-set") != null ? "***SET***" : "not-set");
        envVars.put("MYSQLHOST", env.getProperty("MYSQLHOST", "not-set"));
        envVars.put("MYSQLPORT", env.getProperty("MYSQLPORT", "not-set"));
        envVars.put("MYSQLDATABASE", env.getProperty("MYSQLDATABASE", "not-set"));
        envVars.put("PORT", env.getProperty("PORT", "not-set"));
        
        info.put("environment_variables", envVars);
        info.put("active_profiles", env.getActiveProfiles());
        info.put("database_url_from_value", databaseUrl);
        
        // Database connection test
        try (Connection connection = dataSource.getConnection()) {
            DatabaseMetaData metaData = connection.getMetaData();
            Map<String, Object> dbInfo = new HashMap<>();
            dbInfo.put("url", metaData.getURL());
            dbInfo.put("username", metaData.getUserName());
            dbInfo.put("driver", metaData.getDriverName());
            dbInfo.put("driver_version", metaData.getDriverVersion());
            dbInfo.put("database_product", metaData.getDatabaseProductName());
            dbInfo.put("database_version", metaData.getDatabaseProductVersion());
            dbInfo.put("connection_valid", connection.isValid(5));
            
            info.put("database_connection", dbInfo);
            info.put("connection_status", "SUCCESS");
        } catch (Exception e) {
            info.put("connection_status", "FAILED");
            info.put("connection_error", e.getMessage());
            info.put("error_class", e.getClass().getSimpleName());
        }
        
        return ResponseEntity.ok(info);
    }
}
