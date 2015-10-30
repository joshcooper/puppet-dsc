require 'erb'
require 'dsc_utils'
test_name 'FM-2623 - C68534 - Apply DSC Resource Manifest via "puppet apply" with Debug Enabled'

confine(:to, :platform => 'windows')

# Init
local_files_root_path = ENV['MANIFESTS'] || 'tests/manifests'

# ERB Manifest
dsc_type = 'file'
dsc_module = 'PSDesiredStateConfiguration'
test_dir_path = 'C:/test'
test_file_path = "#{test_dir_path}/test.txt"
test_file_contents = 'catcat'

dsc_manifest_template_path = File.join(local_files_root_path, 'basic_functionality', 'test_file_path.pp.erb')
dsc_manifest = ERB.new(File.read(dsc_manifest_template_path)).result(binding)

# Verify
debug_msg = /Debug:.*Dsc_file\[tmp_file\]: The container Class\[Main\] will propagate my refresh event/

# Teardown
teardown do
  step 'Remove Test Artifacts'
  set_dsc_resource(
    agents,
    dsc_type,
    dsc_module,
    :Ensure          => 'Absent',
    :Type            => 'Directory',
    :Force           => '$true',
    :DestinationPath => test_dir_path
  )
end

# Tests
agents.each do |agent|
  step 'Apply Manifest'
  on(agent, puppet('apply --debug'), :stdin => dsc_manifest, :acceptable_exit_codes => [0,2]) do |result|
    assert_no_match(/Error:/, result.stderr, 'Unexpected error was detected!')
    assert_match(debug_msg, result.stdout, 'Expected debug message was not detected!')
  end

  step 'Verify that No Changes were Made'
  assert_dsc_resource(
    agent,
    dsc_type,
    dsc_module,
    :DestinationPath => test_file_path,
    :Contents        => test_file_contents
  )
end
