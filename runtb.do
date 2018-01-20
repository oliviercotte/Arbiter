if [file exists work] {
  vdel -lib ./work -all
}

echo "###"
echo "### Creating library and compiling design ..."
echo "###"

# Création de la librairie de travail
vlib work

# Compilation du module test (DUT)
vlog Arbiter.v

# Compilation du banc de test
# La commande -mfcu indique au compilateur de traiter tout les fichier dans une même unité de compilation.
vlog -mfcu data_defs.sv if_to_arbiter.sv ArbiterTOP.sv transaction.sv Generator.sv Driver.sv Receiver.sv VirtualArbiter.sv Scoreboard.sv TestProgram.sv TestBenchTOP.sv 

# Afficher les vue de debuggage
quietly view *

# Lancement du simulateur et du banc de test
# La commande -t ps spécifie la résolution temporel en picoseconde au simulateur
vsim -t ps work.TestBenchTOP

# Affichage et configuration de la fenêtre de visualisation des traces
add wave -r *

# Couverture fonctionelle
coverage report -detail -cvg -file coverage.txt

# Execution du banc de test pour 14 cycle d'horloge (14 * 200ns)
run 28000000ns
#run 19000ns
