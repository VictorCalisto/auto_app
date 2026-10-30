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

WORKDIR /workspace

CMD ["flutter", "doctor", "-v"]
