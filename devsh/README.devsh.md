## The dev sh

Using the devsh means that everyone using it, regardless of whether they're on Linux or Mac, will use the exact same dependencies and tools. That helps immensely with onboarding but also sharing of tools between all developers on a project.

## Some explanation of the files

## `flake.nix`

This file is quite similar to a `package.json` in a NodeJS-project or a `Cargo.toml` in a Rust-project. It could also be compared to a `go.mod` file in a Go project. It defines the packages we depend on and possibly allowed versions of those. In a `flake.nix`, dependencies are very often just pointing to github repos. The dependencies can be anything as opposed to what you can realistically put in a `package.json` or `go.mod`.

## `flake.lock`

This file is very similar to `package-lock.json` in a NodeJS-project or a `Cargo.lock` in a Rust-project. It could also be compared to the `go.sum` file in a Go project. It locks down the exact dependencies (until you explicitly update them at some later point).

## `devshell.nix`

This is really THE file relevant to the project where you would add or remove dependencies.