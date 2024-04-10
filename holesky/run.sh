#!/bin/sh

optIn() {

}

optOut() {

}

if [ "$1" = "opt-in" ]; then
  optIn
elif [ "$1" = "opt-out" ]; then
  optOut
else
  echo "Invalid command"
fi