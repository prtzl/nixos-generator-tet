# NixOS Generator TET or Pillow

Yesh, a spelling misstake. Tells a lot about this project.

Started as an attempt in "how hard could this be".
I basically started copying (some functions in lib yes) the approach from [Trilby](https://github.com/ners/trilby) project by @ners.

For me it pushed too many defaults and I like to see my own bloat that I've put inside my OS instead.

So yeah, as it started to work as good as it did, bazinga, it ran.

Now I have users in order of porting:
* vm
* karla: laptop that I don't use much
* poli: main PC
* wsl: primary work "machine" at work

VM is running full GUI and everything so it's good to test bootloaders (fun with boot animations), filesystems, installations, app default configs using nix, etc.

Good thing is that this is closer to what I had [before](https://github.com/prtzl/nixos). Every machine I use has THE SAME STUFF and it ALL WORKS EVERYWHERE. Yeey.

## How-TO

For "physical machines" (VMs count) I use disko to describe and create disk layouts.

Then the rest is made of 2 parts: host and user config.

I've prepared (TODO) a MINIMAL host and MINIMAL user config. No defaults, none of my magic.
Just using my library that "hides" the nice stuff of collection all the configurations into a minimal looking flake and building all together.
This way it should be easy to see where all the stuff should go when migrating from a "stock" nixos setup. It's plug-and-play (as long as disk config is the same, duuuuh).

### host config

Host are stored in `./hosts/<host name>/default.nix`

That is the minimum setup. The library looks for all folders inside of the `hosts` and processes each `default.nix` as a function to feed data into `lib.nixosSystem`.

It looks something like this (vm for example):

```nix
{
  lib,
  ...
}:

lib.pillowSystem rec {
  pillow = lib.makePillowArgs {
    edition = "virtual";
    hostPlatform = "x86_64-linux";
    hasGUI = true;

    host = {
      name = "vm";
      interfaces = [ "enp1s0" ];
      disks = [ "/" ];
    };

    settings.hyprland = {
      monitor = [
        ",1920x1080@60,auto,1"
      ];
    };
  };

  modules = (lib.findModulesList ./.) ++ [
    (import ../../users/macho {
      inherit lib pillow;
    })
    (import ../../users/nacho {
      inherit lib pillow;
    })
  ];

  specialArgs = {
  };
}
```

It's a function that accepts lib and returns a function accepting a set.

You have to defined at least one thing: `pillow`.

Create it with the `lib.makePillowArgs` so that it forces you to define these minimum items:
* edition: workstation, virtual, wsl
* hostPlatform: x86_64-linux, aarch64-linux, ...
* host
  * name: matches `./host/<host config>` name
  * interfaces: all network interfaces
* SOME MODULE (ala `configuration.nix`) to configure your system - bootloader, filesystem, apps, services, kernel, etc.

In VM example it looks like nothing of sorts is defined since:
* `lib.pillowSystem` has a default parameter `useDefaults` set to `true`. This defines base (default) nixos configurations that apply to all my systems.
* `lib.findModulesList` finds all `*.nix` files and includes them in the `modules` list. Sneaky.
  * these include `configuration.nix` and `disko.nix`.

pillow argset is used internally and accross all files (included in `specialArgs` internally) for configuration help.
Lots of items from `pillow.host` are used in my `waybar` configuration to dynamically define necessary widgets on each device.

`modules` are placed directly into `lib.nixosSystem { modules = [modules] ++ ...; }` so you can treat it the same.
Here I'm also importing users as modules so that they have forwarded pillow, lib, and system config set.
This allows home module to reference settings from nixos.

### users

Each user is configured the same as a host. Each folder in `./users/<user name>` represents a user and should include at least a `default.nix`

The module accepts lib and pillow from the host context and returns a function that returns a nixos module, which then gets included by host nixos config.

Mandatory attributes are:
* name: username, matches directory name`./users/<user name>`
* configuration: placed into imports, which will be internally imported into `home.homeImports = []`.

Other parameters are going to be merged with their (identically named) nixos options.

Here is an example from macho:

```nix
{
  lib,
  pillow,
  ...
}:

lib.pillowUser pillow {
  imports = [
    ./configuration.nix
  ];

  name = "macho";

  initialHashedPassword = "$y$j9T$dummyhashfornow$yXUohY5bEl/XXXX"; # run `mkpasswd -m yescrypt`
  extraGroups = [
  ];

  extraSpecialArgs = {
  };
}
```

For nicer and longer configs the `default.nix` is left smaller by putting the user-specific config into `configuration.nix`. For comparison this would be usually named `home.nix` (maybe I should change it).

Inside of that I import the base user configuration: `imports = [ ../../profiles/home ];`
Importing that is NOT required since it only configures my default programs based on the user and host configuration (GUI, hardware, apps), so you may ignore it and use your own.

## Install

Grab the nixos minimal installation iso from [here](https://nixos.org/download).
Burn it onto a USB to make it bootable. On linux it's as easy as:
```shell
# DOUBLE CHECK YOUR DISK DESTINATION. This will F$CK your primary drive if you've put it's path in here.
sudo dd if=~/Downloads/nixos-minimal-25.05.<specific version>-x86_64-linux.iso of=/dev/<your disk path> bs=4M status=progress oflag=sync
```

Boot into that bad boy and once inside, clone this repo:
```shell
git clone https://github.com/prtzl/nixos-generator-tet
cd nixos-generator-tet
```

Once cloned create your system host confi and user:
1) Copy `./host/minimal/*` to `./host/mynewconfig/`
2) Modify: `pillow.{ edition, host.{ name, interfaces = [] } }` to match your PC
3) Modify: `disko.nix` to describe your disk situation. use `lsblk` to check your disk devices and desired filesystem type.
4) Copy `./users/macho/*` to `./users/mynewuser/`
5) Modify: `name` to match `./users/mynewuser` directory name.

Now enter root user, format the drive, and install the system:
```shell
sudo -i
# first and only argument is the name of the new host config
./format_install.sh <mynewconfig>
```

Set the root password when prompted.

I like to set my user password here as well:

```shell
nixos-enter -c 'passwd <mynewuser>'
# enter your new user password
```

Restart the machine and you're done :) Happy modding!
