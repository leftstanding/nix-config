{ pkgs, ... }: {
  imports = [
    ./bash.nix
    ./bat.nix
    ./direnv.nix
    ./nushell.nix
    ./gh.nix
    ./git.nix
    # TODO gpg.nix?
    ./nix-index.nix
    ./pfetch.nix
    ./ranger.nix
    ./screen.nix
    ./shellcolor.nix
    # TODO ./ssh.nix
  ];
  home.packages = with pkgs; [
    comma # Install and run programs by sticking a , before them
    distrobox # Nice escape hatch, integrates docker images with my environment

    bc # Calculator
    bottom # System viewer
    ncdu # TUI disk usage
    ripgrep # Better grep
    fd # Better find
    diffsitter # Better diff
    mprocs # Multiple process viewer
    tealdeer # tldr in rust
    # TODO not sure if I want to keep the following...
    httpie # Better curl
    timer # To help with my ADHD paralysis

    nil # Nix LSP
    nixfmt # Nix formatter
    nix-inspect # See which pkgs are in your PATH

    ltex-ls # Spell checking LSP
  ];
}
