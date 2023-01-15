# Use an official BellSoft Liberica JDK image as the base image
FROM bellsoft/liberica-openjdk-alpine:17

# Set the working directory
WORKDIR /app

# Copy the application jar file to the container
COPY target/aperture-auto.jar /app

# Expose port 8080
EXPOSE 8080

# Set the entrypoint to run the application
ENTRYPOINT ["java","-jar","aperture-auto.jar"]