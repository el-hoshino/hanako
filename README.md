# hanako
Hanako is a command-line tool for macOS to generate a random password.

# How to build
Use archive function from your Xcode application, or just compile the main.swift file like the following line:
`$ swiftc -o hanako main.swift` 
After the binary file generated, put the binary file to /usr/local/bin so that you can always use it from anywhere in terminal. 

# Usage
`$ hanako [options]`

# Options
- -h / --help: Help. (This will ignore all other arguments and won't perform an output.)
- -nu / --no-uppercase: Don't use uppercased string for the output.
- -nl / --no-lowercase: Don't use lowercased string for the output.
- -nn / --no-numeral: Don't use numeral string for the output.
- -nc / --no-copy: Don't copy the result to pasteboard.
- -l [length] / --length [length]: Output length. Replace [length] with a number. Default length is 10.
- -hf [frequency] / --hyphen-frequency [frequency]: Insert a hyphen after every certain characters. Replace [frequncy] with a number. e.g.: abc-def-ghi if you set frequency to 3, abcdefghi if you set frequncy to 0. Default frequency is 0, and hyphens are also counted in the length.
