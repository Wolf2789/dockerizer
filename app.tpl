#!/bin/bash

docker run -it --rm \
	-e UID=$(id -u) \
	-e GID=$(id -g) \
	-w {{printf $TARGET_PWD_MOUNT}} \
	-v "$PWD:{{printf $TARGET_PWD_MOUNT}}" \
	{{printf $IMAGE_ORIGINAL}} \
	$@
