#!/bin/bash

# lower case please
classes=(
  'alacritty',
  'urxvt'
  )

while read -r line; do
  if [[ "$xprop_id" != "" ]]; then
    sub_process=$(ps -ax | grep -e ":[0-9]\{2\} xprop.*${xprop_id}" | awk -F' ' '{print $1}')
    [[ "$sub_process" ]] && kill -9 $sub_process
  fi

  xprop_id=$(echo $line | cut -d ' ' -f 5)
  xprop_info=$(echo "$xprop_id" | cut -d ' ' -f 5 | xargs -I {} xprop -id {})
  wm_class=$(echo "$xprop_info" | grep "WM_CLASS" | awk -F'[ ",]' '{print $4}' | tr 'A-Z' 'a-z')
  [[ ${classes[*]} =~ "$wm_class" ]] || continue

  {
    while read -r line; do
      [[ $line != WM_NAME* ]] && continue
      term_path=$(echo "$line" | awk -F'"' '{print $2}' | awk -F' ' '{$1=""; print}')
      if [[ "${last_term_path}" != "${term_path}" ]]; then
        echo update last_term_path to $term_path
        echo $term_path > "${XDG_RUNTIME_DIR}/last_term_path.txt"
        last_term_path=${term_path}
      fi
    done < <(xprop -spy -id ${xprop_id})
  } &

done < <(xprop -spy -root _NET_ACTIVE_WINDOW)

