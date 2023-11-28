{ pkgs, lib, config, ... }:
let
  # TODO once things are set up might be worth integrating this
  # into the git config
  # ssh = "${pkgs.openssh}/bin/ssh";

  # git-m7 = pkgs.writeShellScriptBin "git-m7" ''
  #   repo="$(git remote -v | grep git@m7.rs | head -1 | cut -d ':' -f2 | cut -d ' ' -f1)"
  #   # Add a .git suffix if it's missing
  #   if [[ "$repo" != *".git" ]]; then
  #     repo="$repo.git"
  #   fi

  #   if [ "$1" == "init" ]; then
  #     if [ "$2" == "" ]; then
  #       echo "You must specify a name for the repo"
  #       exit 1
  #     fi
  #     ${ssh} -A git@m7.rs << EOF
  #       git init --bare "$2.git"
  #       git -C "$2.git" branch -m main
  #   EOF
  #     git remote add origin git@m7.rs:"$2.git"
  #   elif [ "$1" == "ls" ]; then
  #     ${ssh} -A git@m7.rs ls
  #   else
  #     ${ssh} -A git@m7.rs git -C "/srv/git/$repo" $@
  #   fi
  # '';
in
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    aliases = {
      ff = "merge --ff-only";
      pushall = "!git remote | xargs -L1 git push --all";
      graph = "log --decorate --oneline --graph";
      add-nowhitespace = "!git diff -U0 -w --no-color | git apply --cached --ignore-whitespace --unidiff-zero -";
      fast-forward = "merge --ff-only";
    };
    userName = "leftstanding";
    userEmail = "pragmatic.inc@gmail.com";
    extraConfig = {
      # TODO tweak/tune later; example:
      # user.signing.key = "CE707A2C17FAAC97907FF8EF2E54EA7BFE630916";
      # commit.gpgSign = true;
      # gpg.program = "${config.programs.gpg.package}/bin/gpg2";
    };
    lfs.enable = true;
  };
}
