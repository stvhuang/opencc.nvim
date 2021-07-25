# opencc.nvim

## Installation

Install [OpenCC](https://github.com/BYVoid/OpenCC).

```sh
sudo pacman -S opencc
```

Install `opencc.nvim`.

[packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'stvhuang/opencc.nvim',
  cmd={
    'OpenCChk2s',
    'OpenCCjp2t',
    'OpenCCs2hk',
    'OpenCCs2t',
    'OpenCCs2tw',
    'OpenCCt2hk',
    'OpenCCt2jp',
    'OpenCCt2s',
    'OpenCCtw2s',
    'OpenCCtw2t'
  }
}
```
