
## Synopsis

CSE 3901: Web Applications - Autumn 2016 - Giles

Project 2: The Game of Set

SET is a fun to play, challenging, fast and addictive! Boasting over 35 best
game awards including MENSA Select, SET can be played anywhere at anytime. Now, 
due to the magic of dynamic Ruby and a REST based HTTP server, you can now
play virtual SET with your 'few' friends in the Computer Science Department!

Length of play - 20 Minutes

Number of players - 1 or more

## Installation

Installation is always a hassle, which is why we have condensed the process into
4 simple steps with the help of the bundle gem!

    #Step 0: Clone Project
        - git clone <repo>
        
Terminal -
    
    #Step 1: Install Bundle
        - gem install bundle
    
    #Step 2: Run Bundle in Repo
        - bundle install
    
    #Step 3: Start Game
        - ruby Game.rb


## Game Set-up

To begin, allow the host to execute the following command in the terminal:

    ruby Game.rb
    
This will launch the game and display the following text:

Welcome to TEMPorary Variable's Game of Set!  We recommend you resize your terminal to full screen.
Would you like to host or connect? (host / connect): 

At this time, please type:

    host
    
or 

    connect
    
If you select host, our multiplayer REST based HTTP server will be launched!  From that point if you would like to connect to it, you must launch another terminal and type connect.

If you select connect - 

    Enter your name: @TypeYourName!
    
    Enter an IP address to connect to: @IPaddressofhost
    
Remember, if you are connecting to a host on another computer, please refer
to your specific operating system instructions for connecting between computers.

Should you opt to play on the same computer, for this prompt enter:

    Enter an IP address to connect to: localhost
    
The final prompt will ask:

    Enter a PORT to connect to (Default: 4567):
    
Enter the PORT that you wish to connect to. For local games, select:

    Enter a PORT to connect to (Default: 4567): 4567
    
OR just hit the return key.

Congratulations! You have just set up the game and are ready to play!

## Game Syntax

When the game begins and everyone has connected, the current state should be 
shown:

Commands: (start), (set <c1> <c2> <c3>), (stuck), (quit), (players), (help)
Connected Successfully! Type 'start' to start the game.
Current Players: (Jeffy) 

Here you are able to see the commands that will be important during game play.

We will now explain the various commands - 

    start
    
When all users are connected, one player must enter the start command to deal
the cards to the game board. **Full screen HIGHLY recommended if playing with multiple computers**

Congratulations! You can now see the cards in play!

    players
    
The players command will list the current players of the game:

    Current Players: (Jeffy) 

When utilizing the help command, the terinal will populate with all commands
again in the case you forget.

    help
    
    Commands: (start), (set <c1> <c2> <c3>), (stuck), (quit), (players), (help)

Notice that each card in play has a corresponding letter beneathe it. 

This is very important! These are the letters you will enter when you find a set!

The set command allows you to progress in the game and win! Make sure you
use 3 of the letters like this:

    set j k l
    
If you are stuck and unable to find a set use the stuck command - 

    stuck
    
We will explain this command further in the 'Playing the Game' section. 

When all users are stuck, a hint action will be initiated. 
    
If you are done playing, you may use the quit command - We are sad to see you go!

    quit

You have completed the reading on the Syntax. Let's learn how to really play 
the game!

## Playing the Game 

SET is a speed game! The object of the game is to submit as many correct
sets as possible to clear the game! You are racing against your 'few' friends, 
so speed is always a factor. 

What exactly is a set?

A SET is three cards where each feature, when looked at individually, is
either all the same OR all different. 

Each card contains for features:

color
    red, purple, or green
shape
    oval, squiggle, or diamond
number
    1, 2, or 3
shading
    solid (@), striped (x), or outlined
    
Pay special attention to the distinction between solid and striped. 

Solid shapes use the @ sign, and striped shapes use the x with the interior.
    
Get ready to work your left and right brain thought processes!

Start the game with the start command - 

    start
    
The game begins!

When you believe that you have found a set, use the set command as discussed
above - 

    set a b c
    
If you are incorrect, you will lose 5 points! Oh no! Make sure you are 
certain of a set if you submit.

For each correct SET, the player will receive 50 points. 

The score board will continuously display - 

    Cards Remaining: 81, Hints:
    Names                          Scores
    1   jeffy                              -5
------------------------------------------------------------------------------------------------------------------------

It will highlight the number of Cards Remaining, the Hints that have been 
in play, and the leaderboard! 

Keep an eye on this throughout the game!
    
Finding a set is the best feeling in the world - 

    You found a set! :D

What happens if you can't seem to find a set?

Use the stuck command -

    stuck
    
If the server recognizes that all players have used the stuck command, two
things could happen:

    - The server checks the game board to see if there IS actually a set
    
        1. There IS indeed a set and the game will display a set over a period
        of a couple of seconds
        
        2. There IS NOT a set on the game board and the computer will deal 
        three more cards
        
Great! We aren't stuck anymore. Keep on playing!
        
Game play will continue until there are no more remaining cards and all of the
sets have been found. 

Thanks to our server, the game automatically updates on everyone's screen 
whether you're playing on the same computer or not!

Remember, at any time you are able to use the other commands discussed above if you
need a reminder!

## Best Practices

Per http://web.cse.ohio-state.edu/~giles/3901/resources/ we have adhered to the Ruby best practices based on the provided resources - 

http://airbnb.io/projects/ruby/

Whitespace

    Soft-tabs
    
    No trailing whitespace    
    
Line Length 

    Condensed when appropriate
    
Commenting

    Block
    
    inline
    
    Class
    
Syntax

Naming

Consistency 

Conditionals

## API Reference

We've integrated multiple useful gems in this project to give it that 'Wow' sparkle:

source 'https://rubygems.org'

    1. gem 'rest-client' - A simple HTTP and REST client for Ruby, inspired by the Sinatra's microframework style of specifying actions: get, put, post, delete.
    
    2. gem 'puma' - Puma is a simple, fast, threaded, and highly concurrent HTTP 1.1 server for Ruby/Rack applications. Puma is intended for use in both development and production environments. In order to get the best throughput, it is highly recommended that you use a Ruby implementation with real threads like Rubinius or JRuby.
    
    3. gem 'sinatra' - Sinatra is a DSL for quickly creating web applications in Ruby with minimal effort:
    
    4. gem 'sinatra-json' - Encodes JSON responses, Sets Content-Type to Application/json, supports multiple JSON backends via multi_json
    
    5. gem 'colorize' - Ruby gem for colorizing text using ANSI escape sequences. Extends String class or add a ColorizedString with methods to set text color, background color and text effects.
 

## Contributors

Team: Frank Dattalo, Jeffrey Rolland, Mohamed Mayow, Elliot Dehnbostel

## WOW FACTORS

TEMPorary Variables went all out for this riveting game of SET. 

Features that take it above and beyond - 

    REST based HTTP Server - This by far is our premier functionality of this
    game. You can play the game on multiple computers, or the same computer!
  
    Colorize with grid set-up - Who would want boring ASCII cards? We don't! This
    gem allowed us to add colors with ease. Putting the cards
    in a grid-like display makes the gameplay seem real and exciting!
    
    STUCK? Aww Shucks! - With the hint functionality, the game will never 
    drag on! 
    
    Leaderboard - It's always a great idea to display the score and the players!

    Simultaneous play - wheher you choose to play on multiple computers or on the same
    computer in multiple terminals, the game will always be the same! Updates are made
    automatically in real time!
    
READY, GET SET, SET! ;)

## TO TEST

To test our multiplayer features, it is recommended to open two terminals.

