sourceDir=/workspace/football_dataset/.mnt/scratch/videos/*.mp4 #/workspace/football_dataset/.mnt/nfs-data/private/*.mp4
for f in $sourceDir
do ffprobe -v quiet -of csv=p=0 -show_entries format=duration "$f"
done | awk '{sum += $1}; END{print sum}'sr  