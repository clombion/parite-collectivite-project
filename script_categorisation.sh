#!/usr/bin/env bash

# this script checks attribution.txt and compare each of its line with all of the lines of competences.txt
# if a line of competences.txt is equal to or a substring of the current line of attribution.txt, then 
# the content of categories.txt at the same line of competences.txt is written into a file.
# if there are one or more matches, they are more than one matches, they are written on the same line.
# this produces a list of files equal to the number of lines of attributions.txt
# These files are processed to add a space and an /n, making it possible to concatenate them with cat

# creating the files with the validated categories
let i=0
while read -r var0
    do
    while read -r var1 <&3 && read var2 <&4
        do
        if [[ ${var0} == *"${var2}"* ]]
        then echo "${var1} " | tr -d '\n'
        fi
    done 3<categories.txt 4<competences.txt  > file_$i.txt
let i+=1
done < attributions.txt

#prepare the files to make sure cat can process them
let j=0
for j in file_*
    do
    echo ' ' >> $j
    sed -i '' -e '$a\' $j
done

#compile everything into the final text
cat file_* > final.txt

#clean up folder
rm file_*