#!/bin/bash
#simple_sysadmin2.sh
#Auteur: Brice Cornet
#Lancer le service

bash ./simple_sysadmin2.sh & 
ps -x | grep simple_sysadmin2 > id-processus.txt
