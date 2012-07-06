namespace :zsh do

    task :install => [:ohmyzsh_install]

    task :ohmyzsh_install do
        # subdir_clone( $home, '.oh-my-zsh', 'git://github.com/robbyrussell/oh-my-zsh.git')
        system "curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh"
    end

    task :zshrc => ['ohmyzsh_install'] do
    	dest = "#{$home}/.zshrc"
    	src = "#{$home}/.dothome/dotfiles/#{base}"

    	if File.symlink? target and (File.readlink(target) == src)
        puts "*** ~/.#{base} already symlinked properly"
      elsif File.symlink? target
        #symlinked but to the wrong place (e.g. I moved directory structure for bootstrapper)
        #just resymlink to repair
        puts "+++ symlink moved, re-linking ~/.#{base}"
        FileUtils.ln_s(src, target, :force => true)
      elsif File.exist? target
        puts "!!! backing up existing ~/.#{base} to ~/.#{base}.original "
        FileUtils.mv(target,"#{target}.old")
        puts "+++ linking ~/.#{base}"
        File.symlink(src, target)
      else
        puts "+++ linking ~/.#{base}"
        File.symlink(src, target)
      end


    end

end

