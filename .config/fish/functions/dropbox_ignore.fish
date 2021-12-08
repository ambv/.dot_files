# Defined via `source`
function dropbox_ignore --wraps='xattr -w com.dropbox.ignored 1' --description 'alias dropbox_ignore=xattr -w com.dropbox.ignored 1'
  xattr -w com.dropbox.ignored 1 $argv; 
end
