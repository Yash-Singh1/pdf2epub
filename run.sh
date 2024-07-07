if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is not installed."
    exit 1
fi

docker run -it -v `pwd`:/temp --platform linux/amd64 pdf_processor:latest process_pdf $1
