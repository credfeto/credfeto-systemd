# shellcheck shell=sh
[ -d "/usr/share/dotnet" ] && export DOTNET_ROOT=/usr/share/dotnet
[ -d "/usr/share/dotnet" ] && PATH="$PATH:$DOTNET_ROOT"

# Dotnet settings
export DOTNET_NOLOGO=true
export DOTNET_PRINT_TELEMETRY_MESSAGE=false
export DOTNET_JitCollect64BitCounts=1
export DOTNET_ReadyToRun=0
export DOTNET_TC_QuickJitForLoops=1
export DOTNET_TC_CallCountingDelayMs=0
export DOTNET_TieredPGO=1
export MSBUILDTERMINALLOGGER=auto
export SuppressNETCoreSdkPreviewMessage=true
