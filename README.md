# Welcome to Rasplay

Rasplay is a web-application that was made to run on the raspberry pi and 
interfaces with the Music Player Deamon (MPD). To allow you to turn your raspberry
pi into a little jukebox. We use ours around the office to play music.
You can use it on a number of different versions of linux and even OSX.

## Installing MPD

On osx you should be able to install it with brew.

```
$ brew install mpd
```

On ubuntu you can use apt-get

```
$ sudo apt-get install mpd
```

## Installing Rasplay

Since this is still in development and I haven't been able to figure out a
way to package the app into a gem. You'll need to git clone the site.
I would recommend to install it in your /home directory so you don't
have to worry about permission issues.

```
$ cd ~
$ git clone git@bitbucket.org:wwilimek/rasplay.git
```

## MPD Configuration

There is some small configuration you have to do to get MPD working
correctly with the app.

In your home directory you need to create a .mpd file and a .mpd directory

```
$ echo >> ~/.mpdconf
$ mkdir ~/.mpd/
```

### OSX

```
music_directory "/Users/willywos/rasplay/public/music/"
playlist_directory "~/.mpd/playlists"
db_file "~/.mpd/database"
log_file "~/.mpd/log"
pid_file "~/.mpd/pid"
state_file "~/.mpd/state"
sticker_file "~/.mpd/sticker.sql"
auto_update "yes"
auto_update_depth "2"
follow_outside_symlinks "yes"
follow_inside_symlinks "yes"
audio_output {
    type "osx"
    name "CoreAudio"
    mixer_type "software"
}
```

### UBUNTU

```
music_directory "/Users/willywos/rasplay/public/music/"
db_file "~/.mpd/database"
log_file "~/.mpd/log"
pid_file "~/.mpd/pid"
state_file "~/.mpd/state"
sticker_file "~/.mpd/sticker.sql"
auto_update "yes"
auto_update_depth "2"
follow_outside_symlinks "yes"
follow_inside_symlinks "yes"
audio_output {
        type            "alsa"
        name            "MPD ALSA"
        mixer_type      "software"
        mixer_device    "default"
        mixer_control   "PCM"
}
```

Raspberry PI

```
music_directory "/Users/willywos/rasplay/public/music/"
db_file "~/.mpd/database"
log_file "~/.mpd/log"
pid_file "~/.mpd/pid"
state_file "~/.mpd/state"
sticker_file "~/.mpd/sticker.sql"
auto_update "yes"
auto_update_depth "2"
follow_outside_symlinks "yes"
follow_inside_symlinks "yes"
audio_output {
        type            "alsa"
        name            "MPD ALSA"
        mixer_type      "software"
        mixer_device    "default"
        mixer_control   "PCM"
}

```

You can see all the other configurations on the [MPD site](http://mpd.wikia.com/wiki/Configuration).
Make sure to change the music_directory where you downloaded rasplay.

Once the service is configured you have to restart MPD and start it back up again
so it can read the new configurations. You'll also be able to see any errors
in your configuration when the server starts up.

```
Starting up Rasplay
```

Since Rasplay is still in development, it's best to just run it in
development mode for right now.

Modify the connection settings for the MPD service. If you are running
MPD on another server/computer. The defaults are below. 

```
#~/rasplay/config/initializers/rasplay_mpd_init.rb

RasplayMpd.mpd_server = "127.0.0.1"
RasplayMpd.mpd_port = 6600

```

If you have the MPD service running it should just start working. You can test it by
uploading some songs and adding the song to the queue.

```
$ cd ~/rasplay
$ rails s #starts the server
```


## Special Thanks!

@archSeer for creating the most awesome ruby-mpd gem to interface with the MPD
service.  
https://github.com/archSeer/ruby-mpd

@javichito - Creating a cool gem to fetch lyrics. 
https://github.com/javichito/Lyricfy

@buntine - For making a greate ruby gem around the Discogs API.
https://github.com/buntine/discogs

Everyone else who has helped contribute to Rails, and Ruby!
