############################################################
# Dockerfile to build a Naemon/Adagios server
# Based on appcontainers/nagios
############################################################

FROM centos:6
MAINTAINER "Gardar Thorsteinsson" <gardart@gmail.com>

ENV ADAGIOS_HOST adagios.local
ENV ADAGIOS_USER adagios
ENV ADAGIOS_PASS adagios
ENV THRUK_USER thrukadmin
ENV THRUK_PASS thrukadmin

# First install the opensource.is and consol labs repositories
RUN rpm -ihv http://opensource.is/repo/ok-release.rpm
RUN yum update -y ok-release
RUN rpm -Uvh "https://labs.consol.de/repo/stable/rhel6/i386/labs-consol-stable.rhel6.noarch.rpm"

# Redhat/Centos users need to install the epel repositories (fedora users skip this step)
RUN yum install -y epel-release

RUN yum clean all && yum -y update

# Install naemon, adagios and other needed packages
RUN yum install -y httpd mod_wsgi
RUN yum install -y nagios  nagios-plugins-all git acl pnp4nagios python-setuptools postfix python-pip
RUN yum install -y mk-livestatus

#RUN yum install -y Django python-simplejson
RUN yum install -y okconfig

# Now all the packages have been installed, and we need to do a little bit of
# configuration before we start doing awesome monitoring

WORKDIR /etc/nagios

# Lets make sure adagios can write to nagios configuration files, and that
# it is a valid git repo so we have audit trail
RUN git init /etc/nagios/
RUN git config user.name "User"
RUN git config user.email "email@mail.com"
RUN git add *
RUN git commit -m "Initial commit"

# Make sure nagios group will always have write access to the configuration files:
RUN chown -R nagios /etc/nagios/* /etc/nagios/.git
RUN setfacl -R -m group:nagios:rwx /etc/nagios/
RUN setfacl -R -m d:group:nagios:rwx /etc/nagios/



# Fix permissions for naemon and pnp4nagios

# Install Pynag from Git
RUN mkdir -p /opt/pynag
WORKDIR /opt/
RUN pip install django==1.6
RUN pip install simplejson
RUN git clone git://github.com/pynag/pynag.git


# Install Adagios from Git
RUN mkdir -p /opt/adagios
WORKDIR /opt
RUN git clone git://github.com/opinkerfi/adagios.git
WORKDIR /opt/adagios/adagios
RUN cp -r etc/adagios /etc/adagios
RUN chown -R nagios:nagios /etc/adagios
RUN chmod g+w -R /etc/adagios
RUN mkdir -p /var/lib/adagios/userdata
RUN chown nagios:nagios /var/lib/adagios
RUN mkdir /etc/nagios/adagios
RUN setfacl -R -m d:g:nagios:rwx /etc/nagios
RUN setfacl -R -m g:nagios:rwx /etc/nagios

# Add naemon to apache group so it has permissions to pnp4nagios's session files
RUN usermod -G apache nagios




# Enable Naemon performance data
RUN pynag config --set "process_performance_data=1"


# Redirect root URL to /adagios
#RUN echo "RedirectMatch ^/$ /adagios" > /etc/httpd/conf.d/redirect.conf

#RUN sed -i 's|^\(nagios_init_script\)=\(.*\)$|\1="sudo /usr/bin/naemon-supervisor-wrapper.sh"|g' /etc/adagios/adagios.conf

# add sample configuration and plugins 
ADD ./script /bin/
RUN chmod +rx /bin/start.sh

EXPOSE 80
EXPOSE 8000

VOLUME ["/etc/nagios", "/var/log/nagios", "/etc/adagios", "/opt/adagios", "/opt/pynag"]
#CMD ["/usr/sbin/init"]
CMD ["/bin/start.sh"]
