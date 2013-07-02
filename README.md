# ComputerCraft Github Client

	copyright 2013 Zenobius Jiricek
	MIT three clause license

	Basic github client for computer craft, this seeks to supplant the pastebin functionality in computercraft
	with something more sane.



## Intro

	`gist` is my first experiement in creating a distribution and
	update program for computercraft that interacts with gist.github.com

## Packages

	Since gist.github allows you to store multiple files, gist will save 
	them on the turtle as a package.

	Packages are assumed to follow the format of :

	{{{
	    /
	        /gists
	            /package-name
	                package.toc
	                main.lua
	                /lib
	                    something.lua
	}}}

	The only file that is mandatory is package.toc, and of course if you
	want anything useful an initial lua file to run.


### package.toc

	This file describes the gist url, the package name, the version

	{{{
	    name: My Package
	    url: http://gist.github.com/username/23jh342
	    alias: my-package
	    init: main.lua
	}}}

	A toc file can have the following options

	*name* [string]
	An human readable package label/name, used when displaying packages in lists

	*url* [url]
	Specifies the repo for this package. This is used for updating or installing a 
	particular version of the gist.

	*alias* [slug]
	The symlink to create, which will be what the user interacts with when using the package
	The example above will cause `gist get 23jh342` to :
	    - download the packge to `/tmp/gists/23jh342/`
	    - move `/tmp/gists/23jh342/` to `/gists/my-package/`
	    - create an alias `/my-package` pointing at `/gists/my-package/main.lua`

	*version* [integer]
	if present will cause the package to be pinned to this revision, otherwise
	`gist update package-name|all` will make sure this package is at the lastest
	revision.

	*init* [filename]
	The lua file which the alias will point at, if not present the alias will point at 
	`/gists/package-name/main.lua`