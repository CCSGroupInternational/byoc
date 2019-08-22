#!/bin/sh
wget https://www.python.org/ftp/python/3.7.4/Python-3.7.4.tar.xz
tar xf Python-3.7.4.tar.xz
cd Python-3.7.4
./configure --prefix=/opt/python-3.7.4
make -j 8
make install
