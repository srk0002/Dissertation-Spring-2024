#!/bin/sh
#Script for runing spades with user input
#### Make sure the --threads argument (-t) matches the number of CPUs requested


####   submit job to class queue as "this_script_name"   ####
####       request 16 CPU, and dmc as the cluster        ####
##########Setup Environment###########
source /opt/asn/etc/asn-bash-profiles-special/modules.sh
module load spades/3.13.0


###Commands for user prompts when not utilizing queue system
#echo "Input filename: "input_file
#read input_file
#echo "Input path to fastq files: "path
#read path
#if test -f "$input_file"; then
#    while read F  ; do
#        echo $F
#        declare -a sample_list=($F)
#        for sample in ${sample_list[@]}; do
#        spades.py -o $sample -1 $path/${sample}_1.fastq.gz -2 $path/${sample}_2.fastq.gz -k 21,33,55 --careful -t 16
#        done
#    done <$input_file
#else
#    echo "$input_file not found. Aborting!!!!"
#fi

#exit


######################################################################################
#Below is a queue option
################Define path to fastq files
#path=/scratch/AU_BIOL-7180_GrpProject/samples_Salmonella_muenster/
path=~/scripts/


#Create a text file of isolates for assembly
#> sal_assembly_list.txt

#Add each set of SRR reads within the path directory
#for isonm in ${path}*_1.fastq.gz; do
#    iso=$(basename $isonm)
#    file_nm=${iso%_1.*}

#    echo ${file_nm} >> sal_assembly_list.txt
#done
#for isonm in ${path}*.fastq.gz; do
#    iso=$(basename $isonm)
#    file_nm=${iso%.fastq.gz}

#    echo ${file_nm} >> sal_assembly_list.txt
#done
#Commands for Automated SPAdes assembly
#input_file=sal_assembly_list.txt
input_file=parent_list.txt
#if test -f "$input_file"; then
#    while read F  ; do
#        echo $F
#        declare -a sample_list=($F)
sample_list=$(cat ${input_file})
       for sample in ${sample_list[@]}; do
       #spades.py -o $sample --hqmp1-12 $path/${sample}.fastq.gz -k 21,33,55,77 --careful -t 16
       spades.py -o ~/scripts/${sample}/${sample}_spades_assembly_jan_2023 -1 $path/${sample}/${sample}_1.fastq.gz -2 $path/${sample}/${sample}_2.fastq.gz -k 21,33,55 --careful -t 16
       done
    #done <$input_file
#else
#    echo "$input_file not found. Aborting!!!!"
#fi

#Remove the list generated of assemblies
#rm sal_assembly_list.txt

exit
