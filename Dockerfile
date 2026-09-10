FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /workspace

COPY pom.xml .
RUN mvn -B -DskipTests dependency:go-offline

COPY src ./src
RUN mvn -B -DskipTests package

FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

RUN groupadd --system nextmeal \
    && useradd --system --gid nextmeal --no-create-home nextmeal

COPY --from=build /workspace/target/diet-agent-1.0-SNAPSHOT.jar /app/nextmeal.jar

USER nextmeal
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/nextmeal.jar"]
