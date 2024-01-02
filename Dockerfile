FROM rocker/rstudio:4.3.2
MAINTAINER Micheleen Harris

ARG DEBIAN_FRONTEND=noninteractive
ARG bioc_ver=3.18

RUN apt-get -qqy update
RUN apt-get install -y -q perl-base libapparmor1 wget cmake

RUN apt-get clean all && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        build-essential \
        libhdf5-dev \
        libcurl4-gnutls-dev \
        libssl-dev \
        libxml2-dev \
        libpng-dev \
        libxt-dev \
        zlib1g-dev \
        libbz2-dev \
        liblzma-dev \
        libglpk40 \
        libgit2-dev \
        libfontconfig1-dev \
        libharfbuzz-dev \
        libfribidi-dev \
        libfreetype6-dev \
        libtiff5-dev \
        libjpeg-dev \
        libpq-dev \
        libproj-dev \
        libgdal-dev \
        gcc \
    && apt-get clean all && \
    apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.31/ncbi-blast-2.2.31+-x64-linux.tar.gz &&\
    tar zxvpf ncbi-blast-2.2.31+-x64-linux.tar.gz &&\
    cp ncbi-blast-2.2.31+/bin/* /usr/local/bin &&\
    rm ncbi-blast-2.2.31+-x64-linux.tar.gz

RUN wget http://github.com/bbuchfink/diamond/archive/v2.1.8.tar.gz &&\
    tar xzf v2.1.8.tar.gz &&\
    cd diamond-2.1.8 &&\
    mkdir bin &&\
    cd bin &&\
    cmake .. &&\
    make -j4 &&\
    sudo make install &&\
    cd ../.. &&\
    rm v2.1.8.tar.gz

RUN wget http://www.clustal.org/download/current/clustalw-2.1-linux-x86_64-libcppstatic.tar.gz &&\
    tar xzf clustalw-2.1-linux-x86_64-libcppstatic.tar.gz &&\
    cd clustalw-2.1-linux-x86_64-libcppstatic &&\
    cp clustalw2 /usr/local/bin

RUN wget http://prdownloads.sourceforge.net/argtable/argtable2-13.tar.gz &&\
    tar xzf argtable2-13.tar.gz &&\
    cd argtable2-13 &&\
    ./configure &&\
    make &&\
    sudo make install &&\
    cd .. &&\
    rm argtable2-13.tar.gz

RUN wget http://www.clustal.org/omega/clustal-omega-1.2.4.tar.gz &&\
    tar xzf clustal-omega-1.2.4.tar.gz &&\
    cd clustal-omega-1.2.4 &&\
    ./configure &&\
    make &&\
    sudo make install &&\
    cd .. &&\
    rm clustal-omega-1.2.4.tar.gz

RUN wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/kaks-calculator/KaKs_Calculator1.2.tar.gz &&\
    tar xzf KaKs_Calculator1.2.tar.gz &&\
    cd KaKs_Calculator1.2/src &&\
    echo '#include <cstring>' | cat - GY94.h > temp && mv temp GY94.h &&\
    make &&\
    cp KaKs_Calculator /usr/local/bin/ &&\
    cd ../.. &&\
    rm KaKs_Calculator1.2.tar.gz

RUN Rscript -e "install.packages(c('rmarkdown', 'tidyverse', 'workflowr', 'BiocManager', 'devtools'));"
RUN Rscript -e "BiocManager::install(version = '${bioc_ver}');"
RUN Rscript -e "BiocManager::install(c('Biostrings','GenomicFeatures','GenomicRanges','Rsamtools','IRanges','rtracklayer'));"
RUN Rscript -e "install.packages(c('doParallel', 'foreach', 'ape', 'Rdpack', 'benchmarkme'));"
RUN Rscript -e "devtools::install_github('drostlab/metablastr', build_vignettes = TRUE, dependencies = TRUE);"
RUN Rscript -e "devtools::install_github('drostlab/rdiamond');"
RUN Rscript -e "devtools::install_github('drostlab/orthologr');"

WORKDIR /home/rstudio
