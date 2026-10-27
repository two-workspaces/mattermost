# Railway volumes mount root-owned; Mattermost runs as uid 2000.
set -e
bb=/bin/busybox
$bb chown -R 2000:2000 /mattermost/data

# Seed the system admin once the local-mode socket answers, only while the
# server has no users at all (so a renamed or deleted admin stays that way).
(
  until mmctl --local system status >/dev/null 2>&1; do $bb sleep 2; done
  if mmctl --local user list --all 2>/dev/null | $bb grep -q .; then
    echo "[railway] users exist, admin not seeded"
  elif mmctl --local user create --system-admin --email-verified \
      --email "$MM_ADMIN_EMAIL" --username "$MM_ADMIN_USERNAME" \
      --password "$MM_ADMIN_PASSWORD" >/dev/null; then
    echo "[railway] system admin $MM_ADMIN_USERNAME created"
  fi
) &

exec $bb setuidgid mattermost /mattermost/bin/mattermost
