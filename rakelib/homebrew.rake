namespace :homebrew do
  task :install => [:brew_install, :brew_update, :brew_upgrade, :packages_install]

  desc "installs homebrew"
  task :brew_install do
    if not File.exists? "/usr/local/bin/brew"
      puts "+++ Installing homebrew"
      sh "/usr/bin/ruby -e \"$(/usr/bin/curl -fksSL https://raw.github.com/mxcl/homebrew/go)\""
    else
      puts "*** homebrew already installed."
    end
  end

  desc "updates homebrew package list"
  task :brew_update => [:brew_install] do
    sh "brew update"
  end

  desc "upgrades all homebrew packages to latest versions"
  task :brew_upgrade => [:brew_update] do
    sh "brew upgrade"
    sh "brew cleanup"
  end

  desc "install packages from the brew directory"
  task :packages_install do
    #read each file in brew directory, assume packages are listed one per line
    package_list = []
    FileList["brew/*"].each do |f|
      file = File.new(f, "r")
      while (line = file.gets)
        package_list << line.chomp if not line =~ /^#.*/ #ignore commented out packages
      end
    end

    package_list.each do |p|

      p = p.split('/')
      pkg = p.pop

      if p.any?
        tap = p.join('/')

        begin
          sh "brew tap #{tap}"
        rescue Exception => e
          nil
        end
      end

      sh "brew install #{pkg}" do |ok, res|
        #do nothing, don't die when brew throws an error if already installed
      end
    end
  end

end
