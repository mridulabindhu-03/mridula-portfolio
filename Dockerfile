# Stage 1: build WAR using Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# copy only pom first for dependency caching
COPY pom.xml .
COPY src ./src

# package without running tests (change -DskipTests=false if you want tests)
RUN mvn -B -DskipTests=true package \
    && ls -la /app/target

# Stage 2: runtime Tomcat
FROM tomcat:9.0
# remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# copy WAR produced by build stage to ROOT.war
COPY --from=build /app/target/htmlproject.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]

