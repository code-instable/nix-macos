fd --base-directory "/nix/store/" -j 8 --extension pc | 
  lines |
  each {|line| $line | path dirname} |
  where {|it| $it | str ends-with "lib/pkgconfig"} |
  uniq |
  sort |
  each {|path| $"/nix/store/($path)"} |
  str join ":" |
  save --force "data/PKG_CONFIG_PATH-cache.txt"
  # overwrite the previous file
