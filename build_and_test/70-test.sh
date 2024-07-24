#!/bin/bash

VERSION=$1
TARGET=$2

. ./common.sh $VERSION $TARGET

FRAME_RATE=60
FRAME_COUNT=$(( FRAME_RATE * 5 ))

log_level="32"
log="-v $log_level"
#log=""

working_directory=${ARTIFACTS}/${TARGET}_test

mkdir -p $working_directory
pushd "$working_directory"

if [[ $TARGET == win64 ]]; then
    ffmpeg_bin="wine $SUBMODULES/FFmpeg/ffmpeg.exe"
else
    echo not implemented
    exit 1
fi

for i in $(seq 1 $FRAME_COUNT);
do
    convert \
    -background lightblue \
    -fill blue \
    -font Z003-MediumItalic \
    -pointsize 72 \
    -extent 450x100 \
    label:"fram -> $i <-" \
    PNG32:$i.png &
done

wait

$ffmpeg_bin $log --help

$ffmpeg_bin $log -L

$ffmpeg_bin $log -progress palette.png.log -y -i 300.png -vf palettegen palette.png

$ffmpeg_bin $log -progress TestOutputFile.gif.log -y -framerate 60 -i %d.png -i palette.png -filter_complex "[0:v][1:v] paletteuse" -r 60 TestOutputFile.gif

$ffmpeg_bin $log -progress TextOutputFile.mp4.log -y -framerate 60 -i %d.png -r 60 -codec:v libopenh264 TextOutputFile.mp4

echo -e "\033[0;92mall test run !\033[0m"

popd