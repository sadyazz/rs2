FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files
COPY ["eCinema.Subscriber/eCinema.Subscriber.csproj", "eCinema.Subscriber/"]
COPY ["eCinema.Model/eCinema.Model.csproj", "eCinema.Model/"]

# Restore NuGet packages
RUN dotnet restore "eCinema.Subscriber/eCinema.Subscriber.csproj"

# Copy everything else
COPY . .

# Build the project
WORKDIR "/src/eCinema.Subscriber"
RUN dotnet build "eCinema.Subscriber.csproj" -c Release -o /app/build

FROM mcr.microsoft.com/dotnet/runtime:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/build .

ENTRYPOINT ["dotnet", "eCinema.Subscriber.dll"]