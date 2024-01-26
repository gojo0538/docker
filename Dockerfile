FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY . ./
WORKDIR /app/CVAPI
RUN dotnet restore

# Copy everything else and build
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
RUN apt-get update && apt-get install -y apt-utils libgdiplus libc6-dev
RUN cp /usr/share/zoneinfo/Asia/Kolkata /etc/localtime	
RUN rm -rf /etc/localtime	
RUN ln -s /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
WORKDIR /app
#RUN mkdir AppData
COPY --from=build-env /app/CVAPI/out .
ENTRYPOINT ["dotnet", "CVAPI.dll"]
