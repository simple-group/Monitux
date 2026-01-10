#!/bin/bash
# simple_sysadmin2.sh
# Version Finale : Debug + Optimisation Performance (lsof -n)

# --- CONFIGURATION ---
export TERM=xterm
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
cd "$(dirname "$0")" || exit 1

# Fonction pour horodater les logs debug à l'écran uniquement
# log_debug() {
#    echo "--- [DEBUG $(date +%T)] $1 ---"
# }

# log_debug "Démarrage du script"

# --- DETECTION DES OUTILS ---
HAS_IOSTAT=0; [ -x "$(command -v iostat)" ] && HAS_IOSTAT=1
HAS_SYSTEMCTL=0; [ -x "$(command -v systemctl)" ] && HAS_SYSTEMCTL=1
# On vérifie lsof ET timeout (timeout est vital pour éviter les blocages)
HAS_LSOF=0; [ -x "$(command -v lsof)" ] && HAS_LSOF=1
HAS_TIMEOUT=0; [ -x "$(command -v timeout)" ] && HAS_TIMEOUT=1

# Prefixe de commande sécurisée (Si timeout existe, on limite à 3 secondes)
if [ $HAS_TIMEOUT -eq 1 ]; then
    CMD_SAFE="timeout 3"
else
    CMD_SAFE=""
fi

# --- INITIALISATION ---
cpt=0
cptlog=0
limite=3
limitelog=28000

# Création des fichiers
# log_debug "Création des fichiers..."
for f in monitoring-cpu-log.txt top.txt df-log.txt srvc-ena.txt srvc-all.txt connex.txt apache-request.txt; do
    echo > "$f"
done

# > DF
# log_debug "Log Espace Disque..."
{ date; df -h; } >> df-log.txt
cat df-log.txt >> df-log-backup.txt

# > CONNEXIONS
# log_debug "Log Connexions (last)..."
$CMD_SAFE last -i -n 5 >> connex.txt 2>/dev/null
cat connex.txt >> connex-backup.txt

# > SERVICES
# log_debug "Log Services..."
if [ $HAS_SYSTEMCTL -eq 1 ]; then
    $CMD_SAFE systemctl list-unit-files --type=service | grep enabled >> srvc-ena.txt 2>/dev/null
    $CMD_SAFE systemctl list-unit-files --type=service >> srvc-all.txt 2>&1
else
    echo "Systemctl introuvable" >> srvc-ena.txt
fi
cat srvc-ena.txt >> srvc-ena-backup.txt
cat srvc-all.txt >> srvc-all-backup.txt

# > APACHE (C'est là que ça plantait)
# log_debug "Log Apache (lsof)..."
date > apache-request.txt
echo "Total connexion Apache" >> apache-request.txt

if [ $HAS_LSOF -eq 1 ]; then
    # CORRECTION MAJEURE : Ajout de -n -P pour éviter la résolution DNS lente
    # On cherche directement les ports 80 (http) et 443 (https)
    # wc -l compte les lignes
    count=$($CMD_SAFE lsof -n -P -i :80,443 2>/dev/null | wc -l)
    echo "$count" >> apache-request.txt
    
    # Log détaillé
    date >> apache-request-log.txt
    echo "Total connexion Apache: $count" >> apache-request-log.txt
    $CMD_SAFE lsof -n -P -i :80,443 >> apache-request-log.txt 2>/dev/null
else
    echo "lsof introuvable" >> apache-request.txt
fi

# log_debug "Entrée dans la boucle infinie..."

# --- BOUCLE ---
while true; do   
    cpt=0
    
    while [ $cpt -lt $limite ]; do   
        # --- CPU ---
        {
            date
            echo "--------------------------------"
            ps -Ao user,uid,comm,pid,pcpu --sort=-pcpu | head -n 12
            echo "Compteur log: $cptlog"
            echo -e "\n\n"
        } >> monitoring-cpu-log.txt

        # --- TOP & IO ---
        {
            date
            echo "--- UTILISATEURS ---"
            w -f 2>/dev/null || echo "w non dispo"
            echo "--- MEMOIRE ---"
            free -h 2>/dev/null || echo "free non dispo"
            echo "--- STATS IO ---"
            if [ $HAS_IOSTAT -eq 1 ]; then
                $CMD_SAFE iostat -p 1 1 | tail -n +3
            else
                echo "iostat non dispo"
            fi
            echo "--- TOP ---"
            # Top en mode batch sécurisé
            $CMD_SAFE top -b -n 1 | head -n 20
        } > top.txt 2>&1

        # Validation visuelle
        # if [ $cpt -eq 0 ]; then
        #     log_debug "Cycle OK - Logs mis à jour (Compteur: $cptlog)"
        # fi

        cpt=$((cpt+1))
        cptlog=$((cptlog+1))

        # --- PERIODIQUE (30) ---
        if [ $((cptlog % 30)) -eq 0 ]; then
            # log_debug "Tâche périodique (30)..."
            if [ $HAS_SYSTEMCTL -eq 1 ]; then
                $CMD_SAFE systemctl list-unit-files --type=service | grep enabled > srvc-ena.txt
                cat srvc-ena.txt >> srvc-ena-backup.txt
            fi
            
            if [ $HAS_LSOF -eq 1 ]; then
                # On utilise la version rapide ici aussi
                echo "Total Apache: $($CMD_SAFE lsof -n -P -i :80,443 2>/dev/null | wc -l)" > apache-request.txt
            fi
        fi
        
        # --- PERIODIQUE (100) ---
         if [ $((cptlog % 100)) -eq 0 ]; then
            # log_debug "Tâche périodique (100)..."
            df -h > df-log.txt
            cat df-log.txt >> df-log-backup.txt
            $CMD_SAFE last -i -n 5 > connex.txt
            cat connex.txt >> connex-backup.txt
        fi

        sleep 17

        # Reset logs
        if [ "$cptlog" -ge "$limitelog" ]; then
            # log_debug "RESET DES LOGS (Limite atteinte)"
            echo "Reset logs" > monitoring-cpu-log-backup.txt
            cptlog=0
        fi
    done

    # Backup fin de petit cycle
    cat monitoring-cpu-log.txt >> monitoring-cpu-log-backup.txt
    cat top.txt >> top-backup.txt
    # echo "--- Nouveau Cycle $(date) ---" > monitoring-cpu-log.txt
done
