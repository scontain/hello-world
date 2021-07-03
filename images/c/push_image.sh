export VERSION=0.1.0
set -e -x
export IMAGE="registry.scontain.com:5050/native/hello-world:$VERSION"
docker build . -t "$IMAGE"
docker push $IMAGE

echo "Image $IMAGE built and pushed"
