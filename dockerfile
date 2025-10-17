# Purpose: To run .NET application
# Maintainer: Sarthak singh
# ---------- BUILD STAGE ----------
# ---------- BUILD STAGE ----------
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Copy the csproj file and restore dependencies
COPY hello-world-api/Properties/hello-world-api.csproj ./hello-world-api/Properties/
RUN dotnet restore ./hello-world-api/Properties/hello-world-api.csproj

# Copy the rest of the source code
COPY . .

# Build the project in Release mode
RUN dotnet publish -c Release -o /app/publish ./hello-world-api/Properties/hello-world-api.csproj

# ---------- RUNTIME STAGE ----------
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app

# Copy only the published output from build stage
COPY --from=build /app/publish ./

# Expose the port your app runs on
EXPOSE 80

# Set the entrypoint
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
