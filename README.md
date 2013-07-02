# ComputerCraft Github Client

copyright 2013 Zenobius Jiricek

MIT three clause license

Basic github client for computer craft, this seeks to supplant the pastebin functionality in 
computercraft with something more sane.



## Intro

This is my first experiement in creating a distribution and pacaging program for computercraft 
that interacts with github.com.

The idea is to utilise the awesomeness of git and github so that `github install airtonix/cross-mining` 
will install the latest version of that package.

My approach to this is fairly opinionated, being influenced by the pip utility used and loved by 
python programmers.


## Packages

Packages are assumed to follow the format of :

```
/package-name
    manifest.json
    main.lua
    /lib
        something.lua
README
LICENSE
```

The only file that is mandatory is manifest.json.


### package.toc

This JSON file describes some information about the package.


The following example manifest will cause `github install airtonix/my-package` to :
* download the packge to `/tmp/github/my-package`
* move `/tmp/github/my-package` to `/usr/local/my-package/`
* create an alias `/my-package` pointing at `/usr/local/my-package/main.lua`

```
{
    "name": "My Package",
    "username": "airtonix",
    "reponame": "my-package",
    "branch": "master",
    "commands": [
            { "doSomething" : "main.lua" },
        ]
}
```

#### Supported Values

* *name* [string]
An human readable package label/name, used when displaying packages in lists

* *username* [string]
your github username. used to contruct part of the url

* *repo* [string]
name of the repo, used construct the url and the name of the command alias.

* *branch* [string]
name of the branch that your package is released from. good practice is to use `master`

* *commands* [list of dicts]
Describes command aliases to create.
The key will become the name of the command alias, and the value is what lua file in the package it points at.



## Updating

	github update package-name

## Removing

	github remove package-name

## List installed

	github list



## Todo

### proposed commands

I intend to allow the `github` tool to use the following:

* install
	fetch repo and setup command alias
* update
	runs install again, fetching from latest version, overwriting any files
* remove
	removes package and alias
* list
	list installed and managed packages


### Dependancy Management

Although something that might be beyond my reach, I can see that this would be great.

```
{
	"name": "My Package",
	"username": "airtonix",
	"reponame": "my-package",
	"branch": "master",
	"commands": [
			{ "doSomething" : "main.lua" },
		],
	"requires": [
		"fred/supporting-modules",
		"jane/nice-colours",
	]

}
```
