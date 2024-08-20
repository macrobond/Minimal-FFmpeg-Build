#!/bin/bash

NAME=$1
VERSION=$2
TARGET=$3

. ./common.sh $NAME $VERSION $TARGET

VERSION="${VERSION:1}" # substring from 1st character

FFMPEG_VER_FILEVERSION="${VERSION},0"
FFMPEG_VER_FILEVERSION="${FFMPEG_VER_FILEVERSION//./,}" # replace all dots with commas
FFMPEG_VER_FILEVERSION_STR=$FFMPEG_VER_FILEVERSION

EXTRA_VERSION="min-build_$VERSION"

pushd $SUBMODULES/FFmpeg

FFTOOLSRES_RC="
VS_VERSION_INFO VERSIONINFO
FILEVERSION     $FFMPEG_VER_FILEVERSION
BEGIN
    BLOCK \"StringFileInfo\"
    BEGIN
        BLOCK \"040904E4\"
        BEGIN
            VALUE \"FileVersion\",\"$FFMPEG_VER_FILEVERSION_STR\"
        END
    END
    BLOCK \"VarFileInfo\"
    BEGIN
        VALUE \"Translation\", 0x0, 1252 // language neutral - multilingual (decimal)
    END
END"
echo "$FFTOOLSRES_RC" >> fftools/fftoolsres.rc

./configure \
    --prefix=/ffbuild/prefix \
    --pkg-config=pkg-config \
    --pkg-config-flags="--static" \
    --enable-cross-compile \
    --cross-prefix=x86_64-w64-mingw32- \
    --arch=x86_64 \
    --target-os=mingw32 \
    --enable-version3 \
    \
    --enable-zlib \
    --enable-libopenh264 \
    \
    --disable-network \
    --disable-debug \
    --disable-ffplay \
    --disable-ffprobe \
    \
    --disable-doc \
    --disable-htmlpages \
    --disable-manpages \
    --disable-podpages \
    --disable-txtpages \
    \
    --disable-everything \
    --enable-protocol=file \
    --enable-decoder=png \
    --enable-encoder=png,gif,libopenh264 \
    --enable-demuxer=image2 \
    --enable-muxer=mp4,gif,image2 \
    --enable-filter=scale,palettegen,paletteuse \
    \
    --extra-cflags="-static-libgcc -static-libstdc++ -O2 -pipe -D_FORTIFY_SOURCE=2 -fstack-protector-strong" \
    --extra-cxxflags="-static-libgcc -static-libstdc++ -O2 -pipe -D_FORTIFY_SOURCE=2 -fstack-protector-strong" \
    --extra-ldflags="-static -static-libstdc++ -static-libgcc -O2 -pipe -fstack-protector-strong" \
    --cc="$CC" \
    --cxx="$CXX" \
    --ar="$AR" \
    --ranlib="$RANLIB" \
    --nm="$NM" \
    --extra-version="$EXTRA_VERSION"

make -j$(nproc) V=1

make install # install-doc

if [[ $TARGET == win64 ]]; then
    mkdir -p $ARTIFACTS/nuget_files/runtimes/win-x64/native
    cp -f ./ffmpeg.exe $ARTIFACTS/nuget_files/runtimes/win-x64/native/ffmpeg.exe
else
    echo not implemented
    exit 1

    # mkdir -p $ARTIFACTS/nuget_files/runtimes/linux-x64/native
    # cp -f ./ffmpeg $ARTIFACTS/nuget_files/runtimes/linux-x64/native/ffmpeg
fi

popd