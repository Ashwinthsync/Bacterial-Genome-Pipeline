# Snakemake NGS Variant Calling Pipeline
A reproducible and scalable NGS variant calling workflow implemented
using Snakemake.

### Features
- Configurable
- Restartable
- Multi-sample support
- HPC-ready

### Usage
```bash
#To get dag.png image :
conda install -y graphviz
snakemake --dag | dot -Tpng > results/dag.png

#To dryrun Snakefile, run :
snakemake -n

#To run Snakefile, run :
snakemake --cores 4
---
