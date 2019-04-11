#!/usr/bin/env bash

# this script checks attribution.txt and compare each of its line with all of the lines of competences.txt
# if a line of competences.txt is equal to or a substring of the current line of attribution.txt, then 
# the content of categories.txt at the same line of competences.txt is written into a file.
# if there are one or more matches, they are more than one matches, they are written on the same line.
# this produces a list of files equal to the number of lines of attributions.txt
# These files are processed to add a space and an /n, making it possible to concatenate them with cat


define_variables() {
    readonly competences="competences.txt"
    readonly categories="categories.txt"
    readonly attributions="attributions.txt"
}

# creating the files with the validated categories
# each created file is processed in order to remove line breaks and add space between words (if any)

categorisation() {
    local var_att
    local var_cat
    local var_comp
    let i=0
    while read -r var0
        do
        while read -r var1 <&3 && read var2 <&4
            do
            if [[ ${var_att} == *"${var_comp}"* ]]
            then echo "${var_cat} " | tr -d '\n'
            fi
        done 3<${categories} 4<${competences}  > file_$i.txt
    let i+=1
    done < ${attributions}
}

#prepare the files to make sure cat can process them

file_prep() {
    local filename
    for filename in file_*
        do
        echo ' ' >> ${filename}
     sed -i '' -e '$a\' ${filename}
    done
}

#compile everything into the final text

compilation() {
    cat file_* > final.txt
}

#clean up folder

cleanup() {
rm file_*
}

main() {
define_variables
categorisation
file_prep
compilation
cleanup
}