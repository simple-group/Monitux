#On initialise le log espace disque
df -h > df-log.txt
date >> df-log-backup.txt
more df-log.txt >> df-log-backup.txt
#On initialise le log des connexion
echo Log connexion > connex.txt
last -i -n 5 >> connex.txt
more connex.txt >> connex-backup.txt
#On initialise le log des services actif
systemctl list-unit-files --type=service | grep enable > srvc-ena.txt
systemctl list-unit-files --type=service > srvc-all.txt
date >> srvc-ena-backup.txt
more srvc-ena.txt >> srvc-ena-backup.txt
date >> srvc-all-backup.txt
more srvc-all.txt >> srvc-all-backup.txt
#On initialise l'écoute d'Apache (nombre de connexion HTTP(S))
date > apache-request.txt
echo Total connexion Apache >> apache-request.txt
lsof -i | grep localhost:http | wc -l >> apache-request.txt
date >> apache-request-log.txt
echo Total connexion Apache >> apache-request-log.txt
lsof -i | grep localhost:http | wc -l >> apache-request-log.txt
lsof -i | grep localhost:http >> apache-request-log.txt
