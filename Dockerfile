# Purpose: To run .NET application
# Maintainer: Sarthak singh
# ---------- BUILD STAGE ----------
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Copy csproj and restore dependencies
COPY hello-world-api/hello-world-api.csproj ./hello-world-api/
RUN dotnet restore ./hello-world-api/hello-world-api.csproj

# Copy the full project
COPY . .

# Build and publish
RUN dotnet publish -c Release -o /app/publish ./hello-world-api/hello-world-api.csproj

# ---------- RUNTIME STAGE ----------
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app

# Copy the published output from the build stage
COPY --from=build /app/publish .

# Set the entrypoint
ENTRYPOINT ["dotnet", "hello-world-api.dll"]



