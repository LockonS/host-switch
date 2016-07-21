## host-switch
A zsh plugin for quickly switch hostfile and refresh dns cache

### Usage

#### Step 1
- Download this plugin and place it in `path-to-zsh/custom/plugin` 

#### Step 2
- Activate the plugin by adding `host-switch`in `plugins` in your config file

#### Step 3
- Setup hostfiles

	1. Be advised, before setting up this plugin, remember to backup your original file `/etc/hosts` as you might already add a few custom host setting into you hosts file. This plugin works as a tiny tool to help you switch between several hosts files.

	2. Add host file to be switched in `hostfile` folder， and rename the file like `hosts.dev`. Switching current hosts file to `hosts.dev` reqires this command. Filename extension was used as the arguments to match files.

	```sh
	hostswitch dev
	```
	
