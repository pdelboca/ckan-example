#!/bin/bash -e
# Install the CKAN extensions of this repositories: ckanext-example

echo "------ Installing ckanext-example ------"
pip install -q -e ./ckanext-example/
