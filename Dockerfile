# escape=\

# Stage 1 - Build
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8 AS build
# Windows 10 or Windows Server 2019
# FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019 AS build
# Windows 11 or Windows Server 2022
# FROM mcr.microsoft.com/dotnet/framework/sdk:4.8.1-windowsservercore-ltsc2022 AS build

WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY aspnetmvcapp/*.csproj ./aspnetmvcapp/
COPY aspnetmvcapp/*.config ./aspnetmvcapp/
RUN nuget restore

# copy everything else and build app
COPY aspnetmvcapp/. ./aspnetmvcapp/
WORKDIR /app/aspnetmvcapp
RUN msbuild /p:Configuration=Release -r:False

# Stage 2 - Runtime
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8 AS runtime
# Windows 10 or Windows Server 2019
# FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019 AS build
# Windows 11 or Windows Server 2022
# FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8.1-windowsservercore-ltsc2022 AS build

WORKDIR /inetpub/wwwroot
COPY --from=build /app/aspnetmvcapp/. ./
