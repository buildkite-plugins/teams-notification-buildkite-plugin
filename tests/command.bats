#!/usr/bin/env bats

setup() {
  load "${BATS_PLUGIN_PATH}/load.bash"

  # Stub curl command
  export PATH="$PWD/tests/stubs:$PATH"

  # you can set variables common to all tests here
  export BUILDKITE_PLUGIN_TEAMS_NOTIFICATION_WEBHOOK_URL='https://example.com/webhook'
  export BUILDKITE_PLUGIN_TEAMS_NOTIFICATION_MESSAGE='Test message'
  export BUILDKITE_COMMAND_EXIT_STATUS=0
  export BUILDKITE_PIPELINE_SLUG='example-pipeline'
  export BUILDKITE_BRANCH='main'
  export BUILDKITE_BUILD_NUMBER=1
  export BUILDKITE_BUILD_URL='https://buildkite.com/example-pipeline/builds/1'
}

@test "Missing mandatory option fails" {
  unset BUILDKITE_PLUGIN_TEAMS_NOTIFICATION_WEBHOOK_URL

  run "$PWD"/hooks/pre-exit

  assert_failure
  assert_output --partial 'Missing webhook_url property in the plugin definition'
  refute_output --partial 'Sending notification to MS Teams channel...'
}

@test "Normal basic operations" {
  run "$PWD"/hooks/pre-exit

  assert_success
  assert_output --partial 'Sending notification to MS Teams channel...'
  assert_output --partial '"text": "Test message"'
  assert_output --partial '"text": "Passed example-pipeline (main) #1"'
}

@test "Optional value changes behaviour" {
  export BUILDKITE_PLUGIN_TEAMS_NOTIFICATION_MESSAGE='Another test message'

  run "$PWD"/hooks/pre-exit

  assert_success
  assert_output --partial 'Sending notification to MS Teams channel...'
  assert_output --partial '"text": "Another test message"'
}

@test "Failed build status" {
  export BUILDKITE_COMMAND_EXIT_STATUS=1

  run "$PWD"/hooks/pre-exit

  assert_success
  assert_output --partial 'Sending notification to MS Teams channel...'
  assert_output --partial '"text": "Failed example-pipeline (main) #1"'
}

@test "Missing message fails" {
  unset BUILDKITE_PLUGIN_TEAMS_NOTIFICATION_MESSAGE

  run "$PWD"/hooks/pre-exit

  assert_failure
  assert_output --partial 'Missing message property in the plugin definition'
  refute_output --partial 'Sending notification to MS Teams channel...'
}

@test "Special characters in the message" {
  export BUILDKITE_PLUGIN_TEAMS_NOTIFICATION_MESSAGE='Test message with special characters: !@#$%^&*()'

  run "$PWD"/hooks/pre-exit

  assert_success
  assert_output --partial 'Sending notification to MS Teams channel...'
  assert_output --partial 'Test message with special characters: !@#$%^&*()'
}

@test "Multiple executions" {
  run "$PWD"/hooks/pre-exit

  assert_success
  assert_output --partial 'Sending notification to MS Teams channel...'

  export BUILDKITE_COMMAND_EXIT_STATUS=1
  run "$PWD"/hooks/pre-exit

  assert_success
  assert_output --partial 'Sending notification to MS Teams channel...'
}

@test "Dry run mode validates without sending webhook" {
  export BUILDKITE_PLUGIN_TEAMS_NOTIFICATION_DRY_RUN='true'

  run "$PWD"/hooks/pre-exit

  assert_success
  assert_output --partial 'Dry run mode, validating payload without sending.'
  assert_output --partial 'Validating adaptive card...'
  assert_output --partial 'Validation passed'
  refute_output --partial 'Sending notification to MS Teams channel...'
}

@test "Dry run mode shows payload content" {
  export BUILDKITE_PLUGIN_TEAMS_NOTIFICATION_DRY_RUN='true'

  run "$PWD"/hooks/pre-exit

  assert_success
  assert_output --partial 'Payload:'
  assert_output --partial '"type": "message"'
  assert_output --partial '"contentType": "application/vnd.microsoft.card.adaptive"'
  assert_output --partial '"$schema": "http://adaptivecards.io/schemas/adaptive-card.json"'
}

@test "Dry run with false value sends webhook normally" {
  export BUILDKITE_PLUGIN_TEAMS_NOTIFICATION_DRY_RUN='false'

  run "$PWD"/hooks/pre-exit

  assert_success
  assert_output --partial 'Sending notification to MS Teams channel...'
  refute_output --partial 'Dry run mode enabled'
}
