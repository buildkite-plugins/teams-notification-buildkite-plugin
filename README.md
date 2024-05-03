# Teams Notification Buildkite Plugin

A Buildkite plugin for sending incoming webhook notifications setup on specific MS Teams channels.

## Options

These are all the options available to configure this plugin's behaviour.

### Required

#### `webook_url` (string)

The incoming webhook URL configured for a specific channel.

#### `message` (string)

The message to include in the payload sent to the Teams channel

## Examples

Show how your plugin is to be used

```yaml
steps:
  - label: "💭 Sending Teams Notification"
    plugins:
      - teams-notification#0.0.1:
          webhook_url: "<webhook_url>"
          message: "From Buildkite with Love"
```

## And with other options as well

If you want to change the plugin behaviour:

```yaml
steps:
  - label: "💭 Sending Teams Notification"
    plugins:
      - teams-notification#0.0.1:
          webhook_url: "<webhook_url>"
          message: "From Buildkite with Love" 
```

## ⚒ Developing

You can use the [bk cli](https://github.com/buildkite/cli) to run the [pipeline](.buildkite/pipeline.yml) locally:

```bash
bk local run
```

## 👩‍💻 Contributing

Your policy on how to contribute to the plugin!

## 📜 License

The package is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
