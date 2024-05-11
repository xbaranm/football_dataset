filename=$(printf %03d $1)

echo "Unmounting from /workspace/football_dataset/.mnt/scratch/old"
umount /workspace/football_dataset/.mnt/scratch/old

echo "Unmounting from /workspace/football_dataset/.mnt/scratch/new"
umount /workspace/football_dataset/.mnt/scratch/new