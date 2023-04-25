#!/usr/bin/env bash
# This Bash script can be used to download the twistcli

# If using SaaS, PCC_USER and PCC_PASS will be an access key and secret key.
# Can also set environment variables PCC_USER or PCC_PASS or PCC_URL
# Will leverage env variables  PCC_USER or PCC_PASS or PCC_URL if set.
[[ -z "${PCC_USER}" ]] && PCC_USER="${PC_ACCESS_KEY}" || PCC_USER="${PCC_USER}"
[[ -z "${PCC_PASS}" ]] && PCC_PASS="${PC_SECRET_KEY}" || PCC_PASS="${PCC_PASS}"
[[ -z "${PCC_URL}" ]] && PCC_URL="${CONSOLE_ADDRESS}" || PCC_URL="${PCC_URL}"

json_auth_data="$(printf '{ "username": "%s", "password": "%s" }' "${PCC_USER}" "${PCC_PASS}")"
token=$(curl -sSLk -d "$json_auth_data" -H 'content-type: application/json' "$PCC_URL/api/v1/authenticate" | python3 -c 'import sys, json; print(json.load(sys.stdin)["token"])')

echo "Downloading twistcli ..."
curl --progress-bar -L -k --header "authorization: Bearer $token" "${PCC_URL}/api/v1/util/twistcli" > twistcli; chmod a+x twistcli;
