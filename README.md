# Monitux
Server Monitor | Native GNU Edition 🛡️ Dashboard de monitoring ultra-léger &amp; sécurisé. 0% JS complexe, 100% outils natifs GNU/Linux (Top, DF, Systemd). ✅ Stable : Aucune dépendance/base de données. ✅ Sécurité : Protection .htaccess/.htpasswd. Lancez avec start-moni.sh. Simple - Pur - Robuste

![Capture d'écran Monitux](https://raw.githubusercontent.com/simple-group/Monitux/refs/heads/main/screen-shot.png)

==========
          SERVER MONITOR - NATIVE GNU DASHBOARD (Matrix Edition)
==========

[FRANÇAIS]

1. PRÉSENTATION
Ce système de monitoring est conçu pour être ultra-léger, stable et sécurisé. 
Il n'utilise aucune base de données (NoSQL/NoDB), aucun langage serveur complexe
(PHP/Python) et aucune dépendance externe. Il repose à 100% sur les outils 
natifs GNU/Linux.

2. INSTALLATION & LANCEMENT
Pour démarrer la génération des logs et le monitoring en direct :
> Ouvrez un terminal dans le dossier du projet
> Lancez le script principal : bash start-moni.sh

3. AVANTAGES SÉCURITÉ & STABILITÉ
- Fonctions Natives : Utilise uniquement 'top', 'df', 'netstat/ss' et 'systemctl'. 
  Le code est transparent et ne peut pas être corrompu par des failles de 
  bibliothèques tierces (Zero-day JS/PHP).
- Empreinte Ressource : Consommation CPU/RAM proche de zéro.
- Résilience : Tant que le noyau Linux tourne, votre monitoring tourne.

4. SÉCURISATION DES ACCÈS (Apache)
L'accès au dashboard doit être protégé via les fichiers fournis :
- .htaccess : Configure les restrictions d'accès au répertoire.
- .htpasswd : Stocke les identifiants chiffrés.
Assurez-vous qu'Apache autorise les 'AllowOverride All' pour activer ces fichiers.

--------------------------------------------------------------------------------

[ENGLISH]

1. OVERVIEW
This monitoring system is designed to be ultra-lightweight, stable, and secure. 
It uses no databases (NoSQL/NoDB), no complex server-side languages (PHP/Python), 
and no external dependencies. It relies 100% on native GNU/Linux tools.

2. DEPLOYMENT
To start log generation and live monitoring:
> Open a terminal in the project directory
> Run the main script: bash start-moni.sh

3. SECURITY & STABILITY ADVANTAGES
- Native Functions: Uses only 'top', 'df', 'netstat/ss', and 'systemctl'. 
  The code is transparent and cannot be compromised by third-party library 
  vulnerabilities (Zero-day JS/PHP).
- Resource Footprint: CPU/RAM consumption is near zero.
- Resilience: As long as the Linux kernel is running, your monitoring is running.

4. ACCESS SECURITY (Apache)
Dashboard access must be protected using the provided files:
- .htaccess : Configures directory access restrictions.
- .htpasswd : Stores encrypted credentials.
Ensure Apache has 'AllowOverride All' enabled to activate these files.

================================================================================
