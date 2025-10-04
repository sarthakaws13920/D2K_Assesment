FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS build
WORKDIR /src

COPY hello-world-api/*.csproj ./hello-world-api/
RUN dotnet restore ./hello-world-api/hello-world-api.csproj

COPY . .
WORKDIR /src/hello-world-api
RUN dotnet publish -c Release -o /app/out

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

# 👇  Important: Make ASP.NET Core listen on all IPs, not just localhost
ENV ASPNETCORE_URLS=http://0.0.0.0:80

EXPOSE 80
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
