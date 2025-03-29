if exists("g:loaded_garden")
  finish
endif
let g:loaded_garden = 1

lua require('idle-garden')
