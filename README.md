# HyperMind
In a cross between Worms clone and Roguelike, you enter a dreamlike world of abstractions, constructing mental tools to explore - and alter - the mind.

# Requirements
Löve2D 0.10.2 or compatible

# How to Build

1. Update whatever .lua files.

2. Run package.sh

3. Optionally, rename the new .backup file to save it.


# Pro-tips

* Configure your controls in Properties.lua

* If you change the level generating bits, you should probably delete the existing level cache. On Linux, this is ~/.local/share/love/HyperMind/levels/*.png

* Holy hell do not look at the source, though. It is currently very atrocious; I make no excuse.


# Information

Roguelike elements:

* Permadeath

* Procedural world generation

* Complex interaction of objects and environment


Departures from roguelikes:

* No tiles

* Real-time gameplay

* No high fantasy


Minimal feature set:

* Main menu: Continue | Restart

* Infinite world spanning the full range of emotive-cognitive space

* Random generating seed | Specify a seed

* Flat graphics

* Discover and retrieve tool parts

* Construct unique tools of escalating power from the tool parts

* Use the tools to traverse the world

* Use the tools to erase, modify, or create thoughts and feelings

* Save/Load world

* Save/Load inventory

* New procedural sound for each unique tool

* Support for playing MP3's from the game directory


Extended feature set:

* Procedural soundscape mirroring the current emotive-cognitive context

* Immersive graphical experience

* Cooperative and antagonist agents

* Much greater variety in world generation 

* More abilities

* More powerful

* Hot-seat mode

