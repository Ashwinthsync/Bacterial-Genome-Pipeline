# Bacterial-Genome-Pipeline
A small pipeline written in bash and snakemake for bacterial genome analysis 
with end-to-end NGS pipeline for bacterial genomics: QC, trimming, mapping, 
and variant detection using E.coli as reference.

## 📁 NGS Variant Calling Pipeline (Bacteria)
This repository provides two implementations of a bacterial whole-genome

variant calling pipeline:
- **Bash-based pipeline** – simple, linear, and beginner-friendly
- **Snakemake pipeline** – modular, reproducible, and scalable

Both pipelines perform:
- Raw read QC
- Read trimming
- Alignment to reference genome
- Post-alignment QC
- Variant calling and filtering
- QC summary reporting
---

## 📌 Pipelines

### 1️⃣ Bash Pipeline
📁 `bash\_pipeline/`
- Designed for learning and quick runs
- Single-sample workflow
- Easy to understand step-by-step execution

### 2️⃣ Snakemake Pipeline
📁 `snakemake\_pipeline/`
- Production-ready workflow manager
- Config-driven
- Easily extendable to multiple samples
- Suitable for HPC / cloud environments
---

## 🧬 Test Dataset
The example dataset uses **E. coli REL606 (SRR2589044)** for demonstration.
---

## ⚙️ Requirements
- Conda / Mamba
- fastqc
- trimmomatic
- bwa
- samtools
- bcftools
- multiqc
- snakemake (for Snakemake pipeline).
---

## 🚀 Quick Start

### 1️⃣ Clone the Repository
Follow the steps below to clone the repository and run the pipeline.
```bash
git clone https://github.com/Ashwinthsync/Bacterial-Genome-Pipeline.git
cd Bacterial-Genome-Pipeline
```

### 2️⃣ Conda Installation (Required Before Running the Pipeline)
- This project uses **Conda** to manage all bioinformatics dependencies 
in a reproducible manner.
- If Conda is not already installed, install **Miniconda** (recommended).
📄 Official documentation: https://docs.conda.io/en/latest/miniconda.html

**Linux (x86_64):**
```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

## After installation, restart the terminal or run:
source ~/.bashrc
```

### 3️⃣ Create Environment and Activate
All required tools are listed in the provided Conda environment file.

```bash
# From the root of the repository, run:
conda env create -f environment.yml

# Activate the environment:
conda activate ngs_pipeline
```

### 4️⃣ Verify Installation
If these commands return version information, the setup is complete ✅

```bash
conda list
fastqc --version
bwa 2>&1 | head -n 1
samtools --version
bcftools --version
multiqc --version
snakemake --version
```

### 5️⃣ Run the Pipeline
```bash
# From the root of the repository, run: 
cd Bash
bash script.sh
```

```bash
# From the root of the repository, run:
cd Snakemake
snakemake --cores 4
```
---

## 📝 Notes
Always activate the Conda environment before running the pipeline.
- The Bash pipeline is ideal for learning.
- The Snakemake pipeline is suitable for production workflows.
---
