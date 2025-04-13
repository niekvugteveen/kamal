class Kamal::Commands::Registry < Kamal::Commands::Base
  def login(registry_config: nil)
    registry_config ||= config.registry
    logline = "Logging in to #{registry_config.server} with #{registry_config.username} and password #{registry_config.password}..."
    puts logline
    SSHKit.config.output.debug(logline)

    echo_password = [ :echo, sensitive(Kamal::Utils.escape_shell_value(registry_config.password)) ]
    docker_login = docker :login,
                          registry_config.server,
                          "-u", sensitive(Kamal::Utils.escape_shell_value(registry_config.username)),
                          "--password-stdin"
  
    pipe echo_password, docker_login
  end

  def logout(registry_config: nil)
    registry_config ||= config.registry

    docker :logout, registry_config.server
  end
end
