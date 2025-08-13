# Railway Deployment Troubleshooting Guide

## Common Issues and Solutions

### 1. Build Failures
**Problem**: Build fails during Maven package
**Solution**:
```bash
# Check if these are in your railway.json
{
  "build": {
    "builder": "DOCKERFILE",
    "dockerfilePath": "Dockerfile"
  }
}
```

### 2. Health Check Failures
**Problem**: Application fails health checks
**Solutions**:
- Ensure actuator endpoint is accessible: `/actuator/health`
- Check if email configuration is causing health check to fail
- Verify database connection is working

### 3. Database Connection Issues
**Problem**: Can't connect to MySQL
**Solutions**:
- Verify all MySQL environment variables are set correctly
- Check if database service is running in Railway
- Ensure network connectivity between services

### 4. Port Configuration
**Problem**: Application not accessible
**Solution**:
```properties
# In application-production.properties
server.port=${PORT:8080}
```

### 5. Memory Issues
**Problem**: Application crashes due to memory
**Solution**:
- In Railway project settings, increase memory allocation
- Add JVM options in Dockerfile:
```dockerfile
ENV JAVA_OPTS="-Xmx512m -Xms256m"
```

## Quick Commands to Check Status

### View Logs
```bash
# In Railway CLI (if installed)
railway logs
```

### Manual Health Check
```bash
curl https://your-app.up.railway.app/actuator/health
```

### Test API Endpoints
```bash
# Test login endpoint
curl -X POST https://your-app.up.railway.app/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"usernameOrEmail":"test","password":"test"}'
```

## Environment Variables Checklist

✅ Database Configuration:
- [ ] MYSQL_DATABASE
- [ ] MYSQL_HOST  
- [ ] MYSQL_PASSWORD
- [ ] MYSQL_PORT
- [ ] MYSQL_URL
- [ ] MYSQL_USER

✅ Application Settings:
- [ ] SPRING_PROFILES_ACTIVE=production
- [ ] APP_FRONTEND_URL
- [ ] JWT_SECRET

✅ Email Configuration (Optional):
- [ ] MAIL_HOST
- [ ] MAIL_PORT
- [ ] MAIL_USERNAME
- [ ] MAIL_PASSWORD

## Deployment Steps Summary

1. **Connect Repository**: Link GitHub repo to Railway
2. **Add Database**: Create MySQL service in Railway  
3. **Set Variables**: Configure all environment variables
4. **Deploy**: Push code or trigger manual deployment
5. **Monitor**: Check logs and health endpoint
6. **Test**: Verify application functionality

## Railway Dashboard Navigation

- **Overview**: Project summary and quick actions
- **Deployments**: Build and deployment history
- **Variables**: Environment configuration
- **Settings**: Project configuration and domains
- **Observe**: Real-time logs and metrics
- **Connect**: Database and service connections

## Useful Railway URLs

- Dashboard: https://railway.app/dashboard
- Docs: https://docs.railway.app
- Status: https://status.railway.app
- CLI: https://railway.app/cli
