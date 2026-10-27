# Official distroless Mattermost image plus a static busybox, so the first
# boot can fix volume ownership and seed the system admin through mmctl.
FROM busybox:1.37.0-musl AS busybox
FROM mattermost/mattermost-team-edition:12.0.1
COPY --from=busybox /bin/busybox /bin/busybox
COPY --chmod=555 railway-start.sh /railway-start.sh
USER root
ENTRYPOINT ["/bin/busybox", "sh", "/railway-start.sh"]
