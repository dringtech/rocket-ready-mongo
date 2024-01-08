ARG MONGO_VERSION=4.4.4
FROM mongo:${MONGO_VERSION}

WORKDIR /opt/rrm
COPY setup.sh .
RUN chmod u+x setup.sh

ENV REPLICA_SET_NAME=rs01
ENV REPLICA_SET_HOST=localhost:27017
ENV MONGO_HOST=mongodb://localhost:27017

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/opt/rrm/setup.sh"]