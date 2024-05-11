currentDir=`pwd`
videoDir=/workspace/football_dataset/.mnt/scratch/videos/
outputDir=/workspace/football_dataset/.mnt/scratch/images_extracted/
extracted=/workspace/football_dataset/.mnt/scratch/extracted.txt

mkdir -p $outputDir

cd $videoDir
for f in *.mp4
do
    ffmpeg -i "${f}" -r 2 "${outputDir}${f}"image-%010d.png
    echo "${f}" >> $extracted
done
cd $currentDir