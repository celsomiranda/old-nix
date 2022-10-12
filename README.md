# My NixOS Configs

This repo contains a simple nix flake template with NixOS + home-manager.

# What this provides

- [Minimal version](./minimal):
  - NixOS configuration on `nixos/configuration.nix`, accessible via
    `nixos-rebuild --flake .`
  - Home-manager configuration on `home-manager/home.nix`, accessible via
    `home-manager --flake .`

# Getting started

Assuming you have a basic NixOS booted up (either live or installed, anything
works). [Here's a link to the latest NixOS downloads, just for
you](https://nixos.org/download#download-nixos).

## The repo

- Download this repo

```bash
cd ~
git clone https://github.com/celsomiranda/nix-config
cd nix-config
```

- Make sure you're running Nix 2.4+, and opt into the experimental `flakes` and `nix-command` features:

```bash
# Should be 2.4+
nix --version
export NIX_CONFIG="experimental-features = nix-command flakes"
```

## Usage

- Run `sudo nixos-rebuild switch --flake .#omen` to apply your system
  configuration.
  - If you're still on a live installation medium, run `nixos-install --flake .#omen` instead, and reboot.
- Run `home-manager switch --flake .#celso@omen` to apply your home configuration.
  - If you don't have home-manager installed, try `nix shell nixpkgs#home-manager`.

And that's it, really! You're ready to have fun with your configurations using
the latest and greatest nix3 flake-enabled command UX.

# What next?

## Adding more hosts or users

You can organize them by hostname and username on `nixos` and `home-manager`
directories, be sure to also add them to `flake.nix`.

You can take a look at my (beware, here be reproductible dragons)
[configuration repo](https://github.com/misterio77/nix-config) for ideas.

NixOS makes it easy to share common configuration between hosts (you might want
to create a common directory for these), while keeping everything in sync.
home-manager can help you sync your environment (from editor to WM and
everything in between) anywhere you use it. Have fun!

## User password and secrets

You have basically two ways of setting up default passwords:

- By default, you'll be prompted for a root password when installing with
  `nixos-install`. After you reboot, be sure to add a password to your own
  account and lock root using `sudo passwd -l root`.
- Alternatively, you can specify `initialPassword` for your user. This will
  give your account a default password, be sure to change it after rebooting!
  If you do, you should pass `--no-root-passwd` to `nixos-install`, to skip
  setting a password on the root account.

If you don't want to set your password imperatively, you can also use
`passwordFile` for safely and declaratively setting a password from a file
outside the nix store.

There's also [more advanced options for secret
management](https://nixos.wiki/wiki/Comparison_of_secret_managing_schemes),
including some that can include them (encrypted) into your config repo and/or
nix store, be sure to check them out if you're interested.

## Dotfile management with home-manager

Besides just adding packages to your environment, home-manager can also manage
your dotfiles. I strongly recommend you do, it's awesome!

For full nix goodness, check out the home-manager options with `man home-configuration.nix`. Using them, you'll be able to fully configure any
program with nix syntax and its powerful abstractions.

Alternatively, if you're still not ready to rewrite all your configs to nix
syntax, there's home-manager options (such as `xdg.configFile`) for including
files from your config repository into your usual dot directories. Add your
existing dotfiles to this repo and try it out!

## Try opt-in persistance

You might have noticed that there's impurity in your NixOS system, in the form
of configuration files and other cruft your system generates when running. What
if you change them in a whim to get something working and forget about it?
Boom, your system is not fully reproductible anymore.

You can instead fully delete your `/` and `/home` on every boot! Nix is okay
with a empty root on boot (all you need is `/boot` and `/nix`), and will
happily reapply your configurations.

There's two main approaches to this: mount a `tmpfs` (RAM disk) to `/`, or
(using a filesystem such as btrfs or zfs) mount a blank snapshot and reset it
on boot.

For stuff that can't be managed through nix (such as games downloaded from
steam, or logs), use [impermanence](https://github.com/nix-community/impermanence)
for mounting stuff you to keep to a separate partition/volume (such as
`/nix/persist` or `/persist`). This makes everything vanish by default, and you
can keep track of what you specifically asked to be kept.

Here's some awesome blog posts about it:

- [Erase your darlings](https://grahamc.com/blog/erase-your-darlings)
- [Encrypted BTRFS with Opt-In State on NixOS](https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html)
- [NixOS: tmpfs as root](https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/) and
  [tmpfs as home](https://elis.nu/blog/2020/06/nixos-tmpfs-as-home/)
- [Paranoid NixOS Setup](https://xeiaso.net/blog/paranoid-nixos-2021-07-18)

## Adding custom packages

Something you want to use that's not in nixpkgs yet? You can easily build and
iterate on a derivation (package) from this very repository.

Create a folder with the desired name inside `pkgs`, and add a `default.nix`
file containing a derivation. Be sure to also `callPackage` them on
`pkgs/default.nix`.

You'll be able to refer to that package from anywhere on your
home-manager/nixos configurations, build them with `nix build .#package-name`,
or bring them into your shell with `nix shell .#package-name`.

See [the manual](https://nixos.org/manual/nixpkgs/stable/) for some tips on how
to package stuff.

## Adding overlays

Found some outdated package on nixpkgs you need the latest version of? Perhaps
you want to apply a patch to fix a behaviour you don't like? Nix makes it easy
and manageble with overlays!

Use the `overlay/default.nix` file for this.

If you're creating patches, you can keep them on the `overlay` folder as well.

See [the wiki article](https://nixos.wiki/wiki/Overlays) to see how it all
works.

## Adding your own modules

Got some configurations you want to create an abstraction of? Modules are the
answer. These awesome files can expose _options_ and implement _configurations_
based on how the options are set.

Create a file for them on either `modules/nixos` or `modules/home-manager`. Be
sure to also add them to the listing at `modules/nixos/default.nix` or
`modules/home-manager/default.nix`.

See [the wiki article](https://nixos.wiki/wiki/Module) to learn more about
them.

# Troubleshooting / FAQ

Please [let me know](https://github.com/Misterio77/nix-starter-config/issues)
any questions or issues you face with these templates, so I can add more info
here!

## I'm trying to set nixpkgs.config options (e.g. allowUnfree), but they won't work!

We instantiate nixpkgs and pass it to NixOS, to make the flake a bit simpler
and ensure both configs have the same nixpkgs instance, this has the drawback
of breaking nixpkgs configuration through in your NixOS config files.

This is a design choice I made based on the `homeManagerConfiguration`
interface, that requires a `pkgs` instance anyway. If you prefer to set them
modularly, you'll have to remove the `pkgs` argument. If you use overlays,
you'll have to pass them into your configuration (through specialArgs) or set
`nixpkgs.overlays` right on the flake; in this case, you might prefer to use
[home-manager as a NixOS
module](https://nix-community.github.io/home-manager/index.html#sec-flakes-nixos-module)
and set `home-manager.useGlobalPkgs = true`.

## Nix says my repo files don't exist, even though they do!

Nix flakes only see files that git is currently tracked, so just `git add .`
and you should be good to go. Files on `.gitignore`, of course, are invisible
to nix - this is to guarantee your build won't depend on anything that is not
on your repo.
