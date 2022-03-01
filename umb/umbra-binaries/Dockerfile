FROM fedora:35

COPY bin /umbra/bin
COPY lib /umbra/lib

ENV LD_LIBRARY_PATH=/umbra/lib

EXPOSE 5432

ENTRYPOINT ["tail"]
CMD ["-f", "/dev/null"]
