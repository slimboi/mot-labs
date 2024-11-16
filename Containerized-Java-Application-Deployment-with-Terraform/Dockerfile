FROM eclipse-temurin:11-jre-noble
COPY . /app
WORKDIR /app
ENTRYPOINT [ "java", "-jar", "spring-petclinic-2.4.2.war", "--server.port=8080"]