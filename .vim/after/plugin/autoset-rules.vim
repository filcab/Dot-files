let s:llvm = {
  \  'name': 'llvm',
  \  'cd': '~/dev/llvm',
  \  'pattern': '~/dev/llvm',
  \  'pattern_expand': 1,
  \  'options': {
  \    'makeprg': 'ninja -C ~/dev/llvm/build'
  \  }
  \}
call AutosetAddRule(s:llvm)

call AutosetInstall()
