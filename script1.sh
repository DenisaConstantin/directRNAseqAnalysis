#!/usr/bin/env bash

for i in *.fastq
do
mkdir ${i%.fastq}

NanoPlot --fastq $i -o ${i%.fastq}"_NanoPlot"

minimap2 -a -x map-ont -k14 --for-only $1 $i > ${i%.fastq}".sam"

samtools view -S -b ${i%.fastq}".sam" > ${i%.fastq}".fol.bam"
samtools sort -o ${i%.fastq}".sort.bam" ${i%.fastq}".fol.bam"
samtools index ${i%.fastq}".sort.bam"

NanoCount -i ${i%.fastq}".sort.bam" -o ${i%.fastq}".NanoCount.txt" -b ${i%.fastq}".NanoCount.bam"

done

grep ">" $1 | sed 's/>//g' > headers.inf.txt

awk -F " |=|;" '{print $1,$12,$24}' headers.inf.txt > FBtr_FBgn.inf.txt

for i in *.NanoCount.txt; do awk 'FNR==NR {a[$1]; next} $1 in a' $i FBtr_FBgn.inf.txt > ${i%.NanoCount.txt}".gene.txt"; done

for i in *.gene.txt
do
awk -F " " '{print $3}' $i > ${i%.gene.txt}".num.txt"
sort -u ${i%.gene.txt}".num.txt" > ${i%.gene.txt}".de.numarat.txt"
gene=$( wc -l < ${i%.gene.txt}".de.numarat.txt" ) 
transcripts=$( wc -l < $i )
echo $i $transcripts $gene >> Results.csv
done

rm -r *.de.numarat.txt *.num.txt *.inf.txt
for i in *.NanoCount.txt; do mv $i ${i%.NanoCount.txt}/; done
for i in *.NanoCount.bam; do mv $i ${i%.NanoCount.bam}/; done
for i in *.sam; do mv $i ${i%.sam}/; done
for i in *.sort.bam.bai; do mv $i ${i%.sort.bam.bai}/; done
for i in *.fol.bam; do mv $i ${i%.fol.bam}/; done
for i in *.sort.bam; do mv $i ${i%.sort.bam}/; done
