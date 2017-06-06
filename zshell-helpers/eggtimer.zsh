function countdown(){
  if [ -z $1 ]; then
    echo "Fuzzy Wuzzy wuz a bear, but now he's a sad \
bear because you didn't tell him how long to wait. 🐻"
    return 1
  fi

  if [ -z $2 ]; then
    _TIME_UNIT="minutes"
  else
    _TIME_UNIT="$2"
  fi

  if [ -z $3 ]; then
    _MESSAGE="Whee, break time!"
  else
    _MESSAGE="$3"
  fi

  # Variable SCOPEZ!
  _MULTIPLIER=
  case $_TIME_UNIT in
    "hours"|"hour") _MULTIPLIER=3600;;
    "minutes"|"minute") _MULTIPLIER=60;;
    "seconds"|"second") _MULTIPLIER=1;;
    *) echo "Invalid Unit, assuming you meant minutes" && _MULTIPLIER=60;;
  esac

  _TIME_FROM_NOW=$(($1 * $_MULTIPLIER))

  (
    # trap "" HUP
    _DATE=$((`date +%s` + $_TIME_FROM_NOW));
    while [ "$_DATE" -ge `date +%s` ]; do 
      sleep 1
    done

    osascript -e 'on run {message}' \
              -e 'display notification message as text with title "Countdown Finished" sound name "Submarine"' \
              -e 'end run' $_MESSAGE
   ) &!

  echo "Counting down for $1 $_TIME_UNIT"

  return 0
}