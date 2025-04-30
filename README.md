# Setup guide

### Download and Install
#### Create directory to store Neovim config
```
  # clear existing config
  rm -fr ~/.config/nvim

  # create directory
  mkdir -p ~/.config/nvim
```
#### Clone the githug repository
```
# go to the config directory
cd ~/.config/nvim

# clone the repo. notice a . (dot) at the end of the command
git clone https://github.com/ashikur-rahman-fh/nvim-config.git .
```

### Requirements
```
gcc
npm
python
```


#### Source all the plugins
```
make install
```

#### Help
```
make help
```


### Update
```
make update
```
