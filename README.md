# CKAN Development Example

This is a repository to document a template that has worked very well when needing to develop a CKAN project.

In contrast to open-source reusable CKAN extensions, when developing an Open Data Portal we usually have a main
extension with all the business logic, patches to upstream CKAN, specific OS dependencies, third party 
extensions that we want to integrate in our test-cases and other spagetthi code. This particularity of CKAN related
projects means that sometimes it is easier to handle codebase + deployment under a single repository.

Also, when working on several CKAN projects at the same time we need to deal with several databases, solr and Redis instances.
There is no clear documentation nor developer workflow on how to properly manage several CKAN projects at the same time, this
repository could help with that as well.
