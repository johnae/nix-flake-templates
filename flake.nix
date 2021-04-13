{
  description = "A collection of flake templates";

  outputs = { self }: {

    templates = {

      shell = {
        path = ./shell;
        description = "A flake for dev shells - simple and easy to understand";
      };

      devshell = {
        path = ./devshell;
        description = "A flake for toml-based dev shells - somewhat simpler to use but also less obvious";
      };

      app = {
        path = ./app;
        description = "A flake more suited to building an application";
      };

      rustapp = {
        path = ./rustapp;
        description = "A flake for rust development";
      };

    };

    defaultTemplate = self.templates.shell;

  };
}
