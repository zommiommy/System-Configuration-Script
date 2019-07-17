FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qyy
RUN apt-get install --no-install-recommends -qyy \
  texlive \
  texlive-full \
  texlive-lang-italian \
  texlive-lang-english \
  texlive-latex-extra \
  biber \
  texlive-bibtex-extra \
  python \
  python-pip \
  python-pygments

RUN apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /latex && chmod 777 /latex
ADD compile.sh /latex/compile.sh
WORKDIR /latex

ENTRYPOINT ["/script.sh"]
CMD ["main.tex"] 

