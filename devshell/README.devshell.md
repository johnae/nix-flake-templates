## The devshell

This flake uses [numtide's](https://github.com/numtide) excellent (but still alpha) `devshell` flake. It also adds some other dependencies that are useful to have in all projects.

Using the devshell means that everyone using it, regardless of whether they're on Linux or Mac, will use the exact same dependencies and tools. That helps immensely with onboarding but also sharing of tools between all developers on a project.

As with everything, there are upsides and downsides. The devshell is based on the [Nix Package Manager](https://nixos.org) which is much more than a package manager. Nix is also a build tool and a programming language, though specifically built for package management, configuration management and build tools.
The tradeoff is that to most people it is something new, non-trivial, to learn and that it does things in a very different way. It does things differently for good reason, but it's still different which does mean some cognitive load while learning.

I'm certain this is something anyone can use effectively by just adding things to the `devshell.toml` file and not much else. That probably covers 80% of the use cases even. Anything more advanced however, does need a deeper understanding of the tooling behind it all. But that's a lot of fun :-).

## Some explanation of the files

## `flake.nix`

This file is quite similar to a `package.json` in a NodeJS-project or a `Cargo.toml` in a Rust-project. It could also be compared to a `go.mod` file in a Go project. It defines the packages we depend on and possibly allowed versions of those. In a `flake.nix`, dependencies are very often just pointing to github repos. The dependencies can be anything as opposed to what you can realistically put in a `package.json` or `go.mod`.

## `flake.lock`

This file is similar to `package-lock.json` in a NodeJS-project or a `Cargo.lock` in a Rust-project. It could also be compared to the `go.sum` file in a Go project. It locks down the exact dependencies (until you explicitly update them at some later point).

## `devshell.toml`

This is really THE file relevant to the project. This is where dependencies go and possibly some relevant environment variables go.