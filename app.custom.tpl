#!/bin/bash
DOCKERIZER_PATH="$(cd -- $(dirname $0)/../ && pwd)"
if [ -f "$DOCKERIZER_PATH/config" ]; then
	. "$DOCKERIZER_PATH/config"
fi

read -r -d '' DOCKERFILE <<EOD
FROM {{printf $IMAGE_ORIGINAL}}
RUN useradd -m user
USER user
RUN echo "#!/bin/bash\nusermod -u \\\$UID -g \\\$GID user > /dev/null 2>&1\n\\\$@" > /home/user/entrypoint && chmod +x /home/user/entrypoint
ENTRYPOINT [ "/home/user/entrypoint" ]
EOD

IMAGE_TAG="{{printf $IMAGE_CUSTOM}}"

build() {
	echo "$DOCKERFILE" | docker build -t $IMAGE_TAG -
}

execute() {
	docker run -it --rm \
		-e UID=$(id -u) \
		-e GID=$(id -g) \
		-w {{printf $TARGET_PWD_MOUNT}} \
		-v "$PWD:{{printf $TARGET_PWD_MOUNT}}" \
		$IMAGE_TAG \
		{{printf $IMAGE_ENTRYPOINT}} "$@"
}

case "$1" in
	build) build ;;
	*)
		execute "$@"
		;;
esac
