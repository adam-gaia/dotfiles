My dotfiles

[![Build Status](https://travis-ci.com/adam-gaia/dotfiles.svg?branch=master)](https://travis-ci.com/adam-gaia/dotfiles)

## Initializing a new machine
### Curl
```
# "Safe" way
curl https://raw.githubusercontent.com/adam-gaia/dotfiles/master/setup.sh > setup.sh
chmod +x setup.sh
bash ./setup.sh

# For the bold
curl https://raw.githubusercontent.com/adam-gaia/dotfiles/master/setup.sh | bash

# When debugging, make sure caching is off. Otherwise we can't make a change and immediatly execute
curl -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/adam-gaia/dotfiles/master/setup.sh | bash
```

### Git
```
git clone https://github.com/adam-gaia/dotfiles.git
cd dotfiles
./setup.sh
```

### Updating dotfiles only
```
cd dotfiles
./deploy.sh
```
