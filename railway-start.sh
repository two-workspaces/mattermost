# Railway volumes mount root-owned; Mattermost runs as uid 2000.
set -e
bb=/bin/busybox
$bb chown -R 2000:2000 /mattermost/data

# Seed the system admin once the local-mode socket answers. A marker on the
# volume makes it one-shot, so a renamed or deleted admin stays that way.
# (user list can't tell: it already shows the system bots on a fresh server.)
marker=/mattermost/data/.railway-admin-seeded
(
  [ -e $marker ] && exit 0
  until mmctl --local system status >/dev/null 2>&1; do $bb sleep 2; done
  if mmctl --local user create --system-admin --email-verified \
      --email "$MM_ADMIN_EMAIL" --username "$MM_ADMIN_USERNAME" \
      --password "$MM_ADMIN_PASSWORD" >/dev/null; then
    echo "[railway] system admin $MM_ADMIN_USERNAME created"
    $bb touch $marker
  fi
) &

exec $bb setuidgid mattermost /mattermost/bin/mattermost
