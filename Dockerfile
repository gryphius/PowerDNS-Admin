FROM ubuntu:18.04
ENV ENVIRONMENT=development

RUN mkdir -p /powerdns-admin
WORKDIR /powerdns-admin

RUN apt-get update -y
RUN apt-get install -y apt-transport-https

RUN apt-get install -y locales locales-all
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get install -y python3-pip python3-dev supervisor curl

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

# Install yarn
RUN apt-get update -y
RUN apt-get install -y yarn

# lib for building mysql db driver
RUN apt-get install -y libmysqlclient-dev

# lib for buiding ldap and ssl-based application
RUN apt-get install -y libsasl2-dev libldap2-dev libssl-dev

# lib for building python3-saml
RUN apt-get install -y libxml2-dev libxslt1-dev libxmlsec1-dev libffi-dev pkg-config 


ADD . /powerdns-admin/
RUN pip3 install -r requirements.txt

ADD ./supervisord.conf /etc/supervisord.conf
COPY ./configs/${ENVIRONMENT}.py /powerdns-admin/config.py
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
