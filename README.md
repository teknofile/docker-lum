# docker-lum

This is a docker container that encapsulates the [wheelybird/ldap-user-manager](https://github.com/wheelybird/ldap-user-manager) software.

The original container, provided by wheelybird, didn't work for my usecase. I ran into issues with the apache-backed php-8 image used and some of the HTTP->HTTPS redirection. Instead of diving into apache configs, I used my existing alpine/nginx based container to run the software.

ARM, ARM64 and AMD64 containers are available on hub.docker.com. I run this software on a ARM64 based K3s cluster and deploy it via helm.
