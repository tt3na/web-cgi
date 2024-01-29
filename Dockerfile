FROM almalinux:9

ENV LANG ja_JP.UTF-8
ENV TZ Asia/Tokyo

RUN groupadd -g 1000 abc
RUN useradd --uid 1000 --gid 1000 --shell /bin/bash -G wheel,abc abc
RUN ulimit -n 1024000 && yum update -y
RUN yum install -y python httpd vim 

WORKDIR /home/abc

CMD ["/home/abc/entrypoint.sh"]
