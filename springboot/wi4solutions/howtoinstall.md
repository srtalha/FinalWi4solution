First Step

----Installing Mariadb -----

apt install  default-mysql-server/kali-rolling
apt install default-mysql-client/kali-rolling

----Start mysql-----

# /etc/init.d/mysql start

---install mysql----
mysql_secure_installation
root password should be:v413nt1n4

----------Clone project source code-----------
#apt install git
#apt-get install apache2
#mkdir /var/www/projects
#mkdir -p /var/www/projects
#cd /var/www/projects

Clone repository with your custom git access: (After that you will have project source code in server to install it)

#git clone https://github.com/nesmor/wi4solutions.git
Username for 'https://github.com/nesmor/wi4solutions.git':[github Username]
Password for [github [github Username]] 'https://github.com/nesmor/wi4solutions.git':[github password]

Asterisk Install

#apt update && sudo apt upgrade
#apt install wget build-essential subversion
#cd /usr/src/
#wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-16-current.tar.gz
#tar -zxf asterisk-16-current.tar.gz
#mv asterisk-16.1.0/ asterisk
#cd asterisk/
#contrib/scripts/get_mp3_source.sh
#contrib/scripts/install_prereq install
#./configure
#make menuselect
#make -j2
#make install
#make samples
#make config
#ldconfig
#systemctl enable asterisk
#cp /var/www/projects/wi4solutions/springboot/wi4solutions/asterisk/*conf /etc/asterisk
#cp /var/www/projects/wi4solutions/springboot/wi4solutions/asterisk/odbc.ini /etc/.
#cp /var/www/projects/wi4solutions/springboot/wi4solutions/asterisk/odbcinst.ini /etc/.
#cp /var/www/projects/wi4solutions/springboot/wi4solutions/libs/libmyodbc* /usr/lib/x86_64-linux-gnu/odbc/.
#apt install unixodbc unixodbc-dev unixodbc-bin


Install g729 and g2723 asterisk code:

#cd /var/www/projects/wi4solutions/springboot/wi4solutions/asterisk/codec
#chmod +x codec_g729-ast160-gcc4-glibc-x86_64-pentium4.so
#chmod +x codec_g723-ast160-gcc4-glibc-x86_64-pentium4.so
#cp codec_g723-ast160-gcc4-glibc-x86_64-pentium4.so /usr/lib/asterisk/modules/.
#cp codec_g729-ast160-gcc4-glibc-x86_64-pentium4.so /usr/lib/asterisk/modules/.
#asterisk -rx  "module load codec_g723-ast160-gcc4-glibc-x86_64-pentium4.so"
#asterisk -rx  "module load codec_g729-ast160-gcc4-glibc-x86_64-pentium4.so"
#service asterisk restart


-----Install java and maven--------

#apt install openjdk-8-jdk/kali-rolling

Select number associated to openjdk 1.8 version. By default server has 11 installed.

#update-alternatives  --config java
#apt install maven

Create user and password for database.

Log into mariadb

#mysql -u root -h localhost -p
#password v413nt1n4
mariadb> create database wi4solutions;
mariadb> GRANT ALL PRIVILEGES ON *.* to 'wi4solutions'@'localhost' IDENTIFIED BY 'w14s0l_!';
mariadb> GRANT ALL PRIVILEGES ON *.* to 'wi4solutions'@'%' IDENTIFIED BY 'w14s0l_!';
mariadb> FLUSH PRIVILEGES;

Import database wi4solutions

mariadb>source /var/www/projects/wi4solutions/springboot/wi4solutions/database/wi4solutions.sql;

-----wait for atleast 2 mint----------
please check database and tables;

mariadb>use database wi4solutions;
mariadb>show tables;

----------see if tables are created or not----------------


Change config files base on custom server ip and database settings if it is necesary. Validate odbc connection

echo "select 1" | isql -v asterisk-connector

Out will be something like:

+---------------------------------------+
| Connected!                            |
|                                       |
| sql-statement                         |
| help [tablename]                      |
| quit                                  |
|                                       |
+---------------------------------------+
SQL> select 1
+---------------------+
| 1                   |
+---------------------+
| 1                   |
+---------------------+
SQLRowCount returns 1
1 rows fetched



-------------Compile and package project with maven and install as service----------

