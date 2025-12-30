#!/bin/bash
#simple_sysadmin2.sh
#Auteur: Brice Cornet
#Donne vue sur le CPU, RAM, DISQUE

#Initialisation les compteurs
cpt=0
cptlog=0

#Limitation du nombre d'affichage à l'écran
limite=3

#Limitation longueur des logs
# Une journée = 7000 occurences
limitelog=28000

#On clean les différents logs
echo > monitoring-cpu-log.txt
echo > monitoring-cpu-log-backup.txt
echo > top.txt
echo > top-backup.txt
echo > df-log.txt
echo > df-log-backup.txt
echo > srvc-ena.txt
echo > srvc-ena-backup.txt
echo > srvc-all.txt
echo > srvc-all-backup.txt
echo > connex.txt
echo > connex-backup.txt
echo > apache-request.txt
echo > apache-request-log.txt

#On initialise le log espace disque
date > df-log.txt
echo >> df-log.txt
df -h >> df-log.txt
more df-log.txt >> df-log-backup.txt
#On initialise le log des connexion
last -i -n 5 > connex.txt
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

#On boucle en continu
while true
   do   
   while test $cpt != $limite;
		do   
		date >> monitoring-cpu-log.txt
		echo >> monitoring-cpu-log.txt
		ps -Ao user,uid,comm,pid,pcpu,tty --sort=-pcpu | head -n 12 >> monitoring-cpu-log.txt
		echo >> monitoring-cpu-log.txt
		echo -------------------------------- $cptlog >> monitoring-cpu-log.txt
		echo >> monitoring-cpu-log.txt
		echo >> monitoring-cpu-log.txt
		w -f > top.txt
		echo >> top.txt
		free -h >> top.txt
		echo >> top.txt
		echo >> top.txt
		iostat -p >> top.txt
		echo >> top.txt
		top -n 1 -b >> top.txt
		echo >> top.txt
			#Incrémetation
			cpt=$((cpt+1))
			cptlog=$((cptlog+1))
				#Ca ne sert à rien de mesurer non stop espace disque, donc on ne le fait que toutes les 100 occurences compteur
				if ! (( $cptlog % 100 ))
					then
						df -h > df-log.txt
						date >> df-log-backup.txt
						more df-log.txt >> df-log-backup.txt
						echo >> df-log-backup.txt
						#Idem pour les log de connexion
						more connex.txt >> connex-backup.txt
						echo Log connexion > connex.txt
						last -i -n 5 > connex.txt
					fi	
				#Même logique pour les services et Apache que l'on va juste interroger toutes les 10 minutes
				if ! (( $cptlog % 30 ))
					then
						#Etat des services
						systemctl list-unit-files --type=service | grep enable > srvc-ena.txt
						systemctl list-unit-files --type=service > srvc-all.txt
						echo >> srvc-ena-backup.txt
						date >> srvc-ena-backup.txt
						more srvc-ena.txt >> srvc-ena-backup.txt
						echo >> srvc-all-backup.txt
						date >> srvc-all-backup.txt
						more srvc-all.txt >> srvc-all-backup.txt
						#Idem pour l'écoute d'Apache
						date > apache-request.txt
						echo Total connexion Apache >> apache-request.txt
						lsof -i | grep localhost:http | wc -l >> apache-request.txt
						echo >> apache-request-log.txt
						date >> apache-request-log.txt
						echo Total connexion Apache >> apache-request-log.txt
						lsof -i | grep localhost:http | wc -l >> apache-request-log.txt
						lsof -i | grep localhost:http >> apache-request-log.txt
					fi
		#On attend 17 sec ce qui totalise avec l'exécution 20 secondes
		sleep 17
			#On regarde s'il faut nettoyer les log de backup
			if [[ "$cptlog" == "$limitelog" ]]; 
				then 
					echo > monitoring-cpu-log-backup.txt
					echo > df-log-backup.txt
					echo > srvc-ena-backup.txt
					echo > srvc-all-backup.txt
					echo > top-backup.txt
					echo > connex-backup.txt
					echo > apache-request-log.txt
					cptlog=0
				fi
		done
      #On backup les log dans le deuxième affichage
      echo >> monitoring-cpu-log-backup.txt
      more monitoring-cpu-log.txt >> monitoring-cpu-log-backup.txt
      echo >> top-backup.txt
      more top.txt >> top-backup.txt
      #Clean l'affichage du monitoring CPU
      echo > monitoring-cpu-log.txt
      #echo > top.txt
      cpt=0
   done
   
