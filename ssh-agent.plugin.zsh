# https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/ssh-agent

typeset _agent_forwarding _ssh_env_cache _osx_use_launchd_ssh_agent

function _start_agent() {
    local lifetime
    local -a identities

    # start ssh-agent and setup environment
    zstyle -s :omz:plugins:ssh-agent lifetime lifetime

    ssh-agent -s ${lifetime:+-t} ${lifetime} | sed 's/^echo/#echo/' >! $_ssh_env_cache
    chmod 600 $_ssh_env_cache
    . $_ssh_env_cache > /dev/null

    # load identies
    zstyle -a :omz:plugins:ssh-agent identities identities

    echo starting ssh-agent...
    ssh-add $HOME/.ssh/${^identities}
}

# Get the filename to store/lookup the environment from
_ssh_env_cache="$HOME/.ssh/environment-$SHORT_HOST"

if [[ "$OSTYPE" == "darwin*" ]]; then
    zstyle -b :omz:plugins:ssh-agent osx-use-launchd-ssh-agent _osx_use_launchd_ssh_agent
fi

if [[ "$_osx_use_launchd_ssh_agent" != "yes" ]]; then
    if [[ -f "$_ssh_env_cache" ]]; then
        # Source SSH settings, if applicable
        . $_ssh_env_cache > /dev/null
        ps x | grep ssh-agent | grep -q $SSH_AGENT_PID || {
            _start_agent
        }
    else
        _start_agent
    fi
fi

# test if agent-forwarding is enabled
zstyle -b :omz:plugins:ssh-agent agent-forwarding _agent_forwarding

if [[ $_agent_forwarding == "yes" ]]; then
    # Add a nifty symlink for screen/tmux if agent forwarding
    [[ -L $SSH_AUTH_SOCK ]] || ln -sf "$SSH_AUTH_SOCK" /tmp/ssh-agent-$USER-screen
fi

# tidy up after ourselves
unset _agent_forwarding _ssh_env_cache _osx_use_launchd_ssh_agent
unfunction _start_agent
