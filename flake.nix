{
  description = "A collection of flake templates";

  outputs = {self}: {
    templates = {
      devshell = {
        path = ./devshell;
        description = "A flake for toml-based dev shells - deprecated";
      };

      devenv = {
        path = ./devenv;
        description = "A flake for devenv based projects, also based on flake.parts";
      };

      rustapp = {
        path = ./rustapp;
        description = "A flake for rust development";
      };
    };

    defaultTemplate = self.templates.devenv;
  };
}
