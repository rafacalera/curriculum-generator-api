FROM --platform=linux/amd64 gradle:8.1.1-jdk17 AS builder

WORKDIR /compilacao


COPY build.gradle .
COPY settings.gradle .

RUN gradle clean build --no-daemon > /dev/null 2>&1 || true

COPY . .

RUN gradle clean build --no-daemon

FROM --platform=linux/amd64 openjdk:17-alpine

WORKDIR /app

COPY --from=builder /compilacao/build/libs/curriculum-generator-api-0.0.1-SNAPSHOT.jar ./api.jar

RUN /bin/sh -c 'touch /app/api.jar'

EXPOSE 8080

CMD ["java", "-jar", "api.jar"]