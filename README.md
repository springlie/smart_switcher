# smart_switcher #

Auto-detect proxy switcher in terminal. It supports many protocols and tools.

----------

## Overview ##

A **smart** proxy switcher wrapper, supports **http**, **https**, **ftp**, **rsync**, **ssh**([**connect**](https://bitbucket.org/gotoh/connect/src/) depended), **git**([**connect**](https://bitbucket.org/gotoh/connect/src/) depended) protocols.

It can **automatically** detect your network environment (in preset set) and fit proxy for you.

It supports **multi-proxies**.

If you usually switch the network environment (maybe home with no-proxy, workplace1 with proxy1, workplace2 with proxy2), it may help you a lot.

Tested in [**Zsh**](http://www.zsh.org/) and [**Bash**](http://www.gnu.org/software/bash/) on Linux and Mac.

![screenshot](https://raw.github.com/springlie/smart_switcher/master/screenshot.png)

### Protocols supported ###

- [x] http

- [x] https

- [x] ftp

- [x] rsync

- [x] ssh

- [x] git

### Tools supported ###

- [x] wget

- [x] ftp

- [x] rsync

- [x] yum

- [x] brew

- [x] emerge

- [x] npm

- [x] pip

- [x] gopkg

- [x] git

- [x] hg

- [ ] svn

- [ ] ~~cvs~~

## Installation ##

- Download script (temply set your https proxy if necessary for installation)

> export https_proxy={YOUR_PROXY_GATEWARY_IP}:{YOUR_PROXY_GATEWAY_PORT}
>
> git clone https://github.com/springlie/smart_switcher.git /path/to/smart_switcher

- Set proxies host/port in `$SMART_SWITCHER_DIR/gateway.ini`.

	[optional] Follow `gateway.ini` format and customize your multiple proxies.

	[optional] Note: the most common proxies should be set first in the value of "gateways"

- Source it in your `.zshrc` (or any shell script resource file like `.bashrc`):

> export SMART_SWITCHER_DIR=/path/to/smart_switcher; source $SMART_SWITCHER_DIR/smart_switcher.sh

## Usage ##

Execute antomatically when user login.

Use command `sm_toggle` to toggle proxy status when you want.

## What's more ##

#### cecho ####

`smart_switcher` supports [**cecho**](https://github.com/springlie/cecho), who will bring you some colors.

#### connect ####

[**connect**](https://bitbucket.org/gotoh/connect/src/) is required to support **ssh** and **git** protocols. 

Ensure proxy be set temply for installation ... 

> export http_proxy={YOUR_PROXY_GATEWARY_IP}:{YOUR_PROXY_GATEWAY_PORT}

- [**for Mac**]

> brew install connect

- [**for Gentoo**]

> emerge net-misc/connect

- [**for other**]

	download the [source](https://bitbucket.org/gotoh/connect/src/), make and install it easily in system path

## Known issues

1. When $SHLVL > 1 (means in multi-layers sub-shell), the proxy setting is invalid

2. ssh can't distinguishes the destination sites before or behind proxy gateway

## TODO ##

- [x] add protocol header before proxy gateway
- [x] add username & password
- [x] add proxy for npm
- [x] add toggle function
- [ ] specified ssh rule for sites
- [ ] add proxy for svn
- [ ] add automatical setup for **connect** package

