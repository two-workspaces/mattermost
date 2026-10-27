# Deploy and Host Mattermost on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/mattermost-team?referralCode=sLjDXb&utm_medium=integration&utm_source=button&utm_campaign=mattermost-team)

[Mattermost](https://mattermost.com/) is an open-source team chat platform, the self-hosted alternative to Slack. Teams get channels, threads, direct messages, file sharing, search, integrations, bots and webhooks, with desktop and mobile apps. This template runs Mattermost Team Edition 12.0.1 from the official image on its own Postgres 17. It creates the system admin on first boot and keeps public sign-up closed.

## About Hosting Mattermost

The stack is two services: Mattermost and Postgres.

- **Upstream's image, pinned.** Mattermost runs the official `mattermost/mattermost-team-edition` image at a fixed release (12.0.1), not `latest`. A thin wrapper ([source](https://github.com/two-workspaces/mattermost)) adds one start script, nothing else.
- **System admin on first boot.** The admin is created through Mattermost's own `mmctl` from `MM_ADMIN_EMAIL`, `MM_ADMIN_USERNAME` and the generated `MM_ADMIN_PASSWORD`. Nobody can claim the server by signing up first, and open sign-up stays off: new people join through invite links.
- **Settings that stick.** Mattermost keeps its configuration in Postgres instead of a file in the container, so changes you make in the System Console survive redeploys.
- **Files on a volume.** Uploads, images and plugins are stored on a volume at `/mattermost/data`.
- **Real-time over WebSockets.** Messages, typing indicators and notifications stream live over your Railway domain.
- **Footprint.** Mattermost idles at about 530 MB of RAM and Postgres at about 80 MB, so use the Hobby plan or higher.

## Common Use Cases

- Replacing Slack or Microsoft Teams with team chat you host yourself and no per-seat pricing
- Engineering and DevOps chat with GitHub, GitLab, Jira and CI notifications through webhooks and plugins
- Chat for regulated or privacy-sensitive teams that must keep messages on their own infrastructure
- A community or customer workspace with public and private channels

## Dependencies for Mattermost Hosting

- Postgres 17 (included, private network only)

### Deployment Dependencies

- [Mattermost documentation](https://docs.mattermost.com/)
- [Configuration settings and environment variables](https://docs.mattermost.com/configure/configuration-settings.html)
- [Mattermost on GitHub](https://github.com/mattermost/mattermost)
- [Template source on GitHub](https://github.com/two-workspaces/mattermost)

### Implementation Details

**Sign in.** When the deploy is green, open your Mattermost domain and sign in as `sysadmin` (or the `MM_ADMIN_USERNAME` you chose) with the password in the Mattermost service's `MM_ADMIN_PASSWORD` variable. The admin is created once; change the password in Mattermost afterwards (Profile, Security). Then create your first team.

**Inviting people.** From the team menu choose Invite People and copy the invite link. Email invitations, password resets and notification emails need SMTP. Railway only allows outbound SMTP on the Pro plan; there, add your provider in System Console, Environment, SMTP.

**Mobile and desktop apps.** Point the Mattermost apps at your Railway domain. Push notifications to phones need a push proxy: enable Mattermost's hosted push notification service in System Console, Environment, Push Notification Server.

**Calls.** The Calls plugin streams voice and video over its own RTC port (8443), which this template doesn't expose, so calls are not set up. Text chat, threads, files and integrations work fully.

**Custom domains.** Add the domain to the Mattermost service in Railway, then set `MM_SERVICESETTINGS_SITEURL` to `https://your.domain` and redeploy. Settings set through environment variables (Site URL and the database) are locked in the System Console.

**Upgrading.** Bump the version in the Dockerfile of your fork and redeploy. Mattermost migrates its database on start, so back up Postgres before a major version.

**Back up.** Messages, users and settings are in Postgres; files are on the Mattermost volume. Use Railway's volume backups or `pg_dump`.

## Why Deploy Mattermost on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Mattermost on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
