# -*- coding: utf-8 -*-
require 'phuture'

After('@sudo') do
  in_current_dir do
    Dir.glob("#{Phuture.settings['PID_DIR']}/*.pid").each do |each|
      pid = IO.read(each)
      system "sudo kill #{pid}"
    end
  end
end
