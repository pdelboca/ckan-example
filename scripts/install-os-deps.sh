#!/bin/bash -e
echo "Installing OS dependencies"

# =====================================================
apt update
apt install -y gettext-base file git libmagic1 libpq-dev libuchardet-dev postgresql-client supervisor uchardet unzip vim wget python3.11-venv python3 python3-dev python3-pip python3-venv

# file: for QSV
# git: to pull the CKAN source code from GitHub
# libmagic1: for the file upload functionality in CKAN
# libpq-dev: for PostgreSQL support in CKAN (psycopg2)
# postgresql-client: for the psql command-line tool
# supervisor: to run CKAN jobs in the background
# gettext-base: for envsubst command
# wget: to get qsv
# unzip: for qsv
# locales: for locale settings qsv
# libuchardet-dev uchardet: for qsv
# python3*: for virtualenvs, psycopg2-binary and OS python dependencies

# Install QSV (Datapusher+)
# https://github.com/dathere/qsv
echo "Installing QSV for Datapusher+"
wget https://github.com/dathere/qsv/releases/download/0.134.0/qsv-0.134.0-x86_64-unknown-linux-gnu.zip
unzip qsv-0.134.0-x86_64-unknown-linux-gnu.zip
rm qsv-0.134.0-x86_64-unknown-linux-gnu.zip
mv qsv* /usr/local/bin
