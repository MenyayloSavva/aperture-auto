FROM bellsoft/liberica-openjdk-alpine:17

# set environment variables
ENV APP_NAME=aperture-auto
ENV JAR_FILE=build/libs/$APP_NAME.jar

# copy application files
COPY ${JAR_FILE} /app/${JAR_FILE}

# navigate to app directory
WORKDIR /app

# run application
ENTRYPOINT ["sh", "-c", "java -jar ${JAR_FILE}"]
