# tmux-cssh-rb

## Requirements

* Ruby 1.9.3 or later
* tmux

## How to use

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

`tssh` should be executed outside of tmux session.

```sh
tssh user@host1 host2 host3
```

### Sync mode

When you type to pane, key strokes are copied to all panes in the window.
Use tmux command `set-window-option synchronize-panes` to disable this mode.

You may want to bind a shortcut key to this command (add the line below to your ~/.tmux.conf)

```
bind-key g setw synchronize-panes
```

### How to exit

Panes do not close after the ssh sessions terminate
(using `set remain-on-exit`) so that you can see error messages in the case
ssh session terminated unexpectedly by errors such as connection error and
authentication failure.

You can close dead panes with tmux commands:

* `kill-pane` (closes selected pane; bound to `C-b x` by default) or
* `kill-window` (closes all panes in current window; bound to `C-b &` by default)

## Known issues

XXX
