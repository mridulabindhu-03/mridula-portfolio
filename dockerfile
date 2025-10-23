# Stage 1: Build with Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package

# Stage 2: Deploy to Tomcat
FROM tomcat:9.0
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/htmlproject.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080 inside container (Tomcat default)
EXPOSE 8080
CMD ["catalina.sh", "run"]
