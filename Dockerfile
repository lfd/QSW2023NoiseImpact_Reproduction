FROM ubuntu:22.04

LABEL authors="Felix Greiwe <felix.greiwe@oth-regensburg.de>, Tom Krüger <tom.krueger@oth-regensburg.de>, Wolfgang Mauerer <wolfgang.mauerer@oth-regensburg.de>" 

ENV LANG="C.UTF-8"
ENV LC_ALL="C.UTF-8"

# Install required packages
RUN apt-get update && apt-get install -y \
        python3 \
        python3-pip \
	vim

ADD --chown=repro:repro . /home/repro/qsw-repro

WORKDIR /home/repro/qsw-repro

# install python packages
ENV PATH $PATH:/home/repro/.local/bin
RUN pip3 install -r requirements.txt

ENTRYPOINT ["bash"]
