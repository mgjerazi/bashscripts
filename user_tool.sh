#!/bin/bash
set -euo pipefail

# ----------------------------
# Sample JSON data (users.json)
# ----------------------------
JSON_FILE="/tmp/users.json"
cat > "$JSON_FILE" <<'EOF'
[
  {"name": "Alice", "age": 25, "role": "admin"},
  {"name": "Bob", "age": 30, "role": "user"},
  {"name": "Charlie", "age": 22, "role": "user"}
]
EOF

echo "JSON file created at $JSON_FILE"
echo

# ----------------------------
# jq: List all user names
# ----------------------------
echo "All users from JSON:"
jq -r '.[].name' "$JSON_FILE"
echo

# ----------------------------
# awk: Show all system users
# ----------------------------
echo "All real users from /etc/passwd:"
awk -F: '$0 !~ /^#/ {print $1, $3, $6}' /etc/passwd
echo

# ----------------------------
# grep: Check for failed login attempts
# ----------------------------
# We'll simulate a small log file
LOG_FILE="/tmp/auth.log"
cat > "$LOG_FILE" <<'EOF'
Jan 1 10:00 Failed password for root
Jan 1 10:05 Accepted password for alice
Jan 1 10:10 Failed password for bob
EOF

echo "Failed login attempts:"
grep "Failed password" "$LOG_FILE"
echo

# ----------------------------
# sed: Clean log lines and make them uppercase (only the username)
# ----------------------------
echo "Failed login usernames (uppercase):"
grep "Failed password" "$LOG_FILE" | sed -E 's/.Failed password for (.)/\U\1/'
echo

# ----------------------------
# Combined example: greet JSON users that exist on system
# ----------------------------
echo "Greetings for users in JSON and on system:"
jq -r '.[].name' "$JSON_FILE" | while read -r json_user; do
    if awk -F: -v user="$json_user" '$1 == user {print $1}' /etc/passwd >/dev/null; then
        echo "Hello $json_user! You exist on this system."
    else
        echo "Hello $json_user! You are not a system user."
    fi
done