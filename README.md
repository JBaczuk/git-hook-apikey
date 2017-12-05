# API Key Git Hook
This tool will scan source files for possible API keys which could incur a securty risk to publish to a public repository.  It will prevent a commit if any keys are detected.

## Installation
### MacOS:

**Globally (all repos):**
- Find global git directory:  
`git config --list --show-origin`  
Check top line of output, should be similar to:  
`file:/Applications/Xcode.app/Contents/Developer/usr/share/git-core/gitconfig	credential.helper=osxkeychain`
- Create a global git hooks directory:  
`mkdir /Applications/Xcode.app/Contents/Developer/usr/share/git-core/hooks`
- Configure a global git hooks path:  
`git config --global core.hooksPath /Applications/Xcode.app/Contents/Developer/usr/share/git-core/hooks`
- Install api-key-hook file:  
`cp pre-commit.sh /Applications/Xcode.app/Contents/Developer/usr/share/git-core/hooks/pre-commit`

**Locally (local repo):**
- Create pre-commit.sh to local repo  
`cp pre-commit.sh .git/hooks/pre-commit`

## Development
Clone this repo, and make a pull request!

To add a regex, just add it as a variable in pre-commit.sh and add the variable to the FORBIDDEN_EXP array.

## Features
The script will scan for keys of the following format:

| Service Provider | Public Key | Secret Key |
| ---------------- | --------- | ---------- |
| GDAX | [a-f0-9]{32} | [a-zA-Z0-9=\/+]{88} |
| Bittrex | [a-f0-9]{32} | [a-f0-9]{32} |
| Poloniex | (([A-Z0-9]{8}\-){3})([A-Z0-9]{8}) | [a-f0-9]{128} |

**Future:**  

| Service Provider | Client ID | Secret Key |
| ---------------- | --------- | ---------- |
| Amazon AWS | AKIA[0-9A-Z]{16} |  [0-9a-zA-Z/+]{40} |
| Bitly | [0-9a-zA-Z_]{5,31} | R_[0-9a-f]{32} |
| Facebook | [0-9]{13,17} | [0-9a-f]{32} |
| Flickr | [0-9a-f]{32} | [0-9a-f]{16} |
| Foursquare | [0-9A-Z]{48} | [0-9A-Z]{48} |
| LinkedIn | [0-9a-z]{12} | [0-9a-zA-Z]{16} |
| Twitter | [0-9a-zA-Z]{18,25} | [0-9a-zA-Z]{35,44} |

## Origins
For a backstory on why this was created, see [How my Bitcoin was stolen - how to prevent it](https://baczuk.com/2017/12/04/how-i-had/)