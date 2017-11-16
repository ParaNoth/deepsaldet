                                                     FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu14.04
LABEL version="1.0"

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        nano \
        cmake \
        git \
        wget \
        python-tk \
        libatlas-base-dev \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libprotobuf-dev \
        libsnappy-dev \
        protobuf-compiler \
        python-dev \
        python-numpy \
        python-pip \
        python-setuptools \
        libhdf5-dev \
        g++ \
        openmpi-bin \
        ssh \
        curl \
        python-scipy && \
    rm -rf /var/lib/apt/lists/*

# CREATE USER
ENV NB_USER deepsaldet
ENV NB_UID 1000

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER

ENV HOME /home/$NB_USER

# configure pip virtualenv
RUN pip install virtualenv virtualenvwrapper
USER $NB_USER

RUN mkdir $HOME/envs
RUN export WORKON_HOME=$HOME/envs

RUN /bin/bash -c "source /usr/local/bin/virtualenvwrapper.sh && mkvirtualenv deepsaldet && workon deepsaldet && pip install scikit-image leveldb matplotlib protobuf==2.6"

WORKDIR $HOME

RUN git clone https://github.com/Robert0812/deepsaldet.git

# build Caffe
ADD docker_files/Makefile.config $HOME/deepsaldet/caffe-sal/Makefile.config
COPY docker_files/models/*caffemodel $HOME/deepsaldet/models/
WORKDIR $HOME/deepsaldet/caffe-sal
RUN make all -j$(nproc)

VOLUME $HOME/deepsaldet/images
WORKDIR $HOME/deepsaldet