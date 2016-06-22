# pschmid/docker-errbot-saltslack

- [Introduction](#introduction)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
    - [Bot Runtime Config](#bot-runtime-config)
- [Persistence](#persistence)
- [Use your own config file](#use-your-own-config-file)
- [Run Err with extra arguments](#run-err-with-extra-arguments)
    - [Alternative config file](#alternative-config-file)
    - [Run with text debug backend](#run-with-text-debug-backend)
- [Exposed Ports](#exposed-ports)
- [Credit](#credit)

# Introduction

Dockerfile to build an [Errbot](http://errbot.io) (the pluggable chatbot) container image.
Currently based on python:3.5.1 container.

# Quick Start

Sample configuration for Slack:
```
sudo docker run -d \
    --name errbot \
    -e BACKEND=Slack \
    -e BOT_USERNAME=@YOUR_SLACK_BOT_NAME \
    -e BOT_TOKEN=YOUR_SLACK_BOT_TOKEN \
    -e BOT_ADMINS=@SLACK_USER_ADMIN1,@SLACK_USER_ADMIN2 \
    pschmid/docker-errbot-saltslack
```

# Configuration

## Bot Runtime Config

Below is the complete list of available options that can be used to customize your Err bot. See [config-template.py](https://raw.githubusercontent.com/gbin/err/master/errbot/config-template.py) for complete settings documentation.

- **BACKEND**: Chat server type. (XMPP, Text, HipChat, Slack, IRC). Defaults to `XMPP`.
- **BOT_LOG_LEVEL**: Change log level. Defaults to `INFO`.
- **BOT_USERNAME**: The UID for the bot user.
- **BOT_PASSWORD**: The corresponding password for the user.
- **BOT_TOKEN**: Token for HipChat and Slack backend.
- **BOT_SERVER**: Server address for XMPP and HipChat.
- **BOT_PORT**: Server port.
- **BOT_SSL**: Use SSL for IRC backend. Default to `False`.
- **BOT_ENDPOINT**: HipChat endpoint for hosted HipChat.
- **BOT_NICKNAME**: Nickname for IRC backend.
- **BOT_ADMINS**: Bot admins separated with comma. Defaults to `admin@localhost`.
- **CHATROOM_PRESENCE**: Chatrooms your bot should join on startup.
- **CHATROOM_FN**: The FullName, or nickname, your bot should use. Defaults to `Err`.
- **XMPP_CA_CERT_FILE**: Path to a file containing certificate authorities. Default to `None`.
- **BOT_PREFIX**: Command prefix for the bot. Default to `!`.
- **BOT_PREFIX_OPTIONAL_ON_CHAT**: Optional prefix for normal chat. Default to `False`.
- **BOT_ALT_PREFIXES**: Alternative prefixes.
- **BOT_ALT_PREFIX_SEPARATORS**: Alternative prefixes separators.
- **BOT_ALT_PREFIX_CASEINSENSITIVE**:  Require correct capitalization. Defaults to `False`.
- **HIDE_RESTRICTED_COMMANDS**: Hide the restricted commands from the help output. Defaults to `False`.
- **HIDE_RESTRICTED_ACCESS**: Do not reply error message. Defaults to `False`.
- **DIVERT_TO_PRIVATE**: Private commands.
- **MESSAGE_SIZE_LIMIT**: Maximum length a single message may be. Defaults to `10000`.

# Persistence

For storage of the application data, you should mount a volume at

* `/srv`

Create the directories for the volume

```bash
mkdir /tmp/errbot /tmp/errbot/ssl /tmp/errbot/data /tmp/errbot/plugins
chmod -R 777 /tmp/errbot
```

# Use your own config file

```bash
curl -sL https://raw.githubusercontent.com/gbin/err/master/errbot/config-template.py -o /tmp/errbot/config.py
```

# Run Err with extra arguments

If you pass arguments to Errbot you have to set the `-c /srv/config.py` argument by your self to run with the default config.

## Alternative config file

```bash
docker run -it -v /tmp/errbot:/srv pschmid/docker-errbot-saltslack -c /srv/production.py
```

## Run with text debug backend

```bash
docker run -it -v /tmp/errbot:/srv pschmid/docker-errbot-saltslack -c /srv/config.py -T
```

# Exposed Ports

* 3142 (Webserver if configured)

# Credit
Thanks to rroemhild for his docker container which was used as basement for this one.
