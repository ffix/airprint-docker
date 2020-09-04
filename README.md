# Intro
This Ubuntu-based Docker image runs a CUPS instance that is meant as an AirPrint
Based upon [quadportnick/docker-cups-airprint](https://github.com/quadportnick/docker-cups-airprint)

## Create
Creating a container is often more desirable than directly running it:
```
$ docker create \
       --name=cups \
       --restart=always \
       --net=host \
       -v /var/run/dbus:/var/run/dbus \
       -v ~/airprint_data/config:/config \
       -v ~/airprint_data/services:/services \
       -e CUPSADMIN="admin" \
       -e CUPSPASSWORD="password" \
       tigerj/cups-airprint
```
Follow this with `docker start` and your cups/airprint printer is running:
```
$ docker start cups
```
To stop the container simply run:
```
$ docker stop cups
```
To remove the conainer simply run:
```
$ docker rm cups
```

### Parameters
* `--name`: gives the container a name making it easier to work with/on (e.g.
  `cups`)
* `--restart`: restart policy for how to handle restarts (e.g. `always` restart)
* `--net`: network to join (e.g. the `host` network)
* `-v ~/airprint_data/config:/config`: where the persistent printer configs
   will be stored
* `-v ~/airprint_data/services:/services`: where the Avahi service files will
   be generated
* `-e CUPSADMIN`: the CUPS admin user you want created
* `-e CUPSPASSWORD`: the password for the CUPS admin user
* `--device /dev/bus`: device mounted for interacting with USB printers
* `--device /dev/usb`: device mounted for interacting with USB printers

## Using
CUPS will be configurable at http://localhost:631 using the
CUPSADMIN/CUPSPASSWORD when you do something administrative.

If the `/services` volume isn't mapping to `/etc/avahi/services` then you will
have to manually copy the .service files to that path at the command line.

## Notes
* CUPS doesn't write out `printers.conf` immediately when making changes even
though they're live in CUPS. Therefore it will take a few moments before the
services files update
* Don't stop the container immediately if you intend to have a persistent
configuration for this same reason
