#!/bin/bash

JSON="groceries.json"

pause() {
  read -p "Press ENTER to continue..."
}

# -------- show grocery list --------
show_list() {
  clear
  echo "🛒 Grocery List"
  echo "-------------------------"

  jq -r '
    to_entries[] |
    "[" + .key + "]",
    (.value[] | if .bought == true then "[x] " else "[ ] " end + .name + " (x" + (.qty|tostring) + ")")
  ' "$JSON"

  echo
  pause
}

# -------- add item --------
add_item() {
  echo "Select category"
  echo "----------------"

  categories=()
  i=1
  while IFS= read -r cat; do
    categories+=("$cat")
    echo "$i) $cat"
    i=$((i+1))
  done < <(jq -r 'keys[]' "$JSON")

  echo
  read -p "Choice: " choice
  category="${categories[$((choice-1))]}"
  [[ -z "$category" ]] && echo "❌ Invalid category" && pause && return

  read -p "Item name: " item
  [[ -z "$item" ]] && echo "❌ Item name required" && pause && return

  read -p "Quantity (default 1): " qty
  [[ -z "$qty" ]] && qty=1
  if ! [[ "$qty" =~ ^[0-9]+$ ]]; then
    echo "❌ Quantity must be a number"
    pause
    return
  fi

  tmp=$(mktemp)
  jq ".\"$category\" += [{\"name\":\"$item\",\"qty\":$qty,\"bought\":false}]" "$JSON" > "$tmp" && mv "$tmp" "$JSON"

  echo "✅ Added '$item' (x$qty) to $category"
  pause
}

# -------- remove item --------
remove_item() {
  echo "Select category"
  echo "----------------"

  categories=()
  i=1
  while IFS= read -r cat; do
    categories+=("$cat")
    echo "$i) $cat"
    i=$((i+1))
  done < <(jq -r 'keys[]' "$JSON")

  echo
  read -p "Choice: " choice
  category="${categories[$((choice-1))]}"
  [[ -z "$category" ]] && echo "❌ Invalid category" && pause && return

  echo
  echo "Items in $category:"
  jq -r ".\"$category\"[] | \"- \(.name) (x\(.qty)) [bought: \(.bought)]\"" "$JSON"

  read -p "Item name to remove: " item
  [[ -z "$item" ]] && echo "❌ Item name required" && pause && return

  tmp=$(mktemp)
  jq ".\"$category\" |= map(select(.name != \"$item\"))" "$JSON" > "$tmp" && mv "$tmp" "$JSON"

  echo "🗑 Removed '$item' from $category"
  pause
}

# -------- mark item as bought --------
mark_bought() {
  echo "Select category"
  echo "----------------"

  categories=()
  i=1
  while IFS= read -r cat; do
    categories+=("$cat")
    echo "$i) $cat"
    i=$((i+1))
  done < <(jq -r 'keys[]' "$JSON")

  echo
  read -p "Choice: " choice
  category="${categories[$((choice-1))]}"
  [[ -z "$category" ]] && echo "❌ Invalid category" && pause && return

  echo
  echo "Items in $category:"
  jq -r ".\"$category\"[] | \"- \(.name) (x\(.qty)) [bought: \(.bought)]\"" "$JSON"

  read -p "Item name to mark as bought: " item
  [[ -z "$item" ]] && echo "❌ Item name required" && pause && return

  tmp=$(mktemp)
  jq ".\"$category\" |= map(if .name == \"$item\" then .bought = true else . end)" "$JSON" > "$tmp" && mv "$tmp" "$JSON"

  echo "🛒 Marked '$item' as bought"
  pause
}

# -------- reset week --------
reset_week() {
  tmp=$(mktemp)
  jq 'map_values(map(.bought = false))' "$JSON" > "$tmp" && mv "$tmp" "$JSON"
  echo "🔄 All items reset to not bought"
  pause
}

# -------- main menu --------
menu() {
  while true; do
    clear
    echo "🛒 Grocery Manager (JSON only)"
    echo "-------------------------"
    echo "1) Show grocery list"
    echo "2) Add item"
    echo "3) Remove item"
    echo "4) Mark item as bought"
    echo "5) Reset week"
    echo "6) Exit"
    echo

    read -p "Choose an option: " choice

    case "$choice" in
      1) show_list ;;
      2) add_item ;;
      3) remove_item ;;
      4) mark_bought ;;
      5) reset_week ;;
      6) exit 0 ;;
      *) echo "Invalid option"; pause ;;
    esac
  done
}

menu
