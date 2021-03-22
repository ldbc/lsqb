FROM fedora/postgresql

USER 0

COPY hyper /hyper

EXPOSE 7484

RUN dnf install ncurses-devel -y

ENTRYPOINT ["tail"]
CMD ["-f", "/dev/null"]
