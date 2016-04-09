# "Spelling Service"
-Programming Exercise- Version 1.5 Implementation by John Bedworth, April 06-09, 2016

The goal is to implement a very simple HTTP web service that provides a RESTFUL spell-checking API on port 8080
that determines if a word is "misspelled" or not; and if it is, give some spelling suggestions.

In this example app, I'm using Rails 5.0.0.beta 3 and Ruby 2.3.0.  Rails 5 has a wonderfully simple and elegant
solution for implementing light weight RESTFUL web services.  This app demonstrates some of those features.


## INSTALLATION

### Unpacking
1) Unzip john-bedworth-spellchecker.zip or pull this down from github (https://github.com/jbedworth/spellchecker)
   into a place where you would normally run ruby on rails projects on a *nix box.

        unzip john-bedworth-spellchecker.zip -d ~/projects/
        cd ~/projects/spellchecker

     or

        cd ~/projects/
        git clone https://github.com/jbedworth/spellchecker.git

   If you are reading this, you probably got this far all ready :)

### Environment Setup
As noted, this is a Ruby 2.3, Rails 5, PostgreSQL application.  If your a Rails Developer, a lot of this is
probably all ready done, or second nature to you.  Including it here for completeness.

1) For best results, use rbenv or rvm to configure your environment for Ruby 2.3. I personally use rbenv for many
   reasons, not the least of which is that it's light weight and doesn't make heavy-handed changes to your machine.
   For me, it's a combination of habit and preference.  Installation instructions for rbenv can be found at
   https://github.com/rbenv/rbenv

        rbenv install 2.3.0

2) Verify you're running 2.3 in the root of this directory by typing:

        cd ~/projects/spellchecker
        ruby --version

3) Ensure RubyGems is up to date

        gem update --system

4) Install Rails 5 beta 3.  This would happpen anyway when we do bundle install, but doing it now gives us the
   opportunity to skip documentation, which is faster.

        gem install rails --version=5.0.0.betat3 --no-ri --no-rdoc
        rbenv rehash

5) I used postgres for the back-end, which is pretty standard for Rails apps.  If you don't all ready
   have a server, we need to set up postgres binaries. Using Homebrew on MacOSX makes this pretty easy.

        brew update
        brew install postgresql
        mkdir -p ~/Library/LaunchAgents
        ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
        initdb /usr/local/var/postgres -E utf8

   This should set up and get your local database running.  I always have to fiddle with this part.
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

2) You can run my all of unit and integration tests here:

        rails test

## SUMMARY

That's it, pretty straightforward and standard "install and run a standard Rails app" stuff.

#### The "GOOD"
For the record, I had a fantastic time coming up with a solution to this project, and had even more fun
designing and coding it up.  I really wanted to figure out a way to leverage the power of SQL to handle the
dictionary instead of using a bunch of convoluted in-memory datastructures and one-off logic, and I'm really
happy tha this approach panned out so well.  I haven't used Rails 5 to build a "pure" API Application yet, and
figuring out how to do this was a ton of fun.  I also haven't used PostgreSQL very much before, and while I'm
not using any of it's _cooler_ features here, it was still a lot of fun to play with it instead of MySQL for a
change.

#### The BAD/UGLY:
I feel like I over-commented the code, because I'm a pretty firm believe that clear and concise code with good
naming conventions and consistent styling is self-documenting.  And there are a couple of (fairly minor) edge-case
scenarios and little things that bother me about this implementation
(e.g. my first implementation of coming up with suggestions was waaaay cooler and more like what you would hope
for from a real spellchecker, but, alas, it didn't fit the very explicit _misspelling_ criteria).
I wanted the service to be really resilient when it comes to handling user input, so I originally stripped out
all non-ascii alpha characters, and this led to some cool possibilities (like coming up with correct
suggestions for "ball00n") but also led to false positives, so I took it out.