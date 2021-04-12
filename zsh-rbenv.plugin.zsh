_install_or_update_rbenv(){
  test -d "~/.rbenv/.git" &>/dev/null && git -C ~/.rbenv pull &>/dev/null || {
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  }
}

_install_or_update_ruby_build(){
  local version_latest;

  test -d "$(rbenv root)/plugins/ruby-build/.git" &>/dev/null && git -C "$(rbenv root)/plugins/ruby-build" pull &>/dev/null || {
    mkdir -p "$(rbenv root)"/plugins && git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build   
  }

  cat ~/.ruby-version &>/dev/null || {
    version_latest=$(rbenv install --list | head -1) 
    echo "$version_latest" > ~/.ruby-version
  }

  cat ~/.ruby-version &>/dev/null && {
    version_latest=$(cat ~/.ruby-version)
    rbenv local $version_latest
    rbenv global $version_latest
    rbenv rehash
    rbenv install
    eval "$(rbenv init -)"
    gem install bundler
  }

  unset -f version_latest
}

command -v rbenv &>/dev/null || {
  export PATH="$HOME/.rbenv/bin:$PATH"
  command -v rbenv &>/dev/null || _install_or_update_rbenv
  test -f "$(rbenv root)/plugins/ruby-build/bin/rbenv-install" &>/dev/null || _install_or_update_ruby_build
  eval "$(rbenv init -)"
  unset -f _install_or_update_rbenv _install_or_update_ruby_build
}
