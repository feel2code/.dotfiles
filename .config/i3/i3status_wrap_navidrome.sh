. "$HOME/.config/i3/navidrome.env"

now_playing() {
  RESULT=$(curl -s --max-time 3 "$NAVIDROME_API/getNowPlaying.view?u=$NAVIDROME_USER&p=$NAVIDROME_PASS&v=1.16.1&c=i3status&f=json" | \
      jq -r '.["subsonic-response"].nowPlaying.entry[0] | select(.state=="playing") | "\(.artist) - \(.title)"' 2>/dev/null)

  if [ -z "$RESULT" ]; then
      echo " "
  else
      echo "$RESULT"
  fi
}

i3status | while :; do
  read -r line
  case $line in
      '{'*|'[')
          echo "$line"
          continue
          ;;
  esac

  NOWPLAYING=$(now_playing)

  prefix="${line#,}"
  if [ "$prefix" != "$line" ]; then comma=","; else comma=""; fi

  NEWLINE=$(echo "$prefix" | jq -c --arg text "$NOWPLAYING" \
      '[{"name":"navidrome","full_text":$text}] + .')

  echo "$comma$NEWLINE"
done
