FROM scratch AS shared

COPY / /

FROM quay.io/fedora-ostree-desktops/silverblue:40

RUN --mount=type=bind,from=shared,src=/,dst=/shared \
    cp /shared/repos/*.repo /etc/yum.repos.d/ && \
    mkdir -p /var/lib/alternatives && \
    /shared/scripts/install.sh && \
    mv /var/lib/alternatives /staged-alternatives && \
    rpm-ostree cleanup -m && \
    ostree container commit && \
    mkdir -p /var/lib && \
    mv /staged-alternatives /var/lib/alternatives && \
    mkdir -p /var/tmp && \
    chmod -R 1777 /var/tmp
