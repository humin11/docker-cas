FROM panoptix/ubuntu:jdk

MAINTAINER Stephan Buys <stephan.buys@panoptix.co.za>
ENV REFRESHED_ON "29 Jan 2015"

RUN apt-get update && apt-get install -y tomcat7 ldap-utils -qq
RUN apt-get install -y maven git

ENV CATALINA_HOME /usr/share/tomcat7
ENV CATALINA_BASE /var/lib/tomcat7
ENV CATALINA_PID /var/run/tomcat7.pid
ENV CATALINA_SH /usr/share/tomcat7/bin/catalina.sh 
ENV CATALINA_TMPDIR /tmp/tomcat7-tomcat7-tmp
RUN mkdir -p $CATALINA_TMPDIR
RUN mkdir -p $CATALINA_BASE/webapps/

WORKDIR /tmp/
ENV DEPLOYDIR /var/lib/tomcat7/webapps/
RUN git clone https://github.com/panoptix-za/cas-overlay.git 
WORKDIR /tmp/cas-overlay/
ENV JAVA_HOME /usr/lib/jvm/default-java
RUN mvn clean package 
RUN cp /tmp/cas-overlay/target/cas.war $CATALINA_BASE/webapps/

#VOLUME [ "/var/lib/tomcat7/webapps/" ]
ADD cas.properties /etc/cas/cas.properties
ADD log4j.xml /etc/cas/log4j.xml
ADD server.xml /etc/tomcat7/

EXPOSE 8080 8443

ENTRYPOINT [ "/usr/share/tomcat7/bin/catalina.sh"]

CMD ["run"]
