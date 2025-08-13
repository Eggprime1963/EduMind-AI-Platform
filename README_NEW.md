# EduMind AI-Powered Learning Platform

A modern, full-stack learning management system built with Spring Boot, featuring AI-powered recommendations, video lectures, assignments, and comprehensive course management.

## 🚀 Features

### Core Learning Features
- **Course Management**: Create, publish, and manage courses with video lectures
- **Assignment System**: Interactive assignments with file upload and grading
- **Progress Tracking**: Real-time student progress monitoring
- **Discussion Forums**: Course-specific discussion boards
- **Notifications**: Real-time notifications for deadlines and updates

### Advanced Features
- **AI Recommendations**: Personalized course and content suggestions
- **Password Reset**: Email-based password recovery system
- **Multi-Role Support**: Students, Instructors, and Administrators
- **Payment Integration**: VNPay payment gateway for course purchases
- **Analytics Dashboard**: Comprehensive reporting for admins
- **Mobile Responsive**: Optimized for all devices

## 🛠 Tech Stack

### Backend
- **Spring Boot 3.x** - Main framework
- **Spring Security** - Authentication & authorization
- **Spring Data JPA** - Database operations
- **MySQL** - Primary database
- **JWT** - Token-based authentication
- **JavaMail** - Email functionality

### Frontend
- **JSP/HTML/CSS/JavaScript** - Web interface
- **Bootstrap** - Responsive design
- **Chart.js** - Analytics visualization

### DevOps & Deployment
- **Docker** - Containerization
- **Railway** - Cloud deployment
- **Vercel** - Frontend hosting option
- **Maven** - Build management

## 📋 Prerequisites

- **Java 17+**
- **Maven 3.6+**
- **MySQL 8.0+**
- **Docker** (optional)
- **Git**

## 🔧 Installation & Setup

### 1. Clone Repository
```bash
git clone https://github.com/Eggprime1963/EduMind-AI-Platform.git
cd EduMind-AI-Platform
```

### 2. Database Setup
```sql
-- Create database
CREATE DATABASE learning_management;

-- Import schema
mysql -u root -p learning_management < learning_management_main.sql
mysql -u root -p learning_management < notifications-table.sql
```

### 3. Configure Environment
Create `src/main/resources/application-dev.properties`:
```properties
# Database Configuration
spring.datasource.url=jdbc:mysql://localhost:3306/learning_management
spring.datasource.username=your_username
spring.datasource.password=your_password

# Email Configuration (Optional)
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=your-email@gmail.com
spring.mail.password=your-app-password
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true

# Application Settings
app.frontend.url=http://localhost:8080
jwt.secret=your-jwt-secret-key
```

### 4. Build & Run
```bash
# Build project
mvn clean package -DskipTests

# Run application
java -jar target/learning-platform-1.0.0.war

# Or run with Maven
mvn spring-boot:run -Dspring-boot.run.profiles=dev
```

### 5. Access Application
- **Application**: http://localhost:8080
- **Health Check**: http://localhost:8080/actuator/health
- **Password Reset Form**: http://localhost:8080/password-reset.html

## 🐳 Docker Deployment

### Build & Run with Docker
```bash
# Build image
docker build -t eduplatform .

# Run container
docker run -p 8080:8080 -e SPRING_PROFILES_ACTIVE=production eduplatform
```

### Docker Compose
```bash
docker-compose up -d
```

## ☁️ Cloud Deployment

### Railway Deployment

1. **Connect Repository** to Railway
2. **Set Environment Variables**:
   ```
   MYSQL_DATABASE=railway
   MYSQL_HOST=containers-us-west-xxx.railway.app
   MYSQL_PASSWORD=your-mysql-password
   MYSQL_PORT=6543
   MYSQL_URL=mysql://root:password@host:port/railway
   MYSQL_USER=root
   MAIL_HOST=smtp.gmail.com
   MAIL_PORT=587
   MAIL_USERNAME=your-email@gmail.com
   MAIL_PASSWORD=your-app-password
   APP_FRONTEND_URL=https://your-domain.up.railway.app
   ```
3. **Deploy** automatically on push

### Vercel Deployment (Frontend)
```bash
# Deploy to Vercel
vercel --prod
```

## 📧 Email Configuration

### Gmail Setup
1. Enable 2-Factor Authentication
2. Generate App Password: Google Account → Security → 2-Step Verification → App passwords
3. Use app password in `MAIL_PASSWORD`

### Alternative Providers
- **Outlook**: `smtp-mail.outlook.com:587`
- **Yahoo**: `smtp.mail.yahoo.com:587`
- **SendGrid**: `smtp.sendgrid.net:587`

## 🔐 Security Features

- **JWT Authentication** with secure token handling
- **Password Encryption** using BCrypt
- **CORS Protection** with configurable origins
- **SQL Injection Prevention** with JPA
- **Email Verification** for password reset
- **Role-based Access Control**

## 📊 API Endpoints

### Authentication
```
POST   /api/auth/login           - User login
POST   /api/auth/logout          - User logout
GET    /api/auth/verify          - Token verification
POST   /api/auth/forgot-password - Request password reset
POST   /api/auth/reset-password  - Reset password with token
```

### Courses
```
GET    /api/courses              - List all courses
POST   /api/courses              - Create course (instructor)
GET    /api/courses/{id}         - Get course details
PUT    /api/courses/{id}         - Update course
DELETE /api/courses/{id}         - Delete course
```

### Lectures
```
GET    /api/lectures/course/{id} - Get course lectures
GET    /api/lectures/{id}        - Get lecture details
POST   /api/lectures             - Create lecture
PUT    /api/lectures/{id}        - Update lecture
DELETE /api/lectures/{id}        - Delete lecture
```

## 🧪 Testing

### Run Tests
```bash
# Unit tests
mvn test

# Integration tests
mvn verify

# Skip tests during build
mvn package -DskipTests
```

### Test Password Reset
1. Access: http://localhost:8080/password-reset.html
2. Enter email to request reset
3. Check email for reset link
4. Use token to reset password

## 🔧 Development

### Project Structure
```
src/
├── main/
│   ├── java/tech/nguyenstudy0504/learningplatform/
│   │   ├── controller/     # REST controllers
│   │   ├── service/        # Business logic
│   │   ├── model/          # Entity classes
│   │   ├── repository/     # Data access layer
│   │   ├── dto/           # Data transfer objects
│   │   ├── util/          # Utility classes
│   │   └── config/        # Configuration classes
│   ├── resources/
│   │   ├── application*.properties
│   │   └── static/        # Static resources
│   └── webapp/            # JSP views and web assets
└── test/                  # Test classes
```

### Adding New Features
1. Create model in `model/`
2. Add repository in `repository/`
3. Implement service in `service/`
4. Create controller in `controller/`
5. Add tests in `test/`

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/Eggprime1963/EduMind-AI-Platform/issues)
- **Documentation**: Check README and inline code comments
- **Email**: Contact repository owner

## 🎯 Roadmap

- [ ] Real-time chat integration
- [ ] Advanced AI recommendations
- [ ] Mobile app development
- [ ] Multi-language support
- [ ] Advanced analytics dashboard
- [ ] Integration with external LMS platforms

---

**Built with ❤️ by the EduMind Team**
