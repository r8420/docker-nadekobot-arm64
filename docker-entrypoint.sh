#!/bin/sh
set -e

data_init="/app/data_init"
data="/app/data"

ls $data
cp -R -n $data_init/* "$data"
cp -n "$data_init/creds_example.yml" "$data/creds.yml"
ls $data

echo "Yt-dlp update"
command -v yt-dlp >/dev/null && yt-dlp -U || echo "yt-dlp update skipped"

echo "Running NadekoBot"
exec "$@"