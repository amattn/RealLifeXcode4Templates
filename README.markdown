# Real Life Xcode 4 File and Project Templates

**Maintainer:** Matt Nunogawa ([@amattn](http://twitter.com/amattn) on [twitter][] and [github][])
**version:** 0.9.0

[twitter]: http://twitter.com/amattn
[github]: https://github.com/amattn

Better Xcode file and project templates.  Over a decade's worth of best practices with Cocoa distilled down into fork-tender templates.

### File Templates:

- Improved organization
- Commonly used methods stubbed out, commented
- Headerdoc comments
- Built for ARC

### Project templates:

- More Sane Folder Layout
- Improved Project Navigator Organization
- more TODO

The Project templates are opinionated, and also a work in progress.

The Project templates in general are difficult to test.  The Single View Application template alone has 24 possible outputs for the configuration options.  If you come across a combination that doesn't build or seems not to work, please let me know.

### Easy Install via Git

The easiest way is to simply clone this into your Developer library directory:

    mkdir -p $HOME/Library/Developer/Xcode/Templates/
    cd $HOME/Library/Developer/Xcode/Templates/
    git clone git://github.com/amattn/RealLifeXcode4Templates.git

Updating is simply:

    cd $HOME/Library/Developer/Xcode/Templates/RealLifeXcode4Templates
    git pull

### Install into any Directory

From the directory of your choice, clone the repository

    git clone git://github.com/amattn/RealLifeXcode4Templates.git
    cd RealLifeXcode4Templates

Run the following commands from the directory where you cloned:

    mkdir -p $HOME/Library/Developer/Xcode/Templates/RealLifeXcode4Templates
    rsync --checksum --recursive --delete --exclude=".git" . $HOME/Library/Developer/Xcode/Templates/RealLifeXcode4Templates
    
In order to update, you can use the same rsync command:

    git pull
    rsync --checksum --recursive --delete --exclude=".git" . $HOME/Library/Developer/Xcode/Templates/RealLifeXcode4Templates 

Please note that the above command will overwrite any changes or customizations you may have made.  You can add the `--dry-run --verbose` to get a preview of which files have changed.
