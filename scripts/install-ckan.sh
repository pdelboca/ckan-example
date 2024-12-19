#!/bin/bash -e
# Install CKAN from upstream and apply specific patches

CKAN_INSTALL_TAG=ckan-2.10.5

echo "------ Checking out upstream CKAN code into ckan folder ------"
git clone -q -b "$CKAN_INSTALL_TAG" "https://github.com/ckan/ckan.git" "ckan"
cd ckan

echo "------ Applying local patches to upstream CKAN code ------"
for f in `ls ./patches/*.diff | sort -g`; do \
    echo "$0: Applying patch $f to CKAN core";
    patch -N -p1 < "$f" ; \
done

echo "------ Installing CKAN's requirements.txt (quiet mode)------"
pip install -q -r requirements.txt

echo "------ Installing CKAN ------"
pip install .
