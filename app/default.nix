{ stdenv, writeStrictShellScriptBin, self }:

writeStrictShellScriptBin "hello" ''
  echo hello world
''
