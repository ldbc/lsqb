FROM karmaresearch/trident:latest
WORKDIR /app/trident
RUN ["/app/trident/scripts/docker/update_and_make.sh"]
