FROM ruby:2.7.1

RUN useradd module_1 && useradd module_2 && useradd module_3
RUN gem install oj ox
RUN apt-get update && apt-get install -y xinetd

COPY ./modules/ /modules
COPY ./xinetd.conf /etc/xinetd.conf
COPY ./entrypoint.sh /entrypoint.sh

CMD ["bash", "/entrypoint.sh"]
