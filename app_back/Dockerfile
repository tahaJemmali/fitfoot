FROM node:12

WORKDIR /src/app

COPY . .

RUN npm install

RUN apt-get -qq update && apt-get -qq -y install curl bzip2 \
    && curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && conda install -y python=3.7.10 \
    && pip install opencv-python==4.5.1.48 \
    && pip install opencv-contrib-python==4.5.1.48 \
    && pip install opencv-python-headless==4.5.1.48 \
    && pip install tf-slim==1.1.0 \
    && conda install matplotlib==3.1.1 \
    && conda install ipython==7.8.0 \
    && conda install numpy==1.19.2 \
    && pip install Pillow==7.2.0 \
    && pip install tensorflow==2.4.0 \
    && conda install cudatoolkit \
    #&& conda update conda \
    && apt-get -qq -y remove curl bzip2 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && conda clean --all --yes

RUN npm install moment

CMD ["node","bin/www"]