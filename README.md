ASP.NET Framework 4.8 Container Image for AKS
=============================================

Credits
-------

Based on original code at: https://github.com/microsoft/dotnet-framework-docker/tree/main/samples/aspnetmvcapp

Assumptions
-----------

* Solution file in this dir
* Project direct in a subdir
* Running Docker Desktop on Windows 11 (with Windows Containers mode)
* Using Process Isolation for containers

```pwsh
wget https://github.com/microsoft/windows-container-tools/releases/download/v1.1/LogMonitor.exe

REPOSITORY=aspnetmvcapp
TAG=v1.0
PROJECT_NAME=aspnetmvcapp
```

Windows 11/Windows Server 2022

```
docker pull mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2022
docker pull mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2022

docker tag mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2022 mcr.microsoft.com/dotnet/framework/sdk:4.8
docker tag mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2022 mcr.microsoft.com/dotnet/framework/aspnet:4.8

docker build --build-arg project_name=$PROJECT_NAME -t $REPOSITORY:$TAG .
docker push $REPOSITORY:$TAG
```

Windows 10/Windows Server 2019

```pwsh
docker pull mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019
docker pull mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019

docker tag mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019 mcr.microsoft.com/dotnet/framework/sdk:4.8
docker tag mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019 mcr.microsoft.com/dotnet/framework/aspnet:4.8

docker build --build-arg project_name=$PROJECT_NAME -t $REPOSITORY:$TAG .
docker push $REPOSITORY:$TAG
```

Test on Docker Desktop, Windows 11
----------------------------------

```pwsh
docker run --rm -ti --isolation=process -p 8080:80 aspnetmvcapp:v1.0
```

Browse to: [http://localhost:8080/Home/About](http://localhost:8080/Home/About)

Cores will match your host logical processors (e.g. 8).

```pwsh
Get-WmiObject -class win32_processor -Property “NumberOfLogicalProcessors” | Select-Object -Property “NumberOfLogicalProcessors”

# NumberOfLogicalProcessors
# -------------------------
#                        8
```

```pwsh
docker run --rm -ti --isolation=process --cpus 1 -p 8080:80 aspnetmvcapp:v1.0
```

Browse to: [http://localhost:8080/Home/About](http://localhost:8080/Home/About)

Cores match requested CPUs.  In this case 1 logical processor.

The same applies when deployed to Kubernetes and specifying the CPU or Memory limits.
