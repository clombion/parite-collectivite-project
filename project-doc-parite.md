# Projet parité IJBA 2019

## Objectif

Catégoriser les attributions des vice-présidents des collectivités selon une liste de référence.

## To Do

- [x] Créer un script pour associer les catégories des compétences uniques identifiées à la liste des compétences attachée aux députés
- [x] Remettre la liste ordonnée dans la spreadsheet iniale

## Notes

### Données

* Ils ont bien fait de récupérer les compétences uniques telles qu'ortographiées dans le fichier initial, cela a facilité le matching
* Attention à ne pas récupérer les en-têtes en copiant les données

### Code

* Pas mal de temps perdu sur le fait que cat ne travaille correctement qu'avec des lignes, définies par un ou plusieurs caractères suivi de "\n". Cela impact la concatenation avec cat, mais aussi le compte de lignes avec wc
* Attention aussi aux différences des fonctions entre MacOs et Linux (e.g sed -i '')

### Réflexions

L'idée est d'utiliser la capacité de BASH à lire les fichiers ligne par ligne et d'utiliser une boucle qui va prendre la première compétence unique, et, pour chaque ligne du fichiers de compétences attribuées :
	1. Vérifier si la compétence unique est égale à ou une sous-chaîne de caractères de la compétence attribuée
	2. Si oui, ajouter la catégorie correspondante à la compétence sur la même ligne, séparé par une virgule
	3. Si non passer à la ligne suivante
	4. (optionnel) si oui mais qu'une compétence a déjà été associée, la rajouter avec un point virgule

## Actions

TROUVER/RECUPERER

Les données sont récupérées à partir de [la spreadsheet](https://docs.google.com/spreadsheets/d/1emXWQNq5jxjOdcP1pJC-AMf3oA9M_4B_9AFMF0PHTsI/edit#gid=1255871619) des étudiants, puis chaque colonne de données est copiée dans un fichier .txt séparé:
* attributions.txt pour les données des attributions des vice-président.e.s de collectivité
* categories.txt pour les données sur les catégories assignées à chaque attribution
* competences.txt pour les données contentant la liste des valeurs uniques filtrées depuis la liste des attributions

### VERIFIER

Pour vérifier que le nombre de lignes des fichiers textes correspond bien aux nombre de lignes de la feuille de calcul :

`wc -l attributions.txt competences.txt categories.txt`

qui donne :

```shell
7991 attributions.txt
650 competences.txt
650 categories.txt
```

Comme attendu, les fichiers competences et categories sont bien de la même taille, et les tous les fichiers ont un nombre de ligne correspondant à la feuille de calcul.

### NETTOYER

Ici le focus est sur le rapprochement des jeux de données attributions et compétences. Il y a 21 catégories uniques identifiées, et près de 8000 lignes à analyser, d'où l'intérêt de passer par un script. Le processus de construction du script final est décrit ci-après :

**Etape 1**

* comparer une variable avec la liste des catégories. 
* Si égalité, afficher la compétence correspondante
* Répéter pour chaque ligne de categories.txt et competences.txt

var0="administration"

while read -r var1 <&3 && read var2 <&4 
do 
if [ "$var0" == "$var2" ] 
then echo "$var1" 
fi 
done 3<competences.txt 4<categories.txt

> OK

**Etape 2**

* comparer une variable avec la liste des catégories. 
* Si égalité ou si la variable est une substring de la catégorie, afficher la compétence correspondante
* Répéter pour chaque ligne de categories.txt et competences.txt

var0="administration"

while read -r var1 <&3 && read var2 <&4 
do 
if [[ "$var0" == *"$var2"* ]] 
then echo "$var1" 
fi 
done 3<competences.txt 4<categories.txt

> OK

**Etape 3**

* comparer une variable avec la liste des catégories. 
* Si égalité ou si la variable est une substring de la catégorie, afficher la compétence correspondante
* Si différent, écrire "NON"
* Répéter pour chaque ligne de categories.txt et competences.txt

var0="administration"

while read -r var1 <&3 && read var2 <&4 
do 
if [[ "$var0" == *"$var2"* ]] 
then echo "$var1" 
else echo "NON"
fi 
done 3<competences.txt 4<categories.txt

> OK

**Etape 4**

* comparer une variable avec la liste des attributions. 
* Si égalité ou si la variable est une substring de la categorie, afficher la catégorie correspondante
* Si différent, écrire "NON"
* Répéter pour chaque ligne de attributions.txt et categorie.txt

var00="économie"

while read -r var1 <&3 && read var2 <&4 
do 
if [[ "$var00" == *"$var1"* ]] 
then echo "$var2" 
else echo "NON"
fi 
done 3<attributions.txt 4<categories.txt

> NOT OK, la lecture s'arrête à la fin de categories

**Etape 5**

* charger la première ligne de categories.txt dans var1 et la première ligne de competences.txt dans var2
* comparer var2 avec la liste des attributions (var0
* Si égalité ou si la variable est une substring de la categorie, afficher var1
* Si différent, écrire "NON"
* Répéter pour chaque ligne de attributions.txt et categories.txt


while read -r var1 <&3 && read var2 <&4
    do
    while read -r var0 
        do 
        if [[ "${var0}" == *"${var2}"* ]]
        then echo "${var1}"
        else echo ";"
        fi
    done < attributions.txt
done 3<categories.txt 4<competences.txt > file.txt

> Ok, it should produce a number of files equal to the number of lines of var1 and var2 (currently it writes over the same file every loop)

**Etape 6**

* first tested with static var1 and var2 and var3

var1='réussite'; var2="media management"; 
if [[ "${var0}" == *"${var2}"* ]]; then echo "${var1}"; fi

* then tested with looping variable declaration for var0

var1='CATEGORIE'; var2='ressources humaines'; 
while read -r var0; 
do if [[ "${var0}" == *"${var2}"* ]]; 
then echo "${var1}"; 
else echo ""; 
fi; 
done < attributions.txt > test3.txt

* charger la première ligne de categories.txt dans var1 et la première ligne de competences.txt dans var2
* comparer var2 avec la liste des attributions (var0
* Si égalité ou si la variable est une substring de la categorie, afficher var1
* Si différent, écrire ""
* Répéter pour chaque ligne de attributions.txt et categories.txt

let i=0
while read -r var1 <&3 && read var2 <&4
    do
    while read -r var0 
        do 
        if [[ "${var0}" == *"${var2}"* ]]
        then echo "${var1}"
        else echo ";"
        fi
    done < attributions.txt > file_$i.txt
let i+=1
done 3<categories.txt 4<competences.txt

* Pour coller le tout


paste -d "|" file_{0..617}.txt > pastetest2.txt

> Au final, inversion de l'ordre des boucles, car je n'avais pas des résultats cohérents (voir script final)