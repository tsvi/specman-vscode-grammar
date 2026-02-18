# Code behavior
- The source code is a Jinja2 template for a TextMate syntax definition file.
- The template is used to generate a JSON file for TextMate syntax highlighting.
- To generate the JSON file, the build system will take into account the variables defined in the variables.yaml file.

# Build and test
- The build system will use the `build.py` script to generate the JSON file.
- Tests are located in the `tests` directory.
- The tests will ensure that the generated JSON file is valid and meets the expected syntax highlighting requirements.
- The tests are run using the vscode-tmgrammar-test package.

# Refactoring behavior
- Tests and code should NEVER be refactored together.
- The definition of the Specman syntax is available in the `sn_eref.md` file. This is the official reference for the syntax.

!!! Whenever possible, prefer readable and maintainable code over clever or complex solutions.
!!! This can be achieved by using clear variable names.
