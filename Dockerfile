FROM tomcat:9.0.19-jre8-alpine

COPY ./target/java-hello-world.war /usr/local/tomcat/webapp