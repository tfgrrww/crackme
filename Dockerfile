FROM debian:trixie-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    socat \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 ctf

WORKDIR /home/ctf
COPY crackme sha256sum.txt ./
RUN sha256sum -c sha256sum.txt \
    && chmod 555 /home/ctf/crackme \
    && chown root:ctf /home/ctf/crackme /home/ctf/sha256sum.txt

USER ctf
EXPOSE 1337

CMD ["socat", "-T30", "TCP-LISTEN:1337,reuseaddr,fork", "EXEC:/home/ctf/crackme,pty,echo=0"]
