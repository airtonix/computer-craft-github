# ComputerCraft Github Client

copyright 2013 Zenobius Jiricek

MIT three clause license

Basic github client for computer craft, this seeks to supplant the pastebin functionality in 
computercraft with something more sane.



## Intro

This is my first experiement in creating a distribution and pacaging program for computercraft 
that interacts with gist.github.com.

The idea is to utilise the awesomeness of git and github so that `github install airtonix/cross-mining` 
will install the latest version of that package.

My approach to this is fairly opinionated, being influenced by the pip utility used and loved by 
python programmers.


## Packages

Packages are assumed to follow the format of :

    /package-name
        manifest.json
        main.lua
        /lib
            something.lua
    README
    LICENSE


The only file that is mandatory is manifest.json.


### package.toc

This file describes the gist url, the package name, the version

    name: My Package
    username: airtonix
    reponame: my-package
    release_branch: master
    alias: my-package
    init: main.lua

A toc file can have the following options

* *name* [string]
An human readable package label/name, used when displaying packages in lists

* *username* [string]
your github username. used to contruct part of the url

* *repo* [string]
name of the repo, used construct the url and the name of the command alias.

* *init* [filename]
The lua file which the alias will point at, if not present the alias will point at 
`/gists/package-name/main.lua`


The example above will cause `github install airtonix/my-package` to :
* download the packge to `/tmp/github/my-package`
* move `/tmp/github/my-package` to `/usr/local/my-package/`
* create an alias `/my-package` pointing at `/usr/local/my-package/main.lua`
