#!/bin/sh
#
#  load the module
source /apps/profiles/modules_asax.sh.dyn
module load fasttree/2.1.10
export OMP_NUM_THREADS=2
#

FastTree -nt -gtr ./roary_results/core_gene_alignment.aln > ./roary_results/roary_tree.newick
