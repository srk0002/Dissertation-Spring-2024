#!/bin/bash

#This script will be used to download raw read data from the sequence read archive (SRA in NCBI) using SRR numbers availible for each sample.
#This requires use of SRA Toolkit on the ASC.
#
##########Queue Information Based on SampleTest Data###########
#Core=1 Mem=1gb (efficiency a for test_sample1 was 0.49% at 2gb) Wall time=Default (runtime for test_sample1 was 7 minutes)
##########Make Sample List Array##
#declare -a sample_list=("SRR10740748" "SRR10740747" "SRR10740746" "SRR10740745" "SRR10740744" "SRR10740743" "SRR10740742" "SRR10740741" "SRR10740740" "SRR10740739")

##########Variables###############
#sample_list= assigned earlier by array in above script
#test_sample1=SRR10740748
##################################
#
##########Setup Environment#######
module load sra
#
##########Commands################
path=/scratch/AU_BIOL-7180_GrpProject/Sal_muensters/

input_file=sal_muenster.txt
if test -f "$input_file"; then
    while read F ; do
        echo $F
        declare -a sample_list=($F)
        for sample in ${sample_list[@]}; do
            fastq-dump --outdir $path --split-files -gzip $sample #Uses fastq-dump to retrieve raw read fastq files and split them based on paired-end data in compressed formats.
#fastq-dump --split-files -gzip $test_sample1
    done

else
    echo "$input_file not found. Aborting!!!!"
fi

exit
