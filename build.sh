#!/bin/bash
#
# Run this to build, tag and create fat-manifest for your images
# Ref: https://lobradov.github.io/Building-docker-multiarch-images/


set -e

PROJECT=$1

if [[ -z $PROJECT ]]; then
  echo "Need to specify PROJECT"
  exit 1
fi

if [[ ! -d $PROJECT ]]; then
  echo "PROJECT: $PROJECT does not exist"
  exit 1
fi

pushd $PROJECT
if [[ -f build.config ]]; then
  source ./build.config
else
  echo ERROR: ./build.config not found.
  exit 1
fi

# Fail on empty params
if [[ -z ${REPO} || -z ${IMAGE_NAME} || -z ${TARGET_ARCHES} ]]; then
  echo ERROR: Please set build parameters.
  exit 1
fi

# Determine OS and Arch.
build_os=$(uname -s | tr '[:upper:]' '[:lower:]' )
build_uname_arch=$(uname -m | tr '[:upper:]' '[:lower:]' )

case ${build_uname_arch} in
  x86_64  ) build_arch=amd64 ;;
  aarch64 ) build_arch=arm ;;
  arm*    ) build_arch=arm ;;
  *)
    echo ERROR: Sorry, unsuppoted architecture ${native_arch};
    exit 1
    ;;
esac

#docker_bin_path=$( type -P docker-${build_os}-${build_arch} || type -P ${DOCKER_CLI_PATH%/}/docker-${build_os}-${build_arch} || echo docker-not-found )
docker_bin_path=$(which docker)

if [[ ! -x ${docker_bin_path} ]]; then
  echo ERROR: Missing Docker CLI with manifest command \(docker_bin_path: ${docker_bin_path}\)
  exit 1
fi

if [[ -z ${IMAGE_VERSION} ]]; then
  IMAGE_VERSION="latest"
fi

for docker_arch in ${TARGET_ARCHES}; do
  case ${docker_arch} in
    amd64       ) qemu_arch="x86_64" ;;
    arm32v[5-7] ) qemu_arch="arm" ;;
    arm64v8     ) qemu_arch="aarch64" ;;
    *)
      echo ERROR: Unknown target arch.
      exit 1
  esac
  cp Dockerfile.cross Dockerfile.${docker_arch}
  sed -i -e "s|__BASEIMAGE_ARCH__|${docker_arch}|g" Dockerfile.${docker_arch}
  sed -i -e "s|__QEMU_ARCH__|${qemu_arch}|g" Dockerfile.${docker_arch}
  if [[ ${docker_arch} == "amd64" || ${build_os} == "darwin" ]]; then
    sed -i -e "/__CROSS_/d" Dockerfile.${docker_arch}
  else
    sed -i -e "s/__CROSS_//g" Dockerfile.${docker_arch}
  fi
  #${docker_bin_path} build -f Dockerfile.${docker_arch} -t ${REPO}/${IMAGE_NAME}:${docker_arch}-${IMAGE_VERSION} .

  # Set any arch based config
  if [[ -f image.config ]]; then
    CURRENT_ARCH=${docker_arch} source image.config
  fi
  # Copy QEMU STATIC TO LOCAL DIR
  cp /usr/bin/qemu-${qemu_arch}-static .
  echo "Building with command: ${docker_bin_path} build ${BUILD_ARGS} -f Dockerfile.${docker_arch} -t ${REPO}/${IMAGE_NAME}:${docker_arch}-${IMAGE_VERSION} ."
  ${docker_bin_path} build ${BUILD_ARGS} -f Dockerfile.${docker_arch} -t ${REPO}/${IMAGE_NAME}:${docker_arch}-${IMAGE_VERSION} .
  #${docker_bin_path} push ${REPO}/${IMAGE_NAME}:${docker_arch}-${IMAGE_VERSION}
  rm -f qemu-${qemu_arch}-static
  arch_images="${arch_images} ${REPO}/${IMAGE_NAME}:${docker_arch}-${IMAGE_VERSION}"
  #rm Dockerfile.${docker_arch}
done

echo INFO: Creating fat manifest for ${REPO}/${IMAGE_NAME}:${IMAGE_VERSION}
echo INFO: with subimages: ${arch_images}
#if [ -d ${HOME}/.docker/manifests/docker.io_${REPO}_${IMAGE_NAME}-${IMAGE_VERSION} ]; then
  #rm -rf ${HOME}/.docker/manifests/docker.io_${REPO}_${IMAGE_NAME}-${IMAGE_VERSION}
#fi
#${docker_bin_path} manifest create --amend ${REPO}/${IMAGE_NAME}:${IMAGE_VERSION} ${arch_images}
for docker_arch in ${TARGET_ARCHES}; do
  case ${docker_arch} in
    amd64       ) annotate_flags="" ;;
    arm32v[5-7] ) annotate_flags="--os linux --arch arm" ;;
    arm64v8     ) annotate_flags="--os linux --arch arm64 --variant armv8" ;;
  esac
  echo INFO: Annotating arch: ${docker_arch} with \"${annotate_flags}\"
  #${docker_bin_path} manifest annotate ${REPO}/${IMAGE_NAME}:${IMAGE_VERSION} ${REPO}/${IMAGE_NAME}:${docker_arch}-${IMAGE_VERSION} ${annotate_flags}
done
echo INFO: Pushing ${REPO}/${IMAGE_NAME}:${IMAGE_VERSION}
#${docker_bin_path} manifest push ${REPO}/${IMAGE_NAME}:${IMAGE_VERSION}
popd