#cd /var/www/projects/wi4solutions/springboot/wi4solutions
#mvn  -Dmaven.test.skip=true -Dspring.profiles.active=prod,webpack,no-liquibase package
# cd /var/www/projects/wi4solutions/springboot/wi4solutions/command
#cp  wi4solutions.service  /etc/systemd/system/wi4solutions.service
#vim /etc/systemd/system/wi4solutions.service
----change the user to root---- & Save
#systemctl enable wi4solutions.service
#service wi4solutions start

If want to see any log status, read file syslog to check any success or error message

#tail -200f /var/log/syslog

Can see application open port on syslog output:

Jan 13 13:45:07 vpn-client systemd[1]: Started Wi4solutions System.
Jan 13 13:45:12 vpn-client java[19569]:         ██╗ ██╗   ██╗ ████████╗ ███████╗   ██████╗ ████████╗ ████████╗ ███████╗
Jan 13 13:45:12 vpn-client java[19569]:         ██║ ██║   ██║ ╚══██╔══╝ ██╔═══██╗ ██╔════╝ ╚══██╔══╝ ██╔═════╝ ██╔═══██╗
Jan 13 13:45:12 vpn-client java[19569]:         ██║ ████████║    ██║    ███████╔╝ ╚█████╗     ██║    ██████╗   ███████╔╝
Jan 13 13:45:12 vpn-client java[19569]:   ██╗   ██║ ██╔═══██║    ██║    ██╔════╝   ╚═══██╗    ██║    ██╔═══╝   ██╔══██║
Jan 13 13:45:12 vpn-client java[19569]:   ╚██████╔╝ ██║   ██║ ████████╗ ██║       ██████╔╝    ██║    ████████╗ ██║  ╚██╗
Jan 13 13:45:12 vpn-client java[19569]:    ╚═════╝  ╚═╝   ╚═╝ ╚═══════╝ ╚═╝       ╚═════╝     ╚═╝    ╚═══════╝ ╚═╝   ╚═╝
Jan 13 13:45:12 vpn-client java[19569]: :: JHipster 🤓  :: Running Spring Boot 2.0.6.RELEASE ::
Jan 13 13:45:12 vpn-client java[19569]: :: https://www.jhipster.tech ::
Jan 13 13:45:12 vpn-client java[19569]: 2019-01-13 13:45:12.439  INFO 19569 --- [           main] com.wi4solutions.Wi4SolutionsApp         : Starting Wi4SolutionsApp on vpn-client with PID 19569 (/var/www/projects/wi4solutions/springboot/wi4solutions/target/wi-4-solutions-0.0.1-SNAPSHOT.war started by root in /)
Jan 13 13:45:12 vpn-client java[19569]: 2019-01-13 13:45:12.453  INFO 19569 --- [           main] com.wi4solutions.Wi4SolutionsApp         : The following profiles are active: prod,webpack,no-liquibase
Jan 13 13:45:29 vpn-client java[19569]: 2019-01-13 13:45:29.359  INFO 19569 --- [           main] com.wi4solutions.config.WebConfigurer    : Web application configuration, using profiles: prod
Jan 13 13:45:29 vpn-client java[19569]: 2019-01-13 13:45:29.377  INFO 19569 --- [           main] com.wi4solutions.config.WebConfigurer    : Web application fully configured
Jan 13 13:45:38 vpn-client java[19569]: 2019-01-13 13:45:38.020  INFO 19569 --- [           main] com.wi4solutions.Wi4SolutionsApp         : Started Wi4SolutionsApp in 28.415 seconds (JVM running for 30.155)
Jan 13 13:45:38 vpn-client java[19569]: 2019-01-13 13:45:38.035  INFO 19569 --- [           main] com.wi4solutions.Wi4SolutionsApp         :
Jan 13 13:45:38 vpn-client java[19569]: ----------------------------------------------------------
Jan 13 13:45:38 vpn-client java[19569]: #011Application 'wi4solutions' is running! Access URLs:
Jan 13 13:45:38 vpn-client java[19569]: #011Local: #011#011http://localhost:8080/
Jan 13 13:45:38 vpn-client java[19569]: #011External: #011http://127.0.1.1:8080/
Jan 13 13:45:38 vpn-client java[19569]: #011Profile(s): #011[prod, webpack, no-liquibase]
Jan 13 13:45:38 vpn-client java[19569]: ----------------------------------------------------------

Our application will be available on

http://[Server Public Ip]:8080/


