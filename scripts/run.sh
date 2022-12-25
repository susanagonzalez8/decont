./download.sh https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz ../res yes filtro

STAR \
	--runThreadN 4 \
	--runMode genomeGenerate \
	--genomeDir ../res/contaminants_idx \
	--genomeFastaFiles ../res/contaminants.fasta \
	--genomeSAindexNbases 9
