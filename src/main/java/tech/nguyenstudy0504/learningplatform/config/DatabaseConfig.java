package tech.nguyenstudy0504.learningplatform.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
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
        System.out.println("=== Railway Database Configuration ===");
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        
        String finalUrl = null;
        
        try {
            // Try MYSQL_URL first (format: mysql://user:pass@host:port/db)
            if (mysqlUrl != null && !mysqlUrl.isEmpty() && !mysqlUrl.contains("${{")) {
                // Convert MySQL URL to JDBC URL
                finalUrl = mysqlUrl.replace("mysql://", "jdbc:mysql://") + 
                          "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&autoReconnect=true&connectTimeout=5000&socketTimeout=5000";
                System.out.println("Using MYSQL_URL: " + finalUrl);
            } 
            // Fallback: construct from individual components
            else if (railwayPrivateDomain != null && !railwayPrivateDomain.isEmpty()) {
                finalUrl = String.format(
                    "jdbc:mysql://%s:%s/%s?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&autoReconnect=true&connectTimeout=5000&socketTimeout=5000",
                    railwayPrivateDomain, mysqlPort, mysqlDatabase
                );
                System.out.println("Constructed URL from RAILWAY_PRIVATE_DOMAIN: " + finalUrl);
            }
            // Last fallback: use default Railway internal host
            else {
                finalUrl = String.format(
                    "jdbc:mysql://mysql.railway.internal:%s/%s?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&autoReconnect=true&connectTimeout=5000&socketTimeout=5000",
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
            
            // Test connection but don't fail startup
            try {
                dataSource.getConnection().close();
                System.out.println("✅ Database connection test successful!");
            } catch (Exception e) {
                System.err.println("⚠️ Database connection test failed, but continuing startup: " + e.getMessage());
            }
            
        } catch (Exception e) {
            System.err.println("⚠️ Database configuration error, using minimal configuration: " + e.getMessage());
            // Fallback minimal configuration
            dataSource.setUrl("jdbc:mysql://localhost:3306/railway?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC");
            dataSource.setUsername("root");
            dataSource.setPassword("");
            dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
        }
        
        System.out.println("=== End Database Configuration ===");
        return dataSource;
    }
}
