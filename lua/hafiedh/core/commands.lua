vim.cmd([[
  function! ExtractDatas()
    %s/\\//ge
    g!/datas/d
    %s/.*"datas":{\(.*\)}}.*$/{\1}/e
  endfunction
  command! ExtractDatas call ExtractDatas()
]])
