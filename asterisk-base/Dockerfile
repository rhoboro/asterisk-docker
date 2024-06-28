FROM ubuntu:24.04

ARG country_code=81
ARG asterisk_version=20.8.1

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  build-essential \
  gdb \
  libopus-dev \
  libopus0 \
  libreadline-dev \
  libreadline8 \
  libssl-dev \
  net-tools \
  opus-tools \
  postgresql-client \
  postgresql-client-common \
  sudo \
  unzip \
  wget \
  zlib1g \
  zlib1g-dev

# Grobal
RUN useradd -U -m -s /bin/bash asterisk \
  && echo 'asterisk ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && usermod -aG sudo asterisk \
  && mkdir -p /usr/local/src \
  && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Install Asterisk
RUN wget -O - https://github.com/cisco/libsrtp/archive/v2.6.0.tar.gz | tar zx -C /usr/local/src \
  && cd /usr/local/src/libsrtp-2.6.0 \
  && ./configure --prefix=/usr/local/libsrtp --enable-openssl \
  && make \
  && make install \
  && rm -rf /usr/local/src/libsrtp-2.6.0

RUN wget -O - http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-${asterisk_version}.tar.gz | tar zx -C /usr/local/src \
  && cd /usr/local/src/asterisk-${asterisk_version} \
  && sed -i 's/#define\ NUM_CACHE_BUCKETS\ 563/#define\ NUM_CACHE_BUCKETS\ 22520/g' ./main/stasis_cache.c \
  && sed -i 's/PJ_ICE_MAX_CAND\ 32/PJ_ICE_MAX_CAND\ 64/g' third-party/pjproject/patches/config_site.h \
  && echo "libvpb1 libvpb1/countrycode string ${country_code}" | debconf-set-selections \
  && yes | bash contrib/scripts/install_prereq install \
  && ./contrib/scripts/get_mp3_source.sh \
  && export PKG_CONFIG_PATH=/usr/lib/pkgconfig \
  && mkdir /usr/tmp -m 755 \
  && ./configure --prefix=/usr/local/asterisk --with-srtp=/usr/local/libsrtp --with-download-cache=/usr/tmp --with-srtp --with-ssl --with-crypto --with-jansson-bundled --with-pjproject-bundled --with-speex --with-opus \
  && make menuselect.makeopts \
  && menuselect/menuselect --enable format_mp3 --enable app_macro --enable codec_opus --enable REF_DEBUG --enable stereorize --enable streamplayer --enable CORE-SOUNDS-EN-WAV --disable CORE-SOUNDS-EN-GSM --enable CORE-SOUNDS-JA-WAV --enable CORE-SOUNDS-JA-WAV menuselect.makeopts \
  && make \
  && make install \
  && make config \
  && make samples \
  && rm -rf /usr/local/src/asterisk-${asterisk_version}

RUN chown -R asterisk /usr/local/asterisk \
  && ln -s /usr/local/asterisk/sbin/asterisk /usr/bin/asterisk

ONBUILD COPY conf/* /usr/local/asterisk/etc/asterisk/

USER asterisk

COPY entrypoint.sh .

CMD ["/bin/bash", "entrypoint.sh"]
