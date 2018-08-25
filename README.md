Docker image to run the Valon 5009 Frequency Synthesizer EPICS IOC
==================================================================

This repository contains the Dockerfile used to create the Docker image to run the
[Valon 5009 EPICS IOC](https://github.com/lnls-dig/valon5009-epics-ioc).

## Running the IOC

The simples way to run the IOC is to run:

    docker run --rm -it --net host lnlsdig/valon5009-epics-ioc -p SERIAL_PORT -P PREFIX1 -R PREFIX2

where `SERIAL_PORT` is the serial port to which the device is connected,
and `PREFIX1` and `PREFIX2` are the prefixes to be added before the PV name.
The options you can specify (after `lnlsdig/valon5009-epics-ioc`) are:

- `-p SERIAL_PORT`: the serial port to connect to (required)
- `-P PREFIX1`: the value of the EPICS `$(P)` macro used to prefix the PV names
- `-R PREFIX2`: the value of the EPICS `$(R)` macro used to prefix the PV names
- `-t TELNET_PORT`: the telnet port used to access the IOC shell

## Creating a Persistent Container

If you want to create a persistent container to run the IOC, you can run a
command similar to:

    docker run -it --net host --restart always --name CONTAINER_NAME lnlsdig/valon5009-epics-ioc -p SERIAL_PORT -P PREFIX1 -R PREFIX2

where `SERIAL_PORT`, `PREFIX1`, and `PREFIX2` are as in the previous section and `CONTAINER_NAME`
is the name given to the container. You can also use the same options as described in the
previous section.

## Building the Image Manually

To build the image locally without downloading it from Docker Hub, clone the
repository and run the `docker build` command:

    git clone https://github.com/lnls-dig/docker-valon5009-epics-ioc
    docker build -t lnlsdig/valon5009-epics-ioc docker-valon5009-epics-ioc
