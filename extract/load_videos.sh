currentDir=`pwd`
# first parameter is number of videos we want to load
# minimum = 1   maximum = 60
n=$1
if [[ $n -le 0 ]] ; then
    n=1
elif [[ $n -gt 60 ]] ; then
    n=60
fi
sourceDir=/workspace/football_dataset/.mnt/nfs-data/private/
destDir=/workspace/football_dataset/.mnt/scratch/videos/

cd $sourceDir
mkdir -p $destDir

for f in *.mp4
do
    # skip InProgress and Done videos
    if [[ $f == "[InProgress]"* || $f == "[Done]"* ]]
    then
        continue
    fi

    # rename orginal file
    mv "${f}" "[InProgress]${f}";
    # copy original file
    cp "[InProgress]${f}" "${destDir}"
    #remove [InProgress] prefix
    mv "${destDir}[InProgress]${f}" "${destDir}${f}"

    echo "[Video Loaded] ${f}"

    ((n--)) # decrement count
    if [ $n -le 0 ] ; then
        break
    fi
done
cd $currentDir