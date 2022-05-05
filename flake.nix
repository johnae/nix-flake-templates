{
  description = "A collection of flake templates";

  outputs = {self}: {
    templates = {
      devshell = {
        path = ./devshell;
        description = "A flake for toml-based dev shells - somewhat simpler to use but also less obvious";
      };

      rustapp = {
        path = ./rustapp;
        description = "A flake for rust development";
      };
    };

    defaultTemplate = self.templates.shell;
  };
}
