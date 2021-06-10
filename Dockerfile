ARG DEBIAN_VERSION
ARG SYNAPPS_VERSION
ARG BASE_VERSION
FROM lnls/epics-synapps:${BASE_VERSION}-${SYNAPPS_VERSION}-${DEBIAN_VERSION}

ARG COMMIT
ARG DEBIAN_VERSION
ARG IOC_GROUP
ARG IOC_REPO

ENV BOOT_DIR iocValon5009

RUN git clone https://github.com/${IOC_GROUP}/${IOC_REPO}.git /opt/epics/${IOC_REPO} && \
    cd /opt/epics/${IOC_REPO} && \
    ln --verbose --symbolic $(ls -d /opt/epics/synApps*) /opt/epics/synApps &&\
    git checkout ${COMMIT} && \
    echo 'EPICS_BASE=/opt/epics/base' > configure/RELEASE.local && \
    echo 'SUPPORT=/opt/epics/synApps/support' >> configure/RELEASE.local && \
    echo 'AUTOSAVE=$(SUPPORT)/autosave-R5-9' >> configure/RELEASE.local && \
    echo 'CALC=$(SUPPORT)/calc-R3-7' >> configure/RELEASE.local && \
    echo 'STREAM=$(SUPPORT)/stream-R2-7-7' >> configure/RELEASE.local && \
    echo 'ASYN=$(SUPPORT)/asyn-R4-33' >> configure/RELEASE.local && \
    make && \
    make install

# Source environment variables until we figure it out
# where to put system-wide env-vars on docker-debian
RUN . /root/.bashrc

WORKDIR /opt/epics/startup/ioc/${IOC_REPO}/iocBoot/${BOOT_DIR}

ENTRYPOINT ["./runProcServ.sh"]
