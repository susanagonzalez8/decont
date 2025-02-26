#Download all the files specified in data/filenames

echo "Downloding samples..."

for url in data/urls 
do
    bash scripts/download.sh $url data
done

# Download the contaminants fasta file, uncompress it, and
# filter to remove all small nuclear RNAs

echo "Downloading contaminats fasta file..."

bash scripts/download.sh https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz res yes 
echo "Done"

# Index the contaminants file

echo "Running STAR index..."

bash scripts/index.sh res/contaminants.fasta res/contaminants_idx
echo "Done"

# Merge the samples into a single file

echo "Merging samples..."

for sid in $(ls data/*.fastq.gz | cut -d "-" -f1 | cut -d "/" -f2 | uniq) 
do
    bash scripts/merge_fastqs.sh data out/merged $sid
done
echo "Done"

echo "Running cutadapt..."
# TODO: run cutadapt for all merged files
# cutadapt -m 18 -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed \
#     -o <trimmed_file> <input_file> > <log_file>

mkdir -p out/trimmed
mkdir -p log/cutadapt

for sid in $(ls out/merged/*.fastq.gz | cut -d "." -f1 | cut -d "/" -f3)
do
        cutadapt \
        -m 18 \
        -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed \
        -o out/trimmed/$sid.trimmed.fastq.gz /out/merged/$sid.merged.fastq.gz > log/cutadapt/$sid.log
done

echo "Done"

#TODO: run STAR for all trimmed files
#for fname in out/trimmed/*.fastq.gz
#do
    # you will need to obtain the sample ID from the filename
#    sid=#TODO
    # mkdir -p out/star/$sid
    # STAR --runThreadN 4 --genomeDir res/contaminants_idx \
    #    --outReadsUnmapped Fastx --readFilesIn <input_file> \
    #    --readFilesCommand gunzip -c --outFileNamePrefix <output_directory>
#done 

echo "Running STAR for trimmed files..."

for fname in out/trimmed/*.fastq.gz
do
	sid=$(ls $fname | cut -d "." -f1 | sed "s:out/trimmed/::")
	mkdir -p out/star/$(sid)

	STAR \
		 --runThreadN 4 \
		 --genomeDir res/contaminants_idx \
    		 --outReadsUnmapped Fastx \
		 --readFilesIn $fname \
		 --readFilesCommand gunzip -c \
		 --outFileNamePrefix out/star/$sid
done

echo "Exporting environment information"

mkdir -p envs
conda env export --from-history > envs/decont.yaml

echo "Done!"