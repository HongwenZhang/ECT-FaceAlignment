#!/bin/bash
#
# Caffe training script
# Tomas Pfister 2015

if [ "$2" = "" ]; then
	echo "$0 net_name gpu_id [snap_iter] [finetune:0/1] [fine_net] [fine_sub]"
	exit
fi
net=$1
gpu_id=$2
snap_iter=$3
finetune=$4
fine_net=$5
fine_sub=$6
fine_dir="../model_data/$fine_net/$fine_sub/"
finetuneNet="${fine_net}_train"
snap_dir="../model_data/$net/snapshots/"
snapfile="${net}_train";



mkdir -p $snap_dir
if [ "$finetune" = "1" ]; then cmd="weights"; ext="caffemodel"; else cmd="snapshot"; ext="solverstate"; fi
if [ "$snap_iter" != "" ] &&  [ "$snap_iter" != "-1" ]; then snap_str="-$cmd $fine_dir/${finetuneNet}_iter_$snap_iter.$ext"; fi

./build/tools/caffe train $snap_str \
-gpu $gpu_id -solver models/$net/solver.prototxt 2>&1 | tee -a $snap_dir/$snapfile.log
