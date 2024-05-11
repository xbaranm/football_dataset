currentDir=`pwd`

sourceDir=/workspace/football_dataset/.mnt/scratch/images_extracted/
destDir=/workspace/football_dataset/.mnt/scratch/images/
countFile=/workspace/football_dataset/.mnt/scratch/count

mkdir -p $destDir

dirLevel1=`ls "${destDir}" | sort -r | head -1`
if [[ $dirLevel1 == "" ]] ; then
    dirLevel1=0
    dirLevel1=$(printf %03d $dirLevel1) ; fi

mkdir -p "${destDir}${dirLevel1}"
dirLevel2=`ls "${destDir}${dirLevel1}" | sort -r | head -1`
if [[ $dirLevel2 == "" ]] ; then
    dirLevel2=0
    dirLevel2=$(printf %03d $dirLevel2) ; fi

mkdir -p "${destDir}${dirLevel1}/${dirLevel2}"
imageNumber=`ls "${destDir}${dirLevel1}/${dirLevel2}" | sort -r | head -1 | rev | cut -c 5- | rev`
if [[ $imageNumber == "" ]] ; then
    imageNumber=0
    imageNumber=$(printf %03d $imageNumber) ; fi

increment_filename () {
    if [[ $(echo $imageNumber | sed 's/^0*//') -lt 999 ]] ; then
        imageNumber=$(echo $imageNumber | sed 's/^0*//') ; ((imageNumber++)) # hack to fix 008 representing octal number
        imageNumber=$(printf %03d $imageNumber)
    elif [[ $(echo $dirLevel2 | sed 's/^0*//') -lt 999 ]] ; then
        dirLevel2=$(echo $dirLevel2 | sed 's/^0*//') ; ((dirLevel2++))
        dirLevel2=$(printf %03d $dirLevel2) ; imageNumber=$(printf %03d 0)
    else
        dirLevel1=$(echo $dirLevel1 | sed 's/^0*//') ; ((dirLevel1++))
        dirLevel1=$(printf %03d $dirLevel1) ; dirLevel2=$(printf %03d 0) ; imageNumber=$(printf %03d 0) ; fi
    mkdir -p "${destDir}${dirLevel1}/${dirLevel2}" # if new diectory has to be created
}

# if not the very first image, increment filename
if [[ $dirLevel1 != "000" || $dirLevel2 != "000" || $imageNumber != "000" ]] ; then
    increment_filename ; fi

mkdir -p "${destDir}${dirLevel1}/${dirLevel2}"

echo "Starting exporting from ${destDir}${dirLevel1}/${dirLevel2}/${imageNumber}.png"

echo "" # create empty line to write to
cd $sourceDir
for f in *.png
do
    mv "${f}" "${destDir}${dirLevel1}/${dirLevel2}/${imageNumber}.png"
    echo -e "\e[1A\e[K [Saved] ${destDir}${dirLevel1}/${dirLevel2}/${imageNumber}.png"
    increment_filename
done

# write number of extracted images to count file
echo "${dirLevel2}${imageNumber}" | sed 's/^0*//' > $countFile
echo "Total extracted images: ${dirLevel2}${imageNumber}" | sed 's/^0*//'
cd $currentDir
