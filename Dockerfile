FROM bellsoft/liberica-openjdk-alpine:17

# set environment variables
ENV APP_NAME=aperture-auto
ENV JAR_FILE=build/libs/$APP_NAME.jar
ENV BOOTSTRAP_CONFIG=src/main/resources/bootstrap.yml

# copy application files
COPY ${JAR_FILE} /app/${JAR_FILE}
COPY ${BOOTSTRAP_CONFIG} /app/${BOOTSTRAP_CONFIG}

# navigate to app directory
WORKDIR /app

# run application
ENTRYPOINT ["sh", "-c", "java -jar ${JAR_FILE} --spring.config.name=bootstrap --spring.config.location=file:/app/${BOOTSTRAP_CONFIG}"]
