currentDir=`pwd`
sourceDir=/workspace/football_dataset/.mnt/nfs-data/private/

cd $sourceDir
for f in *.mp4
do 
    if [[ $f != "[Done]"* ]]
    then
        continue
    fi
    ffprobe -v quiet -of csv=p=0 -show_entries format=duration "$f"
done | awk '{sum += $1*2}; END{print sum}'sr  

cd $currentDir