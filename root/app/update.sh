#!/usr/bin/with-contenv bash
# shellcheck shell=bash

cd /app/wg++/bin.net || exit 1

/app/dotnet/dotnet "WebGrab+Plus.dll" "/config"
