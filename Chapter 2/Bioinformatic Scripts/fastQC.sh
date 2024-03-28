#!/bin/sh

#FastQC is a tool used to provide an overview of basic quality control metrics for
#raw next generation sequencing data.

#This script will automate quality assessment on genomes located in path

#Path to genomes
#path=/scratch/AU_BIOL-7180_GrpProject/samples_Salmonella_muenster
path=~/scripts/

####################Set up the environment###################
source /opt/asn/etc/asn-bash-profiles-special/modules.sh
module load fastqc/0.10.1

###################List Commands Here########################

#for do done loop to run fastqc on all .fastq.gz files in path directory
#If sequence files have been unzipped, remove .gz in line 15.
declare -a sample_list=("SRR2104591" "SRR1752832")

#for file in *.fastq.gz
for sample in ${sample_list[@]};
do
   #fastqc $file;
    fastqc ${sample}_1.fastq.gz
    fastqc ${sample}_2.fastq.gz
done

exit
