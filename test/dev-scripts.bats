#!/usr/bin/env bats
# Acceptance tests for install.d/dev-scripts and install.d/git-environment.

load test_helper

DEV_SCRIPTS="${REPO_DIR}/install.d/dev-scripts"
GIT_ENVIRONMENT="${REPO_DIR}/install.d/git-environment"

setup() {
    export HOME="${BATS_TEST_TMPDIR}/home"
    mkdir -p "${HOME}"
    export GIT_CONFIG_GLOBAL="${BATS_TEST_TMPDIR}/gitconfig"
    export GIT_CONFIG_SYSTEM=/dev/null
    # DEV_SCRIPTS_BIN_DIR is user-writable, so dev-scripts's sudo-avoidance
    # path is exercised - no real root/sudo needed for these tests.
    export DEV_SCRIPTS_BIN_DIR="${BATS_TEST_TMPDIR}/bin"
    mkdir -p "${DEV_SCRIPTS_BIN_DIR}"
}

@test "dev-scripts symlinks every executable script into the bin dir" {
    run "${DEV_SCRIPTS}"
    [ "${status}" -eq 0 ]
    [ -L "${DEV_SCRIPTS_BIN_DIR}/dbenv" ]
    [ -L "${DEV_SCRIPTS_BIN_DIR}/login" ]
    [ -L "${DEV_SCRIPTS_BIN_DIR}/buildcheck" ]
    # preview-config is a non-executable sibling data file - must not be
    # linked as if it were a standalone command.
    [ ! -e "${DEV_SCRIPTS_BIN_DIR}/preview-config" ]
    readlink -f "${DEV_SCRIPTS_BIN_DIR}/dbenv" | grep -qF "settings/scripts/db/dbenv"
}

@test "dev-scripts dies on a basename collision across source directories" {
    mkdir -p "${BATS_TEST_TMPDIR}/fake-scripts-repo/settings/scripts/db" "${BATS_TEST_TMPDIR}/fake-scripts-repo/settings/scripts/development"
    printf '#!/bin/sh\nexit 0\n' > "${BATS_TEST_TMPDIR}/fake-scripts-repo/settings/scripts/db/dup"
    printf '#!/bin/sh\nexit 0\n' > "${BATS_TEST_TMPDIR}/fake-scripts-repo/settings/scripts/development/dup"
    chmod +x "${BATS_TEST_TMPDIR}/fake-scripts-repo/settings/scripts/db/dup" "${BATS_TEST_TMPDIR}/fake-scripts-repo/settings/scripts/development/dup"
    cp "${DEV_SCRIPTS}" "${BATS_TEST_TMPDIR}/fake-scripts-repo/dev-scripts-under-test"
    mkdir -p "${BATS_TEST_TMPDIR}/fake-scripts-repo/lib"
    cp "${REPO_DIR}/lib/common" "${BATS_TEST_TMPDIR}/fake-scripts-repo/lib/common"
    mkdir -p "${BATS_TEST_TMPDIR}/fake-scripts-repo/install.d"
    mv "${BATS_TEST_TMPDIR}/fake-scripts-repo/dev-scripts-under-test" "${BATS_TEST_TMPDIR}/fake-scripts-repo/install.d/dev-scripts"
    chmod +x "${BATS_TEST_TMPDIR}/fake-scripts-repo/install.d/dev-scripts"

    run "${BATS_TEST_TMPDIR}/fake-scripts-repo/install.d/dev-scripts"
    [ "${status}" -eq 1 ]
    [[ "${output}" == *"Duplicate script name"* ]]
    [[ "${output}" == *"dup"* ]]
}

@test "dev-scripts prunes a stale symlink left by a renamed/removed script, leaves unrelated symlinks alone" {
    # A symlink from a prior run, pointing at a script that no longer exists.
    ln -s "${REPO_DIR}/settings/scripts/db/no-longer-here" "${DEV_SCRIPTS_BIN_DIR}/no-longer-here"
    # An unrelated symlink this script must not touch.
    ln -s /bin/true "${DEV_SCRIPTS_BIN_DIR}/unrelated"

    run "${DEV_SCRIPTS}"
    [ "${status}" -eq 0 ]
    [ ! -e "${DEV_SCRIPTS_BIN_DIR}/no-longer-here" ]
    [ -L "${DEV_SCRIPTS_BIN_DIR}/unrelated" ]
}

@test "dev-scripts is idempotent - a second run leaves the same set of symlinks" {
    run "${DEV_SCRIPTS}"
    [ "${status}" -eq 0 ]
    first_count=$(find "${DEV_SCRIPTS_BIN_DIR}" -maxdepth 1 -type l | wc -l)

    run "${DEV_SCRIPTS}"
    [ "${status}" -eq 0 ]
    second_count=$(find "${DEV_SCRIPTS_BIN_DIR}" -maxdepth 1 -type l | wc -l)

    [ "${first_count}" -eq "${second_count}" ]
}

# ── git-environment ──────────────────────────────────────────────────────────

@test "git-environment configures the expected global git identity and behaviour" {
    setup_fake_bin gpg
    seed_fake_output gpg <<'EOF'
pub:u:4096:1:ABCDEF1234567890:1234567890:::u:::scESC::::::23::0:
fpr:::::::::0123456789ABCDEF0123456789ABCDEF01234567:
uid:u::::1234567890::HASH::Mark Ridgwell <credfeto@users.noreply.github.com>::::::::::0:
EOF

    run "${GIT_ENVIRONMENT}"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"Git environment configured"* ]]

    run git config --global user.name
    [ "${output}" = "Mark Ridgwell" ]

    run git config --global user.email
    [ "${output}" = "credfeto@users.noreply.github.com" ]

    run git config --global user.signingkey
    [ "${output}" = "0123456789ABCDEF0123456789ABCDEF01234567" ]

    run git config --global commit.gpgsign
    [ "${output}" = "true" ]

    run git config --global pull.rebase
    [ "${output}" = "true" ]

    run git config --global url."git@github.com:".insteadOf
    [ "${output}" = "https://github.com/" ]
}

@test "git-environment dies rather than enabling gpgsign when no signing key is found" {
    setup_fake_bin gpg
    # No seeded output - fake gpg prints nothing, as real gpg would for an
    # account with no matching key.

    run "${GIT_ENVIRONMENT}"
    [ "${status}" -eq 1 ]
    [[ "${output}" == *"No GPG key found"* ]]

    run git config --global commit.gpgsign
    [ "${status}" -ne 0 ]
}
