FROM python:3.11-bookworm

WORKDIR /app

COPY scripts/install-os-deps.sh scripts/install-os-deps.sh
RUN scripts/install-os-deps.sh

COPY scripts/install-locales.sh scripts/install-locales.sh
RUN scripts/install-locales.sh

COPY patches patches
COPY ckan.ini ckan.ini

# Create the ckan user
RUN useradd -m -s /bin/bash ckan
RUN chown ckan -R /app
RUN chown ckan -R /var/log/supervisor
USER ckan

# Create virtualenv for CKAN and add it to the PATH
RUN /usr/bin/python3 -m venv venv
ENV PATH="/app/venv/bin:$PATH"
RUN pip install wheel gunicorn

COPY scripts/install-ckan.sh scripts/install-ckan.sh
RUN scripts/install-ckan.sh

COPY scripts/install-ckan-extensions.sh scripts/install-ckan-extensions.sh
RUN scripts/install-ckan-extensions.sh

COPY --chown=ckan ckanext-example/ /app/ckanext-example
COPY scripts/install-main-extension.sh scripts/install-main-extension.sh
RUN scripts/install-main-extension.sh

# Copy supervisor files to run the web application and the workers
COPY files/etc/supervisord.conf /etc/supervisor/supervisord.conf
COPY files/etc/ckan.conf /etc/supervisor/conf.d/ckan.conf
COPY files/etc/ckan-worker.conf /etc/supervisor/conf.d/ckan-worker.conf

RUN cp /app/ckan/wsgi.py .
RUN chmod u+x wsgi.py

RUN mkdir /app/storage
RUN mkdir /app/storage/uploads

EXPOSE 5000
COPY scripts/setup-ckan-ini-file.sh scripts/setup-ckan-ini-file.sh
COPY entrypoint.sh entrypoint.sh
ENTRYPOINT [ "/app/entrypoint.sh" ]
