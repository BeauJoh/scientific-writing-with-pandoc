# An Ubuntu environment configured for building papers written in pandoc
FROM ubuntu:16.04

MAINTAINER Beau Johnston <beau.johnston@anu.edu.au>

# Disable post-install interactive configuration.
# For example, the package tzdata runs a post-installation prompt to select the
# timezone.
ENV DEBIAN_FRONTEND noninteractive

# Setup the environment.
ENV HOME /root
ENV USER docker
ENV PANDOC /pandoc

# Install essential packages.
RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common \
    pkg-config \
    build-essential \
    git \
    make \
    zlib1g-dev \
    apt-transport-https \
    wget \
    vim \
    less

# Install Pandoc and Latex to build the paper
RUN apt-get install --no-install-recommends -y lmodern texlive-latex-recommended texlive-fonts-recommended texlive-latex-extra texlive-generic-extra texlive-science python-pip python-dev
RUN wget https://bootstrap.pypa.io/ez_setup.py -O - | python
RUN pip2 install setuptools && pip2 install wheel && pip2 install pandocfilters pandoc-fignos
WORKDIR $PANDOC
RUN wget https://github.com/jgm/pandoc/releases/download/1.19.2/pandoc-1.19.2-1-amd64.deb && apt-get install -y ./pandoc-1.19.2-1-amd64.deb
RUN wget https://github.com/lierdakil/pandoc-crossref/releases/download/v0.3.0.0/linux-ghc8-pandoc-2-0.tar.gz
RUN tar -xvf linux-ghc8-pandoc-2-0.tar.gz
RUN mv pandoc-crossref /usr/bin/

#container variables and startup...
WORKDIR /workspace
ENV LD_LIBRARY_PATH "${OCLGRIND}/lib:${LSB}/lib:./lib:${LD_LIBRARYPATH}"
ENV PATH "${PATH}:${OCLGRIND}/bin}"

#start beakerx/jupyter by default
#CMD ["beakerx","--allow-root"]

CMD ["/bin/bash"]

