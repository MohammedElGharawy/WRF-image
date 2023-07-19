FROM centos:7

# Install required dependencies
RUN yum -y update
RUN yum -y install gcc gcc-gfortran gcc-c++  git patch make epel-release openssl-devel bzip2-devel libffi-devel zlib-devel wget python36 bzip2

#Install GCC 9.4.0
RUN wget https://ftp.mpi-inf.mpg.de/mirrors/gnu/mirror/gcc.gnu.org/pub/gcc/releases/gcc-9.4.0/gcc-9.4.0.tar.gz
RUN tar xzf gcc-9.4.0.tar.gz
WORKDIR "gcc-9.4.0/"
RUN ./contrib/download_prerequisites
RUN ./configure --disable-multilib --prefix=/usr && make && make install

WORKDIR "/"
RUN rm -rf gcc-9.4.0.tar.gz gcc-9.4.0/

ENV LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib:$LD_LIBRARY_PATH

RUN yum -y install numactl-devel

#Install Mpich 3.4.3
RUN wget https://www.mpich.org/static/downloads/3.4.3/mpich-3.4.3.tar.gz
RUN tar xzf mpich-3.4.3.tar.gz
WORKDIR "mpich-3.4.3/"
RUN ./configure --with-device=ch4:ucx --prefix=/usr && make && make install

WORKDIR "/"
RUN rm -rf mpich-3.4.3.tar.gz mpich-3.4.3/

#Install Python 3.8
RUN wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz
RUN tar xzf Python-3.8.0.tgz
WORKDIR "Python-3.8.0/"
RUN ./configure --prefix=/usr && make && make install

WORKDIR "/"
RUN rm -rf Python-3.8.0.tgz Python-3.8.0/

#test gcc
RUN gcc --version

#test mpich
RUN mpiexec --version

#Install zlib
RUN wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/zlib-1.2.7.tar.gz
RUN tar -xf zlib-1.2.7.tar.gz
WORKDIR "zlib-1.2.7/"
RUN bash ./configure --prefix=/usr && make all && make install

WORKDIR "/"
RUN rm -rf zlib-1.2.7.tar.gz zlib-1.2.7/

#Install libpng
RUN wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/libpng-1.2.50.tar.gz
RUN tar -xf libpng-1.2.50.tar.gz
WORKDIR "libpng-1.2.50/"
RUN bash ./configure --prefix=/usr --with-zlib-prefix=/usr/lib && make && make install

WORKDIR "/"
RUN rm -rf libpng-1.2.50.tar.gz libpng-1.2.50/

#Install cmake
RUN wget https://cmake.org/files/v3.16/cmake-3.16.9.tar.gz
RUN tar zxvf cmake-3.16.9.tar.gz
WORKDIR "cmake-3.16.9/"
RUN bash ./bootstrap && make && make install

WORKDIR "/"
RUN rm -rf cmake-3.16.9.tar.gz cmake-3.16.9/

#Install Jasper
RUN wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/jasper-1.900.1.tar.gz
RUN tar -xf jasper-1.900.1.tar.gz
WORKDIR "jasper-1.900.1/"
RUN bash ./configure --prefix=/usr && make && make install

WORKDIR "/"
RUN rm -rf jasper-1.900.1.tar.gz jasper-1.900.1/

#Install wgrib2
RUN wget ftp://ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/wgrib2.tgz
RUN tar -xzf wgrib2.tgz
WORKDIR "grib2/"
ENV CC=gcc
ENV FC=gfortran
ENV COMP_SYS=gnu_linux
RUN sed -i "197s:USE_AEC=1:USE_AEC=0:" ./makefile
RUN mkdir -p /opt/bin && mv /usr/bin/tar /opt/bin/
COPY tar.sh /usr/bin/tar
RUN chmod 755 /usr/bin/tar
RUN make && make lib
RUN rm -f /usr/bin/tar && mv /opt/bin/tar /usr/bin/

WORKDIR "/"
RUN rm -rf wgrib2.tgz

#Install netcdf 4.1.3
RUN wget https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compile_tutorial/tar_files/netcdf-4.1.3.tar.gz
RUN tar -xzf netcdf-4.1.3.tar.gz
WORKDIR "netcdf-4.1.3/"
RUN bash ./configure --prefix=/usr --disable-netcdf-4 && make check install

