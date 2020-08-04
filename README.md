My dotfiles

[![Build Status](https://travis-ci.com/adam-gaia/dotfiles.svg?branch=master)](https://travis-ci.com/adam-gaia/dotfiles)

## Initializing a new machine
### Curl
```
curl https://raw.githubusercontent.com/adam-gaia/dotfiles/master/setup.sh > setup.sh
chmod +x setup.sh
bash ./setup.sh
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
