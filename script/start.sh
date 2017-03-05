#!/bin/bash
service httpd start
service nagios start
cd /opt/pynag
pip install -e .
cd /opt/adagios
pip install -e .
cd /opt/adagios/adagios
python manage.py runserver 0.0.0.0:8000

/bin/bash
