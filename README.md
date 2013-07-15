# Welcome to Rasplay

Rasplay is a web-application that was made to run on the raspberry pi and 
interfaces with the Music Player Deamon (MPD). To allow you to turn your raspberry
pi into a little jukebox. We use ours around the office to play music.

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
way to package the app into a gem yet you'll need to git clone the site.
I would recommend to install it in your /home directory.

```
$ cd ~
$ git clone git@bitbucket.org:wwilimek/rasplay.git
```

## MPD Configuration

There is some small configuration you have to do to get MPD working
correctly with the app.

In your home directory you need to create a .mpd file and a .mpd directory

```
$ echo >> .mpdconf
$ mkdir .mpd/
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

Since Rasplay is still in development, it's best to just run it in development mode.

```
$ cd ~/rasplay
$ script/ci #run all the database scripts and tests
$ rails s #starts the server
```

If you have the MPD service running it should just start working. You can test it by
uploading some songs and adding the song to the queue.

