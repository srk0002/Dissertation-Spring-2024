\#!/bin/bash


#This script will be used to align contigs to a reference genome
#This requires use of BWA, Samtools, and Picard
#Must have both reads for each sequence and reference genome downloaded into current working directory.
#If reference and samples are not downloaded, use script ref_sequences.sh
#
##########Queue Information Based on SampleTest Data###########
#Core=4 Mem=4gb
#
#  load the module
##################################
#
##########Setup Environment#######
source /apps/profiles/modules_asax.sh.dyn
module load picard/1.79
module load bwa/0.7.17
module load samtools/1.18
module load gatk/4.4.0.0
#module load java/1.8.0_192
module load anaconda/3-2022.10

#
#  place commands here
##########Variables###############
#fil_dir=/scratch/aubsrk/newport_fastq
#ref_sam=$fil_dir/newport_reference/GCF_002060435.1_ASM206043v1_genomic.fna
#mut_R1=$fil_dir/SRR1752832_1.fastq.gz
#mut_R2=$fil_dir/SRR1752832_2.fastq.gz
#par_R1=$fil_dir/SRR2104591_1.fastq.gz
#par_R2=$fil_dir/SRR2104591_2.fastq.gz

#cp $ref_sam ./salm_newport_ref.fna
#cp $mut_R1 ./
#cp $mut_R2 ./
#cp $par_R1 ./
#cp $par_R2 ./

ref=parent_ref_scaffolds.fasta
m_R1=SRR1752832_1.fastq.gz
m_R2=SRR1752832_2.fastq.gz
#p_R1=SRR2104591_1.fastq.gz
#p_R2=SRR2104591_2.fastq.gz

#Index for the Burrows-Wheeler Align and is used to create the reference genome for the scripts that require BWA


bwa index -p parent_reference ${ref}
samtools faidx ${ref}
java -Xms2g -Xmx4g -jar /apps/x86-64/apps/picard_1.79/picard-tools-1.79/CreateSequenceDictionary.jar REFERENCE=${ref} OUTPUT=parent_reference.dict
samtools dict $ref -o parent_reference.dict


#BWA mem for alignment piped into Samtools view piped into Samtools sort and converted to .bam opposed to .sam file format.

#Use command below if read group is available in fastq files
#bwa mem -M -t 4 -R "@RG\tID:foo\tSM:bar" $ref $m_R1 $m_R2 > mut.mem.sam #| samtools view -Sb | samtools sort - -@ 4 -m 2GB >${sample}.sorted.bam

    #Mutant
    bwa mem -M -t 4 parent_reference $m_R1 $m_R2 > mut.mem.sam #| samtools view -Sb | samtools sort - -@ 4 -m 2GB >${sample}.sorted.bam

    #Parent
    #bwa mem -M -t 4 salm_newport_ref $p_R1 $p_R2 > par.mem.sam #| samtools view -Sb | samtools sort - -@ 4 -m 2GB >${sample}.sorted.bam

#Alignment piped into Samtools view piped into Samtools sort and converted to .bam opposed to .sam file format.
    #Mutant
    samtools view -Sb -@ 4 mut.mem.sam -o mut.mem.bam
    samtools sort -@ 4 mut.mem.bam -o mut.memsorted.bam
    samtools index -@ 4 mut.memsorted.bam

    #Parent
    #samtools view -Sb -@ 4 par.mem.sam -o par.mem.bam
    #samtools sort -@ 4 par.mem.bam -o par.memsorted.bam
    #samtools index -@ 4 par.memsorted.bam

####IMPORTANT: Carefully read the hpcdocs entry for GATK4: https://hpcdocs.asc.edu/content/gatk-0
####Important: Folder must contain reference salmonella.fasta file and alignment bam files (*.merged.sorted.bam)

#Add Read Group information to bam files. Necessary for gatk tools.

    #Mutant
    gatk AddOrReplaceReadGroups -I mut.memsorted.bam -O mut.rg.bam --RGID MUTANT --RGLB SRR1752832 --RGPL ILLUMINA --RGPU UF --RGSM 20

    #Parent
    #gatk AddOrReplaceReadGroups -I par.memsorted.bam -O par.rg.bam --RGID PARENT --RGLB SRR2104591 --RGPL ILLUMINA --RGPU UF --RGSM 20

