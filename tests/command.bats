#!/usr/bin/env bats

setup() {
  load "${BATS_PLUGIN_PATH}/load.bash"

  # Uncomment to enable stub debugging
  # export CURL_STUB_DEBUG=/dev/tty

  # you can set variables common to all tests here
  export BUILDKITE_PLUGIN_TEAMS_NOTIFICATION_WEBHOOK_URL='Value'
  export BUILDKITE_PLUGIN_TEAMS_NOTIFICATION_MESSAGE='Value'
}

@test "Missing mandatory option fails" {
  unset BUILDKITE_PLUGIN_TEAMS_NOTIFICATION_WEBHOOK_URL
  unset BUILDKITE_PLUGIN_TEAMS_NOTIFICATION_MESSAGE

  run "$PWD"/hooks/pre-exit

  assert_failure
  assert_output --partial 'Missing mandatory option'
  refute_output --partial 'Running plugin'
}

@test "Normal basic operations" {

  run "$PWD"/hooks/pre-exit

  assert_success
  assert_output --partial 'Running plugin with options'
  assert_output --partial '- mandatory: Value'
}

@test "Optional value changes behaviour" {
  export BUILDKITE_PLUGIN_YOUR_PLUGIN_NAME_OPTIONAL='other value'

  run "$PWD"/hooks/pre-exit

  assert_success
  assert_output --partial 'Running plugin with options'
  assert_output --partial '- optional: other value'
}