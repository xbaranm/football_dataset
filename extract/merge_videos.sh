currentDir=`pwd`
cd /workspace/football_dataset/.mnt/scratch/videos/
sourceDir=/workspace/football_dataset/.mnt/nfs-data/private

for f in *.mp4
do
    # rename original file
    mv "${sourceDir}/[InProgress]${f}" "${sourceDir}/[Done]${f}"
    rm "${f}"
    echo "[Video Merged] ${f}"
done
cd $currentDir