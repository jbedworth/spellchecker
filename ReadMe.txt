# "Spelling Service"
-Programming Exercise- Version 1.5 Implementation by John Bedworth, April 2016

The goal is to implement a very simple HTTP web service that provides a RESTFUL spell-checking API on port 8080
that determines if a word is "misspelled" or not; and if it is, give some spelling suggestions.

In this example app, I'm using Rails 5.0.0.beta 3 and Ruby 2.3.0.  Rails 5 has a light-weight
solution for implementing RESTFUL web services.  This app demonstrates some of these features.


## INSTALLATION

### Unpacking
1) Unzip john-bedworth-spellchecker.zip or pull this down from github (https://github.com/jbedworth/spellchecker)
   into a place where you would normally run ruby on rails projects on your *nix box.

        unzip john-bedworth-spellchecker.zip -d ~/projects/
        cd ~/projects/spellchecker

     or

        cd ~/projects/
        git clone https://github.com/jbedworth/spellchecker.git

### Environment Setup
As noted, this is a Ruby 2.3, Rails 5, PostgreSQL application.  If your a Rails Developer, a lot of this is
probably all ready set up, or second nature for you.  Including it here for completeness.

1) For best results, use rbenv or rvm to configure your environment for Ruby 2.3. I personally use rbenv for many
   reasons, not the least of which is that it's light weight and doesn't make heavy-handed changes to your machine.
   For me, it's a combination of habit and preference.  Installation instructions for rbenv can be found at
   https://github.com/rbenv/rbenv

        rbenv install 2.3.0

2) Verify you're running 2.3 in this project's directory by typing:

        cd ~/projects/spellchecker
        ruby --version

3) Ensure RubyGems is up to date

        gem update --system

4) Install Rails 5 beta 3.  This would happpen anyway when we do bundle install, but doing it now gives us the
   opportunity to skip documentation, which is faster.

        gem install rails --version=5.0.0.betat3 --no-ri --no-rdoc
        rbenv rehash

5) I used postgres for the back-end, which is pretty standard for typical Rails apps.  If you don't all ready
   have a server, we need to set up postgres binaries. Using Homebrew on MacOSX makes this pretty easy. If you
   don't have Homebrew set up, you can install it here: http://brew.sh/

        brew update
        brew install postgresql
        mkdir -p ~/Library/LaunchAgents
        ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
        initdb /usr/local/var/postgres -E utf8
        createdb `whoami`

   This should set up and get your local database running, more or less.  On some environments (Ubuntu)
   You might have to install the dev libs and tools by hand to get this working and rails wired in.
   I usually have to fiddle with this part to get it perfect, but on MacOSX with HomeBrew, my PostgreSQL
   setup was a dream right out of the box.  It was almost scary how seamless it was.

   Let me know if you have any issues and I'll try to help you out (especially if your on Ubuntu or
   "gasp" Windows). A good article that I've found useful is:
     https://www.codefellows.org/blog/three-battle-tested-ways-to-install-postgresql

That's it, at this point you should have a genuine development enviornment capable of running any
Rails 5/Postgres app.  On to the fun part!

### Application Installation

1) Make sure you are in the root of the project directory.

        cd ~/projects/spellchecker

2) Gem installation time.  Run your typical bundle install command.

        bundle install

3) Set up the database that holds our dictionary.

        rails db:create
        rails db:migrate
        rails db:seed

4) Go get some coffee.  db:seed is loading over 100,000 entries into our dictionary table from the interwebz.

5) Time to start the server.  No, really, that's it.  If you are running this on a dev-box, it's really just
   unpack the project, setup and seed the database, and run the server.

        rails server

   You can include the -p 8080 if you want to, but it's not necessary since the instructions stated
   that 8080 should be the default port. I configured the server properly to run on, yep, 8080. Note
   that this causes Heroku no end of issues, so I don't recommend deploying to "production" like this.

## RUN AND TEST THE SERVICE

1) Point your browser to the app and have fun!

        http://localhost:8080/spellling/House

   Or use curl.

        curl http://localhost:8080/spelling/$word=House
        curl http://localhost:8080/spelling/House

2) You can run my all of unit and integration tests here:

        rails test

## SUMMARY

That's it, pretty straightforward and standard "install and run a Rails app" stuff.

For the record, I had a fantastic time coming up with a solution to this project, and had even more fun
coding it up.  I really wanted to figure out a way to leverage the power of SQL to handle the
dictionary instead of inventing a bunch of data structures and complicated logic, and I'm really happy tha
this approach worked out.

Again, thank you!

John Bedworth
