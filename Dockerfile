FROM maven:3.9.6-eclipse-temurin-17-focal AS build

WORKDIR /app

COPY pom.xml .
#COPY libs ./libs
COPY ./libs/pandora-4.1.0.jar /tmp/pandora-4.1.0.jar

#instala el tema en repo local
RUN mvn install:install-file \
        -Dfile=/tmp/pandora-4.1.0.jar \
        -DgroupId=org.primefaces \
        -DartifactId=pandora \
        -Dversion=4.1.0 \
        -Dpackaging=jar

COPY src ./src

RUN mvn package -DskipTests

FROM eclipse-temurin:17-jre-focal

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 9090

ENTRYPOINT ["java", "-jar", "app.jar"]