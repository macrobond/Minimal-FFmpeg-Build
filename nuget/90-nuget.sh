#!/bin/bash

set -e
set -o pipefail

VERSION=$1

[[ $(grep -i Microsoft /proc/version) ]] && IS_WSL=true

NUGET_CSPROJ="\
<Project Sdk=\"Microsoft.NET.Sdk\">
    <PropertyGroup>
        <TargetFrameworks>netstandard2.0</TargetFrameworks>

        <Version>$VERSION</Version>
        <Authors>Hohan Polson</Authors>
        <RequireLicenseAcceptance>false</RequireLicenseAcceptance>

        <GeneratePackageOnBuild>true</GeneratePackageOnBuild>
        <IncludeBuildOutput>false</IncludeBuildOutput>
    </PropertyGroup>
    <ItemGroup>
        <Content Include=\"files/**/*.*\" Pack=\"true\" PackagePath=\"\">
            <PackageCopyToOutput>true</PackageCopyToOutput>
        </Content>
    </ItemGroup>
    <Target Name=\"ValidateCommandLine\" BeforeTargets=\"GenerateNuspec\">
        <Error Text=\"The PackageId property must be set on the command line.\" Condition=\"'\$(PackageId)' == ''\" />
    </Target>
</Project>"

echo $NUGET_CSPROJ

working_directory=${ARTIFACTS}/nuget

mkdir -p "$working_directory"
pushd "$working_directory"

mkdir -p files/runtimes/win-x64/native
cp -f $ARTIFACTS/win64/ffmpeg/ffmpeg.exe files/runtimes/win-x64/native/ffmpeg.exe

# mkdir -p files/runtimes/linux-x64/native
# cp -f $ARTIFACTS/linux64/ffmpeg/ffmpeg files/runtimes/linux-x64/native/ffmpeg

cp $ARTIFACTS/**.log files/

echo "$NUGET_CSPROJ" > nuget.csproj

dotnet pack

tar -czvf nuget.csproj.tar.gz nuget.csproj files

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

echo ffmpeg.exe -L
wine files/runtimes/win-x64/native/ffmpeg.exe -L

echo nupkg proj
echo "$working_directory"
if [[ "$IS_WSL" == "true" ]]; then
    echo $(wslpath -w $working_directory)
fi

echo "nupkg"
local output="$working_directory"/$(ls bin/Release/*.nupkg)
echo "$output"
if [[ "$IS_WSL" == "true" ]]; then
    echo $(wslpath -w $output)
fi

echo nupkg proj tar
local tar="$working_directory"/nuget.csproj.tar.gz
echo "$tar"
if [[ "$IS_WSL" == "true" ]]; then
    echo $(wslpath -w $tar)
fi

popd