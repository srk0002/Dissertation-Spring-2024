#!/bin/bash
#
#  load the module
source /opt/asn/etc/asn-bash-profiles-special/modules.sh
module load snippy/4.6.0
#
#  place commands here
fil_dir=/scratch/aubsrk/newport_fastq

snippy --report --cpus 4 --outdir mut_snps --ref refseq.gbff --R1 $fil_dir/SRR1752832_1.fastq.gz --R2 $fil_dir/SRR1752832_2.fastq.gz --rgid --unmapped --report
snippy --report --cpus 4 --outdir parent_snps --ref refseq.gbff --R1 $fil_dir/SRR2104591_1.fastq.gz --R2 $fil_dir/SRR2104591_2.fastq.gz --rgid --unmapped --report
