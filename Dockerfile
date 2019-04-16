FROM arm64v8/ubuntu:bionic

# install baseline x, vnc and wine
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -y software-properties-common && dpkg --add-architecture i386 && apt-get upgrade -y && apt-get install -y git net-tools qemu-kvm qemu nvidia-modprobe virt-manager virt-viewer libvirt-bin net-tools wget && apt-get clean all && apt -y autoremove
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y  --install-recommends xfce4 xfce4-goodies libsdl1.2-dev mesa-utils && apt-get clean all && apt -y autoremove
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y x11vnc  tightvncserver vnc4server novnc xvfb firefox mc lynx open-vm-tools && apt-get clean all && apt -y autoremove
RUN cp /usr/share/novnc/vnc.html /usr/share/novnc/index.html && mkdir /root/.vnc
RUN apt-get -y -f install libtasn1-bin && apt-get update && apt-get install -y wine-stable && apt-get clean all && apt -y autoremove

# add system frameworks
RUN apt-get -y -f install  lm-sensors hddtemp python3-pip clinfo freeglut3 && apt-get clean all && apt -y autoremove

# add OCL dev
# RUN apt-get -y -f install ocl-icd-libopencl1 opencl-headers ocl-icd-opencl-dev opencl-icd-* && apt-get clean all && apt -y autoremove

# cleanup idle cpu usage
RUN apt-get -y remove xscreensaver

#copy run scripts
COPY run /root
RUN chmod 755 /root/run
COPY run-nv /root
RUN chmod 755 /root/run-nv

# vnc settings
COPY xorg.conf /usr/share/X11/xorg.conf.d/
COPY passwd /root/.vnc/
COPY xstartup /root/.vnc/
RUN chmod 755 /root/.vnc/xstartup

EXPOSE 5900 6080