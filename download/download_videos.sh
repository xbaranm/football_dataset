playlist_number=-1
link_file="/workspace/football_dataset/src/link_parts/x"
while getopts p: flag
do
    case "${flag}" in
        p) playlist_number=${OPTARG};;
    esac
done
if [ $playlist_number -eq -1 ]
then
echo "Specify number of playlist to download through parameter -p"
else
    if [ $playlist_number -lt 100 ]
    then
    link_file+="0"
    fi
    if [ $playlist_number -lt 10 ]
    then
    link_file+="0"
    fi
link_file+=$playlist_number
link_file+=".txt"
echo "Downloading videos from file : $link_file"
yt-dlp -f 22 -o "/workspace/football_dataset/.mnt/scratch/%(title)s.%(ext)s" -a $link_file
echo "[Downloaded] Videos from : $link_file"
fi