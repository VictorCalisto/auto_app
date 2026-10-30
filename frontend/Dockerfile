FROM dart:stable-sdk

ENV DEBIAN_FRONTEND=noninteractive \
    FLUTTER_HOME=/opt/flutter \
    PATH=/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:$PATH

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
       file \
       git \
       unzip \
       xz-utils \
       zip \
       libglu1-mesa \
    && rm -rf /var/lib/apt/lists/* \
    && git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$FLUTTER_HOME" \
    && flutter precache --web \
    && flutter config --no-analytics

WORKDIR /frontend

RUN set -eu; \
    arch="$(dpkg --print-architecture)"; \
    case "$arch" in \
      amd64) dcm_checksum=c0a0fc995cf9ec5e020f19eea5a9faac40189748aeb6246b29658fa061cf5d47; \
             osv_checksum=ca69b3d3cd08f889a49dc0a383122f71cc528b83803671df5fd874d97485b108 ;; \
      arm64) dcm_checksum=2fa69aa864ca24237a4a5b8cff0008eb5cdb06cdef2799b385acae6c759c150d; \
             osv_checksum=2c71403eb443d05891c4f268c3ad771cf4f16e5443463fd7851ef8f454d3c7e4 ;; \
      *) exit 1 ;; \
    esac; \
    curl -fsSL "https://github.com/CQLabs/homebrew-dcm/releases/download/1.39.2/dcm_1.39.2-1_${arch}.deb" -o /tmp/dcm.deb; \
    printf '%s  /tmp/dcm.deb\n' "$dcm_checksum" | sha256sum -c -; \
    dpkg -i /tmp/dcm.deb; \
    curl -fsSL "https://github.com/google/osv-scanner/releases/download/v2.6.0/osv-scanner_linux_${arch}" -o /usr/local/bin/osv-scanner; \
    printf '%s  /usr/local/bin/osv-scanner\n' "$osv_checksum" | sha256sum -c -; \
    chmod +x /usr/local/bin/osv-scanner; \
    rm /tmp/dcm.deb

CMD ["sh", "-c", "flutter pub get --enforce-lockfile && exec flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8080"]
