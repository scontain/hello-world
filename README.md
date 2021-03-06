This is a demonstration of _sconification_ process for C, C++, Go, Python, Node, and Java languages.

`start.sh` script does the following:
1) Builds a native image from provided Dockerfile.
2) Sconifies native image and adds to it FSFP or binaryFS.
3) Runs all (or specified with flags) native and sconified images.

To print help message for `start.sh` execute:
```
./start.sh -h
```

To run _sconification_ for C language simply execute:
```
./start.sh -c
```

`/sconification/evn.sh` file has names of all the images that are either used for _sconification_ or
will be created during this process.
This variable in `/sconification/evn.sh` controls name of the image that is used fro sconification (or `-i` option of `start.sh`)
```
export SCONIFY_IMAGE="registry.scontain.com:5050/sconecuratedimages/community-edition-sconify-image:latest"
```

All languages have associated folders in `./images` folder.

Sconification is done by the script `/sconification/sconify_all.sh`.
This script contains separate functions that are responsible for the sconification of one language and one type of file system.

For example, the following function is responsible for the sconification of Java+binaryFS (https://sconedocs.github.io/binary_fs/).
```
sconify_image \
    --from="${JAVA_NATIVE_IMAGE}" \                   <= Name of native image
    --to="${JAVA_TARGET_IMAGE_BINARYFS}" \            <= Name of sconified image
    --namespace="${NAMESPACE}" \                      <= Name of our namespace
    --create-namespace \                              <= Here we request creation of namespace on CAS
    --name="${JAVA_SESSION_NAME}" \                   <= Name of the session within our namespace
    --service-name="${JAVA_SERVICE_NAME_BINARYFS}" \  <= Nave of the service within our session
    --command="java -jar /app/app.jar" \              <= Command that will be executed by our container
    --cas-debug \                                     <= We attest cas in debug mode
    --cas="${SCONE_CAS_ADDR_L}" \                     <= CAS address (will be embedded in image as ENV)
    --las="${SCONE_LAS_ADDR_L}" \                     <= LAS address (will be embedded in image as ENV)
    --cli="${CLI_IMAGE}" \                            <= SCONE image that has CLI tool (internal use by sconify_image)
    --crosscompiler="${CROSSCOMPILER_IMAGE}" \        <= SCONE image that has crosscompiler tool (internal use by sconify_image)
    --binary="${JAVA_BINARY}" \                       <= Binary within image that we wish to sconify
    --heap="${SCONE_HEAP}" \                          <= Heap size (will be use by SCONE signer)
    --stack="${SCONE_STACK}" \                        <= Stack size (will be use by SCONE signer)
    --dlopen="${SCONE_ALLOW_DLOPEN}" \                <= Permission for library loading size (will be use by SCONE signer)
    --binary-fs \                                     <= Request binaryFS mode for final image
    --fs-dir=/app \                                   <= Directory that we wish to include in binaryFS
    --host-path=/etc/hosts \                          <= Allow binary with binaryFS access to this file on host file system
    --host-path=/etc/resolv.conf \                    <= -//-
    --no-color                                        <= Print without color
```
If you wish to check the other options of `sconify_image`, you could run:
```
docker run -it --rm registry.scontain.com:5050/vasyl/test-images:sconify-image-5.3.3
```
As a result of sconification we obtain $JAVA_TARGET_IMAGE_BINARYFS image that we run with docker-compose.
```
docker-compose run java_scone_binaryfs
```

In `docker-compose.yml`, the above service corresponds to:
```
    java_scone_binaryfs:
        image: ${JAVA_TARGET_IMAGE_BINARYFS}
        environment:
         - SCONE_VERSION=1
        devices:
         - "${SGXDEVICE}"
        depends_on:
            - las
            - cas
```

And if everything went smoothly, you will see output similar to this one:
```
Starting hello-world_las_1 ... done
Starting hello-world_cas_1 ... done
export SCONE_QUEUES=4
export SCONE_SLOTS=256
export SCONE_SIGPIPE=0
export SCONE_MMAP32BIT=0
export SCONE_SSPINS=100
export SCONE_SSLEEP=4000
export SCONE_TCS=8
export SCONE_LOG=WARNING
export SCONE_HEAP=4294967296
export SCONE_STACK=4194304
export SCONE_CONFIG=autogenerated
export SCONE_ESPINS=10000
export SCONE_MODE=hw
export SCONE_ALLOW_DLOPEN=yes (unprotected)
export SCONE_MPROTECT=no
export SCONE_FORK=no
musl version: 1.1.24
SCONE version: 5.3.0-48-gb57eea3c5-robert/sconify-maintenance (Wed Apr 21 08:56:03 2021 +0000) (repository state: dirty)
Enclave hash: 4f88313b1b6d74605813c8b66aeba2f562c56996557205d4a9fd4bb9761b74b2
[SCONE|WARN] src/enclave/dispatch.c:181:print_version(): Application runs in SGX debug mode. Its memory can be read from outside the enclave with a debugger! This is not secure!
[SCONE|WARN] src/syscall/syscall.c:34:__scone_ni_syscall(): system call: membarrier, number 324 is not implemented.
[SCONE|WARN] src/syscall/syscall.c:34:__scone_ni_syscall(): system call: membarrier, number 324 is not implemented.
Picked up JAVA_TOOL_OPTIONS: -Xmx256m
[SCONE|WARN] src/shielding/proc_fs.c:384:_proc_fs_open(): open: /proc/self/mountinfo is not supported
[SCONE|WARN] src/shielding/proc_fs.c:384:_proc_fs_open(): open: /proc/self/coredump_filter is not supported
[SCONE|WARN] src/shielding/proc_fs.c:384:_proc_fs_open(): open: /proc/self/coredump_filter is not supported
[SCONE|WARN] src/syscall/syscall.c:34:__scone_ni_syscall(): system call: membarrier, number 324 is not implemented.
[SCONE|WARN] src/shielding/shielded_syscall.c:1127:handler(): Emulating file memory mapping for fd 3 (/usr/lib/jvm/java-11-openjdk/lib/modules)
[SCONE|WARN] src/shielding/shielded_syscall.c:1262:emulate_memory_mapping(): The application requested to map a file (/usr/lib/jvm/java-11-openjdk/lib/modules) into memory such that modifications will be synchronized between the memory mapping and the file (MAP_SHARED option).
        SCONE is unable to protect such file interactions due to limitations of SGX.
        The memory mapping will be created without file synchronization as most programs do not
        rely on the file synchronization.
[SCONE|WARN] tools/starter/ethread.c:314:enclave_thread(): Protected heap memory exhausted! Set SCONE_HEAP environment variable to increase it. Available memory: 1051092 kB
[SCONE|WARN] tools/starter/ethread.c:314:enclave_thread(): Protected heap memory exhausted! Set SCONE_HEAP environment variable to increase it. Available memory: 1051092 kB
[SCONE|WARN] tools/starter/ethread.c:314:enclave_thread(): Protected heap memory exhausted! Set SCONE_HEAP environment variable to increase it. Available memory: 1051092 kB
[SCONE|WARN] tools/starter/ethread.c:314:enclave_thread(): Protected heap memory exhausted! Set SCONE_HEAP environment variable to increase it. Available memory: 1051092 kB
[SCONE|WARN] tools/starter/ethread.c:314:enclave_thread(): Protected heap memory exhausted! Set SCONE_HEAP environment variable to increase it. Available memory: 1051092 kB
[SCONE|WARN] tools/starter/ethread.c:314:enclave_thread(): Protected heap memory exhausted! Set SCONE_HEAP environment variable to increase it. Available memory: 1051092 kB
[SCONE|WARN] tools/starter/ethread.c:314:enclave_thread(): Protected heap memory exhausted! Set SCONE_HEAP environment variable to increase it. Available memory: 1051092 kB
Hello World Java!
[SCONE|WARN] src/syscall/syscall.c:34:__scone_ni_syscall(): system call: membarrier, number 324 is not implemented.
[SCONE|WARN] src/shielding/ephemeral.c:1269:_fs_ephemeral_handle_fd_syscall(): fcntl(X, 3, 0) reached a SCONE ephemeral file descriptor.
[SCONE|WARN] src/shielding/proc_fs.c:384:_proc_fs_open(): open: /proc/net/ipv6_route is not supported

<You will see here content of repl from example.com>
<You will see here content of /etc/hosts>
<You will see here content of /etc/resolv.conf>


Java SCONE binaryFS image is done!
```

Happy Sconification!
