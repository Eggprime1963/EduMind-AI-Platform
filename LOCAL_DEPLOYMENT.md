# Local Deployment Guide

## Quick Start (5 minutes)

### Prerequisites
- Java 17+ installed
- MySQL 8.0+ installed and running
- Maven 3.6+ installed

### Step 1: Database Setup
```sql
-- Connect to MySQL
mysql -u root -p

-- Create database
CREATE DATABASE learning_management;

-- Import schema
USE learning_management;
SOURCE learning_management_main.sql;
SOURCE notifications-table.sql;

-- Create a test user (optional)
INSERT INTO users (username, email, password, role, active, created_date)
VALUES ('admin', 'admin@example.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2uheWG/igi.', 'ADMIN', true, NOW());
```

### Step 2: Configure Application
Create `src/main/resources/application-local.properties`:
```properties
# Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/learning_management
spring.datasource.username=root
spring.datasource.password=your_mysql_password
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA/Hibernate Configuration
spring.jpa.hibernate.ddl-auto=update
spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect
spring.jpa.show-sql=false

# Server Configuration
server.port=8080
server.servlet.context-path=/

# JWT Configuration
jwt.secret=your-secret-key-here-make-it-long-and-secure
jwt.expiration=86400000

# Email Configuration (Optional - for password reset)
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=your-email@gmail.com
spring.mail.password=your-app-password
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
management.health.mail.enabled=false

# Application Settings
app.frontend.url=http://localhost:8080

# File Upload
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=10MB

# Logging
logging.level.tech.nguyenstudy0504=DEBUG
logging.level.org.springframework.security=DEBUG
```

### Step 3: Build & Run
```bash
# Build the application
mvn clean package -DskipTests

# Run with local profile
java -jar target/learning-platform-1.0.0.war --spring.profiles.active=local

# Or use Maven directly
mvn spring-boot:run -Dspring-boot.run.profiles=local
```

### Step 4: Access Application
- **Main Application**: http://localhost:8080
- **Login Page**: http://localhost:8080/login
- **Admin Dashboard**: http://localhost:8080/admin (admin/password)
- **Health Check**: http://localhost:8080/actuator/health
- **Password Reset**: http://localhost:8080/password-reset.html

## Development Mode

### Hot Reload Setup
```bash
# Install Spring Boot DevTools (already included in pom.xml)
# Run with dev profile for auto-restart
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

### Database Auto-Creation
For quick testing, use H2 in-memory database:
```properties
# Add to application-dev.properties
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driver-class-name=org.h2.Driver
spring.h2.console.enabled=true
spring.jpa.hibernate.ddl-auto=create-drop
```
Access H2 Console at: http://localhost:8080/h2-console

## Troubleshooting

### Common Issues

1. **Port 8080 already in use**
   ```bash
   # Kill process on port 8080
   netstat -ano | findstr :8080
   taskkill /PID <PID> /F
   
   # Or change port in application.properties
   server.port=8081
   ```

2. **MySQL Connection Failed**
   ```bash
   # Check MySQL is running
   net start MySQL80
   
   # Test connection
   mysql -u root -p -e "SELECT 1;"
   ```

3. **Build Errors**
   ```bash
   # Clean and rebuild
   mvn clean compile
   
   # Skip tests if needed
   mvn package -DskipTests
   ```

4. **JWT Secret Error**
   - Make sure `jwt.secret` is at least 32 characters long
   - Use a strong random string

### Performance Optimization

```properties
# Add to application-local.properties for better performance
spring.jpa.properties.hibernate.jdbc.batch_size=20
spring.jpa.properties.hibernate.order_inserts=true
spring.jpa.properties.hibernate.order_updates=true
spring.jpa.properties.hibernate.jdbc.batch_versioned_data=true

# Connection Pool
spring.datasource.hikari.maximum-pool-size=20
spring.datasource.hikari.minimum-idle=5
```

## API Testing

### Test Authentication
```bash
# Login
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"usernameOrEmail":"admin","password":"password"}'

# Get courses (replace TOKEN with JWT from login)
curl -X GET http://localhost:8080/api/courses \
  -H "Authorization: Bearer TOKEN"
```

### Test Password Reset
```bash
# Request password reset
curl -X POST http://localhost:8080/api/auth/forgot-password \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com"}'
```

## Production Deployment

### Docker Local
```bash
# Build image
docker build -t eduplatform .

# Run with MySQL
docker run -d --name mysql-eduplatform \
  -e MYSQL_ROOT_PASSWORD=password \
  -e MYSQL_DATABASE=learning_management \
  -p 3306:3306 mysql:8.0

# Run application
docker run -d --name eduplatform \
  --link mysql-eduplatform:mysql \
  -e SPRING_PROFILES_ACTIVE=production \
  -e MYSQL_HOST=mysql \
  -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=password \
  -e MYSQL_DATABASE=learning_management \
  -p 8080:8080 eduplatform
```

### Docker Compose
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## Default Credentials

After importing the SQL files, you can use these default accounts:

- **Admin**: admin@example.com / password
- **Instructor**: instructor@example.com / password  
- **Student**: student@example.com / password

⚠️ **Important**: Change these passwords in production!

## Next Steps

1. **Configure Email**: Set up Gmail app password for password reset
2. **Add Sample Data**: Create courses, lectures, and assignments
3. **Customize UI**: Modify JSP files and CSS in `src/main/webapp/`
4. **Set up AI**: Configure Gemini API for AI features
5. **Payment Setup**: Configure VNPay for payment processing

## Support

- Check logs in console output
- Visit: http://localhost:8080/actuator/health for system status
- Enable debug logging for detailed troubleshooting
- Database console: http://localhost:8080/h2-console (if using H2)
