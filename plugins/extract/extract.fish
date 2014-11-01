# Taken from: https://github.com/dideler/dotfiles/blob/master/functions/extract.fish
function _extract --description "Expand or extract bundled & compressed files"
  set --local ext (echo $argv[1] | awk -F. '{print $NF}')
  switch $ext
    case tar  # non-compressed, just bundled
      tar -xvf $argv[1]
    case gz
      if test (echo $argv[1] | awk -F. '{print $(NF-1)}') = tar  # tar bundle compressed with gzip
        tar -zxvf $argv[1]
      else  # single gzip
        gunzip $argv[1]
      end
    case tgz  # same as tar.gz
      tar -zxvf $argv[1]
    case bz2  # tar compressed with bzip2
      tar -jxvf $argv[1]
    case rar
      unrar x $argv[1]
    case zip
      set dir (echo $argv[1] | awk -F. '{print $(NF-1)}')
      unzip $argv[1] -d "$dir"
    case '*'
      echo "unknown extension"
      return 1
    return $status
  end
end

function extract --description "Expand or extract bundled & compressed files"
  if _extract $argv
    rm -rf $argv[1]
  end
end
