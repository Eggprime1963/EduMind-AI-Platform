package tech.nguyenstudy0504.learningplatform.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import javax.sql.DataSource;

@Configuration
public class DatabaseConfig {

    @Value("${MYSQL_URL:}")
    private String mysqlUrl;
    
    @Value("${MYSQL_PUBLIC_URL:}")
    private String mysqlPublicUrl;
    
    @Value("${MYSQLUSER:root}")
    private String mysqlUser;
    
    @Value("${MYSQL_ROOT_PASSWORD:}")
    private String mysqlPassword;
    
    @Value("${MYSQLHOST:}")
    private String mysqlHost;
    
    @Value("${MYSQLPORT:3306}")
    private String mysqlPort;
    
    @Value("${MYSQL_DATABASE:railway}")
    private String mysqlDatabase;
    
    @Value("${RAILWAY_PRIVATE_DOMAIN:}")
    private String railwayPrivateDomain;

    @Bean
    @Primary
    public DataSource railwayDataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        
        String finalUrl = null;
        
        // Try MYSQL_URL first (format: mysql://user:pass@host:port/db)
        if (mysqlUrl != null && !mysqlUrl.isEmpty() && !mysqlUrl.contains("${{")) {
            // Convert MySQL URL to JDBC URL
            finalUrl = mysqlUrl.replace("mysql://", "jdbc:mysql://") + 
                      "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&autoReconnect=true";
            System.out.println("Using MYSQL_URL: " + finalUrl);
        } 
        // Fallback: construct from individual components
        else if (railwayPrivateDomain != null && !railwayPrivateDomain.isEmpty()) {
            finalUrl = String.format(
                "jdbc:mysql://%s:%s/%s?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&autoReconnect=true",
                railwayPrivateDomain, mysqlPort, mysqlDatabase
            );
            System.out.println("Constructed URL from RAILWAY_PRIVATE_DOMAIN: " + finalUrl);
        }
        // Last fallback: use hardcoded values for Railway
        else {
            finalUrl = String.format(
                "jdbc:mysql://%s:%s/%s?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&autoReconnect=true",
                mysqlHost != null && !mysqlHost.isEmpty() ? mysqlHost : "mysql.railway.internal",
                mysqlPort, mysqlDatabase
            );
            System.out.println("Using fallback URL: " + finalUrl);
        }
        
        dataSource.setUrl(finalUrl);
        dataSource.setUsername(mysqlUser);
        dataSource.setPassword(mysqlPassword);
        dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
        
        System.out.println("Database Configuration:");
        System.out.println("  URL: " + finalUrl);
        System.out.println("  Username: " + mysqlUser);
        System.out.println("  Password: " + (mysqlPassword != null && !mysqlPassword.isEmpty() ? "***SET***" : "NOT SET"));
        
        return dataSource;
    }
}
