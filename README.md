# zsh-ssh-agent

This is a copy of the [ssh-agent][1] plugin from [oh-my-zsh][2], packaged as a zsh plugin to be used with your favorite zsh plugin manager.

[1]: https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/ssh-agent
[2]: https://github.com/robbyrussell/oh-my-zsh
[3]: http://zsh.sourceforge.net/

## Requirements

* [ZSH][3] >= 4.3.0

## Install

### antigen

    antigen bundle twang817/zsh-ssh-agent

### zgen

    zgen load twang817/zsh-ssh-agent
    
### antibody


    antibody bundle twang817/zsh-ssh-agent
    
## Usage

This plugin starts automatically `ssh-agent` to set up and load whichever credentials you want for ssh connections.

To enable **agent forwarding support** add the following to your zshrc file:

```
zstyle :omz:plugins:ssh-agent agent-forwarding on
```

To **load multiple identities** use the `identities` style, For example:

```
zstyle :omz:plugins:ssh-agent identities id_rsa id_rsa2 id_github
```

To **set the maximum lifetime of the identities**, use the `lifetime` style.  The lifetime may be specified in seconds or as described in sshd_config(5) (see _TIME FORMATS_). If left unspecified, the default lifetime is forever.

### NOTE:

The upstream version of this plugin from [oh-my-zsh][1] will use the ssh-agent lazily loaded by launchd.  This causes us to ignore any configured `identities`.

This plugin has been modified to always launch a separate instance of ssh-agent which will correctly load all configured `identities`.  If you wish to use the ssh-agent loaded by launchd, you may set the `osx-use-launchd-ssh-agent` style:

```
zstyle :omz:plugins:ssh-agent osx-use-launchd-ssh-agent yes
```

To load your keys, you may add them to the keychain manually via:

```
ssh-add -K <identity>
```

Once in your keychain, this *should* persist across reboots (untested).

## Credits

Based on code from Joseph M. Reagle: http://www.cygwin.com/ml/cygwin/2001-06/msg00537.html

Agent-forwarding support based on ideas from Florent Thoumie and Jonas Pfenniger
