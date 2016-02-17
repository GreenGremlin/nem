# ~~sub~~ nem: a delicious way to organize programs

~~Sub~~ Nem is a model for setting up shell programs that use subcommands, like `git` or `rbenv` using bash. Making a ~~sub~~ nem subcommand does not require you to write shell scripts in bash, you can write subcommands in any scripting language you prefer.

A nem subcommand is run at the command line using this style:

    $ nem [subcommand] [(args)]

Here's some quick examples:

    $ nem                    # prints out usage and subcommands
    $ nem versions           # runs the "versions" subcommand
    $ nem shell 1.9.3-p194   # runs the "shell" subcommand, passing "1.9.3-p194" as an argument

Each subcommand maps to a separate, standalone executable program. Sub programs are laid out like so:

    .
    ├── completions       # (optional) bash/zsh completions
    ├── libexec           # where the main and subcommand executables are
    └── share             # static data storage

## Subcommands

Each subcommand executable does not necessarily need to be in bash. It can be any program, shell script, or even a symlink. It just needs to run.

Here's an example of adding a new subcommand. Let's say your subcommand is named `who` Run:

    touch libexec/nem-who
    chmod a+x libexec/nem-who

Now open up your editor, and dump in:

``` bash
#!/usr/bin/env bash
set -e

who
```

Of course, this is a simple example...but now `nem who` should work!

    $ nem who
    qnem     console  Sep 14 17:15 

You can run *any* executable in the `libexec` directly, as long as it follows the `nem-SUBCOMMAND` convention. Try out a Ruby script or your favorite language!

## What's on ~~your sub~~ nem

You get a few commands that come with ~~your sub~~ nem:

* `commands`: Prints out every subcommand available
* `completions`: Helps kick off subcommand autocompletion.
* `help`: Document how to use each subcommand
* `init`: Shows how to load ~~your sub~~ nem with autocompletions, based on your shell.
* `shell`: Helps with calling subcommands that might be named the same as builtin/executables.

If you ever need to reference files inside of ~~your sub~~ nem's installation, say to access a file in the `share` directory, ~~your sub~~ nem exposes the directory path in the environment, based on ~~your sub~~ nem's name. For `nem`, the variable name will be `_NEM_ROOT`.

Here's an example subcommand you could drop into your `libexec` directory to show this in action: (make sure to correct the name!)

``` bash
#!/usr/bin/env bash
set -e

echo $_NEM_ROOT/share
```

You can also use this environment variable to call other commands inside of your `libexec` directly. Composition of this type very much encourages reuse of small scripts, and keeps scripts doing *one* thing simply.

## Self-documenting subcommands

Each subcommand can opt into self-documentation, which allows the subcommand to provide information when ~~`sub`~~ `nem` and ~~`sub help [SUBCOMMAND]`~~ `nem help [SUBCOMMAND]` is run.

This is all done by adding a few magic comments. Here's an example from `nem who` (also see `nem commands` for another example):

``` bash
#!/usr/bin/env bash
# Usage: nem who
# Summary: Check who's logged in
# Help: This will print out when you run `nem help who`.
# You can have multiple lines even!
#
#    Show off an example indented
#
# And maybe start off another one?

set -e

who
```

Now, when you run `nem`, the "Summary" magic comment will now show up:

    usage: nem <command> [<args>]

    Some useful ~~sub~~ nem commands are:
       commands               List all ~~sub~~ nem commands
       who                    Check who's logged in

And running `nem help who` will show the "Usage" magic comment, and then the "Help" comment block:

    Usage: nem who

    This will print out when you run `nem help who`.
    You can have multiple lines even!

       Show off an example indented

    And maybe start off another one?

That's not all you get by convention with ~~sub~~ nem...

## Autocompletion

~~Your sub~~ nem loves autocompletion. It's the mustard, mayo, or whatever topping you'd like that day for your commands. Just like real toppings, you have to opt into them! Sub provides two kinds of autocompletion:

1. Automatic autocompletion to find subcommands (What can this subcommand do?)
2. Opt-in autocompletion of potential arguments for your subcommand (What can this subcommand do?)

Opting into autocompletion of subcommands requires that you add a magic comment of (make sure to replace with ~~your sub~~ nem's name!):

    # Provide ~~YOUR_SUB_NAME~~ nem completions

and then your script must support parsing of a flag: `--complete`. Here's an example from rbenv, namely `rbenv whence`:

``` bash
#!/usr/bin/env bash
set -e
[ -n "$RBENV_DEBUG" ] && set -x

# Provide rbenv completions
if [ "$1" = "--complete" ]; then
  echo --path
  exec rbenv shims --short
fi

# lots more bash...
```

Passing the `--complete` flag to this subcommand short circuits the real command, and then runs another subcommand instead. The output from your subcommand's `--complete` run is sent to your shell's autocompletion handler for you, and you don't ever have to once worry about how any of that works!

## Sourcing commands

Sometimes, you want to source a command instead of executing it in a
subshell. This happen in cases like you want to set environment
variables, or navigate to a directory.

You can tell ~~sub~~ nem to source environments by adding a SOURCE comment in your script:

    # SOURCE

So if you wanted to create something that navigated you workspace:

``` bash
#!/usr/bin/env bash
# SOURCE
# Usage: nem w {directoryname}
# Summary: A quick way to navigate to a folder inside your "workspace" location. 

if [ ! -d ~/workspace ]; then
    mkdir -p ~/workspace
fi

# provide nem completions
if [ "$1" == "--complete" ]; then  
    ls ~/workspace
    exit
fi
cd ~/workspace/$1
```

## Shortcuts

Creating shortcuts for commands is easy, just symlink the shorter version you'd like to run inside of your `libexec` directory.

Let's say we want to shorten up our `nem who` to `nem w`. Just make a symlink!

    cd libexec
    ln -s nem-who nem-w

Now, `nem w` should run `libexec/nem-who`, and save you mere milliseconds of typing every day!

## License

MIT. See `LICENSE`.
