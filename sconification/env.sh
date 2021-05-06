
export SCONIFY_IMAGE="sconecuratedimages/sconecli:sconify-image"
export CLI_IMAGE="$SCONIFY_IMAGE"
export CROSSCOMPILER_IMAGE="$SCONIFY_IMAGE"

export C_NATIVE_IMAGE="c-native"
export C_SERVICE_NAME="scone_c_service"
export C_TARGET_IMAGE="${C_SERVICE_NAME}_image"

export CPP_NATIVE_IMAGE="cpp-native"
export CPP_SERVICE_NAME="scone_cpp_service"
export CPP_TARGET_IMAGE="${CPP_SERVICE_NAME}_image"

export GO_NATIVE_IMAGE="go-native"
export GO_SERVICE_NAME_FSPF="scone_go_service_fspf"
export GO_TARGET_IMAGE_FSPF="${GO_SERVICE_NAME_FSPF}_image"

export JAVA_NATIVE_IMAGE="java-native"
export JAVA_SERVICE_NAME_FSPF="scone_java_service_fspf"
export JAVA_TARGET_IMAGE_FSPF="${JAVA_SERVICE_NAME_FSPF}_image"

export JAVA8_NATIVE_IMAGE="java8-native"
export JAVA8_SERVICE_NAME_FSPF="scone_java8_service_fspf"
export JAVA8_TARGET_IMAGE_FSPF="${JAVA8_SERVICE_NAME_FSPF}_image"

export PYTHON_NATIVE_IMAGE="python-native"
export PYTHON_SERVICE_NAME_BINFS="scone_python_service_binfs"
export PYTHON_TARGET_IMAGE_BINFS="${PYTHON_SERVICE_NAME_BINFS}_image"