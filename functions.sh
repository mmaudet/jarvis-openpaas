jv_pg_op_nextMeeting() {
    curl    -sq \
            -u"${jv_pg_op_username}:${jv_pg_op_password}" \
            -H"Accept-Language: fr" \
            ${jv_pg_op_url}/calendar/api/events/next/text
}

jv_pg_op_createMeeting() {
    curl    -sq \
            -u"${jv_pg_op_username}:${jv_pg_op_password}" \
            -XPOST \
            -H"Accept-Language: fr" \
            -H"Content-Type: application/json" \
            -d"{
                \"summary\": \"${jv_pg_op_createMeeting_summary}\",
                \"location\": \"${jv_pg_op_createMeeting_location}\",
                \"when\": \"${jv_pg_op_createMeeting_when}\"
            }" \
            ${jv_pg_op_url}/calendar/api/events
}
