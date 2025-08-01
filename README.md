# Teams Notification Buildkite Plugin [![Build status](https://badge.buildkite.com/519c16632496b3610d4691c7c75db6e679911ef5f666ce8f6a.svg)](https://buildkite.com/buildkite/plugins-ms-teams-notification)

A Buildkite plugin for sending incoming webhook notifications setup on specific MS Teams channels.

## Options

These are all the options available to configure this plugin's behaviour.

### Required

#### `webhook_url` (string)

The incoming webhook URL configured for a specific channel.

#### `message` (string)

The message to include in the payload sent to the Teams channel

### Optional

#### `dry_run` (boolean)

When set to `true`, validates the adaptive card payload against the Teams schema without sending the webhook. Useful for testing and debugging. Default: `false`

## Examples

Sending a webhook:

```yaml
steps:
  - label: "💭 Sending Teams Notification"
    plugins:
      - teams-notification#1.0.0:
          webhook_url: "<webhook_url>"
          message: "From Buildkite with Love"
```

## Testing with dry run

To validate your notification payload without sending it:

```yaml
steps:
  - label: "💭 Testing Teams Notification"
    plugins:
      - teams-notification#1.0.0:
          webhook_url: "<webhook_url>"
          message: "From Buildkite with Love"
          dry_run: true
```

## ⚒ Developing

You can use the [bk cli](https://github.com/buildkite/cli) to run the [pipeline](.buildkite/pipeline.yml) locally:

```bash
bk local run
```

## 🧪 Testing

### Unit tests

The unit tests are written using BATS. You can test locally with:

```bash
make test
```

Or using Docker Compose:

```bash
docker-compose -f docker-compose.yml run --rm tests
```

## 👩‍💻 Contributing

Your policy on how to contribute to the plugin!

## 📜 License

The package is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
