#!/bin/bash

echo "Sourcig env.sh that contains image names"
source /sconification/env.sh

export DEVICE="/dev/isgx"
export SCONE_CAS_ADDR_L="cas"
export SCONE_LAS_ADDR_L="las"
export SCONE_HEAP=2G
export SCONE_STACK=4M
export SCONE_ALLOW_DLOPEN=2


function build_native_images {

    echo "Building native c image..."
    docker build /images/c/. --tag "${C_NATIVE_IMAGE}" &> /dev/null

    echo "Building native C++ image..."
    docker build /images/cpp/. --tag "${CPP_NATIVE_IMAGE}" &> /dev/null

    echo "Building native Go image..."
    docker build /images/go/. --tag "${GO_NATIVE_IMAGE}" &> /dev/null

    echo "Building native Java image..."
    docker build /images/java/. --tag "${JAVA_NATIVE_IMAGE}" &> /dev/null

    echo "Building native Java8 image..."
    docker build /images/java8/. --tag "${JAVA8_NATIVE_IMAGE}" &> /dev/null

    echo "Building native Python image..."
    docker build /images/python/. --tag "${PYTHON_NATIVE_IMAGE}" &> /dev/null
}

export C_SESSION_NAME="c-alpine"
export C_BINARY="/app/hello-world"

function c_image_binaryfs(){    
    echo "Making C with binary-fs"
    SCONE_HEAP=64M

    export NAMESPACE="sconify-c-namespace-$RANDOM$RANDOM$RANDOM"
    export SESSION=$(
    sconify_image \
            --from="${C_NATIVE_IMAGE}" \
            --to="${C_TARGET_IMAGE}" \
            --namespace="${NAMESPACE}" \
            --create-namespace \
            --name="${C_SESSION_NAME}" \
            --service-name="${C_SERVICE_NAME}" \
            --command="${C_BINARY}" \
            --cas-debug \
            --cas="${SCONE_CAS_ADDR_L}" \
            --las="${SCONE_LAS_ADDR_L}" \
            --cli="${CLI_IMAGE}" \
            --crosscompiler="${CROSSCOMPILER_IMAGE}" \
            --heap="${SCONE_HEAP}" \
            --stack="${SCONE_STACK}" \
            --dlopen="${SCONE_ALLOW_DLOPEN}" \
            --binary="${C_BINARY}" \
            --binary-fs \
            --fs-dir=/app \
            --no-color \
        )
    echo "Done making C with binary-fs"
}

export CPP_SESSION_NAME="cpp-alpine"
export CPP_BINARY="/app/hello-world"

function cpp_image_binaryfs(){    
    echo "Making C++ with binary-fs"
    SCONE_HEAP=64M

    export NAMESPACE="sconify-cpp-ns-$RANDOM$RANDOM$RANDOM"
    export SESSION=$(
    sconify_image \
            --from="${CPP_NATIVE_IMAGE}" \
            --to="${CPP_TARGET_IMAGE}" \
            --namespace="${NAMESPACE}" \
            --create-namespace \
            --name="${CPP_SESSION_NAME}" \
            --service-name="${CPP_SERVICE_NAME}" \
            --command="${CPP_BINARY}" \
            --cas-debug \
            --cas="${SCONE_CAS_ADDR_L}" \
            --las="${SCONE_LAS_ADDR_L}" \
            --cli="${CLI_IMAGE}" \
            --crosscompiler="${CROSSCOMPILER_IMAGE}" \
            --heap="${SCONE_HEAP}" \
            --stack="${SCONE_STACK}" \
            --dlopen="${SCONE_ALLOW_DLOPEN}" \
            --binary="${CPP_BINARY}" \
            --binary-fs  \
            --fs-dir=/app \
            --no-color
        )
    echo "Done making C++ with binary-fs"
}

export GO_SESSION_NAME="go-alpine"
export GO_BINARY="/app/hello-world"

function go_image_fspf(){
    echo "Making GO with fspf"
    SCONE_HEAP=2G

    export NAMESPACE="sconify-go-ns-$RANDOM$RANDOM$RANDOM$RANDOM"
    export SESSION=$(
    sconify_image \
            --from="${GO_NATIVE_IMAGE}" \
            --to="${GO_TARGET_IMAGE_FSPF}" \
            --namespace="${NAMESPACE}" \
            --create-namespace \
            --name="${GO_SESSION_NAME}" \
            --service-name="${GO_SERVICE_NAME_FSPF}" \
            --command="${GO_BINARY}" \
            --cas-debug \
            --cas="${SCONE_CAS_ADDR_L}" \
            --las="${SCONE_LAS_ADDR_L}" \
            --cli="${CLI_IMAGE}" \
            --crosscompiler="${CROSSCOMPILER_IMAGE}" \
            --heap="${SCONE_HEAP}"  \
            --stack="${SCONE_STACK}"  \
            --dlopen="${SCONE_ALLOW_DLOPEN}" \
            --binary="${GO_BINARY}" \
            --dir=/app \
            --no-color 
        )
    
    echo "Done making GO with fspf"
}