#gatk
#### COMMAND LINE FOR GATK BELOW ####
#This will identify and mark dupliate reads in bam format
    
    #Mutant
    gatk --java-options "-Xmx1G" BuildBamIndex -I mut.rg.bam -R $ref
    gatk --java-options "-Xmx1G" MarkDuplicates -R $ref -I mut.rg.bam -M mut.dup_metrics -O mut.markdup.bam
    
    #Parent
    #gatk --java-options "-Xmx1G" BuildBamIndex -I par.rg.bam -R $ref
    #gatk --java-options "-Xmx1G" MarkDuplicates -R $ref -I par.rg.bam -M par.dup_metrics -O par.markdup.bam

#Sort and index mark duplicate bam file
    #Mutant
    samtools sort -@ 4 mut.markdup.bam -o mut.markdup.sorted.bam
    samtools index -@ 4 mut.markdup.sorted.bam

    #Parent
    #samtools sort -@ 4 par.markdup.bam -o par.markdup.sorted.bam
    #samtools index -@ 4 par.markdup.sorted.bam

#Build Bam Index
    #Mutant
    gatk --java-options "-Xmx1G" BuildBamIndex -I mut.markdup.sorted.bam  -R $ref

    #Parent
    #gatk --java-options "-Xmx1G" BuildBamIndex -I par.markdup.sorted.bam  -R $ref

#Short Variant Discovery; this step can be multithreaded if you request more cores (try 4 first, then up to 8 if needed)
    #Mutant
    gatk --java-options "-Xmx8G" HaplotypeCaller -R $ref -I mut.markdup.sorted.bam --sample-ploidy 1 -O mut.g.vcf.gz -ERC GVCF

    #Parent
    #gatk --java-options "-Xmx8G" HaplotypeCaller -R $ref -I par.markdup.sorted.bam --sample-ploidy 1 -O par.g.vcf.gz -ERC GVCF

#Joint Genotyping
    #Mutant
    gatk --java-options "-Xmx4G" GenotypeGVCFs -R $ref -V mut.g.vcf.gz -O mut.vcf.gz

    #Parent
    #gatk --java-options "-Xmx4G" GenotypeGVCFs -R $ref -V par.g.vcf.gz -O par.vcf.gz

#Extract only SNPs
    #Mutant
    gatk SelectVariants -R $ref --variant mut.vcf.gz  --select-type-to-include SNP --output  mut.SNPs.vcf

    #Parent
    #gatk SelectVariants -R $ref --variant par.vcf.gz  --select-type-to-include SNP --output  par.SNPs.vcf

#Perform variant filtering
    #Mutant
    gatk VariantFiltration -R $ref --variant mut.SNPs.vcf \
    --filter-expression "QD < 2.0" --filter-name "QD2" \
    --filter-expression "QUAL < 30.0" --filter-name "QUAL30" \
    --filter-expression "SOR > 3.0" --filter-name "SOR3" \
    --filter-expression "FS > 60.0" --filter-name "FS60" \
    --filter-expression "MQ < 40.0" --filter-name "MQ40" \
    --filter-expression "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \
    --filter-expression "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
    --output mut.SNPs.filtered.vcf

    #Parent
    #gatk VariantFiltration -R $ref --variant par.SNPs.vcf \
    #--filter-expression "QD < 2.0" --filter-name "QD2" \
    #-filter-expression "QUAL < 30.0" --filter-name "QUAL30" \
    #--filter-expression "SOR > 3.0" --filter-name "SOR3" \
    #--filter-expression "FS > 60.0" --filter-name "FS60" \
    #--filter-expression "MQ < 40.0" --filter-name "MQ40" \
    #--filter-expression "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \
    #--filter-expression "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
    #--output par.SNPs.filtered.vcf

gzip -f mut.SNPs.filtered.vcf
#gzip -f par.SNPs.filtered.vcf


vcftools --gzvcf par.SNPs.filtered.vcf.gz --gzdiff mut.SNPs.filtered.vcf.gz --diff-site --out par_v_mut

#gzip -f $sample.SNPs.vcf $sample.SNPs.filtered.vcf

#get depth statistics
#module load vcftools
#vcftools --gzvcf $sample.SNPs.filtered.vcf.gz --depth --out $sample #output will be called $sample.idepth

#print QC metrics to a file
#depth=`awk 'NR>1 {print $3}' $sample.idepth`
