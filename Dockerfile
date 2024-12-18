FROM indusindregistry.azurecr.io/ubi8/openjdk-17
USER root
#RUN rpm --erase --nodeps tzdata && microdnf install tzdata -y
USER jboss
COPY build/libs/*.jar /home/jboss/crmnext.jar
EXPOSE 11791
ENTRYPOINT ["java","-jar","/home/jboss/crmnext.jar"]