#!/bin/sh
#
#  load the module
source /apps/profiles/modules_asax.sh.dyn
module load quast/5.2.0
#
# Path for directory for SPAdes assemblies

# Path for reference Salmonella Muenster for comparison of assembly analysis
#pathref=/scratch/AU_BIOL-7180_GrpProject/reference_genome/ncbi-genomes-2020-03-23/GCF_001246125.1_Salmonella_enterica_CVM_N51250_v1.0_genomic.fna

# place command here
    quast.py -o muenster_quast --threads 4 --circos --gene-finding ./SRR10740739.fasta ./SRR10740740.fasta ./SRR10740741.fasta ./SRR10740742.fasta ./SRR10740743.fasta ./SRR10740744.fasta ./SRR10740745.fasta ./SRR10740746.fasta ./SRR10740747.fasta ./SRR10740748.fasta
