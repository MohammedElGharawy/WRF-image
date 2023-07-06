FROM centos:7

# Install required dependencies

RUN yum update -y
RUN yum -y install git patch gcc make epel-release openssl-devel bzip2-devel libffi-devel zlib-devel wget python36 bzip2


# Clone spack repo
WORKDIR "/"
RUN git clone -c feature.manyFiles=true https://github.com/spack/spack.git

#Set environment variables
ENV SPACK_ROOT=$PWD/spack
ENV SPACK_PYTHON=/usr/bin/python3
ENV PATH="$PATH:$PWD/spack/bin/"


# create spack env
RUN spack env create myenv

#edit spack.yml to include the needed stack
RUN sed -i "7s:\[\]:\[gcc@9.4.0,python@3.8,mpich@3.4.3\]:" ./spack/var/spack/environments/myenv/spack.yaml

#Install software stack
RUN ./spack/share/spack/setup-env.sh

RUN spack env activate --sh  myenv && spack -e myenv install


#check what's installed by spack
RUN spack find