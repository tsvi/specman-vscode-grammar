# Specman grammar syntax for VS Code

This repository holds the source code for the Specman (e) HDL verification language for
VS Code.

## Development

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