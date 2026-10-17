#!/usr/bin/env bash
# Read a text file aloud through the Kokoro container.
set -euo pipefail

[[ $# -eq 1 ]] || { echo "usage: $0 <file>" >&2; exit 1; }

config="$(dirname "$0")/config.json"

jq --rawfile input "$1" '{model, voice, speed} + {input: $input, response_format: "pcm", stream: true}' "$config" |
  curl -sSfN -H 'Content-Type: application/json' --data-binary @- "$(jq -r .url "$config")" |
  ffplay -nodisp -autoexit -loglevel error -nostats -f s16le -sample_rate 24000 -ch_layout mono -
