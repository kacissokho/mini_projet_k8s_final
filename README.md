Rapport de Déploiement PayMyBuddy sur Kubernetes

🚀 Aperçu du Projet

Ce projet consiste au déploiement de l'application PayMyBuddy (une application Spring Boot de transfert d'argent entre amis) sur un cluster Kubernetes en utilisant des manifests YAML natifs plutôt que Helm. L'objectif est de comprendre en profondeur les mécanismes de déploiement Kubernetes.

Repository Source : 

 https://github.com/OlivierKouokam/PayMyBuddy/ 

🏗️ Architecture du Déploiement

Composants Déployés

Composant

Type

Réplicas

Port

Stockage

MySQL 

Deployment + ClusterIP 

1 

3306 

/data/mysql 

PayMyBuddy 

Deployment + NodePort 

1 

8080 

/data/paymybuddy 

Schéma d'Architecture

┌─────────────────┐    ┌──────────────────┐
│   Utilisateur   │───▶│  Service NodePort │
└─────────────────┘    │    Port: 30081    │
                       └──────────────────┘
                                │
                                ▼
┌─────────────────┐    ┌──────────────────┐
│  PayMyBuddy App │◄───│ PayMyBuddy Pod   │
│   Spring Boot   │    │   Port: 8080     │
└─────────────────┘    └──────────────────┘
         │                        │
         ▼                        │
┌─────────────────┐    ┌──────────────────┐
│  MySQL Database │◄───│  MySQL Pod       │
│                 │    │   Port: 3306     │
└─────────────────┘    └──────────────────┘

📁 Manifests Kubernetes

1. Déploiement MySQL (mysql-deployment.yaml)

Objectifs :

Déployer une instance MySQL unique

Configurer la base de données db_paymybuddy

Persister les données sur le host



2. Service MySQL (mysql-service.yaml)

Objectifs :

Exposer MySQL en interne dans le cluster

Fournir un DNS stable (mysql-service)

Type ClusterIP pour la sécurité

3. Déploiement PayMyBuddy (paymybuddy-deployment.yaml)

Objectifs :

Déployer l'application Spring Boot

Configurer la connexion à MySQL

Persister les données applicatives

Variables d'Environnement (extraites du Dockerfile) :

env:
- name: SPRING_DATASOURCE_USERNAME
  value: "root"
- name: SPRING_DATASOURCE_PASSWORD
  value: "password"
- name: SPRING_DATASOURCE_URL
  value: "jdbc:mysql://mysql-service:3306/db_paymybuddy"

4. Service PayMyBuddy (paymybuddy-service.yaml)

Objectifs :

Exposer l'application vers l'extérieur

Type NodePort pour l'accès direct

Port  30081 l'accès utilisateur

🛠️ Procédure de Déploiement

Prérequis

minikube configuré

Étapes de Déploiement

Cloner le Repository

git clone <https://github.com/OlivierKouokam/PayMyBuddy.git>
cd PayMyBuddy

Construire l'Image Docker

docker build -t paymybuddy:latest .

Appliquer les Manifests

# Créer les répertoires de données
sudo mkdir -p /data/mysql
sudo mkdir -p /data/paymybuddy

# Déployer les ressources Kubernetes
kubectl apply -f mysql-deployment.yaml
kubectl apply -f mysql-service.yaml
kubectl apply -f paymybuddy-deployment.yaml
kubectl apply -f paymybuddy-service.yaml

Vérifier le Déploiement

Les deployments:

kubectl get deploy



kubectl get svc



kubectl get po





💾 Gestion du Stockage

Stratégie de Persistance

Composant

Chemin Container

Chemin Host

Type

MySQL 

/var/lib/mysql 

/data/mysql 

hostPath 

PayMyBuddy 

/app/data 

/data/paymybuddy 

hostPath 

Avantages :

Simplicité de mise en œuvre

Accès direct aux données

Pas de configuration complexe de volumes persistants



🔒 Sécurité et Réseau

Politique de Sécurité

MySQL en ClusterIP : Non accessible de l'extérieur

PayMyBuddy en NodePort : Accessible uniquement sur le port spécifique

Isolation : Les pods communiquent via le réseau interne Kubernetes

Ports Exposés

Service

Port Interne

Port Externe

Accès

MySQL 

3306 

Aucun 

Cluster interne 

PayMyBuddy 

8080 

30081 

Public 

🚀 Accès à l'Application

Une fois déployée, l'application est accessible à l'adresse :

http://192.168.56.10:30081




📝 Conclusion

Ce déploiement démontre une architecture Kubernetes complète pour une application Spring Boot avec base de données MySQL.

Statut : ✅ Déploiement réussi  

