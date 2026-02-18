# Development

This code is currently under development. Feel free to contribute.

The easiest way to do that is by using VS Code with devcontainers.
Otherwise, please check that you have the following tools:
- node
- python3
- vscode-grammar-test (`npm install -g vscode-grammar-test`)
- jinja-cli (`pip install jinja-cli`)
- pre-commit (`pip install pre-commit`)

To update the language edit the `specman.tmLanguage.json.j2`/`variables.yaml` files.

Once you finished the edit, run the build script (`Ctrl-Shift-B` in VS Code), this will
generate the final `specman.tmLanguage.json` file, by inserting any variables into the
template file. You can find the intermediary files in the `tmp/` directory.

Run the test task in VS Code to test the new language file.
Check the [documentation](https://www.npmjs.com/package/vscode-tmgrammar-test) for the
vscode-tmgrammar-test tool on how to implement tests.

If you create a new test file, please confirm that the file starts with the prefix `test_*`.

## npm Scripts

| Command | Description |
|---|---|
| `npm run build` | Generate the grammar JSON from the Jinja2 template |
| `npm run build:validate` | Generate and verify the grammar matches what is committed |
| `npm test` | Run all grammar tests |
| `npm run package` | Build and package the extension into a `.vsix` file |
| `npm run release -- <bump>` | Create a branch, bump the version, and open a release PR |

### Examples

```bash
# Run tests locally
npm test

# Build a .vsix to install locally
npm run package

# Dry run — see what would happen without making changes
npm run release -- -n patch

# Release a patch (0.2.11 -> 0.2.12)
npm run release -- patch

# Release a minor version (0.2.11 -> 0.3.0)
npm run release -- minor

# Release a major version (0.2.11 -> 1.0.0)
npm run release -- major

# Start a pre-release (0.2.11 -> 0.2.12, published as VS Code pre-release)
npm run release -- prerelease

# Explicit version
npm run release -- 0.4.0
```

# CI / CD

## Pull Requests

All pull requests against `main` automatically run:
- **Build validation** — `./build.py --validate` ensures the generated grammar matches what
  is committed.
- **Tests** — `vscode-tmgrammar-test` runs all `tests/test*.e` files.

If a PR changes the version in `package.json`, it is automatically labeled `version-update`.
If the PR also has the `pre-release` label, it will be published as a VS Code pre-release.
Once CI passes, the PR is auto-merged via squash.

## Releasing

Releases are fully automated. The workflow triggered by `npm run release` does the following:

1. Create a branch and update `"version"` in `package.json`.
2. Open a PR to `main`.
3. CI runs tests and build validation.
4. The PR is labeled `version-update` and auto-merged on success.
5. On merge to `main`, the release workflow:
   - Creates a git tag (`v<version>`).
   - Creates a GitHub Release with auto-generated notes and the `.vsix` artifact.
   - Publishes the extension to the VS Code Marketplace.

### Pre-release Versions

Use the `prerelease` bump type:

```bash
npm run release -- prerelease
```

This bumps the patch version normally and labels the PR as `pre-release`.
The release workflow will:
- Mark the GitHub Release as a **prerelease**.
- Publish to the VS Code Marketplace with the `--pre-release` flag.

Note: the VS Code Marketplace does not support semver pre-release suffixes
(e.g., `-beta.1`). Pre-release is controlled by the `--pre-release` flag on publish.

### Manual Release

You can also trigger a release manually from the command line:

```bash
gh workflow run release.yml
# Or with pre-release:
gh workflow run release.yml -f prerelease=true
```
