FROM maven:3.9.6-eclipse-temurin-17-focal AS build

WORKDIR /app

COPY pom.xml .
COPY libs ./libs

COPY src ./src

RUN mvn package -DskipTests

FROM eclipse-temurin:17-jre-focal

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 9090

ENTRYPOINT ["java", "-jar", "app.jar"]