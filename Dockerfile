# Étape 1 : Construire l'application
FROM maven:3.8.5-openjdk-17 AS build

# Copier le projet dans le conteneur
COPY . /app

# Changer de répertoire
WORKDIR /app

# Construire l'application
#RUN mvn clean package
RUN mvn clean install

# Étape 2 : Créer l'image à partir du jar
FROM openjdk:17-jdk-slim

# Créer un répertoire pour l'application
WORKDIR /app
RUN mkdir -p /app/logs

# Copier le fichier jar généré par Maven
#COPY --from=build /app/target/PayMyBuddy-0.0.1-SNAPSHOT.jar /app/app.jar
COPY --from=build /app/target/paymybuddy.jar /app/paymybuddy.jar

# Copier le script de démarrage
COPY entrypoint.sh /app/entrypoint.sh

# Rendre le script exécutable
RUN chmod +x /app/entrypoint.sh

# Exposer le port utilisé par Spring Boot
EXPOSE 8080

# Variables d'environnement de connexion à la BD
ENV SPRING_DATASOURCE_USERNAME=root
ENV SPRING_DATASOURCE_PASSWORD=password
ENV SPRING_DATASOURCE_URL=jdbc:mysql://172.17.0.1:3306/db_paymybuddy

# Démarrer l'application
ENTRYPOINT ["/app/entrypoint.sh"]
