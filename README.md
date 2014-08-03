# Cuegrowler

Displays a Growl notification when a song changes in a mix, according to a .cue file.


## tl;dr

    gem install cuegrowler
    
    # play the episode in iTunes
    
    cuegrowler /Users/dtinth/Downloads/Armin_van_Buuren-A_State_of_Trance_674_31_07_2014_.cue



## Installation

    gem install cuegrowler


## Usage


### Using .cue Files

    cuegrowler <path to .cue file>


### Using Description in iTunes

Some podcasts include the tracklist in form of [HH:MM:SS].
`cuegrowler` can parse the tracklist from that too.
Just

    cuegrowler



## Contributing

1. Fork it ( https://github.com/[my-github-username]/cuegrowler/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
