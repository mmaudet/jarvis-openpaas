#!/usr/bin/env bash

jv_pg_op_nextMeeting() {
    local sc=$(jv_pg_op_curl GET /calendar/api/events/next "" text/plain)

    case "${sc}" in
        "200") say "$(jv_pg_op_i18n NEXT_MEETING), $(cat ${jv_pg_op_tmp})";;
        "404") say "$(jv_pg_op_i18n NO_NEXT_MEETING)";;
        *) say "${phrase_failed}"
    esac
}

jv_pg_op_cancelNextMeeting() {
    local sc=$(jv_pg_op_curl DELETE /calendar/api/events/next)

    case "${sc}" in
        "200") jv_pg_op_done;;
        "404") say "$(jv_pg_op_i18n NO_NEXT_MEETING)";;
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

function jv_pg_op_getContactEmailAddress() {
    local pattern=${1}; [[ ! -z ${2} ]] && pattern="${pattern}+${2}"
    local sc=$(jv_pg_op_curl GET "/contact/api/contacts/search?q=${pattern}")

    case "${sc}" in
        "200") say "$(cat ${jv_pg_op_tmp} | jq '.[] | (.fn + ", " + .emails[].value)')";;
        "204") say "$(jv_pg_op_i18n NO_CONTACT_FOUND)";;
        *) say "${phrase_failed}"
    esac
}

function jv_pg_op_startHublin() {
    chromium-browser --kiosk "${jv_pg_op_hublin}/${jv_pg_op_hublinConference}?displayName=${jv_pg_op_hublinDisplayName}&autostart=true&noAutoInvite=true" &
    jv_pg_op_hublinPid=$!

    say "$(jv_pg_op_i18n STARTING_CONFERENCE)"
}

function jv_pg_op_closeHublin() {
    [[ -z ${jv_pg_op_hublinPid} ]] && say "$(jv_pg_op_i18n NO_CONFERENCE)" || kill ${jv_pg_op_hublinPid} && unset jv_pg_op_hublinPid
}

function jv_pg_op_getUnreadMessagesCount() {
    local sc=$(jv_pg_op_jmap "getMailboxes" "{ \"ids\": [\"${jv_pg_op_inboxId}\"] }")

    case "${sc}" in
        "200") say "$(cat ${jv_pg_op_tmp} | jq '.[0][1].list[0].unreadMessages')";;
        *) say "${phrase_failed}"
    esac
}

function jv_pg_op_done() {
    say "$(jv_pg_op_i18n DONE)"
}

function jv_pg_op_curl() {
	local method=${1}
	local url=${jv_pg_op_url}${2}
	local data=${3}
	local accept=${4}; [[ -z ${accept} ]] && accept=*/*
	local token=${5}; [[ -z ${token} ]] && token=${jv_pg_op_token}

	if [[ -z ${data} ]]
	then
		curl    -sq \
		        -o"${jv_pg_op_tmp}" \
		        -w"%{http_code}" \
		        -H"Authorization: Bearer ${token}" \
		        -H"Accept-Language: ${language:0:2}" \
		        -H"Accept: ${accept}" \
		        -X${method} \
		        ${url}
	else
		curl    -sq \
		        -o"${jv_pg_op_tmp}" \
		        -w"%{http_code}" \
		        -H"Authorization: Bearer ${token}" \
		        -H"Accept-Language: ${language:0:2}" \
		        -H"Accept: ${accept}" \
		        -H"Content-Type: application/json" \
		        -d"${data}" \
		        -X${method} \
		        ${url}
	fi
}

function jv_pg_op_jmap() {
    local command=${1}
    local options=${2}; [[ -z ${options} ]] && options="{}"

    jv_pg_op_curl POST "/jmap" "$(jv_pg_op_jmap_data ${command} "${options}")" "" ${jv_pg_op_jwtToken}
}

function jv_pg_op_jmap_data() {
    local command=${1}
    local options=${2};

cat <<EOF
[
    ["${command}", ${options}, "#0"]
]
EOF
}
