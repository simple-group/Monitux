#!/bin/bash
#simple_sysadmin2.sh
#Auteur: Brice Cornet
#Donne vue sur le CPU, RAM, DISQUE

#Initialisation les compteurs
cpt=0
cptlog=0

#Limitation du nombre d'affichage à l'écran
limite=2

#Limitation longueur des logs
limitelog=44444

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

#On boucle en continu
while true
   do   
   # CPU
	#On mesure le CPU et on stocke l'info
		w -f >> monitoring-cpu-log.txt
		echo >> monitoring-cpu-log.txt
		echo >> monitoring-cpu-log.txt
		free -h >> monitoring-cpu-log.txt
		echo >> monitoring-cpu-log.txt
		echo >> monitoring-cpu-log.txt
		ps -Ao user,uid,comm,pid,pcpu,tty --sort=-pcpu | head -n 12 >> monitoring-cpu-log.txt
		echo >> monitoring-cpu-log.txt
		echo -------------------------------------------------------------- $cptlog >> monitoring-cpu-log.txt
	# TOP 
	date >> top.txt
	echo >> top.txt
	iostat -x >> top.txt
	echo >> top.txt
	top -n 1 >> top.txt
	echo >> top.txt
	more top.txt >> top-backup.txt
   done
   
