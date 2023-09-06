ASP.NET Framework 4.8 Container Image for AKS
=============================================

Credits
-------

Based on original code at: https://github.com/microsoft/dotnet-framework-docker/tree/main/samples/aspnetmvcapp

Assumptions
-----------

* Visual Studio Solution (`myproject.sln`) file in this dir
* Project directory in a subdir (`myproject`) with a project file (`myproject\myproject.csproj`)
* Running Docker Desktop on Windows 10 or Windows 11 (with Windows Containers mode active)
* Using Process Isolation for containers (on Desktop and AKS - if deploying to Kubernetes)

```powershell
# Check https://github.com/microsoft/windows-container-tools/releases for latest stable release
Invoke-WebRequest -Uri 'https://github.com/microsoft/windows-container-tools/releases/download/v2.0/LogMonitor.exe' -OutFile '.\LogMonitor.exe'

$env:REPOSITORY='aspnetmvcapp'
$env:TAG='v1.0'
$env:PROJECT_NAME='aspnetmvcapp'
```

See .NET Framework image tags here: https://mcr.microsoft.com/en-us/product/dotnet/framework/sdk/tags

For Windows 11/Windows Server 2022:

```powershell
docker pull mcr.microsoft.com/dotnet/framework/sdk:4.8.1-windowsservercore-ltsc2022
docker pull mcr.microsoft.com/dotnet/framework/aspnet:4.8.1-windowsservercore-ltsc2022

docker tag mcr.microsoft.com/dotnet/framework/sdk:4.8.1-windowsservercore-ltsc2022 mcr.microsoft.com/dotnet/framework/sdk:4.8
docker tag mcr.microsoft.com/dotnet/framework/aspnet:4.8.1-windowsservercore-ltsc2022 mcr.microsoft.com/dotnet/framework/aspnet:4.8
```

For Windows 10/Windows Server 2019:

```powershell
docker pull mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019
docker pull mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019

docker tag mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019 mcr.microsoft.com/dotnet/framework/sdk:4.8
docker tag mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019 mcr.microsoft.com/dotnet/framework/aspnet:4.8
```

Test on Docker Desktop
----------------------

```powershell
# Build without LogMonitor
docker build --build-arg project_name=$env:PROJECT_NAME -t $env:REPOSITORY:$env:TAG .

# Build with LogMonitor
$env:TAG="$env:TAG-logmonitor"
docker build --build-arg project_name=$env:PROJECT_NAME -t $env:REPOSITORY:$env:TAG -f Dockerfile.logmonitor .

docker run --rm -ti --name $env:PROJECT_NAME --isolation=process -p 8080:80 $env:REPOSITORY:$env:TAG
```

Browse to: [http://localhost:8080/Home/About](http://localhost:8080/Home/About)

Cores will match your host logical processors (e.g. 8).

```powershell
docker exec -ti $env:PROJECT_NAME powershell

Get-WmiObject -class win32_processor -Property “NumberOfLogicalProcessors” | Select-Object -Property “NumberOfLogicalProcessors”

# NumberOfLogicalProcessors
# -------------------------
#                        8

exit
```

Restrict vCPUs and Memory available to the container:

```powershell
docker run --rm -ti --name $env:PROJECT_NAME --isolation=process --cpus=1 --memory="1g" --isolation=process -p 8080:80 $env:REPOSITORY:$env:TAG
```

Browse to: [http://localhost:8080/Home/About](http://localhost:8080/Home/About)

```powershell
docker exec -ti $env:PROJECT_NAME powershell

Get-WmiObject -class win32_processor -Property “NumberOfLogicalProcessors” | Select-Object -Property “NumberOfLogicalProcessors”

# NumberOfLogicalProcessors
# -------------------------
#                        1

exit
```

Cores match requested CPUs.  In this case 1 logical processor.

The same applies when deployed to Kubernetes and specifying the CPU or Memory limits.

Push image to Docker Hub or logged in container registry
--------------------------------------------------------

```powershell
docker login
docker push $REPOSITORY:$TAG
```

Push image to ACR
-----------------

```powershell
# TODO
```

Deploy to AKS
-------------

TODO

- Test memory and CPU limits on AKs
- Test running multiple pods on windows nodes
- Test autoscaling and HPa with KEDA
- Test Deallocate mode vs delete mode

Resources
---------

* [.NET Framework 4.8 Container Improvements (November 2021 Update, KB9008392)](https://github.com/microsoft/dotnet-framework-docker/issues/849)
