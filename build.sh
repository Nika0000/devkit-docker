build() {
    local tag=$(date +"%Y%m%d")
    local image="devkitcloud/${1}"

    pushd ${1} >/dev/null || {
        echo "Directory ${1} not found"
        exit 1
    }

    echo "Building Docker image for ${1}..."
    docker buildx build --no-cache \
        --build-arg TARGET_ARCH=${TARGET_ARCH} \
        -t ${image}:latest -t ${image}:${tag} --push .

    popd >/dev/null
}

if [[ "$1" == "arm64-android" ]]; then
    export TARGET_ARCH ="arm64"
    build android
else
    echo -e "\e[31mUnknown docker, specify arm64-android, arm-android\e[0m"
fi
