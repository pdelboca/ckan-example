#!/bin/bash
# Datapusher+ fails with locale.Error: unsupported locale setting
# Code taken from https://github.com/ckan/ckan-docker-base/blob/a02b410629ec8abd742cbe2539e1d37f6fb678ff/ckan-master/base/Dockerfile#L26-L34

export LC_ALL=en_US.UTF-8

# Set the locale
apt-get -qq install --no-install-recommends -y locales
sed -i "/$LC_ALL/s/^# //g" /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
update-locale LANG=${LC_ALL}
