#!/bin/bash
#
# script to run GATK
#
# setup to use gatk
source /apps/profiles/modules_asax.sh.dyn
module load mummer4/4.0.0rc1
# place mummer command after this line
path=~/spades_phd
nucmer --prefix=nuc_par_mut $path/parent_scaffolds.fasta $path/mutant_scaffolds.fasta

show-snps  *.delta

dnadiff --prefix=dnadiff_par_mut $path/parent_scaffolds.fasta $path/mutant_scaffolds.fasta



