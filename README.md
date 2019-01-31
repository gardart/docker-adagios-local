# docker-adagios-local
Clone this repo and build the Docker image for docker-adagios-local
```
mkdir ~/code
cd ~/code
git clone https://github.com/gardart/docker-adagios-local
cd docker-adagios-local
docker build -t docker-adagios .
```

Download the newest Adagios/Pynag code from github
```
cd ~/code
git clone git://github.com/pynag/pynag.git
git clone git://github.com/opinkerfi/adagios.git
```
Make some changes in pynag or Adagios in ~/code

Now run your code with Nagios and Docker
```
docker run -it -p 8080:80 -p 8000:8000 -v ~/code/adagios:/opt/adagios -v ~/code/pynag:/opt/pynag --name adagios docker-adagios
```

User:nagiosadmin
Password:nagiosadmin

Access Adagios
http://localhost:8080/adagios

Access Nagios
http://localhost:8080/nagios

Access Adagios (using Django developement webserver)
http://localhost:8000

### Development
After making some code changes locally in ~/code/adagios or ~/code/pynag you can test your code by restarting the container.
It will run setup scripts for both adagios and pynag and the start the web services.
```
docker restart adagios
```

To make some changes inside the container, f.eks test different version of Django, you can connect to the container:
```
docker exec -it adagios /bin/bash
pip uninstall django
pip install django==1.9
```
...and test
```
/usr/bin/python /opt/adagios/adagios/manage.py runserver 0.0.0.0:8000
```
