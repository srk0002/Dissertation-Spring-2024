#!/bin/bash
#
#   load the module
source /apps/profiles/modules_asax.sh.dyn
module load anaconda/3-2020.02
#
#   place commands here
#version 1.13

path=./

for dir in ${path}/*.fasta
do
    prokka ${dir} --genus Salmonella -o ${dir}_prokka
done
