# hanako

Hanako is a command-line tool for macOS to generate a random password.

# How to install

## Using Mint

0. [Mint](https://github.com/yonaskolb/Mint) is a package manager that installs and runs Swift CLI packages. If you haven't installed it yet, install it first.
1. Install hanako via mint terminal command: `$ mint install el-hoshino/hanako`.
2. Done!

## Manually

1. Archive `hanako` target from your Xcode application.
2. After the binary file generated, put the binary file to /usr/local/bin or anywhere you have set as bash path so that you can always use it from anywhere in terminal. 

# Usage

`$ hanako [options]`

# Options

- -h / --help: Help. (This will ignore all other arguments and won't perform any output.)
- -v / --version: Print version number. (This will ignore all other arguments and won't perform any output.)
- -nu / --no-uppercase: Don't use uppercased string for the output.
- -nl / --no-lowercase: Don't use lowercased string for the output.
- -nn / --no-numeral: Don't use numeral string for the output.
- -nc / --no-copy: Don't copy the result to pasteboard.
- -l [length] / --length [length]: Output length. Replace [length] with a number. Default length is 10.
- -hf [frequency] / --hyphen-frequency [frequency]: Insert a hyphen after every certain characters. Replace [frequncy] with a number. e.g.: abc-def-ghi if you set frequency to 3, abcdefghi if you set frequncy to 0. Default frequency is 0, and hyphens are also counted in the length.

# Release Notes

## 1.0.4

- Support Mint

## 1.0.3

- Support Xcode 10.2

## 1.0.2

- Add a version number checking parameter.
- README.md update.

## 1.0.1

- README.md update.

## 1.0.0
Initial release
