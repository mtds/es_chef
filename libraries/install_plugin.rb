module Extensions

  # Derived with just slightly modifications from: 
  # https://github.com/elasticsearch/cookbook-elasticsearch/blob/master/libraries/install_plugin.rb
	
  # Install an Elasticsearch plugin
  #
  # In the simplest form, just pass a plugin name in the GitHub <user>/<repo> format:
  #
  #     install_plugin 'karmi/elasticsearch-paramedic'
  #
  # You may also optionally pass a version:
  #
  #     install_plugin 'elasticsearch/elasticsearch-mapper-attachments', 'version' => '1.6.0'
  #
  # ... as well as the URL:
  #
  #     install_plugin 'hunspell', 'url' => 'https://github.com/downloads/.../elasticsearch-analysis-hunspell-1.1.1.zip'
  #
  # The "elasticsearch::plugins" recipe will install all plugins listed in
  # the role/node attributes.
  #
  # Example:
  #
  #     { elasticsearch: {
  #         plugins: {
  #           'karmi/elasticsearch-paramedic' => {},
  #           'lukas-vlcek/bigdesk'           => { 'version' => '1.0.0' },
  #           'hunspell'                      => { 'url' => 'https://github.com/downloads/...' }
  #         }
  #       }
  #     }
  #
  #
  def install_plugin name, params={}

    ruby_block "Install plugin: #{name}" do
      block do
        version = params['version'] ? "/#{params['version']}" : nil
        url     = params['url']     ? " -url #{params['url']}" : nil

	# When working with a host with two version of OpenJDK installed (6 and 7)
	# you must specify which version you want use before calling the plugin
	# script. 
	# The OpenJDK version 7 works correctly while the version 6 raise 
	# an 'java.lang.UnsupportedClassVersionError'.
	ENV['JAVA_HOME'] = "/usr/lib/jvm/java-7-openjdk-amd64"

        plugin_install = "/usr/share/elasticsearch/bin/plugin -DproxyHost=proxy.gsi.de -DproxyPort=3128 -install #{name}#{version}#{url} --timeout 1m"
        Chef::Log.debug plugin_install

        raise "[!] Failed to install plugin" unless system plugin_install

      end

      #notifies :restart, 'service[elasticsearch]'

      not_if do
        Dir.entries("/usr/share/elasticsearch/plugins/").any? do |plugin|
          next if plugin =~ /^\./
          name.include? plugin
        end rescue false
      end

    end

    end

  end
