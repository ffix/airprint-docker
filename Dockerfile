FROM ubuntu:bionic

# Install the packages we need. Avahi will be included
RUN apt-get update && apt-get install -y \
	cups \
	cups-pdf \
	hplip \
	inotify-tools \
	python-cups \
	openprinting-ppds \
	printer-driver-gutenprint \
	&& rm -rf /var/lib/apt/lists/*

# This will use port 631
EXPOSE 631

# We want a mount for these
VOLUME /config
VOLUME /services
	
# Install Canon UFRII Drivers
ADD root /
RUN chmod +x /root/*
RUN apt -y install /root/UFRII/32-bit_Driver/Debian/cndrvcups-common_4.10-1_i386.deb /root/UFRII/32-bit_Driver/Debian/cndrvcups-ufr2-uk_3.70-1_i386.deb 
RUN apt -y install /root/UFRII/64-bit_Driver/Debian/cndrvcups-common_4.10-1_amd64.deb /root/UFRII/64-bit_Driver/Debian/cndrvcups-ufr2-uk_3.70-1_amd64.deb 
# Add scripts
CMD ["/root/run_cups.sh"]

# Baked-in config file changes
RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf && \
	sed -i 's/Browsing Off/Browsing On/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/>/<Location \/>\n  Allow All/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow All\n  Require user @SYSTEM/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow All/' /etc/cups/cupsd.conf && \
	echo "ServerAlias *" >> /etc/cups/cupsd.conf && \
	echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf
