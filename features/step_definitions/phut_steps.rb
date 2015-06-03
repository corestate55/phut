require 'phut'

When(/^I do phut run "(.*?)"$/) do |file_name|
  @config_file = file_name
  run_opts = "-p #{@pid_dir} -l #{@log_dir} -s #{@socket_dir}"
  step %(I run `phut -v run #{run_opts} #{@config_file}`)
end

When(/^I do phut kill "(.*?)"$/) do |name|
  run_opts = "-s #{@socket_dir}"
  step %(I successfully run `phut -v kill #{run_opts} #{name}`)
end

Then(/^a vswitch named "(.*?)" should be running$/) do |name|
  expect(system("sudo ovs-vsctl br-exists br#{name}")).to be_truthy
end

# rubocop:disable LineLength
Then(/^a vswitch named "([^"]*)" \(controller port = (\d+)\) should be running$/) do |name, port_number|
  step %(a vswitch named "#{name}" should be running)
  step %(the output should contain "ovs-vsctl set-controller br#{name} tcp:127.0.0.1:#{port_number}")
end
# rubocop:enable LineLength

Then(/^a vswitch named "(.*?)" should not be running$/) do |name|
  expect(system("sudo ovs-vsctl br-exists br#{name}")).to be_falsey
end

Then(/^a vhost named "(.*?)" launches$/) do |name|
  in_current_dir do
    pid_file = File.join(File.expand_path(@pid_dir), "vhost.#{name}.pid")
    step %(a file named "#{pid_file}" should exist)
  end
end

Then(/^a link is created between "(.*?)" and "(.*?)"$/) do |name_a, name_b|
  in_current_dir do
    link = Phut::Parser.new.parse(@config_file).fetch([name_a, name_b].sort)
    expect(link).to be_up
  end
end
