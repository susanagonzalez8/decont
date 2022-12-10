file=$1
directory=$2
uncompress=$3


file=$(basename $1)

echo "Downloading files"
wget -P $2 $1

echo "Uncompressing files"

if ["$3" = "yes"]
then 
	gunzip -k $2/$file
fi
