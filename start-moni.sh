#!/bin/bash
# launcher_sysadmin.sh
# Auteur: Brice Cornet (Modifié pour Crontab)
# Objectif: Vérifier si simple_sysadmin2.sh tourne. Si non, le lancer.

# 1. IMPORTANT : Se placer dans le répertoire où se trouve ce script
# Cela permet à Crontab de trouver "simple_sysadmin2.sh" sans erreur de chemin.
cd "$(dirname "$0")"

# Nom du script à surveiller
SCRIPT_TO_CHECK="simple_sysadmin2.sh"

# 2. Vérification
# pgrep -f cherche si un processus contient le nom du script.
# > /dev/null cache le résultat visuel, on veut juste le code de retour (succès ou échec).
if pgrep -f "$SCRIPT_TO_CHECK" > /dev/null; then
    # CAS 1 : Le script tourne déjà.
    # On ne fait rien (ou on peut l'écrire dans un log si besoin)
    echo "$(date): Le service tourne déjà." >> launcher_log.txt
else
    # CAS 2 : Le script ne tourne pas. On le lance.
    echo "$(date): Service arrêté. Démarrage en cours..." >> launcher_log.txt
    
    bash ./$SCRIPT_TO_CHECK & 
    
    # On met à jour le fichier id-processus comme demandé
    # Note: On exclut la commande grep elle-même pour plus de propreté avec "grep -v grep"
    ps -x | grep $SCRIPT_TO_CHECK | grep -v grep > id-processus.txt
fi

# ------------------------------------------------------------------
# INSTRUCTIONS POUR CRONTAB (INSTALLATION)
# ------------------------------------------------------------------
# 1. Rendez ce script exécutable via la commande :
#    chmod +x launcher_sysadmin.sh
#
# 2. Ouvrez l'éditeur Crontab avec la commande :
#    crontab -e
#
# 3. Ajoutez la ligne suivante à la fin du fichier pour exécuter ce test
#    toutes les heures (à la minute 0) :
#
#    0 * * * * /chemin/absolu/vers/votre/dossier/start-moni.sh
#
#    (Remplacez "/chemin/absolu/..." par le vrai chemin, 
#     par exemple : /home/brice/scripts/start-moni.sh)
#
# 4. Sauvegardez et quittez (Ctrl+X, puis Y, puis Entrée si vous êtes sur nano).
# ------------------------------------------------------------------
