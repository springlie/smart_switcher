# smart_switcher #

Auto-detect proxy switcher in terminal for http, https, ftp, rsync, git protocols. It supports many tools such as wget, yum, portage, brew ...

----------

## Overview ##

A **smart** proxy switcher wrapper, supports **http**, **https**, **ftp**, **rsync**, **ssh**([**connect**](https://bitbucket.org/gotoh/connect/src/) depended), **git**([**connect**](https://bitbucket.org/gotoh/connect/src/) depended) protocols. It can automatically detect your network environment and set proxy for you. It supports multi-proxies.

If you usually switch the network environment (maybe home with no-proxy and workplace with proxy), it may help you a lot.

Tested in [**Zsh**](http://www.zsh.org/) and [**Bash**](http://www.gnu.org/software/bash/).

## Screenshot ##

![screenshot](https://raw.github.com/springlie/smart_switcher/master/screenshot.png)

## Install ##

Simply source it in your .zshrc, or any shell script resource file like this:

`SMART_SWITCHER_DIR=/path/to/smart_switcher; source $SMART_SWITCHER_DIR/smart_switcher.sh`

**and**, make sure set your proxy host/port in `$SMART_SWITCHER_DIR/gateway.ini`.

## Usage ##

Normally, it antomatically executes when you login in.

You can follow `gateway.ini` format and customize your multiple proxies.

Note: the most common proxies should be set first in the value of "gateways"

## What's more ##

#### cecho ####

`smart_switcher` supports [**cecho**](https://github.com/springlie/cecho), who will bring you some colors.

#### connect ####

[**connect**](https://bitbucket.org/gotoh/connect/src/) is required if proxy is supported in **ssh** and **git**. 

ensure proxy be set temply for installation :) 

`export http_proxy={YOUR_PROXY_GATEWARY_IP}:{YOUR_PROXY_GATEWAY_PORT}`

- [**for MAC user only**]

	brew install connect

- [**for general user**]

	download the source, make and install it easily in system path

## TODO ##

- add protocol header before proxy gateway
- add username & password
- add proxy for npm
- add toggle function
