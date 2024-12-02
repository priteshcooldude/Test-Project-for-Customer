#FROM --platform=linux/amd64 eclipse-temurin:21.0.4_7-jdk-alpine AS build
FROM --platform=linux/amd64 public.ecr.aws/docker/library/eclipse-temurin:21.0.4_7-jdk-alpine AS build
WORKDIR /workspace/app

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src

RUN ./mvnw install
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)

#FROM --platform=linux/amd64 eclipse-temurin:21.0.4_7-jre-alpine
FROM --platform=linux/amd64 public.ecr.aws/docker/library/eclipse-temurin:21.0.4_7-jre-alpine
LABEL maintainer="sebastian.szostek.sp@lhsystems.com"

ARG DEPENDENCY=/workspace/app/target/dependency
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app

COPY cert/LufthansaGroupSubCA1Server-G1.der $JAVA_HOME/lib/security
RUN \
    cd $JAVA_HOME/lib/security \
    && keytool -keystore cacerts -storepass changeit -noprompt -trustcacerts -importcert -alias lhSubCa1Cert -file LufthansaGroupSubCA1Server-G1.der

VOLUME /tmp
#RUN adduser -D g4tuser
#USER g4tuser

ENTRYPOINT ["java", "-XshowSettings:vm", "-XX:+UseZGC", "-XX:MaxRAMPercentage=75.0", "-cp", "app:app/lib/*", "com.dlh.tav.g4t.G4tApplication"]
EXPOSE 8080

