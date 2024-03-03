# Use the official .NET Core SDK image as a build image
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src

# Copy the project files to the container
COPY . .

# Restore the project dependencies
RUN dotnet restore "ShuttleInfraAPI.csproj"

# Build the project
RUN dotnet build "ShuttleInfraAPI.csproj" -c Release -o /app/build

# Publish the project
RUN dotnet publish "ShuttleInfraAPI.csproj" -c Release -o /app/publish

# Use the official .NET Core runtime image as the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
WORKDIR /app

# Copy the published output from the build image
COPY --from=build /app/publish .

# Expose the port that the application will run on
EXPOSE 80

# Run the application
CMD ["dotnet", "ShuttleInfraAPI.dll"]
