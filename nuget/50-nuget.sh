#!/bin/bash

NAME=$1
VERSION=$2
VERSION="${VERSION:1}" # substring from 1st character

. ./common.sh $NAME $VERSION

[[ $(grep -i Microsoft /proc/version) ]] && IS_WSL=true

NUGET_CSPROJ="\
<Project Sdk=\"Microsoft.NET.Sdk\">
    <PropertyGroup>
        <TargetFrameworks>netstandard2.0</TargetFrameworks>

        <PackageId>MinimalFFmpegBuild</PackageId>
        <Version>$VERSION</Version>
        <Authors>Hohan Polson</Authors>
        <RequireLicenseAcceptance>false</RequireLicenseAcceptance>

        <GeneratePackageOnBuild>true</GeneratePackageOnBuild>
        <IncludeBuildOutput>false</IncludeBuildOutput>
        <ProjectUrl>https://github.com/macrobond/Minimal-FFmpeg-Build</ProjectUrl>

    </PropertyGroup>
    <ItemGroup>
        <Content Include=\"files/**/*.*\" Pack=\"true\" PackagePath=\"\">
            <PackageCopyToOutput>true</PackageCopyToOutput>
        </Content>
    </ItemGroup>
</Project>"

echo $NUGET_CSPROJ

working_directory=${ARTIFACTS}/nuget

mkdir -p "$working_directory"
pushd "$working_directory"

cp -fr $ARTIFACTS_NO_NAME/build_and_test/nuget_files files

# cp $ARTIFACTS/**.log files/

echo "$NUGET_CSPROJ" > nuget.csproj

dotnet pack

zip -r nuget.csproj.zip nuget.csproj files

echo ls files/runtimes/win-x64/native/
ls -lh files/runtimes/win-x64/native/

# echo ls files/runtimes/linux-x64/native/
# ls -lh files/runtimes/linux-x64/native/

echo ls bin/Release
ls -lh bin/Release

if [[ "$IS_WSL" == "true" ]]; then
    echo VersionInfo
    /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command "(dir .\files\runtimes\win-x64\native\ffmpeg.exe).VersionInfo | fl"
fi

echo nupkg proj
echo "$working_directory"
if [[ "$IS_WSL" == "true" ]]; then
    echo $(wslpath -w $working_directory)
fi

echo "nupkg"
output="$working_directory"/$(ls bin/Release/*.nupkg)
echo "$output"
if [[ "$IS_WSL" == "true" ]]; then
    echo $(wslpath -w $output)
fi

echo nupkg proj zip
zip="$working_directory"/nuget.csproj.zip
echo "$zip"
if [[ "$IS_WSL" == "true" ]]; then
    echo $(wslpath -w $zip)
fi

popd