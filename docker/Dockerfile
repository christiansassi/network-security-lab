FROM kalilinux/kali-rolling

WORKDIR /network_security_lab

RUN apt-get update && \
    apt-get -y install python2 python3 python3-pip vim wget git && \
    wget https://bootstrap.pypa.io/pip/2.7/get-pip.py && \
    python2 get-pip.py && \
    pip2 install scapy==2.3.3 && \
    rm get-pip.py

COPY install_sslstrip.sh /install_sslstrip.sh
RUN chmod +x /install_sslstrip.sh
RUN /install_sslstrip.sh \
    rm install_sslstrip.sh

RUN git clone https://github.com/vanhoefm/krackattacks-poc-zerokey.git

CMD ["bash"]
