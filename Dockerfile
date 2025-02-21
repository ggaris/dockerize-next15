FROM node:22-alpine

# 工作目录
WORKDIR /app

# Install glibc to run Bun [https://arc.net/l/quote/zkqchaow]
RUN if [[ $(uname -m) == "aarch64" ]] ; \
    then \
    # aarch64
    wget https://raw.githubusercontent.com/squishyu/alpine-pkg-glibc-aarch64-bin/master/glibc-2.26-r1.apk ; \
    apk add --no-cache --allow-untrusted --force-overwrite glibc-2.26-r1.apk ; \
    rm glibc-2.26-r1.apk ; \
    else \
    # x86_64
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk ; \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub ; \
    apk add --no-cache --force-overwrite glibc-2.28-r0.apk ; \
    rm glibc-2.28-r0.apk ; \
    fi

# 检查并安装 bun
RUN if ! command -v bun &> /dev/null; then \
    npm install -g bun; \
    fi

COPY bun.lockb ./

COPY . .

RUN bun install


EXPOSE 3000

# 开发
CMD ["bun", "run", "dev"]
# 构建
# CMD ["bun", "run", "build"]