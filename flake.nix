{
  description = "A collection of flake templates";

  outputs = {self}: {
    templates = {
      devenv = {
        path = ./devenv;
        description = "A generic flake for devenv based projects";
      };

      rust = {
        path = ./rust;
        description = "A flake for rust development";
      };
    };

    defaultTemplate = self.templates.devenv;
  };
}
