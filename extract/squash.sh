sourceDir=/workspace/football_dataset/.mnt/scratch/images/000/
destDir=/workspace/football_dataset/.mnt/scratch/squashes/

# copy count to sourceDir
echo "Copying /workspace/football_dataset/.mnt/scratch/count to ${sourceDir}"
cp /workspace/football_dataset/.mnt/scratch/count $sourceDir

mkdir -p "${destDir}"
squashNumber=`ls "${destDir}" | sort -r | head -1 | rev | cut -c 6- | rev`

if [[ $squashNumber == "" ]] ; then
    squashNumber=0
    squashNumber=$(printf %03d $squashNumber)
else
    squashNumber=$(echo $squashNumber | sed 's/^0*//') ; ((squashNumber++)) # hack to fix 008 representing octal number
    squashNumber=$(printf %03d $squashNumber) ; fi

destFile=$squashNumber.sqhs

mksquashfs $sourceDir "${destDir}${destFile}" -noI -noId -noD -noF -noX
echo "Done making squash file ${destDir}${destFile}"

# remove count from sourceDir
# echo "Removing ${sourceDir}count"
# rm "${sourceDir}count"

echo "Removing images/000/ folder"
rm -r $sourceDir