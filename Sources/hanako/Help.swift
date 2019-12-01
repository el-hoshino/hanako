//
//  Help.swift
//  hanako
//
//  Created by 史翔新 on 2019/12/02.
//

import Foundation

func printHelp() {
    
    let help =
    "hanako is a random string generator.\n" +
    "\n" +
    "Usage:\n" +
    "\t$ hanako [options]\n" +
    "\n" +
    "Arguments:\n" +
    "\t-h / --help: Help. (This will ignore all other arguments and won't perform an output.)\n" +
    "\t-nu / --no-uppercase: Don't use uppercased string for the output.\n" +
    "\t-nl / --no-lowercase: Don't use lowercased string for the output.\n" +
    "\t-nn / --no-numeral: Don't use numeral string for the output.\n" +
    "\t-nc / --no-copy: Don't copy the result to pasteboard" +
    "\t-l [length] / --length [length]: Output length. Replace [length] with a number. Default length is 10.\n" +
    "\t-hf [frequency] / --hyphen-frequency [frequency]: Insert a hyphen after every certain characters. Replace [frequncy] with a number. e.g.: abc-def-ghi if you set frequency to 3, abcdefghi if you set frequncy to 0. Default frequency is 0, and hyphens are also counted in the length.\n"
    
    print(help)
    
}
