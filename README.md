# GitHub Action: Library Version Validation, Pull Request Automation, and Release Creation  

## Overview  

This GitHub Action streamlines version management, pull request validation, and release creation for Arduino library repositories. It ensures that library versions adhere to semantic versioning, automates pull request merges, and creates GitHub releases for validated versions.  

The action validates version progression, checks dependencies, enforces code style rules, and automates the merging and release process.

---

## Features  

- **Semantic Version Validation**: Ensures pull request versions follow semantic versioning conventions, ensuring logical progression (e.g., `v1.0.1` → `v1.1.0`).
- **Automated Merging**: Automatically merges pull requests with valid versions, reducing manual intervention.
- **Release Automation**: Creates GitHub releases with validated versions, including changelog entries.
- **Library Metadata Validation**: Ensures that the `library.properties` file contains all required fields such as `name`, `version`, `author`, `maintainer`, etc.
- **Dependency Validation**: Checks that any dependencies in `library.properties` are in a valid format.
- **Code Style Enforcement**: Uses the Arduino CLI (`arduino-lint`) to validate code style, ensuring consistency with the Arduino standards.
- **Pre-release Version Support**: Allows the use of pre-release versions (e.g., `v1.0.0-alpha`), with a warning if included.

---

## Inputs  

| Input              | Description                                                             | Required | Default                  |  
|--------------------|-------------------------------------------------------------------------|----------|--------------------------|  
| `GITHUB_TOKEN`     | GitHub token for API access to merge pull requests and create releases. | Yes      | `${{ secrets.GITHUB_TOKEN }}` |  

---

## Outputs  

This action does not return direct outputs but performs the following actions:  

- Validates the pull request version against semantic versioning rules.
- Validates library metadata, dependencies, and code style.
- Rejects invalid or duplicate versions.
- Merges valid pull requests.
- Generates a new GitHub release.

---

## Usage  

This action is triggered by the `pull_request` event whenever a pull request is opened, updated, or reopened.  

### Example Workflow  

Below is an example of a workflow using this GitHub Action:  

```yaml  
name: Validate Library Version and Create Release  

on:  
  pull_request:  
    types: [opened, synchronize, reopened]  

jobs:  
  validate-and-release:  
    runs-on: ubuntu-latest  
    permissions:  
      contents: write  
      pull-requests: write  
    steps:  
      - name: Checkout Code  
        uses: actions/checkout@v3  

      - name: Arduino Library Deploy  
        uses: ktauchathuranga/arduino-library-deploy@v2.2.11
        env:  
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}  
```  

---

## Workflow Steps  

1. **Checkout Code**: The workflow uses `actions/checkout@v3` to clone the pull request branch for inspection.  
2. **Version Extraction**: The action extracts the `version` field from the `library.properties` file in the pull request.  
3. **Compare Versions**: The action compares the pull request version with the current main branch version, validating the version progression:  
   - Ensures the new version is greater than the current one.  
   - Validates compliance with semantic versioning.  
4. **Library Metadata Validation**: Checks the `library.properties` file for required fields like `name`, `author`, `maintainer`, etc.  
5. **Dependency Validation**: Checks the dependencies in `library.properties` to ensure they are valid and well-formed.  
6. **Code Style Validation**: Uses the `arduino-lint` tool to ensure code follows the correct Arduino style guide.
7. **Merge and Release**:  
   - Merges the pull request if the version, metadata, dependencies, and code style are valid.  
   - Creates a GitHub release with the validated version and a changelog entry.

---

## Semantic Versioning Rules  

This action enforces strict adherence to [Semantic Versioning (SemVer)](https://semver.org) rules:  

1. **Version Format**: Versions must follow the format `v<MAJOR>.<MINOR>.<PATCH>` (e.g., `v1.0.0`).  
2. **Version Progression**:  
   - **MAJOR**: Incremented for breaking changes, resetting `MINOR` and `PATCH` to `0`.  
   - **MINOR**: Incremented for new features, resetting `PATCH` to `0`.  
   - **PATCH**: Incremented for bug fixes.  
3. **Valid Changes Only**:  
   - A new version must be greater than the current one.  
   - Skipping intermediate versions without justification is disallowed (e.g., `v1.0.0` → `v1.0.2` without `v1.0.1` is invalid).  
4. **Pre-release Versions**: Supports pre-release identifiers (e.g., `v1.0.0-alpha`) for testing purposes, with a warning for inclusion.

### Invalid Examples  

- **Backward progression**: `v1.0.0` → `v0.9.0`
- **Skipping intermediate versions**: `v1.0.0` → `v1.0.2` without `v1.0.1`
- **Invalid version format**: `v1.0.0-rc` (incorrect format without proper pre-release identifier)

---

## Error Handling  

This GitHub Action will reject pull requests that fail the following conditions:  

- Invalid or improperly incremented versions (e.g., backward progression, invalid format).
- Missing or invalid fields in the `library.properties` file.
- Invalid or incorrectly formatted dependencies.
- Code style issues detected by `arduino-lint`.

The action will print the corresponding error message and exit with a non-zero status, which will cause the workflow to fail.

---

## License  

This GitHub Action is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
