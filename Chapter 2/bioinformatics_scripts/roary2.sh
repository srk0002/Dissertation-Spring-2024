#!/bin/sh
#
#  load the module
source /apps/profiles/modules_asax.sh.dyn
module load roary
#
pwddir=`pwd`
#  edit the roary command as needed
#  But ALWAYS include -p flag to set how many processor cores
#example: roary -p 2 -f ${pwddir}/demo -e -n -v ${pwddir}/*.gff

#for folder in ./SRR107407??
#do
    #roary -p 8 -f ${pwddir}/roary_results -e -n -v -qc -k -r ${pwddir}/SRR10740739_roary.gff ${pwddir}/SRR10740740_roary.gff ${pwddir}/SRR10740741_roary.gff ${pwddir}/SRR10740742_roary.gff ${pwddir}/SRR10740743_roary.gff ${pwddir}/SRR10740744_roary.gff ${pwddir}/SRR10740745_roary.gff ${pwddir}/SRR10740746_roary.gff ${pwddir}/SRR10740747_roary.gff ${pwddir}/SRR10740748_roary.gff
    roary -p 8 -f ${pwddir}/roary_results -e -n -v -r *.gff

module load fasttree/2.1.10
export OMP_NUM_THREADS=2

FastTree -nt -gtr ./roary_results/core_gene_alignment.aln > ./roary_results/roary_tree.newick
