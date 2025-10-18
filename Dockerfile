# Étape 1 : Build avec cache Maven optimisé
FROM maven:3.8.5-openjdk-17 AS build

WORKDIR /app

# Étape 1: Copier uniquement le POM pour cacher les dépendances
COPY pom.xml .

# Étape 2: Télécharger toutes les dépendances
RUN mvn dependency:go-offline -B

# Étape 3: Copier les sources
COPY src ./src

# Étape 4: Compiler et package SANS les tests
RUN mvn clean package -DskipTests -Dmaven.test.skip=true

# Étape 2 : Image de production légère
FROM openjdk:17-jdk-slim

WORKDIR /app

# Créer un utilisateur non-root pour la sécurité
RUN groupadd -r spring && useradd -r -g spring spring
RUN mkdir -p /app/logs && chown -R spring:spring /app

# Copier le JAR depuis le stage de build
COPY --from=build /app/target/paymybuddy.jar /app/paymybuddy.jar

# Copier le script d'entrée
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Changer d'utilisateur
USER spring

EXPOSE 8080

# Variables d'environnement (à surcharger en production)
ENV SPRING_DATASOURCE_USERNAME=root
ENV SPRING_DATASOURCE_PASSWORD=password
ENV SPRING_DATASOURCE_URL=jdbc:mysql://192.168.56.10:3306/db_paymybuddy
ENV JAVA_OPTS="-Xmx512m -Xms256m"

ENTRYPOINT ["/app/entrypoint.sh"]
