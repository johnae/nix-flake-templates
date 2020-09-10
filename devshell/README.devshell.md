## The devshell

Using the devshell means it's easy for all developers to share the exact same dependencies, in a similar fashion to how `package.json` + `package.lock` enables us to share nodejs dependencies at exact versions. The difference here is that these dependencies can be anything - a certain version of NodeJS certainly, but could be combined with a specific version of Go in the same project.
The dependencies are project specific and are not installed "globally", they're only available within the devshell of the current project.