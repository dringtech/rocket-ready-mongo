[ -z ${REPLICA_SET_NAME} ] || mongo <<END
  var replicaSetName='${REPLICA_SET_NAME}'
  var replicaSetHost='${REPLICA_SET_HOST}'
  var rsConfig = { _id: replicaSetName, members: [ { _id: 0, host: replicaSetHost } ] }
  printjson(rs.initiate(rsConfig))
END