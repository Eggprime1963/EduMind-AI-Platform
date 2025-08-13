# Working Dockerfile for Render deployment - Using non-deprecated images
FROM maven:3.8-eclipse-temurin-17 AS build

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn package -DskipTests

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/learning-platform-1.0.0.jar app.jar

EXPOSE 8080
ENV JAVA_OPTS="-Xmx400m -Xms200m"

CMD ["sh", "-c", "java $JAVA_OPTS -jar app.jar --spring.profiles.active=production"]
