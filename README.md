# Hatch
_A ComputerCraft Package Manager_

copyright 2013 Zenobius Jiricek

MIT three clause license

Basic package manager for computer craft, seeks to mimic the absolute
basics of aptitude for linux.

## Intro

This is my first experiement in creating a distribution and packaging 
program for ... well anything really.

My initial idea was to utilise the awesomeness of git and github so 
that `hatch install cross-mining` will install the latest version of 
that package. Currenty `hatch` will work with any http server that 
serves files without requiring authentication.

My approach to this is fairly opinionated, being influenced by the 
linux package mananger `apt-get`.

Hatch works with a local package index, a local sources.list of remote 
repos and expects the remote repo to maintain a package index.


## Packages

At the moment, I have a very simple view on how computer-craft applications 
should be packaged.

Basically one directory per application, with some metadata about the 
application describing the name, purpose, author, contributor, homepage, 
license, dependancies as package names.


I've yet to decide how to store the metadata, perhaps it'll be a simple 
`manifest.lua` containing a table in the root of the application directory.


## Commands

For now, Hatch supports a very simple set of commands.

```
> hatch
```
or
```
> hatch help
Hatch x.x.x
  help     : This list.
  update   : Update package index.
  install  : Install package(s).
  upgrade  : Upgrade all packages.
  remove   : remove package(s).
```
