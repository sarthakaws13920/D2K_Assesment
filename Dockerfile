# Purpose: To run .NET application
# Maintainer: Sarthak singh
# ---------- BUILD STAGE ----------
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Copy csproj and restore as a separate step (caching benefits)
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the source code
COPY . ./

# Build the project in Release mode
RUN dotnet publish -c Release -o /app/publish

# ---------- RUNTIME STAGE ----------
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app

# Copy only the published output from build stage
COPY --from=build /app/publish ./

# Expose the port your app runs on (adjust if needed)
EXPOSE 80

# Set the entrypoint
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
