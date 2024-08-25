FROM docker.io/debian:buster

RUN apt update && \
    apt install -y \
        texlive \
        dvipng \
        texlive-latex-extra \
        make \
        epix

COPY entrypoint/entrypoint.sh  /entrypoint.sh
COPY book /book/



ENTRYPOINT ["/entrypoint.sh"]
