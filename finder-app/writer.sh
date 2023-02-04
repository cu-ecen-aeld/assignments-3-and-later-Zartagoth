#!/bin/sh

writefile=$1
writestr=$2

# Check if arguments are empty
if [ -z "$writefile" ] || [ -z "$writestr" ]; then
    echo "\$filesdir or \$searchstr is empty"

    return 1
fi

# Create directory if not exist
mkdir -p "${writefile%/*}/"

if ! echo $writestr > $writefile; then
    echo "Could not create file"

    return 1
fi