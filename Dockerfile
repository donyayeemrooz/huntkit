FROM kalilinux/kali

LABEL maintainer="Matt Mcnamee"

# Environment Variables
ENV HOME=/root
ENV TOOLS="${HOME}/tools"
ENV WORDLISTS="${HOME}/wordlists"
ENV GO111MODULE=on
ENV GOROOT=/usr/local/go
ENV GOPATH=/root/go
ENV PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}

# Create working dirs
WORKDIR /root
RUN mkdir ${TOOLS} && mkdir ${WORDLISTS}

# ------------------------------
# Common Dependencies
# ------------------------------

# Install Essentials
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    awscli \
    build-essential \
    curl \
    dnsutils \
    gcc \
    git \
    iputils-ping \
    make \
    nano \
    net-tools \
    perl \
    python \
    python3 \
    python3-pip \
    tmux \
    tzdata \
    wget \
    whois \
    zsh \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    # dirb
    dirb \
    # dnsenum
    cpanminus \
    # hydra
    hydra \
     # joomscan
    libwww-perl \
    # nikto
    nikto \
    # nmap
    nmap \
    # sqlmap
    sqlmap \
    # wpcscan
    libcurl4-openssl-dev \
    libgmp-dev \
    libxml2 \
    libxml2-dev \
    libxslt1-dev \
    ruby-dev \
    zlib1g-dev \
    # zsh
    fonts-powerline \
    powerline

# Install go
RUN cd /opt && \
    wget https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz && \
    tar -xvf go1.14.4.linux-amd64.tar.gz && \
    rm -rf /opt/go1.14.4.linux-amd64.tar.gz && \
    mv go /usr/local

# Install Python common dependencies
RUN python3 -m pip install --upgrade setuptools wheel

# ------------------------------
# Tools
# ------------------------------

# amass
RUN go get -v github.com/OWASP/Amass/v3/...

# cloudflair
RUN git clone --depth 1 https://github.com/christophetd/CloudFlair.git ${TOOLS}/cloudflair && \
  cd ${TOOLS}/cloudflair && \
  python3 -m pip install -r requirements.txt && \
  chmod +x cloudflair.py && \
  ln -sf ${TOOLS}/cloudflair/cloudflair.py /usr/local/bin/cloudflair

# commix
RUN git clone --depth 1 https://github.com/commixproject/commix.git ${TOOLS}/commix && \
  cd ${TOOLS}/commix && \
  chmod +x commix.py && \
  ln -sf ${TOOLS}/commix/commix.py /usr/local/bin/commix

# dirsearch
RUN git clone --depth 1 https://github.com/maurosoria/dirsearch.git ${TOOLS}/dirsearch && \
  cd ${TOOLS}/dirsearch && \
  chmod +x dirsearch.py && \
  ln -sf ${TOOLS}/dirsearch/dirsearch.py /usr/local/bin/dirsearch

# dnsenum
RUN git clone --depth 1 https://github.com/fwaeytens/dnsenum.git ${TOOLS}/dnsenum && \
  cd ${TOOLS}/dnsenum && \
  cpanm String::Random && \
  cpanm Net::DNS && \
  cpanm Net::IP && \
  cpanm Net::Netmask && \
  cpanm XML::Writer && \
  cpanm Net::Whois::IP && \
  cpanm HTML::Parser && \
  cpanm WWW::Mechanize && \
  cpanm XML::Writer && \
  chmod +x dnsenum.pl && \
  ln -s ${TOOLS}/dnsenum/dnsenum.pl /usr/bin/dnsenum

# exploitdb (searchsploit)
RUN git clone https://github.com/offensive-security/exploitdb.git ${TOOLS}/exploitdb && \
  cd ${TOOLS}/exploitdb && \
  ln -s ${TOOLS}/exploitdb/searchsploit /usr/bin/searchsploit

# fierce
RUN python3 -m pip install fierce

# gobuster
RUN git clone --depth 1 https://github.com/OJ/gobuster.git ${TOOLS}/gobuster && \
  cd ${TOOLS}/gobuster && \
  go get && go install

