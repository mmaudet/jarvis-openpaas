jv_pg_op_nextMeeting() {
  curl -sq -u"${jv_pg_op_username}:${jv_pg_op_password}" -o /tmp/jv_pg_op_curl -H"Accept-Language: fr" ${jv_pg_op_url}/calendar/api/events/next/text && say "`cat /tmp/jv_pg_op_curl`"
}

jv_pg_op_createMeeting() {
  curl -sq -XPOST -u"${jv_pg_op_username}:${jv_pg_op_password}" -o /tmp/jv_pg_op_curl -H"Accept-Language: fr" ${jv_pg_op_url}/calendar/api/events
}

