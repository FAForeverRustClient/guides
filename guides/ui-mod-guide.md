# UI mod guide

By Wilson. [The original](https://app.notion.com/p/UI-Mod-Guide-22995eec16af802b8f8ff482f934a5aa).

# UI Mod List

---

The following list is a conglomerate of what our trainer Wilson likes to use himself, and/or suggests to his trainees for specific reasons. Recommended mods are marked with “***”.**

## **ReUI**

---

- ReUI*****
    - The base mod and foundation to run all “satellite mods” available for ReUI.
- ReUI.ActionsPanel*****
    - Provides you with a customizable panel in the bottom right corner of your screen, next to the construction panel.
    - As of now (April 2026), there are the following mods available to display in the ReUI.ActionsPanel:
        - ACU Enhancements
        - Factory Templates
- ReUI.Construction
    - According to the author, it has way better performance than the old construction menu.
    - Features a useful hotkey for selecting units on transports
- ReUI.Construction.Template
    - Add-on for ReUI.Construction providing the abilty to manage your templates
- ReUI.Economy*****
    - Replaces the default economy bar at the top left of the screen. While you had to right-click the mass or energy value to display your relative build efficiency, both absolute and relative numbers are visible at the same time.
    - If you additionally install “Economy middle”, you can set the economy bar to be on display top mid instead of top left (default).
- ReUI.MissilePanel
    - Adds TML, SML, Yolo (incl. naval ones) icons to the ActionPanel to directly launch from there without having to find the actual unit / structure.
- ReUI.Reclaim*****
    - It declutters the screen by hiding the reclaim value of everything worth ten mass. It does still show the green mass icon though. Thereby, you’ll able to spot and prioritize high value reclaim even easier.
    - Auto-toggles reclaim labels when in reclaim mode
- ReUI.Score*****
    - Replaces the default scoreboard.
    - Provides more display options, e.g. the amount of mass / energy your team mates have in storage
    - Lets you easily transfer units or resources to team mates.
    - Allows for switching POV in replays and in observers.

Soon:

- ReUI.Hotbuild
    - Lets you create your own hotkeys
    - The predecessor “Hotbuild Overhaul” still works, and it seems to have like 90% of the functions
- ReUI.Minimap
    - Lets you lock the zoom-level
    - Auto-adjusts size to map size

*Further information on ReUI can be found here. This forum thread also covers some of the other mods made by 4z0t mentioned below.*

## Target Prioritization

---

- Advanced Target Priorities (Tweaked)*****
    - targeting specific key unit / structure types via popup menu / hotkeys.
    - Can be useful to preemptively target specific unit types, e.g. other artillery with your artillery so your fire base (on a plateau or such) does not die as easily.
- Specific Target Priorities*
    - Better than the default “target priority” hotkey, as it by default lets you target unit categories (e.g. all point defenses instead of a faction specific one)
    - Double-clicking the hotkey lets you target the specific unit type instead of the category
    - Double-clicking the ground resets the target priority to “default”.
    - It seems like you can run it alongside “Advaned Target Priorities”.

## Selections

---

- Advanced Selection Extension*****
    - provides you with options to exclude specific unit types from being selected when dragging a rectangle for unit selection
    - provides you with options to filter domains
    - Recommended: Also install “Selection Fix” (ASE might cause the problem of not being able to select SOME units, this is the fix)
    - Requires: UI Mod Tools
- Engineer Alt Selection*****
    - Hold “Shift” + “Alt” to select engineers only when dragging a rectangle. Super useful if you want to select all engineers in a certain area, e.g. your base.
- Selection Info*****
    - Provides you e.g. with the information of what you have spent on selection units / structures, how much mass they’ve killed and some combat stats
        - Very useful for replay reviews and finding out what players have spent on e.g. fire bases
        - Very useful for eyeballing how much build power you need to pause while stalling
        - In the latest version, it also shows mass reclaimed for engineers.

## Icons

---

- Calibers Complete Icons Mod
    - Alternative unit icon set for 2k+ resolution (50% increased icon size)
    - The author does partially provide icons for smaller / bigger resolutions as well. These are available as independent mods on the vault. Search for author “Caliber” and you cannot miss them.
- Idle Engineers Light*
    - Highlights idle engineers and factories on screen
    - Do not use the “black overlay” for engineers, as it is well-known to cause partial black screens.
    - Requires “UI Mod Tools”
- Penguin's Icon Mod*
    - Highlights Nukes, SMD, TML in green / yellow color
    - Must not be used when running “Calibers Complete Icons Mod”
- Redux ACU Icons
    - Boldly highlights the ACU.
    - If you are looking for a less bold option, “ACU Highlight” might do the trick for you.

## Misc

---

- Advanced Key Actions
    - Provides you with some context-based hotkeys.
- Advanced Mini Map
    - Cleaner, more modern look and feel
    - Matches the ReUI aesthetics.
- Auto Hide UI Menu Elements
    - Starts the game with collapsed menu and multifunction bar
    - If you want to keep the menu uncollapsed, try “Hide Multifunction Bar” instead
- AutoOvercharge
    - When hovering over enemy units, it automatically switches to OC if available (RMB = regular attack, LMB = OC)
    - Works best when combined with target priority mods.
    - Requires ReUI
- Ctrl*****
    - Provides you with the option to hold CTRL in order to keep issuing move commands, instead of accidentally clicking reclaim
    - Provides you with the option to hold CTRL and right-clicking in order to copy orders from one unit to another.
- ECO UI Tools
    - The most useful feature is the mex panel diplaying the current state of your mexes, and also progress bars for your upgrading mexes.
        - The mex panel is not draggable, you might want to adjust the position by hard-coding the coordinates into one of the mod files. Go to mods > EUT > modules > mexpanel.lua and edit the “left” and “top” coordinates (it’s pixels) pretty much at the bottom of the file.
    - Requires UI Mod Tools
- Enemy Tagger
    - By default, double-clicking (LMB) tags enemy units and structures with their names (optional: also with timestamps and progress in percent).
    - useful for team games, saves APM.
- Instant Assist*****
    - Assisting engineers using their full assist range instead of trying to get as close as possible to the object they’re assisting
- Instant Capture*****
    - Uses full capture range instead of crawling next to the enemy unit before starting to capture
    - Requires Instant Assist
- Rings For All*****
    - Provides you with all the option to display all sorts of rings / range when hovering over structures and units. This helps to avoide PD range, edge nuke, and so on.
- Smart OC*
    - When Auto-OC is activated, it won’t fire if you’ve selected your ACU. You’re in the driver seat. It will automatically continue to Auto-OC once you’ve deselected your ACU.
    - We highly recommend mostly relying on manual OC though, as it allows for being in control of your energy drainage. If you are somewhat “short” on power, you better abstain from using Auto-OC at all.
- Start With Land Factory*
    - Does what the title says. You want to start with a land factory in like 90% anyway. It saves a click.
- TeamInfo Share
    - Displays / shares information about Nuke / SMD / Experimental completion with your team (needs activation through in-game menu) in the same style the ACU upgrades are displayed - timer instead of progress bar.
    - Only players having the mod installed themselves will see the information
    - Requires: UI Mod Tools
- UI Mod Tools*****
    - Some UI Mods require it. It’s basically an auxiliary mod enabling them to create a menu entry for mod options.
- ZeP_MiniMapZoom*****
    - Auto-disables MiniMap when fully zoomed out.

<aside>

# About UI Mods

---

While UI mods do not directly influence the game mechanics or make you a better player, they can e.g. change the way units are being managed, or the visibility of strategic icons quite a bit. This means they might help you spending your APM in a more efficient way, and thereby help you focusing on more crucial parts like better decision making.

Unfortunately, most mods in the official vault are poorly described. Nevertheless, you should carefully read the descriptions and comments, as some mods are well-known to have issues like ending up with a black screen. Others are well-known to cause problems when combined with specific mods. If possible, we recommend using mods from as few authors as possible to avoid problems. What you usually want to avoid at all cost is running several UI mods manipulating the same thing, for instance several scoreboard mods, at once. This will most likely cause problems.

</aside>

<aside>

# Mod Activation

---

Once you have downloaded a mod, it is toggled “off” by default.

To activate a specific mod, go to the “Mods” vault in the FAF Client and search for the “Manage active mods” button. Activated mods are highlighted with a blue accent color.

- See screenshot

    !2025-07-07_163124.png

Also, you could create a custom lobby (“Play”  > “Custom games” > “Create game”) and activate a mod through the “Mods” column. Be aware, there are different tabs for UI and SIM mods in there.

- See screenshot

    !2025-07-07_163243.png

</aside>

<aside>

# Mod Tweaking

---

Most UI mods do not provide an in-game menu to change settings. If you want to apply changes to mods (e.g. panel position on screen), you sometimes have to hard-code them into the file(s). In most cases, this is not particularly difficult if you have a general understanding of how this works. However, you want to create a backup first before start tweaking mods.

Be aware, even a single missing quotation mark in the code might cause troubles like the game not starting at all.

</aside>

# Getting Started

---

As a future Dojo member, you need to join our Discord server, and you want to register on Notion. Both is 100% free.

<aside>

## Discord

---

Discord is the “basic package”. You can reach out to people, find replay reviews, and more.

!*Click on the image above to join our Discord server.*

*Click on the image above to join our Discord server.*

</aside>

<aside>

## Notion

---

Notion is the “premium package”. Getting assessed is required for participating in our in-house events.

!*Click on the image above to register on Notion, and thereby become part of our tier lists.*

*Click on the image above to register on Notion, and thereby become part of our tier lists.*

</aside>

(About Ui mods, mod activation, modtweaking steht in einer rechten spalte - der rest ist link)
