# This script should download the file specified in the first argument ($1),
# place it in the directory specified in the second argument ($2),
# and *optionally*:
# - uncompress the downloaded file with gunzip if the third
#   argument ($3) contains the word "yes"
# - filter the sequences based on a word contained in their header lines:
#   sequences containing the specified word in their header should be **excluded**
#
# Example of the desired filtering:
#
#   > this is my sequence
#   CACTATGGGAGGACATTATAC
#   > this is my second sequence
#   CACTATGGGAGGGAGAGGAGA
#   > this is another sequence
#   CCAGGATTTACAGACTTTAAA
#
#   If $4 == "another" only the **first two sequence** should be output



#variables
url=$1
directory=$2
sampleid=$(basename $1)

echo "Downloading samples..."

wget -P $2 -c $1

if [ "$3" = "yes" ]; then 
        echo "Uncompressing samples..."
        gunzip -k $2/$sampleid
        echo "Done"
fi


echo "Filtering..."

if [ "$4" = "filtro" ]; then
        seqkit grep -vrnp '.*small nuclear.*' ../res/contaminants.fasta > ../res/contaminants_filtered.fasta
fi
