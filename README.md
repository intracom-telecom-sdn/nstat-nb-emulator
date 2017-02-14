[![Code Climate](https://codeclimate.com/github/intracom-telecom-sdn/nstat-nb-emulator/badges/gpa.svg)](https://codeclimate.com/github/intracom-telecom-sdn/nstat-nb-emulator)
[![Documentation Status](https://readthedocs.org/projects/nstat-northbound-emulator/badge/?version=latest)](http://nstat-northbound-emulator.readthedocs.io/en/latest/?badge=latest)
[![Build Status](https://travis-ci.org/intracom-telecom-sdn/nstat-nb-emulator.svg?branch=master)](https://travis-ci.org/intracom-telecom-sdn/nstat-nb-emulator)
[![Docker Automated build](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg?maxAge=2592000)](https://hub.docker.com/r/intracom/nstat-nb-emulator/)
[![Issue Count](https://codeclimate.com/github/intracom-telecom-sdn/nstat-nb-emulator/badges/issue_count.svg)](https://codeclimate.com/github/intracom-telecom-sdn/nstat-nb-emulator)
[![Code Health](https://landscape.io/github/intracom-telecom-sdn/nstat-nb-emulator/master/landscape.svg?style=flat)](https://landscape.io/github/intracom-telecom-sdn/nstat-nb-emulator/master)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/b1318125f6e148e4be8deb9d666c185d)](https://www.codacy.com/app/kostis-g-papadopoulos/nstat-nb-emulator?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=intracom-telecom-sdn/nstat-nb-emulator&amp;utm_campaign=Badge_Grade)

# NSTAT Northbound Emulator

## Motivation

To provide a controllable and configurable method for generating and adding flows
to the Config DataStore via the NorthBound interface.

## Northbound Emulator node deployment

In order to distribute this application as an appliance ready to be used, we
use [docker containers](https://www.docker.com/what-docker). There are two
options

- download the prebuilt environment from DockerHub
- build your own container locally using the provided `Dockerfiles` for proxy
  and no-proxy environments, under the path `<PROJECT_DIR>/deploy/docker`

Before using one of these two methods the following steps must be done
- Install docker (v.1.12.1 or later) should be installed on your
  host machine
- Give non-root access to docker daemon
  - Add the docker group if it doesn't already exist sudo groupadd docker
  - Add the connected user "${USER}" to the docker group. Change the user
    name to match your preferred user
    ```bash
    sudo gpasswd -a ${USER} docker
    ```
- Restart the Docker daemon:
  ```bash
  sudo service docker restart
  ```

### Download the prebuilt environment

docker pull `intracom/nstat-nb-gnerator`

For running a container once the `intracom/nstat-nb-gnerator` is locally available

```bash
docker run -it intracom/nstat-nb-gnerator /bin/bash

password: root123
```

then make a git clone of the nstat-nb-emulator repository within the container

```bash
git clone https://github.com/intracom-telecom-sdn/nstat-nb-emulator.git
git --git-dir=nstat-nb-emulator/.git --work-tree=nstat-nb-emulator checkout v.1.0
```

activate the python virtual environment using the command

```bash
source /opt/venv_nb_generator/bin/activate
```

and start testing using the handlers under `<PROJECT_DIR>/src` directory or
directly run the generator. You can find directions in the following two
sections `NorthBound generator handling logic` and `Northbound Generator usage`

### Build your own container based environment

In order to build your own container locally, you can use the `Dockerfiles`
provided under the folder `<PROJECT_DIR>/deploy/docker` either for proxy or
non-proxy environments. If for instance you choose to build a non-proxy
container, go to the path `<PROJECT_DIR>/deploy/docker/no_proxy` and run the
command

```bash
docker build -t intracom/nstat-nb-gnerator .
```

After the build is completed follow the steps to run the new container as
described in the previous section.

## NorthBound generator handling logic

The NorthBound generator can be used by NSTAT through a handler. We have only
one handler `run_handler.py` under the path `<PROJECT_DIR>/src`.
It takes the following command line arguments:
  1. IP address of controller
  2. controller REST interface port (port on which the NorthBound
    controller's interface listens for REST requests)
  3. total number of requests for Flow modifications that will be performed.
    The supported requests for Flow modifications are addition of new flows
    and deletions of the corresponded flows. These requests are distributed
    to the flow worker threads.
  4. number of flow worker threads to create
  5. delay between thread operations (in milliseconds)
  6. whether to delete or not the added flows (can have the values 'True' or
    'False')
  7. controller NorthBound REST interface username
  8. controller NorthBound REST interface password
  9. flows per request, the number of flows that will be sent in a single
  request
  10. NorthBound generator logging level (Can be DEBUG, INFO or ERROR. The
    default value is DEBUG)

Running this handler from the provided docker container can be done with the
following two steps

- Activate the python virtual environment, located in the container under the
  path `/opt/venv_nb_generator` with the following command
```bash
  source /opt/venv_nb_generator/bin/activate
```
- Run the handler using the following command as an example on the same path
  where the handler resides
```bash
  python3.4 run_handler.py 10.0.1.11 8181 100000 5 0 False admin admin 1 DEBUG
```

In case of NSTAT, to avoid a tight coupling between the core application and the
NorthBound Generator docker container, we make the activation of python virtual
environment using a wrapper, that resides in the `<PROJECT_DIR>/bin` folder.
If we would like to use this wrapper instead of activating the python virtual
environment, we could use the following example command in the docker
container, from the `<PROJECT_DIR>/bin`
```bash
./venv_handler.sh run_handler.py 10.0.1.11 8181 100000 5 0 False admin admin 1 DEBUG
```


## Northbound Generator usage

For generating traffic to the controller's Config DataStore via the
NorthBound interface, follow these steps:

1. Start OpenDaylight controller with the following features:
  - `odl-openflowplugin-flow-services`
  - `odl-restconf-all`
2. Start a Mininet network and connect it to the controller
3. Start the flow generator:

```bash
nb_gen.py [-h] --controller-ip CTRL_IP
               --controller-port CTRL_PORT
               --number-of-flows NFLOWS
               --number-of-workers NWORKERS
               --operation-delay OP_DELAY_MS
               [--delete-flows]
               [--restconf-user RESTCONF_USER]
               [--restconf-password RESTCONF_PASSWORD]
               [--logging-level LOGGING_LEVEL]

  -h, --help            show this help message and exit
  --controller-ip CTRL_IP
                        The ip address of the controller.
                        This is a compulsory argument.
                        Example: --controller-ip='127.0.0.1'
  --controller-port CTRL_PORT
                        The port number of RESTCONF port of the controller.
                        This is a compulsory argument.
                        Example: --controller-port='8181'
  --number-of-flows NFLOWS
                        The total number of flow modifications.
                        This is a compulsory argument.
                        Example: --number-of-flows='1000'
  --number-of-workers NWORKERS
                        The total number of worker threads that will be created.
                        This is a compulsory argument.
                        Example: --number-of-workers='10'
  --operation-delay OP_DELAY_MS
                        The delay between each flow operation (in ms).
                        This is a compulsory argument.
                        Example: --operation-delay='5'
  --delete-flows        Flag defines if the type of operations will be
                        additions of flows or deletions of flows. If this flag
                        is used, an action of flow additions should have been
                        performed before.
                        Example: --delete-flag
  --restconf-user RESTCONF_USER
                        The controller RESTCONF username.
                        The default value is 'admin'.
                        Example: --restconf-user='admin'
  --restconf-password RESTCONF_PASSWORD
                        The controller RESTCONF password.
                        The default value is 'admin'.
                        Example: --restconf-password='admin'
  --fpr FPR
                        Flows-per-Request - number of flows
                        (batch size) sent in each HTTP request.
                        Example: --fpr=10
  --logging-level LOGGING_LEVEL
                        Setting the level of the logging messages.Can have one
                        of the following values:
                        INFO
                        DEBUG (default)
                        ERROR
```

If specified, the `--delete-flows` flag deletes all flows that have been
previously added. In order to use this flag you must have previously add an
equal amount of flows you want to delete.

The number of flows to be added or deleted by worker threads, is defined by the
`--number-of-flows` parameter.

The flow generator script returns the following values:
- number of total failed flow operations. These are the operations that their
  response status code were not 200 or 204

The file `nb_gen.py` can be found under the
[<PROJECT_DIR>/src](https://github.com/intracom-telecom-sdn/nstat-nb-emulator/tree/master/src)
folder. In order to run, it requires certain python3.4 libraries, defined in
file
[<PROJECT_DIR>/deploy/requirements.txt](https://github.com/intracom-telecom-sdn/nstat-nb-emulator/blob/master/deploy/requirements.txt).
If the above libraries are installed on the system, as well as python3.4

```bash
apt-get update && apt-get install python3.4 python3-pip
pip3 install -r <PROJECT_DIR>/deploy/requirements.txt
```

then NorthBound generator can run directly with the following example command

```bash
python3.4 <PROJECT_DIR>/src/nb_gen.py --controller-ip=10.0.1.11 --controller-port=8181 --number-of-flows=100 --number-of-workers=5 --operation-delay=0 --restconf-user=admin --restconf-password=admin
```

In case you use the provided docker container and you have activated the python
virtual environment, as described in previous sections, the above installation
step is not necessary. You can directly run the example command.

In case of [NSTAT](https://github.com/intracom-telecom-sdn/nstat), the usage
NorthBound generator is performed through handlers.
These handlers offer an extra layer of decoupling between the operational
requirements of NorthBound Generator and the way this generator will be
invoked from [NSTAT](https://github.com/intracom-telecom-sdn/nstat),
implementing the required interfaces.

## Features

- **Delay before each RESTCONF call**: in this way we control how fast the
  requests are sent to the NorthBound interface of the controller.

- **Emulation of multiple NorthBound applications**: Approaching a more
  realistic usage of a Controller NorthBound interface, where we have multiple
  applications, sending RESTCONF calls to install new flows on OpenFlow devices,
  we have introduced the concept of worker thread. A worker thread
  instantiated by NorthBound Generator emulates a NorthBound application.

- **Multiple Flow installations per RESTCONF call**: There is a parameter that
  defines how many Flows will be packed in a RESTCONF call, sent by a worker
  thread. This parameter is the `--fpr`. In the next section we will see
  NorthBound Generator parameters in more details.

## Design

A Flow-Master thread distributes all flow operations to a number of
Flow-Worker threads to write them to the controller's Config DataStore via
the NorthBound REST interface. The worker threads are synchronized so that the
REST requests are being sent simultaneously. After all flows have been sent, the
worker threads join inside the Flow-Master returning their partial results (the
number of failed REST requests). Subsequently, the Flow-Master polls the
Operational DataStore to discover the flows that have been successfully installed,
until the expected number is reached.

The time between the initiation of REST requests from the worker threads and the moment
when all flows have been reflected to the Operational DataStore, is considered the flow
installation time.

### Flow operations generation and scheduling

The generated flows are created based on the following json template and each
has a unique flow id. These flows are added or deleted to a topology of switches
connected on the SouthBound interface of the controller.
```json
{
    "cookie": %d,
    "cookie_mask": 4294967295,
    "flow-name": "%s",
    "hard-timeout": %d,
    "id": "%s",
    "idle-timeout": %d,
    "installHw": true,
    "priority": 2,
    "strict": false,
    "table_id": 0,
    "match": {
        "ipv4-destination": "%s/32",
        "ethernet-match": {
            "ethernet-type": {
                "type": 2048
            }
        }
    },
    "instructions": {
        "instruction": [
            {
                "apply-actions": {
                    "action": [
                        {
                            "drop-action": {},
                            "order": 0
                        }
                    ]
                },
                "order": 0
            }
        ]
    }
}
```
On the above template all elements with % are configurable parameters. For the
above mentioned template as well as the generation installation and deletion
functions of flows, we were based on
[Jan Medved's](https://github.com/opendaylight/integration/tree/master/test/tools/odl-mdsal-clustering-tests/clustering-performance-test)
original scripts.

The total number of flows, are distributed among the Flow-Worker threads.
There is a scheduling function that distributes equally the total operations
among `Workers`, following a round robin algorithm.

Each `Worker` gets a dictionary, which has elements of keys and flows. The key
is the id of the switch, on which the corresponded flow will be added or
deleted. Total flows are distributed equally among the total switches. This
distribution is also made by the scheduling function that makes the
distribution of flows to Flow-Worker threads and is made in a way that the
same `Worker thread` will make additions and the equivalent deletion operations
on the same switches.

An example of how distribution of flows is done on workers and switches is
depicted in the following figure. In this case depicted, we have four workers,
8 switches and n number of flows, which should be greater than the number of
switches or else some switches will remain without flows.

![Example of flow distribution and operation](https://github.com/intracom-telecom-sdn/nstat-nb-emulator/blob/master/images/nb_flow_gen.png)
