# os-janus-gateway

A Dockerized implementation of the **Janus WebRTC Gateway**, specifically configured to provide open-source voice and communication services for **OpenSimulator (OpenSim)**.

## Context & Purpose

For years, OpenSim grids relied heavily on **Vivox** for high-quality spatial voice communications. However, with Vivox services reaching end-of-life and shutting down, the OpenSim community requires a self-hosted, reliable, and modern alternative. 

This repository provides a production-ready, Dockerized **Janus Gateway** setup tailored to restore and maintain seamless WebRTC voice capabilities across OpenSim environments without depending on third-party proprietary services.

## Features

- **OpenSim WebRTC Voice**: Tailored configurations to replace legacy Vivox services.
- **Janus WebRTC Gateway**: Full deployment of the general-purpose, low-latency WebRTC gateway.
- **Optimized Network Performance**: Uses Docker host networking mode to easily manage WebRTC RTP voice streams.
- **Dockerized**: Easy deployment on any environment supporting Docker (Linux, Windows WSL, etc.).

## Repository Structure

- `Dockerfile`: Defines the build environment and dependencies for Janus.
- `docker-compose.yml`: Defines the local multi-container deployment architecture.
- `janus.jcfg`: Core configuration file for the Janus daemon.
- `janus.transport.http.jcfg`: HTTP transport plugin configuration for OpenSim API communication.
- `janus.transport.websockets.jcfg`: WebSockets transport plugin configuration for real-time signaling.
- `janus.transport.nanomsg.jcfg`: NanoMSG transport plugin configuration.

## Required Configurations Before Running

Before launching the container, you **must** customize the local configuration files to match your network environment:

1. **`janus.jcfg`**: 
   - Locate and adjust the **API Keys** (`api_secret` and `admin_secret`) to secure your Janus gateway integration.
2. **`janus.transport.http.jcfg`**:
   - Update the **Ports** to prevent conflicts with other services running on your host system.
   - Configure your public **WAN IP address** so external OpenSim clients can discover and reach the Janus API successfully.

## Getting Started

### Prerequisites

Make sure you have Docker and Docker Compose installed on your host system:
- [Docker Desktop for Windows/Mac](https://docker.com)
- [Docker Engine for Linux](https://docker.com)

### Local Build

To build the image locally, navigate to the root directory and run:

```bash
docker build -t calvinux/os-janus-gateway:latest .
```

### Deployment using Docker Compose

The recommended way to deploy Janus for OpenSim is using Docker Compose. By using `network_mode: host`, this configuration ensures maximum network performance and avoids complex UDP port mapping issues for WebRTC media streams.

To deploy the gateway in the background, run:

```bash
docker compose up -d
```

Your local configuration files (`.jcfg`) will automatically bind-mount into the container in read-only mode (`:ro`), allowing seamless custom overrides.

## Docker Hub

The official image is hosted and updated on Docker Hub:
👉 [calvinux/os-janus-gateway](https://hub.docker.com/r/calvinux/os-janus-gateway)

To pull the latest image directly from the registry:

```bash
docker pull calvinux/os-janus-gateway:latest
```

## License

This project is open-source. Feel free to use, modify, and distribute it to keep the OpenSim ecosystem loud and clear!

