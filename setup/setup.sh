mongo ${MONGO_HOST} <<END
  var replicaSetName='${REPLICA_SET_NAME}'
  var replicaSetHost='${REPLICA_SET_HOST}'
  var rsConfig = { _id: replicaSetName, members: [ { _id: 0, host: replicaSetHost } ] }
  printjson(rsConfig)

  if (rs.status().set === replicaSetName) {
    printjson(rs.reconfig(rsConfig))
  } else {
    printjson(rs.initiate(rsConfig))
  }
END