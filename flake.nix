{
  description = "st with some patches and a custom config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      pkgs = forAllSystems (system: import nixpkgs { inherit system; });
    in {
      packages = forAllSystems (system: {
        default = pkgs.${system}.st.override {
          conf = builtins.readFile ./config.h;
          extraLibs = [ pkgs.${system}.iosevka ];
          patches = [
            ./st-alpha-20220206-0.8.5.diff
            ./st-xresources-20200604-9ba7ecf.diff
            ./st-scrollback-0.8.5.diff
            ./st-dynamic-cursor-color-0.8.4.diff
            ./st-bold-is-not-bright-20190127-3be4cf1.diff
            /* ./st-glyph-wide-support-20220411-ef05519.diff */
            ./st-copyurl-modified-0.8.5.diff
          ];
        };
      });
  };
}
