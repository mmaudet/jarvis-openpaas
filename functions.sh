#!/usr/bin/env bash

jv_pg_op_nextMeeting() {
    local sc=$(jv_pg_op_curl GET /calendar/api/events/next "" text/plain)

    case "${sc}" in
        "200") say "Votre prochain rendez-vous, $(cat ${jv_pg_op_tmp})";;
        "404") say "Vous n'avez pas de prochain rendez-vous";;
        *) say "${phrase_failed}"
    esac
}

jv_pg_op_cancelNextMeeting() {
    local sc=$(jv_pg_op_curl DELETE /calendar/api/events/next)

    case "${sc}" in
        "200") jv_pg_op_done;;
        "404") say "Vous n'avez pas de prochain rendez-vous";;
        *) say "${phrase_failed}"
    esac
}

jv_pg_op_createMeeting() {
    local sc=$(jv_pg_op_curl POST /calendar/api/events "$(jv_pg_op_createMeeting_data)")

    case "${sc}" in
        "200") jv_pg_op_done;;
        *) say "${phrase_failed}"
    esac
}

function jv_pg_op_createMeeting_data() {
  cat <<EOF
{
  "summary": "${jv_pg_op_createMeeting_summary}",
  "location": "${jv_pg_op_createMeeting_location}",
  "when": "${jv_pg_op_createMeeting_when}"
}
EOF
}

jv_pg_op_getContactEmailAddress() {
    local pattern=${1}; [[ ! -z ${2} ]] && pattern="${pattern}+${2}"
    local sc=$(jv_pg_op_curl GET "/contact/api/contacts/search?q=${pattern}")

    case "${sc}" in
        "200") say "$(cat ${jv_pg_op_tmp} | jq '.[] | (.fn + ", " + .emails[].value)')";;
        "204") say "Je ne trouve personne de ce nom";;
        *) say "${phrase_failed}"
    esac
}

function jv_pg_op_done() {
    say "C'est fait"
}

function jv_pg_op_curl() {
	local method=${1}
	local url=${jv_pg_op_url}${2}
	local data=${3}
	local accept=${4}; [[ -z ${accept} ]] && accept=*/*

	if [[ -z ${data} ]]
	then
		curl    -sq \
		        -o"${jv_pg_op_tmp}" \
		        -w"%{http_code}" \
		        -H"Authorization: Bearer ${jv_pg_op_token}" \
		        -H"Accept-Language: ${language:0:2}" \
		        -H"Accept: ${accept}" \
		        -X${method} \
		        ${url}
	else
		curl    -sq \
		        -o"${jv_pg_op_tmp}" \
		        -w"%{http_code}" \
		        -H"Authorization: Bearer ${jv_pg_op_token}" \
		        -H"Accept-Language: ${language:0:2}" \
		        -H"Accept: ${accept}" \
		        -H"Content-Type: application/json" \
		        -d"${data}" \
		        -X${method} \
		        ${url}
	fi
}
