# RGBKlocK
A digital clock that changes color in a RGB-like fashion.

# Description
RGBKlocK is an application that can show the time in the fashion of digital clocks while also constantly changing the color of the time printed on screen in a similar way to RGB PC hardware and peripherals.
This program was originally created to generate random time outputs to use in a music video.
The song was supposed to be included in a small game that I made about reading an analog clock, called [The KlocK](https://krockmakesgames.itch.io/the-klock).
But since the music wasn't playing correctly in the web version of the game, I decided to not use it and instead make it available on Youtube.
There is the [regular version](https://youtu.be/KfmAwJIbOYM) and a [1-hour loop](https://youtu.be/832LqyWc7uc).

# Dependencies
RGBKlocK relies on [Lua](https://lua.org) and the [LÖVE 2D game framework](https://love2d.org).
Please refer to their documentation for proper installation on your system.

# Run
The script can be run the same way as any other LÖVE application, by calling the LÖVE executable with the root folder of the project as argument. Or by calling the LÖVE executable from the root folder of the project with the argument "./".

For more information, such as how to run the application on MacOS, iOS and Android, look at this page from the [LÖVE wiki](https://love2d.org/wiki/Getting_Started).

## Arguments
Calling the program with no other argument will show the current time.
There is only one argument accepted by the program, and only two possible values:
- "random_real" which replaces the current time with random numbers within the realistic time range (From 00:00 to 23:59).
- "random_all" which replaces the current time with random numbers without care if the time value actually makes sense or not (From 00:00 to 99:99).

The time value is updated every 2 seconds, meaning that the current time can be at most 2 seconds late compared to the system's time. In the case of random values, a new value will appear every two seconds.

## Windows
The application will most likely work on Windows but I can't test it since I don't have any Windows installation to test it on.

```Batchfile
cd "C:\game_folder"
"C:\Program Files\LOVE\love.exe" ./
```
or
```Batchfile
"C:\Program Files\LOVE\love.exe" "C:\game_folder"
```
or
```Batchfile
"C:\Program Files\LOVE\love.exe" "C:\game_folder" random_real
```
or
```Batchfile
"C:\Program Files\LOVE\love.exe" "C:\game_folder" random_all
```

## Linux
```Shell
cd /home/you/game_folder/
love ./
```
or
```Shell
love /home/you/game_folder/
```
or
```Shell
love /home/you/game_folder/ random_real
```
or
```Shell
love /home/you/game_folder/ random_all
```

# Build
LÖVE applications can be built into a .love file, which is basically a .zip file containing all the necessary files.
This is done by either using a GUI application for compressing files or by using a terminal command from the root directory of the application:

```Shell
zip -9 -r RGBKlocK.love .
```

Please refer to the [LÖVE wiki](https://love2d.org/wiki/Game_Distribution) for more information.
