#!/bin/sh
source /apps/profiles/modules_asax.sh.dyn
module load spades/3.15.5

### SPAdes will not work with a For, Do, Done Loop  ###
### with submission to queue system on ASC.         ###
### This script must be submitted for each assembly ###

# Input SRR read number for SPAdes assembly below

#SRR=SRR2104591 # Replace ?? with final two digits of SRR read number
SRR=SRR1752832

# Path to data on /scratch on ASC server
#path=/scratch/AU_BIOL-7180_GrpProject/samples_Salmonella_muenster/

### SPAdes is a genome assembly program. ###

#### COMMAND LINE FOR SPAdes GOES BELOW ####

# SPAdes command
#spades.py -o ${SRR}_asx -1 ${SRR}_1.fastq.gz -2 ${SRR}_2.fastq.gz -k 21,33,55,77 --sc --careful -t 16
spades.py -o ${SRR}_asx -1 ${SRR}_1.fastq -2 ${SRR}_2.fastq -k 21,33,55,77 --sc --careful -t 16

#SPAdes command to restart assembly from a specific kmer
#spades.py -o ${SRR}_reg --continue K55

#SPAdes command to restart assembly that was interrupted
#spades.py -o $SRR --continue
#spades.py --restart-from K77 -k 21,33,55,77 --careful -o $SRR
#### Make sure the --threads argument (-t) matches the number of CPUs requested


####       request 16 CPU, and dmc as the cluster        ####
