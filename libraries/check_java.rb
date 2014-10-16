module Extensions

  #
  # This plugin is used only once in the default recipe
  # to change the default Java version available.
  # 

  def check_java()

    ruby_block "java_check" do
      block do
	update_java_alternatives = Mixlib::ShellOut.new("update-java-alternatives -s java-1.7.0-openjdk-amd64")
	update_java_alternatives.run_command
      end    

      java_bin = File.readlink("/etc/alternatives/java")
      not_if { File.fnmatch(java_bin, '/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java') }

    end

  end

end
