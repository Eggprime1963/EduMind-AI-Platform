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

    @Value("${DATABASE_URL:}")
    private String databaseUrl;
    
    @Value("${MYSQLUSER:}")
    private String mysqlUser;
    
    @Value("${MYSQLPASSWORD:}")
    private String mysqlPassword;
    
    @Value("${MYSQLHOST:}")
    private String mysqlHost;
    
    @Value("${MYSQLPORT:}")
    private String mysqlPort;
    
    @Value("${MYSQLDATABASE:}")
    private String mysqlDatabase;

    @Bean
    @Primary
    @ConditionalOnProperty(name = "spring.datasource.url", matchIfMissing = false)
    public DataSource railwayDataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        
        // Try to construct URL from Railway environment variables if DATABASE_URL is not available
        if (databaseUrl != null && !databaseUrl.isEmpty()) {
            dataSource.setUrl(databaseUrl);
        } else if (mysqlHost != null && !mysqlHost.isEmpty()) {
            String constructedUrl = String.format(
                "jdbc:mysql://%s:%s/%s?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&autoReconnect=true",
                mysqlHost, mysqlPort != null && !mysqlPort.isEmpty() ? mysqlPort : "3306",
                mysqlDatabase != null && !mysqlDatabase.isEmpty() ? mysqlDatabase : "railway"
            );
            dataSource.setUrl(constructedUrl);
            System.out.println("Constructed Database URL: " + constructedUrl);
        }
        
        if (mysqlUser != null && !mysqlUser.isEmpty()) {
            dataSource.setUsername(mysqlUser);
        }
        
        if (mysqlPassword != null && !mysqlPassword.isEmpty()) {
            dataSource.setPassword(mysqlPassword);
        }
        
        // Auto-detect driver based on URL
        if (databaseUrl != null && databaseUrl.contains("postgresql")) {
            dataSource.setDriverClassName("org.postgresql.Driver");
        } else {
            dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
        }
        
        return dataSource;
    }
}
