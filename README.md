Rapport de Déploiement PayMyBuddy sur Kubernetes

🚀 Aperçu du Projet

Ce projet consiste au déploiement de l'application PayMyBuddy (une application Spring Boot de transfert d'argent entre amis) sur un cluster Kubernetes en utilisant des manifests YAML natifs plutôt que Helm. L'objectif est de comprendre en profondeur les mécanismes de déploiement Kubernetes.

Repository Source :  
PayMyBuddy GitHub

📁 Manifests Kubernetes

Déploiement MySQL (mysql-deployment.yaml)

   Objectifs :
   
     Déployer une instance MySQL unique
     Configurer la base de données db_paymybuddy
     Persister les données sur le host

Service MySQL (mysql-service.yaml)

   Objectifs :
   
     Exposer MySQL en interne dans le cluster
     Fournir un DNS stable (mysql-service)
     Type ClusterIP pour la sécurité

Déploiement PayMyBuddy (paymybuddy-deployment.yaml)

   Objectifs :
   
     Déployer l'application Spring Boot
     Configurer la connexion à MySQL
     Persister les données applicatives
   
   
   Service PayMyBuddy (paymybuddy-service.yaml)
   
   Objectifs :
   
     Exposer l'application vers l'extérieur
     Type NodePort pour l'accès direct
     Port 30081 pour l'accès utilisateur

🛠️ Procédure de Déploiement*:

Prérequis:

  minikube configuré

Étapes de Déploiement:

 Cloner le Repositorybash:
 git clone https://github.com/OlivierKouokam/PayMyBuddy.git
 cd PayMyBuddy
   
Construire l'Image Docker:
   
   docker build -t paymybuddy:latest .
   
Appliquer les Manifests: 
Créer les répertoires de données:

   sudo mkdir -p /data/mysql
   sudo mkdir -p /data/paymybuddy
   
Déployer les ressources Kubernetes:

   kubectl apply -f mysql-deployment.yaml
   kubectl apply -f mysql-service.yaml
   kubectl apply -f paymybuddy-deployment.yaml
   kubectl apply -f paymybuddy-service.yaml
   
   Vérifier le Déploiement:
   Les deployments :
   
      kubectl get deploy
   
   Services :
   
      kubectl get svc
   
   Pods :
   
      kubectl get po
   
💾 Gestion du Stockage

Stratégie de Persistance

Composant MySQL:

  Chemin Container : /var/lib/mysql

  Chemin Host : /data/mysql

  Type : hostPath

Composant PayMyBuddy:

  Chemin Container : /app/data

  Chemin Host : /data/paymybuddy

  Type : hostPath

Avantages :

 Simplicité de mise en œuvre
 Accès direct aux donnéesh
 Pas de configuration complexe de volumes persistants

🔒 Sécurité et Réseau

Politique de Sécurité

MySQL en ClusterIP : Non accessible de l'extérieur

PayMyBuddy en NodePort : Accessible uniquement sur le port spécifique

Isolation : Les pods communiquent via le réseau interne Kubernetes

Service MySQL :

Port Interne : 3306
Port Externe : Aucun
Accès : Cluster interne

Service PayMyBuddy :

Port Interne : 8080
Port Externe : 30081
Accès : Public

🚀 Accès à l'Application

Une fois déployée, l'application est accessible à l'adresse :
http://192.168.56.10:30081

📝 Conclusion
Ce déploiement démontre une architecture Kubernetes complète pour une application Spring Boot avec base de données MySQL.

Statut : ✅ Déploiement réussi

