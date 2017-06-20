#!/bin/bash

jv_pg_op_i18n() {
    case "${1}" in
        NEXT_MEETING) echo "Votre prochain rendez-vous";;
        NO_NEXT_MEETING) echo "Vous n'avez pas de prochain rendez-vous.";;
        NO_CONTACT_FOUND) echo "Je ne trouve personne de ce nom.";;
        STARTING_CONFERENCE) echo "Démarrage de la conference...";;
        NO_CONFERENCE) echo "Aucune conference en cours.";;
        DONE) echo "C'est fait.";;
    esac
}
