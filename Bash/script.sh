#!/usr/bin/env bash
#<!==========================================>
# CONFIGURATION
#<!==========================================>
SAMPLE="SRR2589044"
THREADS=4

REF_DIR="ref_genome"
SAMPLE_DIR="samples"
RESULTS="results"

REF_FASTA="${REF_DIR}/ecoli_rel606.fasta"


#<!==========================================>
# INSTALL TOOLS (one-time)
# If you don't follow the conda environment setup, you can uncomment the lines below to install the required tools. 
# Make sure to have conda installed and configured properly before running this step.
#<!==========================================>
# echo "[INFO] Installing required tools..."
# conda install -y -c bioconda fastqc trimmomatic bwa samtools bcftools multiqc
# echo "[INFO] Tools installed"


#<!==========================================>
# CREATE DIRECTORIES
#<!==========================================>
mkdir -p \
  ${SAMPLE_DIR} \
  ${REF_DIR} \
  ${RESULTS}/{fastqc,trimmed,bam,vcf,multiqc}


#<!==========================================>
# DOWNLOAD SAMPLE
#<!==========================================>
echo "[INFO] Downloading FASTQ files..."
wget -O ${SAMPLE_DIR}/${SAMPLE}_1.fastq.gz https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/004/${SAMPLE}/${SAMPLE}_1.fastq.gz
wget -O ${SAMPLE_DIR}/${SAMPLE}_2.fastq.gz https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/004/${SAMPLE}/${SAMPLE}_2.fastq.gz
gunzip -f ${SAMPLE_DIR}/${SAMPLE}_*.fastq.gz


#<!==========================================>
# DOWNLOAD REFERENCE GENOME
#<!==========================================>
echo "[INFO] Downloading reference genome..."
wget -O ${REF_FASTA}.gz https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/017/985/GCA_000017985.1_ASM1798v1/GCA_000017985.1_ASM1798v1_genomic.fna.gz
gunzip -f ${REF_FASTA}.gz


#<!==========================================>
# FASTQC (RAW READS)
#<!==========================================>
echo "[INFO] Running FastQC..."
fastqc -t ${THREADS} \
  ${SAMPLE_DIR}/${SAMPLE}_1.fastq \
  ${SAMPLE_DIR}/${SAMPLE}_2.fastq \
  -o ${RESULTS}/fastqc


#<!==========================================>
# TRIMMING
#<!==========================================>
echo "[INFO] Trimming reads..."
trimmomatic PE -threads ${THREADS} \
  ${SAMPLE_DIR}/${SAMPLE}_1.fastq \
  ${SAMPLE_DIR}/${SAMPLE}_2.fastq \
  ${RESULTS}/trimmed/${SAMPLE}_1.trim.fastq /dev/null \
  ${RESULTS}/trimmed/${SAMPLE}_2.trim.fastq /dev/null \
  SLIDINGWINDOW:4:20 MINLEN:50


#<!==========================================>
# INDEX REFERENCE
#<!==========================================>
echo "[INFO] Indexing reference genome..."
bwa index ${REF_FASTA}
samtools faidx ${REF_FASTA}


#<!==========================================>
# ALIGNMENT + SORTING
#<!==========================================>
echo "[INFO] Aligning reads..."
bwa mem -t ${THREADS} ${REF_FASTA} ${RESULTS}/trimmed/${SAMPLE}_1.trim.fastq ${RESULTS}/trimmed/${SAMPLE}_2.trim.fastq | \
samtools sort -o ${RESULTS}/bam/${SAMPLE}.sorted.bam


#<!==========================================>
# INDEX BAM
#<!==========================================>
samtools index ${RESULTS}/bam/${SAMPLE}.sorted.bam


#<!==========================================>
# ALIGNMENT QC
#<!==========================================>
samtools flagstat ${RESULTS}/bam/${SAMPLE}.sorted.bam > ${RESULTS}/bam/${SAMPLE}.flagstat.txt


#<!==========================================>
# VARIANT CALLING
#<!==========================================>
echo "[INFO] Calling variants..."
bcftools mpileup -O b -f ${REF_FASTA} ${RESULTS}/bam/${SAMPLE}.sorted.bam > ${RESULTS}/bam/${SAMPLE}.bcf
bcftools call --ploidy 1 -m -v -o ${RESULTS}/vcf/${SAMPLE}.raw.vcf ${RESULTS}/bam/${SAMPLE}.bcf


#<!==========================================>
# VARIANT FILTERING
#<!==========================================>
echo "[INFO] Filtering variants..."
bcftools filter -i 'QUAL>30 && DP>10' ${RESULTS}/vcf/${SAMPLE}.raw.vcf | bgzip -c > ${RESULTS}/vcf/${SAMPLE}.filtered.vcf.gz
tabix -p vcf ${RESULTS}/vcf/${SAMPLE}.filtered.vcf.gz


#<!==========================================>
# MULTIQC REPORT
#<!==========================================>
echo "[INFO] Generating MultiQC report..."
multiqc ${RESULTS} -o ${RESULTS}/multiqc


#<!==========================================>
# DONE
#<!==========================================>
echo "🎉 PIPELINE COMPLETED SUCCESSFULLY 🎉"