WORKDIR "/"
RUN rm -rf netcdf-4.1.3.tar.gz netcdf-4.1.3/

#Install netcdf 3.6.3
RUN wget https://www.gfd-dennou.org/library/netcdf/unidata-mirror/netcdf-3.6.3.tar.Z
RUN tar -xf netcdf-3.6.3.tar.Z
WORKDIR "netcdf-3.6.3/"
RUN bash ./configure --prefix=/usr && make check install

WORKDIR "/"
RUN rm -rf netcdf-3.6.3.tar.Z netcdf-3.6.3/

#Install PNetcdf-1.12.2
RUN yum install m4 -y
RUN wget https://parallel-netcdf.github.io/Release/pnetcdf-1.12.2.tar.gz
RUN tar -xzf pnetcdf-1.12.2.tar.gz
WORKDIR "pnetcdf-1.12.2/"
RUN bash ./configure --prefix=/usr && make && make install

WORKDIR "/"
RUN rm -rf pnetcdf-1.12.2.tar.gz pnetcdf-1.12.2/

#Install bison
RUN wget http://ftp.gnu.org/gnu/bison/bison-3.4.tar.gz
RUN tar -xzf bison-3.4.tar.gz
WORKDIR "bison-3.4/"
RUN bash ./configure --prefix=/usr && make && make install

WORKDIR "/"
RUN rm -rf bison-3.4.tar.gz bison-3.4/

#Install flex
RUN wget https://nchc.dl.sourceforge.net/project/flex/flex-2.6.0.tar.bz2
RUN tar -xf flex-2.6.0.tar.bz2
WORKDIR "flex-2.6.0/"
RUN bash ./configure --prefix=/usr && make && make install

WORKDIR "/"
RUN rm -rf flex-2.6.0.tar.bz2 flex-2.6.0/

#Install ncl
RUN wget https://www.earthsystemgrid.org/api/v1/dataset/ncl.650.dap/file/ncl_ncarg-6.5.0-CentOS7.4_64bit_gnu730.tar.gz
RUN tar -xzf ncl_ncarg-6.5.0-CentOS7.4_64bit_gnu730.tar.gz -C /usr/
RUN rm -rf ncl_ncarg-6.5.0-CentOS7.4_64bit_gnu730.tar.gz

#Install WRF
RUN wget https://github.com/wrf-model/WRF/archive/refs/tags/v4.3.3.tar.gz
RUN tar -xzf v4.3.3.tar.gz
WORKDIR "WRF-4.3.3/"
RUN yum install file csh which git time -y
ENV JASPERLIB=/usr/lib
ENV JASPERINC=/usr/inc
ENV NETCDF=/usr/
RUN ./configure <<< "35"
RUN ./clean
RUN ./compile wrf
RUN ./compile em_real
ENV PATH=$PATH:/WRF-4.3.3/main
ENV MANPATH=/WRF-4.3.3/share/man
ENV WRF_SRC=/WRF-4.3.3/
ENV WRFIO_NCD_LARGE_FILE_SUPPORT=1

WORKDIR "/"
RUN rm -rf v4.3.3.tar.gz

#Install WPS
RUN wget https://github.com/wrf-model/WPS/archive/refs/tags/v4.3.1.tar.gz
RUN tar -xzf v4.3.1.tar.gz
WORKDIR "WPS-4.3.1/"
ENV WRF_DIR=/WRF-4.3.3/
ENV LD_LIBRARY_PATH=/usr/lib64:/usr/lib:$LD_LIBRARY_PATH
RUN ./configure <<< "3"
RUN sed -i "s/-lnetcdff -lnetcdf/-lnetcdff -lnetcdf -fopenmp/" ./configure.wps
RUN ./compile
ENV PATH=$PATH:/WPS-4.3.1/
ENV MANPATH=$MANPATH:/WPS-4.3.1/share/man
ENV WPS_DIR=/WPS-4.3.1/
ENV WPS_SRC=/WPS-4.3.1/

WORKDIR "/"
RUN rm -rf v4.3.1.tar.gz
