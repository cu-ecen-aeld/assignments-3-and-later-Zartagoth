#!/bin/sh

filesdir=$1
searchstr=$2

if [ -z "$filesdir" ] || [ -z "$searchstr" ]
then
    echo "\$filesdir or \$searchstr is empty"

    return 1
elif [ ! -d "$filesdir" ]
then
    echo "Directory $filesdir does not exist"

    return 1
else
    numfiles=$(ls $filesdir | wc -l)
    numlines=$(grep -rnw $filesdir -e $searchstr | wc -l)

    echo "The number of files are $numfiles and the number of matching lines are $numlines"
fi