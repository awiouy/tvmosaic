#!/bin/sh

TVM_ROOT_DIR="/storage/tvmosaic"
FFMPEG_DIR=${TVM_ROOT_DIR}/data/common/ffmpeg
#export LD_LIBRARY_PATH=${FFMPEG_DIR}

# $1 = filename_
# $2 = thumb_vert_size_
# $3 = thumb_filename_
# $4 = offset in sec
#
${FFMPEG_DIR}/ffmpeg -y -ss $4 -i "$1" -vcodec mjpeg -vframes 1 -an -f rawvideo -vf scale="trunc(iw*($2/ih)*sar/32)*32:trunc(ih*($2/ih)/16)*16" -ss 3 "$3"
