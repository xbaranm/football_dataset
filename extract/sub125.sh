cd /workspace/football_dataset/.mnt/scratch/images/000
imageNumber="000"
for dir in */; do
    mv ${dir} ${imageNumber}
    imageNumber=$(echo $imageNumber | sed 's/^0*//') ; ((imageNumber++)) # hack to fix 008 representing octal number
    imageNumber=$(printf %03d $imageNumber)
done