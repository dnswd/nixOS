{lib, ...}: let
  inherit (lib) makeExtensible attrValues foldr my;

  imports = [
    ./palette
  ];

  myschema = makeExtensible (self:
    with self;
      my.mapModules ./. (m: import m {inherit self pkgs lib inputs;}));
in
  myschema.extend (self: super: foldr (a: b: a // b) {} (attrValues super))
