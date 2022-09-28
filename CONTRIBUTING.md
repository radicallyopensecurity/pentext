# Contributing to PenText

Thanks for taking the time to contribute!

## Pull Requests

PenText uses the [GitHub flow](https://guides.github.com/introduction/flow/) as
main versioning workflow. In short,

1. Fork the PenText repository
2. Create a new branch for each feature, fix, or improvement
3. Send a pull request from each feature branch to the **master** branch

Please create pull requests that are as atomic as possible, and only implement
one feature, fix, or improvement at a time. That makes it easier to review and
merge the changes.

## Style Guide

### Git commit messages and pull requests

All commits and pull requests SHOULD adhere to the
[Conventional Commits specification](https://conventionalcommits.org/). This
allows us, maintainers, to use the tool `commit-and-tag-version` to
automagically create the [CHANGELOG.md](CHANGELOG.md) file.

Conventional commits is a specification for making commit messages machine
readable and informing automation tools about the context of the commit.

### HTML and XML files

All HTML and XML files are formatted with
[zpretty](https://github.com/collective/zpretty)

### Markdown files

All Markdown files are formatted and linted with
[Prettier](https://prettier.io).

### Python scripts

All Python scripts are formatted with
[black](https://black.readthedocs.io/en/stable/).

## License

We want to ensure that PenText remains free and open source software. By
contributing, you agree that your contributions will be licensed under the same
license PenText falls under, [the GPLv2 license](LICENSE).
