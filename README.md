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
docker run -it -p 80:80 -p 8000:8000 -v ~/code/adagios:/opt/adagios -v ~/code/pynag:/opt/pynag --name adagios docker-adagios
```
Access nagios here
http://dockerhost:80

Access Adagios here
http://dockerhost:8000
