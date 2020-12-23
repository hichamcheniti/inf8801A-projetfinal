
   [PlGa]: <https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md>
# Projet Final 

## Introduction
Pour rappel, mon projet final porte sur l'étude de l'article "Image Melding: Combining Inconsistent Images
using Patch-based Synthesis"
```shell
$ sudo ./install.sh
```

## Benchmarks

We recommand you to run the run_benchmarks.sh file, by specifying the ec2 instance you are running on and the main partition of your instance.

Each tests will be ran 5 times and produce a result file.

```shell
$ sudo ./run_benchmarks.sh $INSTANCE $PARTITION
```

Here's an example of a command you could run with a m4.large instance:
```example
$ sudo ./run_benchmarks.sh m4large xvda1
``` 

WARNING :
1. When running the disk test, an error/warning could appear on the command line output. Just ignore it.
It could be something like this : HDIO_DRIVE_CMD(identify) failed: Invalid argument.

2. You could be confused by the number of times the IOPS test is run. We can ensure you that it is run 5 times, and for more details, consult the iops_test.sh file. 

### Individual benchmark
This section presents each benchmark, and if their corresponding file is executed, only one test will be made (except iops_test.sh). All the details of how each benchmark is performed will be described in the report. 
### 1. IO
We start this benchmark by executing this command : 
```shell
$ sudo ./io_test.sh $INSTANCE
```
It uses the dd linux command.

### 2. CPU Memory Disk
We start this benchmark by executing this command : 
```shell
$ sudo ./cpu_test.sh $INSTANCE
```
It uses the Phoronix test suite.

### 3. IOPS
We start this benchmark by executing this command : 
```shell
$ sudo ./iops_test.sh $INSTANCE
```
It uses bonnie++ software.

### 4. Memory
We start this benchmark by executing this command : 
```shell
$ sudo ./memory_test.sh $INSTANCE
```
It uses stress-ng tool.

### 5. Disk
We start this benchmark by executing this command : 
```shell
$ sudo ./disk_test.sh $INSTANCE $PARTITION
```
It uses hdparm command line.

### 6. Network Throughput
We start this benchmark by executing this command : 
```shell
$ sudo ./network_throughput_test.sh $INSTANCE 
```
It uses Speedtest cli.
