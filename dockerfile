# Purpose: To run .NET application
# Maintainer: Sarthak singh
# ---------- BUILD STAGE ----------
FROM mcr.microsoft.com/dotnet/sdk:2.0 AS build
WORKDIR /app

# Copy csproj and restore
COPY hello-world-api/hello-world-api.csproj ./hello-world-api/
RUN dotnet restore ./hello-world-api/hello-world-api.csproj

# Copy the rest of the source code
COPY . .

# Build and publish
RUN dotnet publish -c Release -o /app/publish ./hello-world-api/hello-world-api.csproj

# ---------- RUNTIME STAGE ----------
FROM mcr.microsoft.com/dotnet/aspnet:2.0 AS runtime
WORKDIR /app

# Copy the published output
COPY --from=build /app/publish ./

# Expose port
EXPOSE 80

# Set the entrypoint
ENTRYPOINT ["dotnet", "hello-world-api.dll"]


