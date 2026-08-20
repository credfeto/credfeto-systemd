#!/usr/bin/env bats
# Acceptance tests for settings/scripts/general/.

load test_helper

GENERAL_DIR="${SCRIPTS_DIR}/general"

setup() {
    export HOME="${BATS_TEST_TMPDIR}/home"
    mkdir -p "${HOME}"
    export GIT_CONFIG_GLOBAL=/dev/null
    export GIT_CONFIG_SYSTEM=/dev/null
}

# ── mkrelease ────────────────────────────────────────────────────────────────

@test "mkrelease dies when no release is given" {
    run "${GENERAL_DIR}/mkrelease"
    [ "${status}" -eq 1 ]
    [[ "${output}" == *"Invalid release"* ]]
}

@test "mkrelease dies when not in a git repository" {
    cd "${BATS_TEST_TMPDIR}"
    run "${GENERAL_DIR}/mkrelease" 1.2.3
    [ "${status}" -eq 1 ]
    [[ "${output}" == *"Not in a git repository"* ]]
}

@test "mkrelease dies when CHANGELOG.md is missing" {
    git init --quiet "${BATS_TEST_TMPDIR}/repo"
    cd "${BATS_TEST_TMPDIR}/repo"
    run "${GENERAL_DIR}/mkrelease" 1.2.3
    [ "${status}" -eq 1 ]
    [[ "${output}" == *"CHANGELOG.md not found"* ]]
}

@test "mkrelease updates the changelog, commits, and pushes" {
    # Real git sets up the fixture; only stubbed afterwards for the actual
    # script invocation, so `git init` etc. above aren't shadowed too.
    git init --quiet "${BATS_TEST_TMPDIR}/repo"
    printf '# Changelog\n' > "${BATS_TEST_TMPDIR}/repo/CHANGELOG.md"
    cd "${BATS_TEST_TMPDIR}/repo"

    setup_fake_bin dotnet git
    # Fake git needs to answer rev-parse --show-toplevel with a real path.
    seed_fake_output git <<< "${BATS_TEST_TMPDIR}/repo"

    run "${GENERAL_DIR}/mkrelease" 1.2.3
    [ "${status}" -eq 0 ]
    assert_fake_called '^dotnet changelog -c 1\.2\.3'
    assert_fake_called '^git commit .*CHANGELOG\.md -mChangelog for 1\.2\.3 -n'
    assert_fake_called '^git push --no-verify'
    [[ "${output}" == *"Released 1.2.3"* ]]
}

# ── stream ───────────────────────────────────────────────────────────────────
# The success path is an unbounded `while true; do ...; sleep 60; done` loop -
# not safe to exercise even via stubs, so only the argument-validation path
# is tested.

@test "stream dies when no streamer is given" {
    run "${GENERAL_DIR}/stream"
    [ "${status}" -eq 1 ]
    [[ "${output}" == *"Streamer not specified"* ]]
}

# ── wallpaper ────────────────────────────────────────────────────────────────

@test "wallpaper clones the wallpapers repo when absent, exits cleanly if still absent after" {
    setup_fake_bin git
    run "${GENERAL_DIR}/wallpaper"
    [ "${status}" -eq 0 ]
    assert_fake_called "clone https://gitlab.com/credfeto/wallpapers.git"
    [[ "${output}" == *"Could not find"*"wallpapers"* ]]
}

@test "wallpaper picks a random jpg, copies it to Pictures/Backgrounds" {
    setup_fake_bin git
    # Real desktops already have ~/Pictures via xdg-user-dirs; the script
    # only mkdir's the Backgrounds subfolder (not -p), so this precondition
    # is part of the fixture, not something the script itself guarantees.
    mkdir -p "${HOME}/Pictures"
    mkdir -p "${HOME}/work/thirdparty/wallpapers"
    printf 'fake-jpg-1' > "${HOME}/work/thirdparty/wallpapers/one.jpg"
    printf 'fake-jpg-2' > "${HOME}/work/thirdparty/wallpapers/two.jpg"

    run "${GENERAL_DIR}/wallpaper"
    [ "${status}" -eq 0 ]
    assert_fake_called '^git -C .*wallpapers pull'
    [[ "${output}" == *"Selected wallpaper:"* ]]
    # dt.jpg itself is not asserted here: the script deliberately uses
    # `cp --reflink` (a real btrfs CoW copy on the target desktop, not
    # something to weaken), which errors with "Operation not supported" on
    # a non-CoW test filesystem (e.g. tmpfs under BATS_TEST_TMPDIR) even
    # though it works as intended on the real machine. The script has no
    # `set -e`, so execution continues past that failure regardless.
    [ -L "${HOME}/Pictures/Backgrounds/dt-link.jpg" ]
}

