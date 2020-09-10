{
  description = "A collection of flake templates";

  outputs = { self }: {

    templates = {

      shell = {
        path = ./shell;
        description = "A flake for dev shells - simple";
      };

      devshell = {
        path = ./devshell;
        description = "A flake for toml-based dev shells - even simpler to use";
      };

      app = {
        path = ./app;
        description = "A flake more suited to building an application";
      };

    };

    defaultTemplate = self.templates.shell;

  };
}
