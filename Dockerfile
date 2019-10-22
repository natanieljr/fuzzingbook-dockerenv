FROM jupyter/scipy-notebook

LABEL maintainer="Nataniel Borges Jr."
LABEL description="v0.1"

#
# install The Fuzzing Book's requirements
#
USER root
RUN apt update
RUN apt install -y --no-install-recommends graphviz inkscape bc ed texinfo groff wget automake autoconf bison ed texinfo clang cargo firefox unzip
RUN apt install -y --no-install-recommends ninja-build cmake gcc lcov

USER $NB_USER
RUN rm -rf /home/$NB_UID/.cache
RUN pip install six==1.11.0 && \
 pip install z3-solver==4.8.0.0.post1 && \
 pip install svglib==0.9.0b0 && \
 pip install matplotlib && \
 pip install numpy && \
 pip install pandas && \
 pip install graphviz && \
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
 pip install six==1.11.0 && \
 pip install z3-solver==4.8.0.0.post1 && \
 pip install svglib==0.9.0b0 && \
 pip install matplotlib && \
 pip install numpy && \
 pip install pandas && \
 pip install graphviz && \
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

#
# install aditional jupyter extensions
#
RUN pip install jupyter_contrib_nbextensions
RUN jupyter contrib nbextension install --user && \
  jupyter nbextension enable toc2/main --user && \
  jupyter nbextension enable exercise2/main --user

RUN jupyter nbextension enable codefolding/main --user && \
  jupyter nbextension enable execute_time/main --user && \
  jupyter nbextension enable varInspector/main --user && \
  jupyter nbextension enable collapsible_headings/main --user

# run matplotlib once to generate the font cache
RUN python -c "import matplotlib as mpl; mpl.use('Agg'); import pylab as plt; fig, ax = plt.subplots(); fig.savefig('test.png')" && \
 test -e test.png && rm test.png

USER root
RUN jupyter lab build

#
# install projects
#
COPY ./2019_ws_generating_software_tests_project-html-tidy /home/$NB_USER/project1
RUN chmod +x /home/$NB_USER/project1/scripts/*.sh

#
# fix directory permissions
#
RUN chown -R $NB_USER /home/$NB_USER/project1
RUN fix-permissions /home/$NB_USER/
RUN fix-permissions /home/$NB_USER/.local
RUN fix-permissions /home/$NB_USER/.local/share/jupyter
RUN fix-permissions /home/$NB_USER/work

COPY start-singleuser-custom.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-singleuser-custom.sh
RUN mv /usr/local/bin/start-singleuser.sh /usr/local/bin/start-singleuser-old.sh

#
# remove temporary apt files
#
RUN apt clean && rm -rf /var/lib/apt/lists/*

USER $NB_UID
