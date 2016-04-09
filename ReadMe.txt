
Instructions:

1) Unpack the spellchecker.zip file (assuming you got this far since you are reading this...) into a
   directory where you typically develop and/or run rails apps from on your dev machine or server box.
        unzip john-bedworth-spellchecker.zip
        cd spellchecker
2) Now that you have all the appropriate project files, lets make sure your environment is up-to-snuff:
   a) This is a Rails 5 (beta 3) app, which requires Ruby 2.2 or later.  I used 2.3 during development
      but don't think I used any 2.3 language specific features.  For best results, use rbenv or rvm
      to configure your environment for Ruby 2.3.
        rbenv install 2.3.0
   b) Verify you're running 2.3 in the root of this directory by typing
        ruby --version
   c) Ensure RubyGems is up to date
        gem update --system
   d) Still from the root of the project directory, we need to install Rails 5 beta 3.  This would
      happen anyway when we do bundle install, but doing it first gives us the opportunity to skip
      documentation, which is faster.
        gem install rails --version=5.0.0.betat3 --no-ri --no-rdoc
3) I used postgres for the back-end, which is pretty standard for Rails apps.  If you don't all ready
   have a server, we need to set up postgres binaries.
        brew update
        brew install postgresql
        mkdir -p ~/Library/LaunchAgents
        ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
        initdb /usr/local/var/postgres -E utf8
5) Gem installation time.  Run your typical bundle install command.
        bundle install
5) Set up the database.  We're using Postgres for this project.
        rails db:migrate
        rails db:seed
   a) Go get coffee.  db:seed is loading over 100,000 entries into our dictionary table from the web.
6) Start the server.  No, really, that's it.  If you are running this on a dev-box, it's really just
   unpack the project, setup and seed the database, and run the server.
        rails server
   a) You can include the -p 8080 if you want to, but it's not necessary since the instructions noted
      that 8080 should be the default port, I configured the server properly to run on, yep, 8080.
7) Point your browser to http://localhost:8080/spellling/$word and plug away.  Or, go to port 80
   and use a crude html interface.  Or use curl.
8) You can run my unit and integration tests:
        rails test
