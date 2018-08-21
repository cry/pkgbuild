FROM egrep/build-slaves/rpm-base

# Pull in development tools
RUN yum groupinstall -y \
    'Development Tools'

COPY do-build.sh /opt/

WORKDIR '/root/rpmbuild'

ENTRYPOINT ["/bin/bash"]
CMD ["/opt/do-build.sh"]
