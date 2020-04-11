FROM  debian:buster-slim
MAINTAINER amsaravi <mahdi.saravi@gmail.com>

# install important dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 python3-pip git && \
    pip3 install waitress

# install recollcmd from recolls programmers website
RUN apt-get install -y --no-install-recommends gnupg
RUN gpg --keyserver pool.sks-keyservers.net --recv-key F8E3347256922A8AE767605B7808CE96D38B9201
RUN gpg --export '7808CE96D38B9201' | apt-key add --no-tty -
RUN apt-get install --reinstall -y ca-certificates

RUN apt-get update
RUN echo deb http://www.lesbonscomptes.com/recoll/debian/ buster main > \
        /etc/apt/sources.list.d/recoll.list
RUN echo deb-src http://www.lesbonscomptes.com/recoll/debian/ buster main >> \
        /etc/apt/sources.list.d/recoll.list
RUN apt-get install  -y --no-install-recommends recollcmd python3-recoll
RUN apt-get remove gnupg
RUN apt autoremove

# install additional dependencies and software here
# RUN apt-get install -y --no-install-recommends poppler-utils
# RUN apt-get install -y --no-install-recommends unrtf antiword
# RUN apt-get install -y --no-install-recommends unzip 
RUN apt-get clean

RUN mkdir /homes && mkdir /root/.recoll

RUN cd / && git clone https://framagit.org/medoc92/recollwebui.git

VOLUME /homes
EXPOSE 8080

CMD ["/usr/bin/python3", "/recollwebui/webui-standalone.py", "-a", "0.0.0.0"]
