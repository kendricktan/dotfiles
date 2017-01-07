#!/bin/bash

eval $(ssh-agent -s)
export $(gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
export SSH_AGENT_PID=${GNOME_KEYRING_PID:-gnome}
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK
