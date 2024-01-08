# rocket-ready-mongo

This repository builds docker images customised to provide a ready-to-use single image database for [Rocket Chat][ROCKET_CHAT].

The container implements the recommendations specified in the [Rocket Chat documentation][RC_MONGO_DOCS], largely relating to creating a replica set.
Note that this is only for relatively simple installations.

[ROCKET_CHAT]: https://rocket.chat/
[RC_MONGO_DOCS]: https://docs.rocket.chat/installation/manual-installation/mongo-replicas/

## Building the images

The build commands are in a bash script called `bake`. You must specify a version mongo to use as a base, as well as a docker hub organisation.

```sh
MONGO_VERSION=5.0.23 DOCKER_HUB_ORG=<my_org> ./bake
```

Alternatively, these can be set in a `.env` file, which the `bake` script will read.

This will build and push two images.

* dringtech/rocket-ready-mongo:<MONGO_VERSION>
* dringtech/rocket-ready-mongo:<MONGO_VERSION>-setup

The first image is a customised mongo image with the REPLICA_SET_HOST and an init file to initiate the replicaset.

The second image is a setup image which connects to the mongo image and initialises the replicaset. This image is expected to halt after starting.

## Upgrading

### From v4.4.4

Databases running v4.4.4 will need to be upgraded to v5.0. It does not appear to be supported to migrate to v4.4.4 -> v6.0.

Simply update the mongo reference to the new image, and mongo will migrate the tables appropriately.

You will then need to follow instructions in the [5.0 Upgrade Replica Set instructions](https://www.mongodb.com/docs/upcoming/release-notes/5.0-upgrade-replica-set/).
The specific manual intervention is related to the feature compatibility version.

To do this, you could connect to the image as follows:

```sh
docker exec -it <CONTAINER ID> mongosh
```

Then run the following command:

```js
db.adminCommand( { setFeatureCompatibilityVersion: "5.0" } )
```

### To 6.0

The database will need to be at version 5 to start with. The feature compatibility version will need to be set to 5.0.

https://www.mongodb.com/docs/upcoming/release-notes/6.0-upgrade-replica-set/

As above, once the upgrade is complete, you can issue the following command in mongosh.

```js
db.adminCommand( { setFeatureCompatibilityVersion: "6.0" } )
```

You might get an error updating to mongo 6.0. If so, you probably havent' issued the `setFeatureCompatibilityVersion` as above.

```json
rocket-ready-mongo-mongo-1  | {"t":{"$date":"2024-01-08T14:41:00.282+00:00"},"s":"F",  "c":"CONTROL",  "id":20573,   "ctx":"initandlisten","msg":"Wrong mongod version","attr":{"error":"UPGRADE PROBLEM: Found an invalid featureCompatibilityVersion document (ERROR: Location4926900: Invalid featureCompatibilityVersion document in admin.system.version: { _id: \"featureCompatibilityVersion\", version: \"4.4\" }. See https://docs.mongodb.com/master/release-notes/5.0-compatibility/#feature-compatibility. :: caused by :: Invalid feature compatibility version value, expected '5.0' or '5.3' or '6.0. See https://docs.mongodb.com/master/release-notes/5.0-compatibility/#feature-compatibility.). If the current featureCompatibilityVersion is below 5.0, see the documentation on upgrading at https://docs.mongodb.com/master/release-notes/5.0/#upgrade-procedures."}}
```

