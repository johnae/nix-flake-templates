## The devshell

This so called flake uses [numtide's](https://github.com/numtide) `devshell` flake. It also adds some other dependencies that are generally useful in most projects.

Using the devshell means that everyone using it, regardless of whether they're on Linux or Mac, will use the exact same dependencies and tools at the exact same versions. This helps immensely with onboarding but also with sharing of tools between all developers on a project while updating those same tools is also a shared process (all via git in the end).

As with everything, there are upsides and downsides. The devshell is based on the [Nix Package Manager](https://nixos.org) which is actually much more than a package manager. The tradeoff here is that to most people this would be something new to learn and that it does things in a different way to most other package managers, configuration managers and build tools. It is different for a good reason, but it does mean some extra cognitive load while learning.

Nix is a build tool and a programming language - though specifically built for package management, configuration management and build software. Nix can even manage a whole operating system (down to the low level kernel bits and pieces) in a reproducible, declarative fashion, i.e the NixOS Linux distro). But it doesn't have to be used like that, it's NixOS that is built on top of Nix, not the other way around. Nix is simply just a really great build tool, dependency management tool and configuration management tool.

I'm certain this is something anyone can use effectively by just adding things to the [devshell.toml](./devshell.toml) file and not do much else. At least I think it probably covers 80% of the use cases. Anything more advanced would need a bit more understanding of the tooling behind it all. But learning is a lot of fun :-).

## Some explanation of the relevant files

## `flake.nix`

This file is quite similar to a `package.json` in a NodeJS-project or a `Cargo.toml` in a Rust-project. It could also be compared to a `go.mod` file in a Go project. It defines the packages we depend on and possibly allowed versions of those. In a `flake.nix`, dependencies are very often just pointing to github repos. The dependencies can be anything as opposed to what you can realistically put in a `package.json` or `go.mod`. I.e you can depend on say `terraform` as well as `nodejs` (and specific versions of those as well).

## `flake.lock`

This file is similar to `package-lock.json` in a NodeJS-project or a `Cargo.lock` in a Rust-project. It could also be compared to the `go.sum` file in a Go project. It locks down the exact dependencies (until you explicitly update them).

## `devshell.toml`

This is a third-party project, written in Nix. While Nix itself has the concept of a devShell - a shell for development in a specific repository where you'll have all dependencies available to you, this takes it much further while simplifying it so that you can do most things using TOML rather than Nix. While Nix is a relatively simple language (sort-of like JSON with functions), it IS a programming language so there's a greater learning curve. Above I mentioned that `flake.nix` is where you specify your dependencies, well - [devshell.toml](./devshell.toml) is really where most of those can now, instead, be specified. See below for how you'd do that.

## What you need to install to use all this

You need to [install the Nix Package Manager](https://nixos.org/download.html). After you've done so there's a very small amount of configuration you need to do. This is that configuration:

```sh
sudo mkdir -p /etc/nix
echo 'experimental-features = nix-command flakes' | sudo tee -a /etc/nix/nix.conf
```

I realize "experimental" might sound bad to some. For me, having used Nix since 2017 and the nix command and flakes since spring 2020, it's not that concerning. There's been a few tweaks to these features over the years but they're close to being stabilized. They aren't buggy but they could potentially still change in incompatible ways, though as noted - they've been pretty stable for quite a while now.

With Nix installed and the above configuration, you should be able to - in this repo - just run:

```sh
nix develop
```

That should bring in all dependencies listed in the [devshell.toml file](./devshell.toml) file. It means that, in the same way you can lock javascript libraries to specific versions using `npm` and store that within the repo while sharing it among all members of the team, you can now do that for any conceivable dependency (like dev tools, runtimes, compilers etc).

## But how do I find packages?

Like this:

```sh
nix search nixpkgs terraform
```

Brief explanation of above: we're searching for terraform within nixpkgs. Nixpkgs is the big package collection of 80 000+ packages (you can compare it to apt repos or rpm repos). The output of the above at the time of writing is just way too long to list here so I'll abbreviate it:


```sh
❯ nix search nixpkgs terraform
* legacyPackages.x86_64-linux.atlantis (0.16.1)
  Terraform Pull Request Automation

* legacyPackages.x86_64-linux.infracost (0.9.8)
  Cloud cost estimates for Terraform in your CLI and pull requests

* legacyPackages.x86_64-linux.k2tf (0.6.3)
  Kubernetes YAML to Terraform HCL converter

* legacyPackages.x86_64-linux.terracognita (0.7.4)
  Reads from existing Cloud Providers (reverse Terraform) and generates your infrastructure as code on Terraform configuration

* legacyPackages.x86_64-linux.terraform (1.0.11)
  Tool for building, changing, and versioning infrastructure

* legacyPackages.x86_64-linux.terraform-compliance (1.2.11)
  BDD test framework for terraform

* legacyPackages.x86_64-linux.terraform-docs (0.16.0)
  A utility to generate documentation from Terraform modules in various output formats

* legacyPackages.x86_64-linux.terraform-full (1.0.11)
  Tool for building, changing, and versioning infrastructure

* legacyPackages.x86_64-linux.terraform-inventory (0.7-pre)
  Terraform state to ansible inventory adapter

* legacyPackages.x86_64-linux.terraform-landscape (0.2.1)
  Improve Terraform's plan output to be easier to read and understand

* legacyPackages.x86_64-linux.terraform-ls (0.25.0)
  Terraform Language Server (official)

* legacyPackages.x86_64-linux.terraform-lsp (0.0.12)
  Language Server Protocol for Terraform

... snip - there's about 190 additional entries
```

Maybe you're wondering what that "legacyPackages.x86_64-linux" thing is all about. Well legacyPackages is what the package list used to be on Nix with sometimes deeply nested structures, like for example `legacyPackages.x86_64-linux.terraform-providers.softlayer`. That x86_64-linux is the architeture/os combo you're on (on MacOS it'd be either `x86_64-darwin` or `aarch64-darwin` on those fancy M1 macs). As you can see though you've got an additional attribute set - `terraform-providers` before you finally reach the `softlayer` provider. This nesting is going away in the future (because reasons) but everyone is still using and depending on this and so legacyPackages is what you install from if you use the cli tools to install things. Actually installing packages via the cli isn't as common when using Nix as it is with other package managers btw - there are multiple ways of making packages available exactly when you need them rather than having them always installed. Btw. managing terraform providers CAN be done using Nix but in this case you're probably better off using terraform:s way of doing the same.

Now when you know what package you'd like to include in the repo, let's say it's `* legacyPackages.x86_64-linux.terraform (1.0.11)`, what you do is to first remove `legacyPackages.x86_64-linux` from the package name, in this case there'd only be `terraform` left. Then you add that as a command in the [devshell.toml](./devshell.toml) file, like this:

```toml
[[commands]]
name = "terraform"
help = "manage you infrastructure like a boss"
category = "infra" ## this is just a nice to have, especially if you've got a lot of tooling
```

For commands where the package isn't the same as the name of the command you need to list both the package and the name of the command, like this:

```toml
[[commands]]
name = "flux"
package = "fluxcd"
help = "manage you kubernetes clusters like a boss"
category = "infra" ## again - a nice to have
```

([[commands]] is TOML syntax for creating an array basically. So you'd create an array with objects in it here.)

If you're unfamiliar with TOML, it's a really simple language. Read more about it here: [https://toml.io/en/](https://toml.io/en/).


## Using direnv for automatically bringing in dependencies when entering repo checkout

Personally, I like using [direnv](https://direnv.net) so that dependencies are automatically brought in when I step into a certain repository (rather than having to always run `nix develop`). Enabling this is really simple. You need to install direnv - that can be done either through whatever package manager you may be using at the moment, or you can install it using Nix - like this: `nix profile install nixpkgs#direnv` (that means install the package `direnv` from the `nixpkgs` repository into my user profile - i.e it's only for your user, not globally installed).

When you've installed direnv, you need to enable it through a shell hook, there are hooks for bash, zsh, fish and others. It's a one-liner really, here's the one for bash:

```sh
eval "$(direnv hook bash)"
```

Add that to your `.bashrc` basically. For other shells, please see the docs: [https://direnv.net/docs/hook.html](https://direnv.net/docs/hook.html). Direnv isn't strictly necessary of course but I find it very convenient.


## More documentation

For Nix, this is the official documentation on the package manager: [https://nixos.org/manual/nix/stable/introduction.html](https://nixos.org/manual/nix/stable/introduction.html).
For Nixpkgs, this is the official documentation: [https://nixos.org/manual/nixpkgs/stable/](https://nixos.org/manual/nixpkgs/stable/).
