# opencc.nvim

## Installation

1. Install [OpenCC](https://github.com/BYVoid/OpenCC), see [link](https://github.com/BYVoid/OpenCC/wiki/Download).

2. Install `opencc.nvim`.

[packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'stvhuang/opencc.nvim',
  config=function()
    require('opencc').setup {}
  end
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

## Usage

TODO
