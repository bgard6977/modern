FROM container-registry.oracle.com/database/enterprise:12.2.0.1-slim

# RUN yum check-update

USER root

RUN yum install -y curl sudo gcc-c++ make wget

# node
RUN curl --silent --location https://rpm.nodesource.com/setup_10.x | bash - && \
    yum -y install nodejs && \
    curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | tee /etc/yum.repos.d/yarn.repo && \
    yum install -y yarn

# jenkins
RUN useradd -u 124 jenkins && \
    usermod -aG wheel jenkins && \
    echo "jenkins ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/jenkins
  
# chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm && \
    yum install -y ./google-chrome-stable_current_*.rpm

# chromedriver
RUN wget https://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    mv chromedriver /usr/bin && \
    chromedriver --version

# oracle
RUN usermod -aG wheel oracle && \
    echo "oracle ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/oracle && \
    yum install -y nano net-tools
ENV LD_LIBRARY_PATH=/u01/app/oracle/product/12.2.0/dbhome_1/lib/
USER oracle
RUN cd ~ && \
    echo 'alter session set "_ORACLE_SCRIPT"=true;' >> init.sql && \
    echo 'CREATE USER modern_test IDENTIFIED BY "password";' >> init.sql && \
    echo 'GRANT CONNECT TO modern_test;' >> init.sql && \
    echo 'GRANT CONNECT, RESOURCE, DBA TO modern_test;' >> init.sql && \
    echo "select value from v\$parameter where name='service_names';" >> init.sql && \
    echo 'quit' >> init.sql && \
    sed -i s/wait/echo/g /home/oracle/setup/dockerInit.sh && \
    echo '/u01/app/oracle/product/12.2.0/dbhome_1/bin/sqlplus sys/Oradoc_db1 as SYSDBA @/home/oracle/init.sql' >> /home/oracle/setup/dockerInit.sh
