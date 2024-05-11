n=$1
if [[ $n -le 0 ]] ; then
    n=1
elif [[ $n -gt 60 ]] ; then
    n=60
fi
/workspace/football_dataset/src/extract/load_videos.sh $n
/workspace/football_dataset/src/extract/extract_frames.sh
/workspace/football_dataset/src/extract/export_frames.sh
/workspace/football_dataset/src/extract/merge_videos.sh
/workspace/football_dataset/src/extract/squash.sh