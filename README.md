# docker-jmeter
## Building

With the script [build.sh](build.sh) the Docker image can be build
from the [Dockerfile](Dockerfile). You may use your own ``docker build`` command or use one
of the pre-built Images from [Docker Hub](https://hub.docker.com/).

See end of this doc for more detailed build/run/test instructions.

### Build Options

Build arguments (see [build.sh](build.sh)) with default values if not passed to build:

- **JMETER_VERSION** - JMeter version, default ``5.4``. Use as env variable to build with another version: `export JMETER_VERSION=5.4`
- **IMAGE_TIMEZONE** - timezone of Docker image, default ``"America/New_York"``. Use as env variable to build with another timezone: `export IMAGE_TIMEZONE="Europe/Berlin"`

## Running

The Docker image will accept the same parameters as ``jmeter`` itself, assuming
you run JMeter non-GUI with ``-n``.

The script [run.sh](run.sh) is an example of how to run containerized JMeter.

## Do it for real: detailed build/run/test

1. In a Terminal/Command session, install Git, navigate/make a folder, then:

   ```
   git clone https://github.com/llinmd/docker-jmeter.git
   cd docker-jmeter
   ```

2. Run the Build script to download dependencies:

   ```
   ./build.sh
   ```
   If you view this file, the <strong>docker build</strong> command within the script is for a specific version of JMeter and implements the <strong>Dockerfile</strong> in the same folder. 
   
   If you view the Dockerfile, notice the `JMETER_VERSION` specified can be different from the one in the build.sh script. The FROM keyword specifies the Alpine operating system, which is very small (less of an attack surface). Also, no JMeter plug-ins are used.
   
   At the bottom of the Dockerfile is the <strong>[entrypoint.sh](entrypoint.sh)</strong> file. If you view it, that's where JVM memory settings are specified for <strong>jmeter</strong> before it is invoked. PROTIP: Such settings need to be adjusted for tests of more complexity.

3. Run the ``docker run`` script:

   ```
   ./run.sh
   ```

4. Switch to your machine's Folder program and navigate to the ``docker-jmeter/tests`` folder:
   
   ```
   cd tests
   ```
   
   The files are:

   * test-apache-home.jmx containing the JMeter test plan
   * jmeter_<date-time-stamp>.log
   * result_<date-time-stamp>.jtl containing statistics from the run displayed by the index.html file
   * reports folder

5. Navigate into the <strong>report</strong> folder and open the <strong>index.html</strong> file to pop up a browser window displaying the run report. On a Mac Terminal:
   
   ```
   cd report
   open index.html
   ```

## Specifics

The Docker image built from the 
[Dockerfile](Dockerfile) inherits from the [Alpine Linux](https://www.alpinelinux.org) distribution:

> "Alpine Linux is built around musl libc and busybox. This makes it smaller 
> and more resource efficient than traditional GNU/Linux distributions. 
> A container requires no more than 8 MB and a minimal installation to disk 
> requires around 130 MB of storage. 
> Not only do you get a fully-fledged Linux environment but a large selection of packages from the repository."

See https://hub.docker.com/_/alpine/ for Alpine Docker images.

The Docker image will install (via Alpine ``apk``) several required packages most specificly
the ``OpenJDK Java JRE``.  JMeter is installed by simply downloading/unpacking a ``.tgz`` archive
from http://mirror.serversupportforum.de/apache/jmeter/binaries within the Docker image.

A generic [entrypoint.sh](entrypoint.sh) is copied into the Docker image and
will be the script that is run when the Docker container is run. The
[entrypoint.sh](entrypoint.sh) simply calls ``jmeter`` passing all argumets provided
to the Docker container, see [run.sh](run.sh) script:

```
docker run \
  --rm --name ${NAME} \
  --volume ${volume_path}:${jmeter_path} ${IMAGE} \
  -n \
  -t ${jmeter_path}/test-apache-home.jmx \
  -l ${jmeter_path}/tmp/result_${timestamp}.jtl \
  -j ${jmeter_path}/tmp/jmeter_${timestamp}.log 
```
