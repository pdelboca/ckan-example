# CKAN Development Example

This is a repository to document a template that has worked very well when needing to develop a CKAN project.

In contrast to open-source reusable CKAN extensions, when developing an Open Data Portal we usually have a main
extension with all the business logic, patches to upstream CKAN, specific OS dependencies, third party 
extensions that we want to integrate in our test-cases and other spagetthi code. This particularity of CKAN related
projects means that sometimes it is easier to handle codebase + deployment under a single repository.

## CKAN Services

CKAN Requires several services to run: PostgreSQL (with ckan and datastore databases), Solr and Redis.

Ideally, services should be handled separatelly since they are mounted and configured once per project. If you have
some instances of this services you can just edit the `ckan.ini` file to point the configurations and that's it.

If you prefer an all-in-one experience, this project ships with a `docker-compose` to run all the services "automatically". Also,
the ckan.ini file is preconfigured with config values that connects to these services.

Note: I'm a strong supporter of managing services in a separated codebase (or even manually), so this example might evolve to that.

## How to work with this repository

In theory, cloning and executing a couple of make files should work. Run `make help` for more information.

In a console, run all the services:
```
make services
```

In a new console, run CKAN:
```
python3.11 -m venv .venv
source .venv/bin/activate

make install-os-deps
make install-ckan
make install-extensions
make install-main-extension

ckan db upgrade
ckan user add ckan_admin password=testpass email=admin@example.com

ckan run
```

If you are running the services by your own, you should edit the `ckan.ini` with the proper config values.

## Dockerfile

In order to deploy CKAN somewhere it is common to create a Dockerfile. This project has Dockerfile that it is build to run both CKAN and Workers
in the same container. This is because 80% of Open Data portals of the world can live peacefully in a single machine.

The structure of the Dockerfile is straight forward and easy to follow: 
 - Install OS dependencies
 - Install CKAN
 - Install all the CKAN Extensions
 - Install the main extension living in this repository
 - Configure supervisor to run the web app and the workers
 - Setup the `ckan.ini` file with the environment variables

This repo is designed to use Kamal Deploy, so the secrets to build a Dockerfile will live in the `.kamal` folder. There is an example secret file called `secrets.local` for building the Dockerfile to run it in your machine.

To build and run the Dockerfile (you should have the services running as well):

```
make build
make run
```


## Notes on the CKAN install

In my experience, I always need to patch CKAN core due to missing features or bugs. So the approach we have to install is:
 - Clone the repository
 - pip install
 - Apply patches

## Notes on the ckan.ini file

While normally Django/Flask have a straightforward approach `ENV Variables -> Run Application`,
CKAN has a legacy `*.ini` file in between, forcing us to do `ENV Variables -> .ini File -> Run CKAN`. In other words, Django/Flask
usually run the application and then setup their configuration object, while CKAN has a strong dependency on having a `.ini` file to
be able to even execute the application (and then setup the configuration object).

This is why we always need an extra step to dump the environment variables into a configuration file before even attempting to
run CKAN. This is always mandatory, even extensions like `ckanext-envvars` do not work properly if we start from a bad `ckan.ini`
file (see https://github.com/ckan/ckanext-envvars/pull/10)

I think this typical workflow designed for CD/CI can be simplified by using a `production.ini` file to directly handle
secrets but that's another story.
