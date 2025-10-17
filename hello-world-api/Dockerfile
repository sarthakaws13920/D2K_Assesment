# Use .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Copy csproj and restore dependencies
COPY hello-world-api.csproj ./
RUN dotnet restore hello-world-api.csproj

# Copy everything and build the app
COPY . .
RUN dotnet publish hello-world-api.csproj -c Release -o /out

# Use the ASP.NET runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build /out .
EXPOSE 80
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
