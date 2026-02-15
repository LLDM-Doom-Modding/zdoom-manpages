# CCMD manpages in modern \*ZDoom-family ports

A quick help pages (manpages) based on the [ZDoom Wiki console commands page](https://zdoom.org/wiki/Console_command) directly in the game engine console.

- Just type `man COMMAND` (e. g. `man summon` or `man dumpclasses`) to read all the information about it without needing of a web browser!

- _\[Work-in-progress\]_: You also can type `man-search PATTERN` or `mas PATTERN` to search for this PATTERN across all known commands.

- _\[Work-in-progress\]_: Supported internationalization, currently available in English and Russian. Feel free to include other languages!


You can add this ulitily mod to autoload section. Find the "Global.Autoload" section and add line with your actual path to the mod to your engine configuration file:
```
[Global.Autoload]
Path=/path/to/manpages.pk3
```


## Supported engines

Supported in:

- UZDoom
- GZDoom 4.0.0+

Not tested, but most probably supported in:

- LZDoom 4.0.0+
- ZZDoom 2.9.0+
- VkDoom
- QZDoom 2.1.0+

Compatibility is expected to be a lot better towards the end of development. Planned to support:

- GZDoom 3.3.1+
- LZDoom 3.8.5+
- QZDoom 2.0.0+
