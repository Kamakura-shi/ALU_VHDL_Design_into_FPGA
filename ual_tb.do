# ============================ ual_tb.do ================================
# ELE344 - Projet 1 : Testbench pour UAL
# Ce script compile, simule et affiche les signaux du testbench UAL_tb
# =======================================================================

# 1) Aller dans le répertoire de travail (adapter si besoin)
cd h:/ELE344/Projet1/src

# 2) Créer la librairie work
vlib work

# 3) Compiler tous les fichiers nécessaires (adapter la liste si besoin)
vcom -93 -work work txt_util.vhd
vcom -93 -work work ual.vhd
vcom -93 -work work ual_tb.vhd

# 4) Démarrer la simulation avec le testbench
vsim work.UAL_tb

# 5) Ouvrir les fenêtres de structure, signaux et formes d'ondes
view structure
view signals
view wave

# 6) Ajouter tous les signaux du testbench et du design sous test
add wave -r *

# 7) Lancer la simulation (adapter la durée si besoin)
run 2 ms

# 8) Fin du script
echo "Simulation terminée. Vérifiez le fichier ual_sorties.txt pour les résultats."