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

      go = {
        path = ./go;
        description = "A flake for go development";
      };

      javascript = {
        path = ./javascript;
        description = "A flake for javascript/typescript development";
      };

      terraform = {
        path = ./terraform;
        description = "A flake for terraform development";
      };

      zig = {
        path = ./zig;
        description = "A flake for zig development";
      };
    };

    defaultTemplate = self.templates.devenv;
  };
}
