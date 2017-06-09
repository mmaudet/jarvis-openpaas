#!/usr/bin/env bash

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

jv_pg_op_getContactEmailAddress() {
    local sc=$(jv_pg_op_searchContacts ${*})

    case "${sc}" in
        "200") say "$(cat ${jv_pg_op_tmp} | jq '.[] | (.fn + ", " + .emails[].value)')";;
        "204") say "Je ne trouve personne de ce nom";;
        *) say "Erreur"
    esac
}

jv_pg_op_searchContacts() {
    curl    -sq \
            -u"${jv_pg_op_username}:${jv_pg_op_password}" \
            -H"Accept-Language: fr" \
            -o ${jv_pg_op_tmp} \
            -w "%{http_code}" \
            ${jv_pg_op_url}/contact/api/contacts/search?q=${1}+${2}
}
