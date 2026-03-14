# CCMD manpages for UZDoom/GZDoom console

A quick help pages ("manual pages", or "manpages") based on the [ZDoom Wiki console commands page](https://zdoom.org/wiki/Console_command) directly in the engine console.


### Pages

- Just type `man COMMAND` (e.g., `man summon` or `man dumpclasses`) to read all the information about it without needing of a web browser. Usage examples are included!

<img src="https://i.imgur.com/Oy1aj2W.png"/>


### Searching

- You also can type `man-search PATTERN` or just `mas PATTERN` to search for this PATTERN across all known commands.

<img src="https://i.imgur.com/W3kyx11.png">


### Localization

- Supported internationalization, currently available in English and Russian. Feel free to include other languages!

<img src="https://i.imgur.com/YKgpXnL.png">

<br>

## Available console commands

- `man COMMAND` itself: prints a description and examples (if they exist) about the specified COMMAND.
- `man-search PATTERN`: searches through all manpages. Short aliases `mans PATTERN` and `mas PATTERN`.
- `man-list`: lists all known manpages. Short alias `manl`.

<br>

## Autoload

You can add this utiltily mod to autoload section. Find the "Global.Autoload" section and add a line with the actual path to the mod in your engine configuration file:
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
- VkDoom

Compatibility is expected to be a lot better towards the end of development. Planned to support:

- GZDoom 3.3.1+
- LZDoom 3.8.5+
- ZZDoom 2.9.0+
- QZDoom 2.0.0+
