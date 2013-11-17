# tmux-cssh-rb

## Requirements

* Ruby 1.9.3 or later
* tmux

## Examples

```
% tssh -h
Usage: tssh [options]
    -l, --login USERNAME
    -c, --config FILE
        --ssh SSH_COMMAND
        --ssh_args SSH_ARGUMENTS
        --debug DEBUG_LEVEL
        --panes_per_window NUM
```

```sh
tssh user@host1 host2 host3
```
