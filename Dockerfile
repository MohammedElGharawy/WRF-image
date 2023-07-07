FROM centos:7

# Install required dependencies
RUN yum update -y
RUN yum -y install git patch gcc make epel-release openssl-devel bzip2-devel libffi-devel zlib-devel wget python36 bzip2 gcc-gfortran gcc-c++

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

RUN spack -e myenv install


#check what's installed by spack
RUN spack find

#activate spack env
ENV SPACK_ENV=/spack/var/spack/environments/myenv
ENV ACLOCAL_PATH=/spack/var/spack/environments/myenv/.spack-env/view/share/aclocal
ENV CMAKE_PREFIX_PATH=/spack/var/spack/environments/myenv/.spack-env/view
ENV MANPATH=/spack/var/spack/environments/myenv/.spack-env/view/share/man:/spack/var/spack/environments/myenv/.spack-env/view/man:
ENV MPICC=/spack/var/spack/environments/myenv/.spack-env/view/bin/mpicc
ENV MPICXX=/spack/var/spack/environments/myenv/.spack-env/view/bin/mpic++
ENV MPIF77=/spack/var/spack/environments/myenv/.spack-env/view/bin/mpif77
ENV MPIF90=/spack/var/spack/environments/myenv/.spack-env/view/bin/mpif90
ENV PATH=/spack/var/spack/environments/myenv/.spack-env/view/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/spack/bin
ENV PKG_CONFIG_PATH=/spack/var/spack/environments/myenv/.spack-env/view/lib/pkgconfig:/spack/var/spack/environments/myenv/.spack-env/view/share/pkgconfig:/spack/var/spack/environments/myenv/.spack-env/view/lib64/pkgconfig

#test gcc
RUN gcc --version

#test mpich
RUN mpiexec --version

#Install zlib
RUN wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/zlib-1.2.7.tar.gz
RUN tar -xf zlib-1.2.7.tar.gz
WORKDIR "zlib-1.2.7/"
RUN bash ./configure && make all && make install

WORKDIR "/"

#Install libpng
RUN wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/libpng-1.2.50.tar.gz
RUN tar -xf libpng-1.2.50.tar.gz
WORKDIR "libpng-1.2.50/"
RUN bash ./configure --with-zlib-prefix=/usr/lib && make && make install

WORKDIR "/"

#Install cmake
RUN wget https://cmake.org/files/v3.16/cmake-3.16.9.tar.gz
RUN tar zxvf cmake-3.16.9.tar.gz
WORKDIR "cmake-3.16.9/"
RUN bash ./bootstrap && make && make install

WORKDIR "/"

#Install Jasper
RUN wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz
RUN tar -xf jasper-1.900.1.tar.gz
WORKDIR "jasper-1.900.1/"
RUN bash ./configure && make && make install

WORKDIR "/"

#Install wgrib2
RUN wget ftp://ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/wgrib2.tgz
RUN tar -xzf wgrib2.tgz
WORKDIR "grib2/"
ENV CC=gcc
ENV FC=gfortran
ENV COMP_SYS=gnu_linux
RUN sed -i "197s:USE_AEC=1:USE_AEC=0:" ./makefile
RUN mkdir -p /opt/bin && mv /spack/var/spack/environments/myenv/.spack-env/view/bin/tar /opt/bin/
COPY tar.sh /spack/var/spack/environments/myenv/.spack-env/view/bin/tar
RUN chmod 755 /spack/var/spack/environments/myenv/.spack-env/view/bin/tar
RUN make && make lib
RUN rm -f /spack/var/spack/environments/myenv/.spack-env/view/bin/tar && mv /opt/bin/tar /spack/var/spack/environments/myenv/.spack-env/view/bin/

WORKDIR "/"

#Install netcdf 4.1.3
RUN wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/netcdf-4.1.3.tar.gz
RUN tar -xzf netcdf-4.1.3.tar.gz
WORKDIR "netcdf-4.1.3/"
RUN bash ./configure --disable-netcdf-4 && make check install

WORKDIR "/"

#Install netcdf 3.6.3
RUN wget https://www.gfd-dennou.org/library/netcdf/unidata-mirror/netcdf-3.6.3.tar.Z
RUN tar -xf netcdf-3.6.3.tar.Z
WORKDIR "netcdf-3.6.3/"
RUN bash ./configure && make check install

WORKDIR "/"
