
filename=$(printf %03d $1)

# echo "Moving: /workspace/football_dataset/.mnt/nfs-data/private/images/$filename.sqhs"
# echo "to:     /workspace/football_dataset/.mnt/nfs-data/private/images/$filename.sqsh"
# mv "/workspace/football_dataset/.mnt/nfs-data/private/images/$filename.sqhs" "/workspace/football_dataset/.mnt/nfs-data/private/images/$filename.sqsh"

for squash in /workspace/football_dataset/.mnt/nfs-data/private/images/*.sqhs
do
    echo "${squash}"
done

#     squashfuse "${squash}" /workspace/football_dataset/.mnt/scratch/test

#     if [ -d "/workspace/football_dataset/.mnt/scratch/test/images" ]; then
#         # Take action if $DIR exists. #
#         echo "${squash}"
#     fi
#     umount /workspace/football_dataset/.mnt/scratch/test

# done



# /workspace/football_dataset/.mnt/nfs-data/private/images/000.sqhs
# /workspace/football_dataset/.mnt/nfs-data/private/images/001.sqhs
# /workspace/football_dataset/.mnt/nfs-data/private/images/002.sqhs
# /workspace/football_dataset/.mnt/nfs-data/private/images/003.sqhs
# /workspace/football_dataset/.mnt/nfs-data/private/images/009.sqhs
# /workspace/football_dataset/.mnt/nfs-data/private/images/010.sqhs
# /workspace/football_dataset/.mnt/nfs-data/private/images/011.sqhs
# /workspace/football_dataset/.mnt/nfs-data/private/images/012.sqhs
# /workspace/football_dataset/.mnt/nfs-data/private/images/013.sqhs
# /workspace/football_dataset/.mnt/nfs-data/private/images/014.sqhs
# /workspace/football_dataset/.mnt/nfs-data/private/images/015.sqhs
# /workspace/football_dataset/.mnt/nfs-data/private/images/016.sqhs
# /workspace/football_dataset/.mnt/nfs-data/private/images/017.sqhs
# /workspace/football_dataset/.mnt/nfs-data/private/images/018.sqhs
# /workspace/football_dataset/.mnt/nfs-data/private/images/020.sqhs
# /workspace/football_dataset/.mnt/nfs-data/private/images/022.sqhs