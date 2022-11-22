# Cargo Semver Update and Tag GitHub Action

GitHub Action that extracts Semver version from Cargo.toml file and updates the file. It also outputs the new semver version.
Updating Major, Minor, Patch:
- Add #major, #minor or #patch to the commit message to update the relevant sermver version.

## Outputs

- `new_version`

  Outputs the new Sember version. example: `0.1.15`

- `new_version_with_v`

  Outputs the new Sember version with the `v` prefix. example: 'v0.1.15'

- `old_version`

  Outputs the old Sember version. example: `0.1.14`

- `old_version_with_v`

  Outputs the old Sember version with the `v` prefix. example: 'v0.1.14'

## Example Usage

You can use action output by setting an `id` field to the step that `uses` this action. For example:

jobs:
  PublishGPR:
    name: Publish Package to GitHub Package Registry
    runs-on: ubuntu-20.04
    steps:
      - name: Checkout
        uses: actions/checkout@v2.4.2
      - name: Cargo Semver Update
        id: update
        uses: CrabMatrix/cargo_semver_update@v1.0.3
      - name: Commit file
        uses: swinton/commit@v2.x
        env:
          GH_TOKEN: ${{ inputs.GITHUB_TOKEN }}
        with:
          files: |
            Cargo.toml
          commit-message: Updating Cargo semver version to ${{ steps.update.outputs.new_version }} # commit message including the new version
      - name: Commit tagger
        uses: tvdias/github-tagger@v0.0.2
        with:
          repo-token: ${{ inputs.GITHUB_TOKEN }}
          tag: ${{ steps.update.outputs.new_version_with_v }} # create new tag with new version that includes the prefix `v`
