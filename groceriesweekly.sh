#!/bin/bash

LIST="groceriesweekly.txt"

pause() {
  read -p "Press ENTER to continue..."
}

show_list() {
  clear
  echo "🛒 Grocery List"
  echo "-------------------------"
  cat "$LIST"
  echo
  pause
}

add_item() {
  read -p "Category: " category
  read -p "Item name: " item
  read -p "Quantity (optional, e.g. x2): " qty

  if ! grep -q "^\[$category\]" "$LIST"; then
    echo -e "\n[$category]" >> "$LIST"
  fi

  line="[ ] $item"
  [[ -n "$qty" ]] && line="$line $qty"

  sed -i '' "/^\[$category\]/a\\
$line
" "$LIST"

  echo "✅ Added $item"
  pause
}

mark_bought() {
  read -p "Item name to mark as bought: " item
  sed -i '' "s/^\[ \] $item/\[x\] $item/" "$LIST"
  echo "🛒 Marked '$item' as bought"
  pause
}

reset_week() {
  read -p "Start a new week? (y/n): " answer
  if [[ "$answer" == "y" ]]; then
    sed -i '' 's/^\[x\]/[ ]/g' "$LIST"
    echo "🔄 All items reset"
  fi
  pause
}

menu() {
  while true; do
    clear
    echo "🛒 Grocery Manager"
    echo "-------------------------"
    echo "1) Show grocery list"
    echo "2) Add item"
    echo "3) Mark item as bought"
    echo "4) Reset week"
    echo "5) Exit"
    echo
    read -p "Choose an option: " choice

    case "$choice" in
      1) show_list ;;
      2) add_item ;;
      3) mark_bought ;;
      4) reset_week ;;
      5) exit 0 ;;
      *) echo "Invalid option"; pause ;;
    esac
  done
}

menu
