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


RUN pip install scikit-image leveldb matplotlib protobuf==2.6
RUN git clone https://github.com/Arsey/deepsaldet.git

# build Caffe
ADD docker_files/Makefile.config /deepsaldet/caffe-sal/Makefile.config
COPY docker_files/models/*caffemodel /deepsaldet/models/
WORKDIR /deepsaldet/caffe-sal
RUN make all -j$(nproc)

VOLUME /deepsaldet/images
WORKDIR /deepsaldet