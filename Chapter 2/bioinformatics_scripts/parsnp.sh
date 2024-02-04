#!/bin/bash
#   script to run parsnp
#
#  load the module
module load parsnp
#
#  run parsnp
ref_dir=~/parsnp/GCA_008429005.2_ASM842900v2_genomic
qry_dir=~/parsnp/ncbi_gen
#qry_dir=~/parsnp/ncbi2

#parsnp -r ~/parsnp/reference/*.fna -d ~/parsnp/ncbi2/*.fasta -c -o muenster_parsnp
parsnp -r ${ref_dir}.fasta -d $qry_dir -o muenster_parsnp -p 8
parsnp -r ${ref_dir}.fna -d $qry_dir -o muenster_parsnp2 -p 8
#parsnp -g ${ref_dir}.gbff -d $qry_dir -o muenster_parsnp3 -p 8
#parsnp -g ${ref_dir}.gff -d $qry_dir -o muenster_parsnp4 -p 8
#parsnp -g ${ref_dir}.gtf -d $qry_dir -o muenster_parsnp5 -p 8


#parsnp -g ~/parsnp/GCA_008429005.2_ASM842900v2_genomic.gbff -d ~/parsnp/ncbi2 -o muenster_parsnp -p 8
#parsnp -r ~/parsnp/GCA_008429005.2_ASM842900v2_genomic.fasta -d ~/parsnp/ncbi2 -o muenster_parsnp2 -p 8
#parsnp -r ~/parsnp/GCA_008429005.2_ASM842900v2_genomic.fna -d ~/parsnp/ncbi2 -o muenster_parsnp5 -p 8
#parsnp -g ~/parsnp/GCA_008429005.2_ASM842900v2_genomic.gff -d ~/parsnp/ncbi2 -o muenster_parsnp3 -p 8
#parsnp -g ~/parsnp/GCA_008429005.2_ASM842900v2_genomic.gtf -d ~/parsnp/ncbi2 -o muenster_parsnp4 -p 8
