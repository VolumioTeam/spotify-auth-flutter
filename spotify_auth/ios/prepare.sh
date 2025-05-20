#!/bin/sh

set -e

rm -fR ios-sdk
mkdir ios-sdk
git clone https://github.com/spotify/ios-sdk
git -C ios-sdk checkout tags/v3.0.0
find ./ios-sdk -mindepth 1 -maxdepth 1 -not -name SpotifyiOS.xcframework -exec rm -rf '{}' \;   # Keep on only the xcframework folder
