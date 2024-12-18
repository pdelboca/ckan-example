#!/bin/bash -e
# Install CKAN extensions from upstream repositories
# If you want to work or debug the extension, clone its repository in a folder 
# and install it in development mode with `pip install -e`

echo "Installing Datapusher+extension"
pip install -e git+https://github.com/okfn/datapusher-plus.git@okfn_tmp#egg=datapusher_plus
pip install -r https://raw.githubusercontent.com/okfn/datapusher-plus/okfn_tmp/requirements.txt
