{ writeShellScriptBin }: writeShellScriptBin "sshga" ''
  host_gpg_agent_socket="$(gpgconf --list-dirs agent-socket)"
  remote_gpg_agent_socket="$host_gpg_agent_socket"
  exec ssh -R "$remote_gpg_agent_socket:$host_gpg_agent_socket" "$@"
''
