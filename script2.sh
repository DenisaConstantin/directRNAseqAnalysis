#!/usr/bin/env bash

sort $1 > ${1%.gene.txt}".gene.sorted.txt"
sort $2 > ${2%.gene.txt}".gene.sorted.txt"

comm -12 ${1%.gene.txt}".gene.sorted.txt" ${2%.gene.txt}".gene.sorted.txt" >> Results_common_${1%.gene.txt}_${2%.gene.txt}".txt"

comm -23 ${1%.gene.txt}".gene.sorted.txt" ${2%.gene.txt}".gene.sorted.txt" >> Results_specific_${1%.gene.txt}".txt"

comm -13 ${1%.gene.txt}".gene.sorted.txt" ${2%.gene.txt}".gene.sorted.txt" >> Results_specific_${2%.gene.txt}".txt"

for i in *.gene.txt; do cp $i ${i%.gene.txt}/; done

mkdir Results
for i in Results*; do mv $i Results/; done
