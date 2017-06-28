#!/bin/sh

#
# by Konrad U. Förstner <konrad.foerstner@uni-wuerzburg.de>
#

main(){
    # Set folder names
    RNA_SEQ_DATA_FOLDER=RNA-Seq_data
    RNA_SEQ_DATA_FASTQ_FOLDER=${RNA_SEQ_DATA_FOLDER}/FASTQ
    RNA_SEQ_DATA_FASTA_FOLDER=${RNA_SEQ_DATA_FOLDER}/FASTA
    
    # Set program paths - please adapt if needed!
    FASTQ_DUMP_BIN=bin/fastq-dump.2.3.4
    FASTQ_QUAL_TRIMMER_BIN=bin/fastq_quality_trimmer
    FASTQ_TO_FASTA_BIN=bin/fastq_to_fasta
    READEMPTION_BIN=reademption
    SEGEMEHL_BIN=bin/segemehl.x
    LACK_BIN=bin/lack.x
    TSSPREDATOR_JAR=bin/TSSpredator_v1-04/TSSpredator.jar

    # Genome URLs
    VIBRIO_BASE_URL=ftp://ftp.ncbi.nih.gov/genomes/Bacteria/Vibrio_cholerae_O1_biovar_El_Tor_N16961_uid57623/
    SACH_BASE_URL=ftp://ftp.ncbi.nih.gov/genomes/Fungi/Saccharomyces_cerevisiae_uid128/

    # The RNA-Seq data set can be found at
    # http://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE62084 
    SRA_BASE_URL=ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByStudy/sra/SRP/SRP048/SRP048672/

    REPLICONS="NC_002505.1 NC_002506.1"
    STRAIN_NAME="Vibrio_cholerae_O1"

#    create_folders
#    download_FASTQ_files
    run_quality_trimming_and_fasta_convesion
}

create_folders(){
    mkdir -p \
	${RNA_SEQ_DATA_FOLDER} \
	${RNA_SEQ_DATA_FASTQ_FOLDER} \
	${RNA_SEQ_DATA_FASTA_FOLDER}
}

download_FASTQ_files(){
    echo "Download FASTQ files"
    for LIB in \
        009:SRR2149459:R_s_exponential_phase_TEX_neg \
        000:SRR2149460:R_s_exponential_phase_TEX_pos \
        001:SRR2149461:R_s_transitional_phase_TEX_neg \
        002:SRR2149462:R_s_transitional_phase_TEX_pos \
	003:SRR2149463:R_s_stationary_phase_TEX_neg \
        004:SRR2149464:R_s_stationary_phase_TEX_pos \
        005:SRR2149465:R_s_lag_phase_TEX_neg \
        006:SRR2149466:R_s_lag_phase_TEX_pos
    do
        SUBFOLDER=$(echo ${LIB} | cut -f 1 -d:)
        RUN_ID=$(echo ${LIB} | cut -f 2 -d:)
        LIB_NAME=$(echo ${LIB} | cut -f 3 -d:)
        wget -O ${RNA_SEQ_DATA_FASTQ_FOLDER}/${LIB_NAME}.fastq.gz \
            ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR214/$SUBFOLDER/${RUN_ID}/${RUN_ID}.fastq.gz
    done
}

run_quality_trimming_and_fasta_convesion(){
    echo "* Perform quality trimming and fasta conversion of the FASTQ files"
    for FASTQ_FILE in $(ls ${RNA_SEQ_DATA_FASTQ_FOLDER})
    do
        BASENAME=$(basename ${FASTQ_FILE} .fastq.gz)
	FASTA_FILE=${BASENAME}.fa.bz2
        gunzip ${RNA_SEQ_DATA_FASTQ_FOLDER}/${FASTQ_FILE}
	${FASTQ_QUAL_TRIMMER_BIN} -t 20 -Q33 -l 1 -i ${RNA_SEQ_DATA_FASTQ_FOLDER}/${BASENAME}.fastq \
	    | ${FASTQ_TO_FASTA_BIN} -Q33 \
	    | bzip2 --stdout - > ${RNA_SEQ_DATA_FASTA_FOLDER}/${FASTA_FILE}
    done
    wait
}

main
