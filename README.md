# smart_switcher #

A auto-detect proxy switcher fot http, https, ftp, rsync, ssh, git protocols.

----------

## Overview ##

A **smart** proxy switcher wrapper, supports **http**, **https**, **ftp**, **rsync**, **ssh**([**connect**](https://bitbucket.org/gotoh/connect/src/) depended), **git**([**connect**](https://bitbucket.org/gotoh/connect/src/) depended) protocols. It can automatically detect your network environment and set proxy for you.

If you usually switch the network environment (maybe home with no-proxy and workplace with proxy), it may help you a lot.

Tested in [**Zsh**](http://www.zsh.org/) and [**Bash**](http://www.gnu.org/software/bash/).

## Screenshot ##

![screenshot](https://raw.github.com/springlie/smart_switcher/master/screenshot.png)

## Install ##

Simply source it in your .zshrc, or any shell script resource file like this:

`source /path/to/smart_switcher.sh`

**and**, make sure set your proxy_server/gateway in `smart_switcher.sh`.

## Usage ##

Normally, it antomatically executes when you login in.

`smart_switcher` supports [**cecho**](https://github.com/springlie/cecho), who will bring you some colors.

[**connect**](https://bitbucket.org/gotoh/connect/src/) is required if proxy is supported in **ssh** and **git**. 

-	[MAC user]

	brew install connect

-	[general]

	download the source, make and install it easily in system path
