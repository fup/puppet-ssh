module Puppet::Parser::Functions
  newfunction(:ssh_keygen, :type => :rvalue) do |args|
    request = args[1].to_sym
    config = {
      :ssh_dir      => 'ssl/ssh_keys',
      :ssh_comment  => args[0],
      :ssh_key_type => 'dsa',

    }

    File.directory?('/etc/puppetlabs/puppet') ? config[:basedir] = '/etc/puppetlabs/puppet' : config[:basedir] = '/etc/puppet'

    # Error Handling
    unless args.length > 1 then
      raise Puppet::ParseError, "ssh_keygen(): wrong number of arguments (#{args.length}; must be > 1)"
    end

    unless (request == :public || request == :private) then
      raise Puppet::ParseError, "ssh_keygen(): invalid key type (#{request}; must be 'public' or 'private')"
    end

    # Make sure to write out a directory to init if necessary
    begin
      if !File.directory?("#{config[:basedir]}/#{config[:ssh_dir]}")
        Dir::mkdir("#{config[:basedir]}/#{config[:ssh_dir]}")
      end
    rescue => e
      raise Puppet::ParseError, "ssh_keygen(): Unable to setup ssh keystore directory (#{e})"
    end

    # Do my keys exist? Well, keygen if they don't!
    begin
      unless File.exists?("#{config[:basedir]}/#{config[:ssh_dir]}/#{config[:ssh_comment]}") then
        %x[/usr/bin/ssh-keygen -t #{config[:ssh_key_type]} -P '' -f #{config[:basedir]}/#{config[:ssh_dir]}/#{config[:ssh_comment]}]
      end
    rescue => e
      raise Puppet::ParseError, "ssh_keygen(): Unable to generate ssh key (#{e})"
    end

    # Return content based on request
    begin
      case config[:ssh_key_type]
      when :private
        return File.open("#{config[:basedir]}/#{config[:ssh_dir]}/#{config[:ssh_comment]}").read
      else
        pub_key = File.open("#{config[:basedir]}/#{config[:ssh_dir]}/#{config[:ssh_comment]}.pub").read
        return pub_key.scan(/^.* (.*) .*$/)[0][0]
      end
    rescue => e
      raise Puppet::ParseError, "ssh_keygen(): Unable to read ssh #{config[:ssh_key_type]} key (#{e})"
    end
  end
end
