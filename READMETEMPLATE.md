[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/irc/
[podcasturl]: https://www.linuxserver.io/podcast/
[appurl]: http://www.webgrabplus.com
[hub]: https://hub.docker.com/r/linuxserver/webgrabplus/

[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)][linuxserverurl]

The [LinuxServer.io][linuxserverurl] team brings you another container release featuring easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io][forumurl]
* [IRC][ircurl] on freenode at `#linuxserver.io`
* [Podcast][podcasturl] covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# linuxserver/webgrabplus
[![](https://images.microbadger.com/badges/version/linuxserver/webgrabplus.svg)](https://microbadger.com/images/linuxserver/webgrabplus "Get your own version badge on microbadger.com")[![](https://images.microbadger.com/badges/image/linuxserver/webgrabplus.svg)](http://microbadger.com/images/linuxserver/webgrabplus "Get your own image badge on microbadger.com")[![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/webgrabplus.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/linuxserver/webgrabplus.svg)][hub][![Build Status](http://jenkins.linuxserver.io:8080/buildStatus/icon?job=Dockers/LinuxServer.io/linuxserver-webgrabplus)](http://jenkins.linuxserver.io:8080/job/Dockers/job/LinuxServer.io/job/linuxserver-webgrabplus/)

[WebGrab+Plus][appurl] is a multi-site incremental xmltv epg grabber. It collects tv-program guide data from selected tvguide sites for your favourite channels.

## Usage

```
docker create \
  --name=webgrabplus \
  -v <path to data>:/config \
  -v <path to data>:/data \
  -e PGID=<gid> -e PUID=<uid>  \
  linuxserver/webgrabplus
```

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`



* `-v /config` - where webgrabplus should store it's config files
* `-v /config` - where webgrabplus should store it's data files
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation

It is based on ubuntu xenial with s6 overlay, for shell access whilst the container is running do `docker exec -it webgrabplus /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application

To configure WebGrab+Plus follow the guide found here: [http://webgrabplus.com/documentation/configuration/howto][guideurl].

Note that there are some things in the guide that does not apply to this container. Below you can find the changes.

**The configuration files are found where your config volume is mounted.**  
**Do not change the filename tag in the configuration file!**

The /data volume mapping is where WebGrab+Plus outputs the xml file. To use the xml file in another program, you have to point it to the host path you mapped the /data volume to.

To adjust the scheduled cron job for grabbing, edit the wg-cron file found in the `/config` folder. After you have edited the the wg-cron file, restart the container to apply the new schedule.
Do not adjust the command!

Below is the syntax of the cron file.

```
 ┌───────────── minute (0 - 59)
 │ ┌───────────── hour (0 - 23)
 │ │ ┌───────────── day of month (1 - 31)
 │ │ │ ┌───────────── month (1 - 12)
 │ │ │ │ ┌───────────── day of week (0 - 6) (Sunday to Saturday;
 │ │ │ │ │                                       7 is also Sunday on some systems)
 │ │ │ │ │
 │ │ │ │ │
 * * * * *  s6-setuidgid abc /bin/bash /defaults/update.sh
```

## Info

* Shell access whilst the container is running: `docker exec -it webgrabplus /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f webgrabplus`

* container version number 

`docker inspect -f '{{ index .Config.Labels "build_version" }}' webgrabplus`

* image version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/webgrabplus`

## Versions

+ **18.01.18:** Initial Release.
