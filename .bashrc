test -e /home/public/admin/bashrc && . /home/public/admin/bashrc


#TrixBash - v0.0.1

#prérequis au fonctionnement
#les couleurs

GREEN='\033[0;32m'
NC='\033[0m'


#lancement-
date
echo -e "${GREEN}[TrixBash]${NC} Bienvenue Dimitri!"
echo -e "${GREEN}€ jhelp ${NC}=> Affiche l'aide des commandes"
echo ""


PS1="${GREEN}€ ${NC}"

#-lancement


# alias
alias main="cd ~"
alias dollar="echo \"dollar is dead\""
alias c="clear"
alias b="bash"
alias cb="c;b"





#_________________________________

#LES FONCTIONS ACTUELLEMENT UTILES
#_________________________________



#fonction J (java(cr) compille&run)
function j(){
START=$(date +%s)
local file="$1.java"
ijavac "$file" && ijava "$1";
echo "   "
END=$(date +%s)
DIFF=$(( END - START )) # temps d'execution
echo -e "${GREEN}[TrixBash]${NC} compilé et exécuté en $DIFF secondes"
};


#fonction JC (java (ijava) create)

function jc() {
	filename="$1.java"
	cat > "$filename" <<EOF
class $1 extends Program {
	void algorithm() {
		println("Basic File");
	}
}
EOF
	echo -e "${GREEN}[TrixBash]${NC} Fichier IJava $filename créé!"
}


#fonction N (quick Nano)

function n() {

if [ -z "$1" ]; then # ouvre le dernier fichier si $1 est vide
	file=$(ls -t |grep -v '\.class$' | head -n 1)
else
	file="$1"
	if [[ "$1" != *.* ]]; then #attribut .java si pas d'extension
		file="$1.java"
	fi
fi

echo -e "${GREEN}[TrixBash]${NC} le fichier ouvert est $file"

if [ "$2" = "-old" ]; then
        nano "$file"
    else
        code "$file"
    fi
#code "$file"

}

#edite directement le fichier dit (bashrc)

function bashedit() {
	nano "/home/infoetu/dimitri.kaimakliotis.etu/.bashrc"
}




#fonction dite de 'listening

function listen() {
    file="$1.java"
    if [ ! -f "$file" ]; then
        echo "Le fichier $file n'existe pas."
        return 1
    fi

    echo -e "${GREEN}Listening Mode activé sur $file ${NC}"
    last_mod_time=$(stat -c %Y "$file")

    while true; do
        current_mod_time=$(stat -c %Y "$file")
        if [ "$current_mod_time" -ne "$last_mod_time" ]; then
            last_mod_time=$current_mod_time
            clear
            echo "Changement détecté sur $file. Compilation et exécution en cours..."
            j "${file%.java}"
        fi
	if read -t 1 -n 1 key; then
            if [ "$key" = "r" ]; then
                clear
                echo -e "${GREEN}Compilation et exécution en cours...${NC}"
                j "${file%.java}"
            fi
        fi
       sleep 1
    done
}


#fuzzion funcs


#jc + listen (create a IJava file and listen to it)

function jcl() {
	jc $1 && listen $1
}

#jc + n (create a file and open it)
function jcn() {
	jc $1 && n
}

#n + listen => open the file and listen to it at the same time
function nl() {
	n $1 && listen $1
}



#fonction d'aides

function jhelp() {
    echo "Aide des commandes disponibles :"
    echo ""
    echo "1. j (Java Compile & Run)"
    echo "   Description : Compile et exécute un fichier IJava."
    echo "   Utilisation : j NomDuFichierSansExtension"
    echo "                Compile et exécute NomDuFichier.java."
    echo ""
    echo "2. jc ((i)Java Create)"
    echo "   Description : Crée un fichier IJava basique avec un squelette prédéfini."
    echo "   Utilisation : jc NomDuFichierSansExtension"
    echo "                Crée un fichier NomDuFichier.java avec le squelette par défaut."
    echo ""
    echo "3. n (Quick Nano)"
    echo "   Description : Ouvre un fichier dans un éditeur texte (par défaut nano)."
    echo "   Utilisation :"
    echo "                - n NomDuFichierSansExtension : Ouvre NomDuFichier.java par défaut."
    echo "                - n : Ouvre le fichier le plus récemment modifié dans le dossier (en excluant les .class)."
    echo "                - n FILENAME -old : Ce paramètre permet d'utiliser Nano au lieu de VScode"
    echo ""
    echo "4 . listen (IJava Listening)"
    echo "   Description: Permet d'écouter un fichier IJava. Le fichier se compile et s'execute en temps réel."
    echo "   Utilisation: "
    echo "		  - listen NomDuFichierSansExtension: Ecoute le fichier .java"
    echo ""
    echo "5. Command Fuzzer (Mélanger des commandes facilement)"
    echo "		   Commandes disponibles: * jcl // jcn // nl // (faire doc..)"
}


