# Build stage
FROM maven:3.9.7-amazoncorretto-21 AS build
WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# Run stage
FROM amazoncorretto:21-alpine
WORKDIR /opt/config-server

RUN addgroup -S spring && adduser -S spring -G spring
USER spring

COPY --from=build /app/target/*.jar config-server.jar

EXPOSE 8888
ENTRYPOINT ["java", "-jar", "config-server.jar", "--spring.profiles.active=docker"]