# joomscan
RUN git clone --depth 1 https://github.com/rezasp/joomscan.git ${TOOLS}/joomscan && \
  cd ${TOOLS}/joomscan && \
  chmod +x joomscan.pl && \
  ln -sf ${TOOLS}/joomscan/joomscan.pl /usr/local/bin/joomscan

# recon-ng
RUN git clone --depth 1 https://github.com/lanmaster53/recon-ng.git ${TOOLS}/recon-ng && \
  cd ${TOOLS}/recon-ng && \
  python3 -m pip install -r REQUIREMENTS && \
  chmod +x recon-ng && \
  ln -sf ${TOOLS}/recon-ng/recon-ng /usr/local/bin/recon-ng

# subfinder
RUN go get -v github.com/projectdiscovery/subfinder/cmd/subfinder

# sublist3r
RUN git clone --depth 1 https://github.com/aboul3la/Sublist3r.git ${TOOLS}/sublist3r && \
  cd ${TOOLS}/sublist3r && \
  python3 -m pip install -r requirements.txt && \
  ln -s ${TOOLS}/sublist3r/sublist3r.py /usr/local/bin/sublist3r

# theharvester
RUN git clone --depth 1 https://github.com/laramies/theHarvester ${TOOLS}/theharvester && \
  cd ${TOOLS}/theharvester && \
  python3 -m pip install pipenv && \
  python3 -m pip install -r requirements/base.txt && \
  chmod +x theHarvester.py && \
  ln -sf ${TOOLS}/theharvester/theHarvester.py /usr/local/bin/theharvester

# virtual-host-discovery
RUN git clone --depth 1 https://github.com/jobertabma/virtual-host-discovery.git ${TOOLS}/virtual-host-discovery && \
  cd ${TOOLS}/virtual-host-discovery && \
  chmod +x scan.rb && \
  ln -sf ${TOOLS}/virtual-host-discovery/scan.rb /usr/local/bin/virtual-host-discovery

# wafw00f
RUN git clone --depth 1 https://github.com/enablesecurity/wafw00f.git ${TOOLS}/wafw00f && \
  cd ${TOOLS}/wafw00f && \
  chmod +x setup.py && \
  python3 setup.py install

# wfuzz
# RUN python3 -m pip install wfuzz

# whatweb
RUN git clone --depth 1 https://github.com/urbanadventurer/WhatWeb.git ${TOOLS}/whatweb && \
  cd ${TOOLS}/whatweb && \
  chmod +x whatweb && \
  ln -sf ${TOOLS}/whatweb/whatweb /usr/local/bin/whatweb

# wpscan
RUN git clone --depth 1 https://github.com/wpscanteam/wpscan.git ${TOOLS}/wpscan && \
  cd ${TOOLS}/wpscan && \
  gem install bundler && bundle install --without test && \
  gem install wpscan

# xsstrike
RUN git clone --depth 1 https://github.com/s0md3v/XSStrike.git ${TOOLS}/xsstrike && \
  cd ${TOOLS}/xsstrike && \
  python3 -m pip install -r requirements.txt && \
  chmod +x xsstrike.py && \
  ln -sf ${TOOLS}/xsstrike/xsstrike.py /usr/local/bin/xsstrike

# ------------------------------
# Wordlists
# ------------------------------

# seclists
RUN  git clone --depth 1 https://github.com/danielmiessler/SecLists.git ${WORDLISTS}/seclists

# Symlink other wordlists
RUN ln -s /root/tools/theHarvester/wordlists ${WORDLISTS}/theharvester && \
  ln -s /usr/share/dirb/wordlists ${WORDLISTS}/dirb

# ------------------------------
# Other utilities
# ------------------------------

# Set timezone
RUN ln -fs /usr/share/zoneinfo/Australia/Brisbane /etc/localtime && \
  dpkg-reconfigure --frontend noninteractive tzdata

# Command line updates
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
  chsh -s $(which zsh)

# Cleanup
RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/bin/zsh" ]
CMD ["-l"]
