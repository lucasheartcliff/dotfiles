#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"

if command -v timeout >/dev/null 2>&1; then
  TIMEOUT_BIN="timeout"
elif command -v gtimeout >/dev/null 2>&1; then
  TIMEOUT_BIN="gtimeout"
else
  echo "Missing timeout command. Install coreutils (timeout/gtimeout)." >&2
  exit 1
fi

export XDG_CONFIG_HOME="${REPO_ROOT}/neovim/.config"
CI_WORKDIR="${NVIM_CI_WORKDIR:-/tmp/nvim-ci-dotfiles}"
export XDG_DATA_HOME="${CI_WORKDIR}/xdg-data"
export XDG_STATE_HOME="${CI_WORKDIR}/xdg-state"
export XDG_CACHE_HOME="${CI_WORKDIR}/xdg-cache"

mkdir -p "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$XDG_CACHE_HOME"

SPEC_TEST="${REPO_ROOT}/neovim/.config/nvim/tests/spec/kotlin_android_spec.lua"
MASON_TEST="${REPO_ROOT}/neovim/.config/nvim/tests/spec/mason_android_install_check.lua"

run_nvim_step() {
  local name="$1"
  local timeout_seconds="$2"
  shift 2
  local log_file
  local status

  echo "==> ${name}"
  log_file="$(mktemp)"
  set +e
  "${TIMEOUT_BIN}" --foreground "${timeout_seconds}s" "$@" >"${log_file}" 2>&1
  status=$?
  set -e
  cat "${log_file}"

  if [[ ${status} -ne 0 ]]; then
    rm -f "${log_file}"
    return ${status}
  fi

  if rg -q '(Error detected while processing|E[0-9]{4}:|Failed to (setup handlers|run `config`|load))' "${log_file}"; then
    echo "Neovim reported errors in step: ${name}" >&2
    rm -f "${log_file}"
    return 1
  fi

  rm -f "${log_file}"
}

run_nvim_step \
  "Lazy sync" \
  "${NVIM_CI_LAZY_TIMEOUT:-900}" \
  nvim --headless "+Lazy! sync" "+qa"

run_nvim_step \
  "Kotlin/Android config spec checks" \
  "${NVIM_CI_SPEC_TIMEOUT:-60}" \
  nvim --headless -u NONE -i NONE "+lua dofile('${SPEC_TEST}')" "+qa"

if [[ "${NVIM_CI_SKIP_MASON_INSTALL:-0}" == "1" ]]; then
  echo "==> Skipping Mason install checks (NVIM_CI_SKIP_MASON_INSTALL=1)"
else
  run_nvim_step \
    "Mason install and package checks" \
    "${NVIM_CI_MASON_TIMEOUT:-1200}" \
    nvim --headless "+lua dofile('${MASON_TEST}')" "+qa"
fi

echo "All Neovim Kotlin/Android CI checks passed."
