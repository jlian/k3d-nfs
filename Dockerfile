FROM alpine:3.21

LABEL template.source="https://github.com/k3d-io/k3d/issues/1109#issuecomment-1220374460"

RUN set -ex; \
    apk add --no-cache iptables ip6tables nfs-utils rpcbind openrc; \
    echo 'hosts: files dns' > /etc/nsswitch.conf

RUN rc-update add rpcbind && \
    rc-update add nfs

RUN mkdir -p /run/openrc
RUN touch /run/openrc/softlevel

VOLUME /var/lib/kubelet
VOLUME /var/lib/rancher/k3s
VOLUME /var/lib/cni
VOLUME /var/log

ENV PATH="$PATH:/bin/aux"
ENV CRI_CONFIG_FILE="/var/lib/rancher/k3s/agent/etc/crictl.yaml"

COPY --from=rancher/k3s:v1.31.4-k3s1 /bin /bin

COPY k3d-entrypoint-nfs.sh /bin/

RUN chmod +x /bin/k3d-entrypoint-nfs.sh
ENTRYPOINT ["/bin/k3d-entrypoint-nfs.sh"]
CMD ["agent"]
