FROM mongo:4.4.4

ENV REPLICA_SET_HOST=localhost:27017
COPY init/ /docker-entrypoint-initdb.d/

CMD ["mongod", "--oplogSize", "128", "--replSet", "rs01", "--storageEngine=wiredTiger"]