
Instructions:

1) Unpack the spellchecker.zip file (assuming you got this far since you are reading this...) into a
   directory where you typically develop and/or run rails apps from on your dev machine or server box.
   I've test deployed this to heroku if you don't want to install the whole app and just want to test
   it to see if it works (it does).
2) Now that you have all the appropriate project files, lets make sure your environment is up-to-snuff:
   a) This is a Rails 5 (beta 3) app, which requires Ruby 2.2 or later.  I used 2.3 during development
      but don't think I used any 2.3 language specific features.  For best results, use rbenv or rvm
      to configure your environment for Ruby 2.3.  If you're cool and use rbenv like I do, you're all
      set, because I use a .ruby-version file and have 2.3 locked in my gem file. If you're using
      rvm or system ruby, take the appropriate steps to ensure you've got the latest and greatest. Go
      ahead, we'll wait...
        rbenv install 2.3.0
   b) Verify you're running 2.3 in the root of this directory by typing
        ruby --version
   c) Ensure RubyGems is up to date
        gem update --system
   d) Still from the root of the project directory, we need to install Rails 5 beta 3.  This would
      happen anyway when we do bundle install, but doing it first gives us the opportunity to skip
      documentation, which is nice.
        gem install rails --version=5.0.0.betat3 --no-ri --no-rdoc
   e) I used postgres for the back-end, which is pretty standard for Rails apps.
3) Gem installation time.  Run your typical bundle install command, this will probably take a while
   since we're using Rails 5 beta 3. Darn, I should have had you install that without documentation
   before this step...
        bundle install