export JAVA_SESSION_NAME="java"
export JAVA_BINARY="/usr/lib/jvm/java-11-openjdk/bin/java"

function java_image_fspf(){
    echo "Making Java with fspf"
    SCONE_HEAP=4G

    export NAMESPACE="sconify-java-ns-$RANDOM$RANDOM$RANDOM$RANDOM"
    export SESSION=$(
    sconify_image \
            --from="${JAVA_NATIVE_IMAGE}" \
            --to="${JAVA_TARGET_IMAGE_FSPF}" \
            --namespace="${NAMESPACE}" \
            --create-namespace \
            --name="${JAVA_SESSION_NAME}" \
            --service-name="${JAVA_SERVICE_NAME_FSPF}" \
            --command="java -jar /app/app.jar" \
            --cas-debug \
            --cas="${SCONE_CAS_ADDR_L}" \
            --las="${SCONE_LAS_ADDR_L}" \
            --cli="${CLI_IMAGE}" \
            --crosscompiler="${CROSSCOMPILER_IMAGE}" \
            --binary="${JAVA_BINARY}" \
            --heap="${SCONE_HEAP}" \
            --stack="${SCONE_STACK}" \
            --dlopen="${SCONE_ALLOW_DLOPEN}" \
            --dir=/app \
            --no-color 
        )
    
    echo "Done making Java with fspf"
}

export JAVA8_SESSION_NAME="java"
export JAVA8_BINARY="/usr/lib/jvm/java-1.8-openjdk/jre/bin/java"

function java8_image_fspf(){
    echo "Making Java8 with fspf"
    SCONE_HEAP=4G

    export NAMESPACE="sconify-java8-ns-$RANDOM$RANDOM$RANDOM$RANDOM"
    export SESSION=$(
    sconify_image \
            --from="${JAVA8_NATIVE_IMAGE}" \
            --to="${JAVA8_TARGET_IMAGE_FSPF}" \
            --namespace="${NAMESPACE}" \
            --create-namespace \
            --name="${JAVA8_SESSION_NAME}" \
            --service-name="${JAVA8_SERVICE_NAME_FSPF}" \
            --command="java -jar /app/app.jar" \
            --cas-debug \
            --cas="${SCONE_CAS_ADDR_L}" \
            --las="${SCONE_LAS_ADDR_L}" \
            --cli="${CLI_IMAGE}" \
            --crosscompiler="${CROSSCOMPILER_IMAGE}" \
            --binary="${JAVA8_BINARY}" \
            --heap="${SCONE_HEAP}" \
            --stack="${SCONE_STACK}" \
            --dlopen="${SCONE_ALLOW_DLOPEN}" \
            --dir=/app \
            --no-color 
        )
    
    echo "Done making Java8 with fspf"
}

export PYTHON_SESSION_NAME="python"
export PYTHON_BINARY="/usr/bin/python3.7"

function python_image_binaryfs(){    
    echo "Making Python with binary-fs"
    SCONE_HEAP=512M

    export NAMESPACE="sconify-python-ns-$RANDOM$RANDOM$RANDOM"
    export SESSION=$(
    sconify_image \
            --from="${PYTHON_NATIVE_IMAGE}" \
            --to="${PYTHON_TARGET_IMAGE_BINFS}" \
            --namespace="${NAMESPACE}" \
            --create-namespace \
            --name="${PYTHON_SESSION_NAME}" \
            --service-name="${PYTHON_SERVICE_NAME_BINFS}" \
            --command="python3 /app/helloworld.py" \
            --cas-debug \
            --cas="${SCONE_CAS_ADDR_L}" \
            --las="${SCONE_LAS_ADDR_L}" \
            --cli="${CLI_IMAGE}" \
            --crosscompiler="${CROSSCOMPILER_IMAGE}" \
            --heap="${SCONE_HEAP}" \
            --stack="${SCONE_STACK}" \
            --dlopen="${SCONE_ALLOW_DLOPEN}" \
            --binary="${PYTHON_BINARY}" \
            --binary-fs \
            --fs-dir=/app \
            --no-color \
        )
    echo "Done making Python with binary-fs"
}

echo "Step 1: Building native images"
build_native_images

echo "Step 2: Sconifying C image."
c_image_binaryfs

echo "Step 3: Sconifying C++ image.."
cpp_image_binaryfs

echo "Step 4: Sconifying GO image..."
go_image_fspf

echo "Step 5: Sconifying java image...."
java_image_fspf

echo "Step 6: Sconifying java8 image....."
java8_image_fspf

echo "Step 7: sconifying Python image......"
python_image_binaryfs