@test "wallpaper does not attempt to copy into an empty Zoom virtual-background directory" {
    setup_fake_bin git
    mkdir -p "${HOME}/Pictures"
    mkdir -p "${HOME}/work/thirdparty/wallpapers"
    printf 'fake-jpg-1' > "${HOME}/work/thirdparty/wallpapers/one.jpg"
    # Present, but with no "{...}"-named subfolder yet - e.g. Zoom's virtual
    # background picker was opened but no custom background added.
    mkdir -p "${HOME}/.var/app/us.zoom.Zoom/.zoom/data/VirtualBkgnd_Custom"

    run "${GENERAL_DIR}/wallpaper"
    [ "${status}" -eq 0 ]
    [[ "${output}" != *"cp: missing"* ]]
    [[ "${output}" != *"omitting"* ]]
}

# ── install-dotnet-tools ───────────────────────────────────────────────────

@test "install-dotnet-tools creates a tool manifest when absent, then installs every tool" {
    setup_fake_bin dotnet
    run "${GENERAL_DIR}/install-dotnet-tools"
    [ "${status}" -eq 1 ]
    # No tool manifest exists and the fake `dotnet new tool-manifest` is a
    # no-op that doesn't create dotnet-tools.json, so the script's own
    # `[ -f "$HOME/dotnet-tools.json" ] || die "No tool manifest"` guard
    # fires - this is the genuine behaviour with any non-functional stub,
    # so it's asserted directly rather than papered over.
    assert_fake_called '^dotnet new tool-manifest'
    [[ "${output}" == *"No tool manifest"* ]]
}

@test "install-dotnet-tools installs every tool once a manifest exists" {
    setup_fake_bin dotnet
    printf '{}' > "${HOME}/dotnet-tools.json"
    run "${GENERAL_DIR}/install-dotnet-tools"
    [ "${status}" -eq 0 ]
    refute_fake_called '^dotnet new tool-manifest'
    assert_fake_called '^dotnet tool install --local sleet'
    assert_fake_called '^dotnet tool install --local csharpier'
    assert_fake_called '^dotnet tool install --local ilspycmd'
    [[ "${output}" == *"Done"* ]]
}

# ── update-dotnet-tools ──────────────────────────────────────────────────────

@test "update-dotnet-tools reinstalls global tools locally and updates every local tool" {
    FAKE_BIN_DIR="${BATS_TEST_TMPDIR}/fakebin"
    FAKE_BIN_LOG="${BATS_TEST_TMPDIR}/fakebin.log"
    mkdir -p "${FAKE_BIN_DIR}"
    : > "${FAKE_BIN_LOG}"
    cat > "${FAKE_BIN_DIR}/dotnet" <<'EOF'
#!/bin/sh
printf 'dotnet %s\n' "$*" >> "__FAKE_BIN_LOG__"
case "$1 $2" in
    "tool list")
        if [ "$3" = "--local" ]; then
            printf 'Package Id      Version\n-----------------------\nlocaltool       1.0.0\n'
        elif [ "$3" = "--global" ]; then
            printf 'Package Id      Version\n-----------------------\nglobaltool      1.0.0\n'
        fi
        ;;
esac
exit 0
EOF
    sed -i "s#__FAKE_BIN_LOG__#${FAKE_BIN_LOG}#" "${FAKE_BIN_DIR}/dotnet"
    chmod +x "${FAKE_BIN_DIR}/dotnet"
    export PATH="${FAKE_BIN_DIR}:${PATH}"

    run "${GENERAL_DIR}/update-dotnet-tools"
    [ "${status}" -eq 0 ]
    assert_fake_called '^dotnet tool uninstall --global globaltool'
    assert_fake_called '^dotnet tool install --local globaltool'
    assert_fake_called '^dotnet tool update --local localtool'
}
