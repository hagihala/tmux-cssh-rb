# tmux-cssh-rb

## 必要環境

* Ruby 1.9.3 以上
* tmux

## インストール

### gem コマンド

TODO: RubyGems リポジトリに上げる

GitHub リポジトリから直接インストールする場合は以下を実行してください。

```sh
gem install specific_install
gem specific_install https://github.com/yshh/tmux-cssh-rb.git
```

### ビルド・インストール

```sh
git clone https://github.com/yshh/tmux-cssh-rb.git path/to/tmux-cssh-rb
cd path/to/tmux-cssh-rb
gem build tmux-cssh.gemspec
gem install tmux-cssh-*.gem
```

### Bundler を使う

Gemfile に以下を１行追加してください。

```ruby
gem 'tmux-cssh', git: 'https://github.com/yshh/tmux-cssh-rb.git'
```

## 使い方

`tssh` は tmux セッションの外で実行する必要があります。
tmux セッション内での実行は現状サポート(?)外です。

```sh
tssh user@host1 host2 host3
```

`-h` オプションをつけて実行するとヘルプが表示されます。

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

### Sync モード

ひとつの pane にタイプした文字は、window 内の全ての pane にコピーされます。
これは tmux の機能を使っており、
tmux コマンド `set-window-option synchronize-panes` で無効化できます。
この tmux コマンドにショートカットキーを割り当てると便利です。

例えば以下の tmux コマンドを ~/.tmux.conf に追加する:

```
bind-key g setw synchronize-panes
```

詳細については tmux のマニュアルを参照してください。

### 終了方法

pane は ssh セッションの終了後に自動的には終了しません
(tmux の `set-window-option remain-on-exit` を設定しています)。
認証えらーなどでセッションが意図せずエラー終了した際、エラーメッセージが
消えてしまうのを防ぐためです。

pane は以下の tmux コマンドで閉じることができます。

* `kill-pane` (選択中の pane を閉じる; デフォルト: `C-b x`)
* `kill-window` (window 上の全ての pane を閉じる; デフォルト: `C-b &`)

## OS の制限

たくさんの tmux pane を開くと、OS の各種上限に当たります。

* pty 数
* max open files

TODO: 回避方法

## 既知の問題

XXX

