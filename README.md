# docker-adagios-local
Clone this repo and build the Docker image for docker-adagios-local
```
docker build -t docker-adagios .
```

Download the newest Adagios/Pynag code from github
```
mkdir ~/code
cd ~/code
git clone git://github.com/pynag/pynag.git
git clone git://github.com/opinkerfi/adagios.git
```
Make some changes in pynag or Adagios in ~/code

Now run your code with Nagios and Docker
```
docker run -it -p 80:80 -p 8081:8000 -v ~/code/adagios:/opt/adagios -v ~/code/pynag:/opt/pynag --name adagios docker-adagios
```

User:nagiosadmin
Password:nagiosadmin

Access Adagios
http://localhost:8081/adagios

Access Nagios
http://localhost:8081/nagios

Access Adagios (using Django developement webserver)
http://localhost:8000
