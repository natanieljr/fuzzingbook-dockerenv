FROM jupyter/scipy-notebook

LABEL maintainer="Nataniel Borges Jr."
LABEL description="v0.1"

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends matplotlib numpy pandas graphviz autopep8 notedown mypy pip inkscape && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

RUN pip install matplotlib numpy pandas graphviz svglib jupyter_contrib_nbextensions

RUN git clone https://github.com/uds-se/fuzzingbook.git

RUN apt-get clean
RUN apt-get autoremove
RUN rm -rf /var/lib/apt/lists/*
