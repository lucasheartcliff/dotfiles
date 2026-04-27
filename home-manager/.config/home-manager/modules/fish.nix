{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      set -gx EDITOR nvim
      set -gx VISUAL nvim
      fish_add_path $HOME/.local/bin
      fish_add_path $HOME/.local/share/npm/bin
      fish_add_path $HOME/.cargo/bin
      set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
      set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

      if test -f $HOME/asdf/asdf.fish
        set -gx ASDF_DATA_DIR $HOME/asdf
        source $HOME/asdf/asdf.fish
        if test -f $HOME/asdf/plugins/java/set-java-home.fish
          source $HOME/asdf/plugins/java/set-java-home.fish
        end
      end
    '';
    shellAbbrs = {
      g = "git";
      ga = "git add";
      gaa = "git add --all";
      gap = "git add --patch";
      gb = "git branch";
      gba = "git branch -a";
      gc = "git commit";
      gca = "git commit --amend";
      gcan = "git commit --amend --no-edit";
      gco = "git checkout";
      gcb = "git checkout -b";
      gcm = "git checkout main";
      gd = "git diff";
      gds = "git diff --staged";
      gf = "git fetch";
      gfa = "git fetch --all --prune";
      gl = "git pull";
      glog = "git log --oneline --graph --decorate --all";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gr = "git restore";
      grs = "git restore --staged";
      gs = "git status";
      gsw = "git switch";
      gswm = "git switch main";
      gt = "git tag";
      glg = "lazygit";

      ghpr = "gh pr";
      ghco = "gh pr checkout";

      k = "kubectl";
      kgp = "kubectl get pods";
      kgs = "kubectl get svc";
      kctx = "kubectx";
      kns = "kubens";

      hmb = "home-manager build";
      hms = "home-manager switch";
      hmd = "home-manager switch --dry-run";
      nrs = "nix repl '<nixpkgs>'";

      cx = "codex";
      cxl = "codex login";
      ccode = "claude";

      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      ls = "lsd";
      ll = "lsd -l";
      la = "lsd -la";
      lt = "lsd --tree";
      cat = "bat --style=plain";
      grep = "rg";
      find = "fd";

      v = "set -lx JAVA_HOME (asdf where java graalvm-community-21.0.2); set -lx PATH $JAVA_HOME/bin $PATH; set -lx NODE22_HOME (asdf where nodejs 22.17.0); set -lx PATH $NODE22_HOME/bin $PATH; nvim";
      vim = "set -lx JAVA_HOME (asdf where java graalvm-community-21.0.2); set -lx PATH $JAVA_HOME/bin $PATH; set -lx NODE22_HOME (asdf where nodejs 22.17.0); set -lx PATH $NODE22_HOME/bin $PATH; nvim";
      codex22 = "set -lx NODE22_HOME (asdf where nodejs 22.17.0); set -lx PATH $NODE22_HOME/bin $PATH; codex";

      d = "docker";
      dc = "docker-compose";
      dps = "docker ps";
      dimg = "docker images";
      dcu = "docker-compose up -d";
      dcd = "docker-compose down";
      dcl = "docker-compose logs -f";
      dce = "docker-compose exec";
      h = "history";
      md = "mkdir -p";
      c = "clear";
    };
    plugins = [
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "fish-git-abbr";
        src = pkgs.fishPlugins.git-abbr.src;
      }
      {
        name = "fish-you-should-use";
        src = pkgs.fishPlugins.fish-you-should-use.src;
      }
      {
        name = "foreign-env";
        src = pkgs.fishPlugins.foreign-env.src;
      }
    ];
  };

  xdg.configFile."fish/completions/asdf.fish".text = ''
    complete -c asdf -f
    complete -c asdf -n "__fish_use_subcommand" -a "plugin list current where which install uninstall latest local global shell reshim exec env info version help" -d "asdf command"
    complete -c asdf -n "__fish_seen_subcommand_from plugin" -a "add list list-all remove update" -d "Plugin command"
    complete -c asdf -n "__fish_seen_subcommand_from install uninstall latest list local global shell where which" -a "(asdf plugin list 2>/dev/null)" -d "asdf plugin"
  '';

  xdg.configFile."fish/completions/gh.fish".text = ''
    complete -c gh -f
    complete -c gh -n "__fish_use_subcommand" -a "auth browse codespace gist issue pr release repo run search secret ssh status workflow" -d "GitHub CLI command"
    complete -c gh -n "__fish_seen_subcommand_from pr" -a "checkout checks close comment create diff edit list merge ready reopen review status view" -d "Pull request command"
    complete -c gh -n "__fish_seen_subcommand_from issue" -a "close comment create develop edit list reopen status transfer view" -d "Issue command"
    complete -c gh -n "__fish_seen_subcommand_from repo" -a "clone create delete deploy-key edit fork list rename set-default sync view" -d "Repository command"
  '';

  xdg.configFile."fish/completions/kubectl.fish".text = ''
    complete -c kubectl -f
    complete -c kubectl -n "__fish_use_subcommand" -a "apply attach auth autoscale certificate cluster-info completion config cordon cp create delete describe diff drain edit exec explain expose get kustomize label logs patch port-forward proxy replace rollout run scale set taint top uncordon version wait" -d "kubectl command"
    complete -c kubectl -n "__fish_seen_subcommand_from get describe delete edit logs top" -a "pods services deployments replicasets statefulsets daemonsets jobs cronjobs configmaps secrets namespaces nodes ingress persistentvolumeclaims storageclasses" -d "Kubernetes resource"
    complete -c kubectl -s n -l namespace -d "Namespace"
    complete -c kubectl -l context -d "Kubeconfig context"
    complete -c kubectl -l kubeconfig -r -d "Path to kubeconfig"
    complete -c kubectl -s o -l output -a "json yaml wide name go-template custom-columns" -d "Output format"
  '';

  xdg.configFile."fish/completions/kubectx.fish".text = ''
    complete -c kubectx -f -a "(kubectx 2>/dev/null)" -d "Kubernetes context"
    complete -c kubectx -s h -l help -d "Show help"
  '';

  xdg.configFile."fish/completions/kubens.fish".text = ''
    complete -c kubens -f -a "(kubens 2>/dev/null)" -d "Kubernetes namespace"
    complete -c kubens -s h -l help -d "Show help"
  '';

  xdg.configFile."fish/completions/helm.fish".text = ''
    complete -c helm -f
    complete -c helm -n "__fish_use_subcommand" -a "completion create dependency env get history install lint list package plugin pull push registry repo rollback search show status template test uninstall upgrade verify version" -d "Helm command"
    complete -c helm -n "__fish_seen_subcommand_from repo" -a "add index list remove update" -d "Repository command"
    complete -c helm -n "__fish_seen_subcommand_from search" -a "hub repo" -d "Search source"
    complete -c helm -s n -l namespace -d "Namespace"
    complete -c helm -l kube-context -d "Kubernetes context"
  '';

  xdg.configFile."fish/completions/docker-compose.fish".text = ''
    complete -c docker-compose -f
    complete -c docker-compose -n "__fish_use_subcommand" -a "build config cp create down events exec images kill logs ls pause port ps pull push restart rm run start stop top unpause up version" -d "Docker Compose command"
    complete -c docker-compose -s f -l file -r -d "Compose file"
    complete -c docker-compose -s p -l project-name -d "Project name"
  '';

  xdg.configFile."fish/completions/docker.fish".text = ''
    complete -c docker -f
    complete -c docker -n "__fish_use_subcommand" -a "attach build builder checkpoint commit compose config container context cp create diff events exec export history image images import info inspect kill load login logout logs manifest network node pause plugin port ps pull push rename restart rm rmi run save scout search secret service stack start stats stop swarm system tag top trust unpause update version volume wait" -d "Docker command"
    complete -c docker -n "__fish_seen_subcommand_from compose" -a "build config cp create down events exec images kill logs ls pause port ps pull push restart rm run start stop top unpause up version" -d "Docker Compose command"
    complete -c docker -s H -l host -d "Daemon socket"
    complete -c docker -l context -d "Docker context"
  '';

  xdg.configFile."fish/completions/home-manager.fish".text = ''
    complete -c home-manager -f
    complete -c home-manager -n "__fish_use_subcommand" -a "build edit expire-generations generations help news option packages remove switch uninstall" -d "Home Manager command"
    complete -c home-manager -l flake -d "Flake URI"
    complete -c home-manager -l dry-run -d "Show what would be done"
    complete -c home-manager -l backup-extension -d "Backup extension"
  '';

  xdg.configFile."fish/completions/nix.fish".text = ''
    complete -c nix -f
    complete -c nix -n "__fish_use_subcommand" -a "build develop edit flake fmt hash log path-info profile registry repl run search shell store upgrade-nix why-depends" -d "Nix command"
    complete -c nix -n "__fish_seen_subcommand_from flake" -a "archive check clone info init lock metadata new prefetch show update" -d "Flake command"
    complete -c nix -l extra-experimental-features -d "Enable experimental features"
  '';

  xdg.configFile."fish/completions/npm.fish".text = ''
    complete -c npm -f
    complete -c npm -n "__fish_use_subcommand" -a "access adduser audit bugs cache ci completion config dedupe deprecate diff dist-tag docs doctor edit exec explain explore find-dupes fund get help hook init install link login logout ls outdated owner pack ping pkg prefix profile prune publish query rebuild repo restart root run-script search set shrinkwrap star stars start stop team test token uninstall unpublish update version view whoami" -d "npm command"
    complete -c npm -s g -l global -d "Use global install"
    complete -c npm -l save-dev -d "Save as dev dependency"
  '';

  xdg.configFile."fish/completions/yarn.fish".text = ''
    complete -c yarn -f
    complete -c yarn -n "__fish_use_subcommand" -a "add audit bin cache config create dlx exec explain global help import init install link list login logout node outdated pack patch plugin rebuild remove run search set unlink up upgrade version why workspace workspaces" -d "Yarn command"
    complete -c yarn -n "__fish_seen_subcommand_from run" -a "(jq -r '.scripts | keys[]?' package.json 2>/dev/null)" -d "Package script"
  '';
}
