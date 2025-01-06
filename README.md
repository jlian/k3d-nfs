# Custom image for k3d to have NFS support

Add NFS support in k3d using custom k3s dockerfile. Useful for GitHub Codespace. Based on https://github.com/k3d-io/k3d/issues/1109#issuecomment-1220374460, and https://github.com/marcoaraujojunior/k3s-docker. What I changed:

- Not use `/opt/` (maybe can revert)
- Add `touch /run/openrc/softlevel` before starting NFS
- Use the `/bin/k3d-entrypoint-*.sh` [method](https://github.com/k3d-io/k3d/issues/1109#issuecomment-1614415733) for custom entrypoint script

## To use

```sh
k3d cluster create -i ghcr.io/jlian/k3d-nfs:v1.31.4-k3s1
```

## To do

Go back to using `/opt/`?

## Tested with

GitHub codepsace with the Linux universal image (mcr.microsoft.com/devcontainers/universal:2-linux) and k3d feature (version v5.5.1). Does NOT work with k3d v4 and older (needs [this commit](https://github.com/k3d-io/k3d/commit/b4158a1dc13cc4dd176a689f07af20e940164243)).

```console
$ k3d runtime-info
arch: x86_64
cgroupdriver: cgroupfs
cgroupversion: "2"
endpoint: /var/run/docker.sock
filesystem: extfs
infoname: codespaces-bd98e8
name: docker
os: Ubuntu 20.04.6 LTS (containerized)
ostype: linux
version: 20.10.25+azure-2
```

Docker

```console
$ docker version
Client:
 Version:           20.10.25+azure-2
 API version:       1.41
 Go version:        go1.19.10
 Git commit:        b82b9f3a0e763304a250531cb9350aa6d93723c9
 Built:             Thu Apr  6 10:55:17 UTC 2023
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server:
 Engine:
  Version:          20.10.25+azure-2
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.19.10
  Git commit:       5df983c7dbe2f8914e6efd4dd6e0083a20c41ce1
  Built:            Thu May  4 13:33:05 2023
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.21+azure-1
  GitCommit:        3dce8eb055cbb6872793272b4f20ed16117344f8
 runc:
  Version:          1.1.7
  GitCommit:        860f061b76bb4fc671f0f9e900f7d80ff93d4eb7
 docker-init:
  Version:          0.19.0
  GitCommit:
```

```console
$ docker info
Client:
 Context:    default
 Debug Mode: false
 Plugins:
  buildx: Docker Buildx (Docker Inc., 0.11.0+azure-1)
  compose: Docker Compose (Docker Inc., 2.18.1+azure-2)

Server:
 Containers: 2
  Running: 2
  Paused: 0
  Stopped: 0
 Images: 7
 Server Version: 20.10.25+azure-2
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Native Overlay Diff: false
  userxattr: false
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Cgroup Version: 2
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: io.containerd.runtime.v1.linux runc io.containerd.runc.v2
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 3dce8eb055cbb6872793272b4f20ed16117344f8
 runc version: 860f061b76bb4fc671f0f9e900f7d80ff93d4eb7
 init version: 
 Security Options:
  apparmor
  seccomp
   Profile: default
  cgroupns
 Kernel Version: 5.15.0-1040-azure
 Operating System: Ubuntu 20.04.6 LTS (containerized)
 OSType: linux
 Architecture: x86_64
 CPUs: 8
 Total Memory: 15.62GiB
 Name: codespaces-bd98e8
 ID: YHXC:ARRH:MMYY:CCJL:K3BA:M3WQ:72V7:IAWH:5OHB:O2PP:FYBD:Y5SW
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Username: codespacesdev
 Registry: https://index.docker.io/v1/
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false
``` 
