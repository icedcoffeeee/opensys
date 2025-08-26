{ pkgs ? import <nixpkgs> {} }: with pkgs;
mkShell {
  packages = [(python312.withPackages(py: with py; [
        numpy vispy pyqt6
  ]))];
}
