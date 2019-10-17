FROM jupyter/scipy-notebook

LABEL maintainer="Nataniel Borges Jr."
LABEL description="v0.1"

USER root

# Install required APT packages
RUN apt update && \
 apt install -y --no-install-recommends graphviz inkscape bc ed texinfo groff wget automake autoconf bison ed texinfo clang cargo firefox unzip && \
 apt clean && \
 rm -rf /var/lib/apt/lists/*

USER $NB_UID

RUN rm -rf /home/$NB_UID/.cache

USER root 

# Install required python packages
RUN pip install six==1.11.0 && \
 pip install z3-solver==4.8.0.0.post1 && \
 pip install svglib==0.9.0b0 && \
 pip install matplotlib && \
 pip install numpy && \
 pip install pandas && \
 pip install graphviz && \
 pip install jupyter_contrib_nbextensions && \
 pip install autopep8 && \
 pip install mypy && \
 pip install notedown && \
 pip install nbdime  && \
 pip install nbstripout && \
 pip install enforce && \
 pip install showast && \
 pip install astor && \
 pip install yapf  && \
 pip install pydot && \
 pip install networkx && \
 pip install FuzzManager && \
 pip install git+https://github.com/uds-se/pyan#egg=pyan && \
 pip install redis && \
 pip install selenium && \
 pip install laniakea && \
 cd /home/$NB_USER && \
 git clone https://github.com/uds-se/fuzzingbook.git && \
 fix-permissions /home/$NB_USER/fuzzingbook && \
 pip install six==1.11.0 && \
 pip install z3-solver==4.8.0.0.post1 && \
 pip install svglib==0.9.0b0 && \
 pip install matplotlib && \
 pip install numpy && \
 pip install pandas && \
 pip install graphviz && \
 pip install jupyter_contrib_nbextensions && \
 pip install autopep8 && \
 pip install mypy && \
 pip install notedown && \
 pip install nbdime  && \
 pip install nbstripout && \
 pip install enforce && \
 pip install showast && \
 pip install astor && \
 pip install yapf  && \
 pip install pydot && \
 pip install networkx && \
 pip install FuzzManager && \
 pip install git+https://github.com/uds-se/pyan#egg=pyan && \
 pip install redis && \
 pip install selenium && \
 pip install laniakea
# cd /home/$NB_USER && \
# git clone https://github.com/uds-se/fuzzingbook.git && \
# fix-permissions /home/$NB_USER/fuzzingbook && \

## Geckodriver
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.24.0/geckodriver-v0.24.0-linux64.tar.gz && \
  sh -c 'tar -x geckodriver -zf geckodriver-v0.24.0-linux64.tar.gz -O > /usr/bin/geckodriver' && \
  chmod +x /usr/bin/geckodriver && \
  rm geckodriver-v0.24.0-linux64.tar.gz

# Activate nbdime and nbstripout
RUN nbdime extensions --enable && \
 nbdime config-git --enable --global
RUN cd fuzzingbook

# enable nbdime for JupyterLab
RUN conda install -c conda-forge nodejs # you

# Install aditional extensions (ToC and exercise)
RUN jupyter contrib nbextension install --user && \
 jupyter nbextension enable toc2/main --user && \
 jupyter nbextension enable exercise2/main --user

# Other useful extensions
RUN jupyter nbextension enable codefolding/main --user && \
 jupyter nbextension enable execute_time/main --user && \
 jupyter nbextension enable varInspector/main --user && \
 jupyter nbextension enable collapsible_headings/main --user

# run matplotlib once to generate the font cache
RUN python -c "import matplotlib as mpl; mpl.use('Agg'); import pylab as plt; fig, ax = plt.subplots(); fig.savefig('test.png')" && \
 test -e test.png && \
 rm test.png

# Trust notebooks such that users can see their HTML and JS output
RUN jupyter trust /home/$NB_USER/fuzzingbook/notebooks/*.ipynb /home/$NB_USER/fuzzingbook/docs/notebooks/*.ipynb /home/$NB_USER/fuzzingbook/docs/beta/notebooks/*.ipynb

# Fix directory permissions
RUN fix-permissions /home/$NB_USER/.local && \
 fix-permissions /home/$NB_USER/.local/share/jupyter

# Remove temporary content
RUN apt-get clean && \
 apt-get autoremove && \
 rm -rf /var/lib/apt/lists/* 

COPY start-singleuser-custom.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-singleuser-custom.sh
RUN mv /usr/local/bin/start-singleuser.sh /usr/local/bin/start-singleuser-old.sh
#RUN cp /usr/local/bin/custom-start.sh /usr/local/bin/start-singleuser.sh

# Quit root mode
USER $NB_UID
