# smart_switcher #

A auto-detect proxy switcher fot http, https, ftp, rsync, git ...

----------

## Overview ##

A **smart** proxy switcher wrapper, supports http, https, ftp, rsync, git(if installed). It can automatically detect your network environment and set proxy for you.

If you usually switch the network environment (may be home with no-proxy and workplace with proxy), it may help you a lot.

Tested in [zsh](http://www.zsh.org/).

## Screenshot ##

![screenshot](https://raw.github.com/springlie/smart_switcher/master/screenshot.png)

## Install ##

Simply source it in your .zshrc, or any shell script resource file like this:

`source /path/to/smart_switcher.sh`

**and**, make sure set your proxy_server/gateway in `smart_switcher.sh`.

**Specially**, `smart_switcher` supports [cecho](https://github.com/springlie/cecho), who will bring some colors for you.

## Usage ##

Normally, it antomatically executes when you login in.

