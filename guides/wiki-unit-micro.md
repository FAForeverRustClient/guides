# Unit micro

By the FAF wiki. [The original](https://wiki.faforever.com/Play/Learning/Unit-Micro).

Microing units can greatly increase their effectiveness, however, it concentrates your attention in one spot. When deciding whether to micro or not, consider the advantages you will gain from that vs. the advantages of spending the APM in another place.

## Basic Commands
This section will cover how to use regular unit orders. Most orders can be given by using right clicks, or by using a hotkey if bound. There is also an orders panel in the bottom left of the screen which shows all the available commands that the selected group can perform. Using a hotkey or clicking on the panel is identical in all cases.

### Move Command
Normally given with a right-click, this can be used to make units that have built power move into reclaimable objects without being disrupted.
- Give move commands with right-click, the hotkey, or the panel on the bottom left.
- Usually used for sending units to attack, instead of the attack command.
- Useful for microing your ACU in forested areas.
- You can queue multiple move orders in a zig-zag to dodge projectiles.
- Dragging move orders can be used to quickly change a unit's direction without worrying about accidentally reclaiming something.
- Dragging can also be used to divert a unit without cancelling the rest of its queue. Use them to avoid units or catch them while on your way to something.

### Attack Command
Given by a right-click while mousing over a hostile unit, or using the bottom-left panel.
- When an enemy unit leaves intel range, land units lose their targets, while air units do not.
- Use this to focus fire on important targets.
- This command is good for intercepting bombers as air units don't lose their targets.

### Attack Move
This command is given with Alt+right-click. It appears as a red attack icon, just like an attack command.
- When units are given this command, they will move to the location, but stop to attack anything in their range.
- Engineers will reclaim anything on their way. This does not apply to SCUs or ACUs.
- When given directly from a factory, engineers built from it will reclaim resources in a large radius.
	- This is one of the best ways to reclaim because it has a much larger range than normal.
	- You can drag this command around to keep its effects while moving to another spot to reclaim.

### Reclaim Command
When having a unit that can reclaim selected, right-click on reclaimable objects to reclaim them, and use the hotkey or the icon in the bottom left panel.
- Manually clicking rocks to reclaim is the fastest way to reclaim, but it takes a lot of attention.
- Using the hotkey or the icon works slightly differently than simply mousing over reclaimable objects.
	- The reclaim command only shows up on its own when zoomed in to a certain level.
	- To ensure it works, zoom in, and use the hotkey or the icon in the panel.
	- Using the hotkey can also allow you to click on the ground, which does nothing.
	- It also means that you can't miss a rock and give a move order without intending.
	- However, using the mouseover method ensures that all commands are on real objects and not missed.

### Assist Command
This causes the units to assist the target in whichever way they can. Right-clicking allied units with unit selected, or using the hotkey or the icon in the panel.
- Combat units will follow their target and stop to engage units in range.
- Air units will form a circular formation around the target and also defend it.
- If the target is damaged, units with build power will repair it.
- Units with build power will also assist any building project of the target.
	- Repair is prioritized over assisting with the building.

### Repair
You can't "normally" issue this command - you need to use the hotkey or the icon in the unit panel. It orders units to start assisting with a building project or repairing it immediately.
- Units will become idle once a building project is complete, unlike the assist command.
- Unlike the assist command, units can start building from a longer range.

### Patrol Command
This will order units to move between a series of waypoints and attack anything on their way. It is the only command which does not get completed and requires at least 2 points. You can use the hotkey or the icon in the panel to use it, or by looping a series of move orders.
- Engineers will reclaim their path. This is less preferable to an attack move as this command doesn't expire when the reclaim is gone.
- This is the only way to get ACUs and SCUs to automatically reclaim an area, as an attack move doesn't work on them in that way.
- You can use this to draw enemy fire by keeping a group of units constantly on the move. Bear in mind if they get in range they will stop, so don't try this with long-range units.
- Air units on patrol will automatically refuel if air staging is present and in range.

### Surface/dive
A feature present for submarines and a couple of special units (f.i. seraphim destroyer). Accessible from the command panel on the bottom left or you can assign it a hotkey in the F1 menu in the game.
- Submerged units will not be able to use any weapon not meant for use underwater, only usable weapons will be torpedoes and tactical/strategic missiles.
- This is a strong tool to fight against the poor naval composition of your opponent, or just fight against a force with weak torpedo potential.
- Submerged units can be attacked with groundfire by weapons with a splash.
- This can be used as a way to fight pathfinding problems and stuck units. A stuck Tempest (t4 battleship of Aeon) is very common, submerging it temporarily can allow you to move it around freely.

### Transport & Ferry Commands
There are several ways you can use your transports, one being for small drops where you want to have more control and another for an automated ferry line.
- You can either select units and right-click on transport to load or select transport and click on units.
- You can set up a sequence of orders for your loading units to perform after they are dropped. For this, shift orders them to load on the transport and then proceed to queue other desired orders. Those other orders will be performed after they get dropped.
- You can drop individual units from a transport, left-click on a unit icon to highlight it while having a transport selected and then click on a place where to drop.
- For ferry command you can issue many ferry orders, not necessarily only 2, this way you can make a more sophisticated ferry path, the transports will follow them all until the last one, where they will drop out all units. For a normal drop command to issue a sequence of move orders, you have to use the actual move order and the drop order only at the end when you want to drop.
- You can put transports to assist your factories, they will gather all the units from them and transport them to the rally points of those factories.
- Alternatively, you can put factories' rally points on a ferry command, units will go straight onto the ferry line after coming out of the factory.
- You can put new transports to assist an already existing ferry command instead of creating new ones.

## How to get units to follow your orders
### Pathfinding
![engie_pathfinding_1.jpg](/images/learning/engie_pathfinding_1.jpg){.align-right}

Pathfinding is one of the most prominent issues of Forged Alliance up to this day. It slows down games, ruins the experience, and causes frustration. Knowing how to deal with it is necessary. It's tightly connected with some of the topics listed below so it's recommended to familiarize yourself with them. Pathfinding in this game is bad and often causes units to collide with each other, lose acceleration, rotate undesirably and block each other's movements. This however can also be used to your advantage.
- Time is especially important early on so you have to orchestrate your base and movements with the thought of having nothing interfering with something else.
- Engineers that are being built in the factory will be facing the direction of the factory's rally point, and if you drag it to the opposite side while the engineer is still in production after it's built it will rotate on the spot causing your factory to sit idle as the current engineer still hasn't rolled off. You either have to change the rally point to the desired position before the engineer is started or change it already after the engineer gets built.
- To gather a large number of engineers in one place, use the factory attack order (alt+right click on the ground while having a factory selected, as illustrated on the screenshot to the right) instead of the standard rally point. This way they will spread out less upon reaching their destination point.
- To have a large number of engineers assisting 1 project issue 1 engineer to assist the project and all others to assist this engineer. With how game mechanics work this will give them much better range and responsiveness.
- You can use the pathfinding wankiness to your advantage by blocking enemies' acu or other units if there is a need. For this place a move order for your units as close to the unit you want to block as possible. If he is trying to escape to a safe zone like water, place units in between him and the water. This is especially strong using the spread move order which is explained below.
- Walls are absurdly strong in the face of big unit numbers as they cause those units to cluster and slow down significantly.
- To lower the effect of pathfinding instead of issuing one big move order for your entire force, select it by parts and issue several move orders to slightly different destinations so they don't get in each other's way.
- If there is ever a potential danger to your ACU, make sure you are free to move and dodge. Standing in the middle of 100 engies when an air snipe is coming at you is not the smartest idea.

### Acceleration
All units in FA require a small window of time to accelerate to the maximum speed.
- For engineers and ACU it's usually better to have as few individual movements as possible while expanding. For example, if you can build 2 mexes while standing on 1 spot in between them, it's recommended to move there and build from there as opposed to stopping to build 1 mex, then losing time to accelerate and move up to the 2nd one (unless you are coming from a direction where you can build 1 of the mexes fast but have to walk quite a bit to build 2nd).
- Try to not have your units collide as it will make them lose their acceleration and sometimes even rotate.
- Try to not have any units collide with your ACU while chasing the enemy's ACU for the kill. It's essential to keep him in range and losing your acceleration can cost you the game. This works both ways however, try to block the enemy's commander as much as possible.
- There sometimes comes a situation when you are chasing an enemy's ACU with a GC or other experimental. While moving, it will target random units so you have to stop and target-fire an ACU. Try to first get as close as possible without actually allowing the enemy to escape and then stop and target his ACU when you are sure you are going to kill him without having to move and lose time to accelerate again.

### Rotation

Units in FA are divided into units with a turret that can rotate the turret and the body separately, and units with their weapons merged into the body, which means they have to rotate their whole body to change the direction of fire.
- Rotation doesn't play much role with units with at least medium-speed rotating turrets - when the rotation speed is greater or equal to the turn rate of the unit.
- Versus units with slow rotation speed, like Cybran t1 bot Mantis, you can try to get in a very close range and circle, it's hard to execute but will cause the mantis to prove useless.
- If you are on a receiving end and have units with slow-rotating turrets try to not micro them much, as any sort of change to the direction of movement will rotate their bodies quickly while turrets will need time to get back in the firing position, losing valuable DPS.
- Blocking units can cause them to act weird and rotate undesirably, useful versus ACUs.
- Some units like Cybran destroyers have their turret only rotating a limited amount of degrees (can't shoot backwards) which means they are defenceless when retreating. If you can overrun the Cybran navy and force them to retreat you will be in an advantageous position.
- Some units have a set minimal range of fire. If those units have a limited turret that cant rotate 360 degrees, it can result in an opportunity to abuse a pretty absurd and overpowered "mechanic" of getting pretty much in the face of this unit, rendering it useless, to start shooting this opposing unit would need to get out of the minimal range but since it's turret doesn't allow it to shoot backwards while trying to move away it results in a very one-sided fight. A good example would be getting right in the face of Seraphim's T4 bot with the GC.

### Formation basics
In FA you have 4 main types of movement you can use.
- Standard move order - all units on their max speed will try to get to the destination point where they will gather in a formation.
- Attack move - using either alt+right click or attack move from the menu on the bottom left, acts the same as move order but units will stop to kill any enemy on their way. It's recommended to issue this order via alt+right click instead of the attack move from the order menu because if you have your units on ground fire it will cause them to attack the selected point of the map instead of the attack moving to it. Alt+right click doesn't have this issue. Useful to clean up raids and such but is very weak against artillery and anything with a splash.
- Formation move - issued either by holding the right mouse button (you can use the left mouse click after the "phantoms" of units appear to change the type of formation) or holding ctrl and right-clicking, this one, however, doesn't allow you to change the formation type. In this mode, units will stay in formation up to their destination and will move with the speed of the slowest unit within the group. It's rarely used because of the speed deficits and difficulty of setting it up properly. When using ctrl-right click even the slightest change of move point will cause the whole formation to rotate, causing disorder, holding the right click will allow you to fine-tune the formation but requires some time. In some cases however this can be a really good move to use, it has been proven to be fairly strong.
- Spread the attack, in more detail below. Allows units to ignore pathfinding and get an individual move order for every unit. Makes them bunch up upon reaching the destination making them extremely vulnerable to splash.

### Target Priorities and Retention
Different units have different priorities which sometimes can play to your advantage and sometimes lose you the game. This mechanic is very prominent since FA units can shoot on the move, but can't target fire while moving.

- If you don't have to move and are not sure what will your units prioritize you can use target fire or attack move depending on the units you have, target firing weak units with something that has big overkill potential isn't the best idea.
- In big experimental+T3 force encounters in 9/10 cases it's best to prioritize and kill the T4 first before it gets any veterancy.
- If all units in range are of the same priority your unit will target the one it can lock on the fastest.
- You can and should use this concept above when chasing an enemy acu for the kill with your acu. Your com might be targetting other units, in this case, target his commander and when your ACU has its gun pointed at the enemy ACU proceeds with the move order again, it now should be shooting the com again. Although this technique is not very consistent.
- Try to not leave bombers unmicroed, their first target will be mexes while most likely you want to kill engies.

### Reload time
To effectively micro you need to know your units. Their firing cycles are a part of essential knowledge.
- Units with big alpha-strike (slow reload and big damage) are usually very powerful especially if you can use the tactic "hit and retreat" then come back and repeat. The enemy will deal less damage over this short period your forces are engaging.
- Units with big alpha strikes and slow reload have the disadvantage of overkilling their targets, which is why you should carefully consider when target-firing has merit.
- Units with fast fire rates are very good at finishing off damaged targets and not getting any overkill. They are usually good versus lower-tier units and spam.

If you meet frontloaded units of your opponent you have to not allow them to use the "hit and retreat" tactic and stay in range. If possible try to make them overkill your units.
- It's useful to roughly memorize the fire cycle of bombers so that in critical moments you can micro them efficiently and maximize the damage.
- You can dodge not only slow-firing units but also greatly reduce the damage of fast-shooting ones by zig-zagging.

### Fire states
In FA there are 3 fire states.
-![return_fire.png](/images/learning/return_fire.png) Return fire - the default fire mode, acts as you would expect it to, all units start engaging as soon as they can.
-![ground_fire.png](/images/learning/ground_fire.png) Ground fire - the same as return fire with 1 exception, if you use the attack command on the ground units will attack the ground spot instead of attack moving to that point. This is why it's recommended to use alt+right click for attack moving.
-![holdfire.png](/images/learning/hold_fire.png) Hold fire - turns your units into pacifist activists of modern society and puts pink glasses on them. Useful when you want to sneak some stealthy units through and don't want to give yourself out by accidentally shooting something. Used with units like Monkeylord (cybran T4). Alternatively can be used to stop accidental team damage.

### Radar vs Direct visual; Stealth, Cloak, Omni, Radar, Sonar, Jammer

There are 2 main visions in the game: direct vision and radar vision. Direct vision is present in all units and is what they can "see". Radar vision can be divided into radar and sonar vision. There are also 2 types of concealing technology: stealth and cloak. Stealth hides you from both radar and sonar vision. The cloak hides you from direct vision. If you can get both (on Cybran Commander for example) the only way to spot you would be using an omni-vision.
- Direct vision shows which units are present, what kinda units they are and other info such as HP. It does not detect submerged units.
- Radar vision spots all non-stealthed land, air and surfaced naval units, but only identifies a unit type (land/sea/air), not the exact unit. It does not detect submerged units.
- Omni vision is the type of radar vision that uncovers all stealthed and cloaked units. Present on all commanders, t3 radar, spy planes and GC (aeon T4 bot).
- To fight stealth you either need to keep a constant direct vision on them or to have an omni sensor nearby.
- Some units like cybran T1 Scout have a cloak but no stealth, to see them you just need to have a radar.
- Seraphim T1 scouts if put on hold fire mode get cloak and stealth if not moving and are extremely hard to discover.
- Sonar spots any emerged and submerged navy that doesn't have stealth.
- Submerged units can't be spotted with direct vision if your units are looking while standing on the ground. They can be seen if you go into the water, however.
- In addition to this, units have a water vision radius. this is the same as normal vision but can detect submerged units. Typically it has a shorter range. There is no UI to distinguish it from normal vision.
- Cybran have a T3 perimeter monitoring system which gives direct vision in solid range but you still need to have an Omni as this direct vision doesn't help vs cloak and underwater units.
- Jammer is a feature present on some units like the UEF t1 frigate, which creates fake radar signatures making it seem as though you have more units than you do.

### Weapon range vs Visual range

Units don't have the same vision range as the weapon range. Most of the time your weapon range is much greater than the vision range. This means that to effectively make use of your range you need to have a constant radar coverage of the area near your units.
- Always mix in some land scouts with your land forces, especially since it's important for aeon on the t1 stage, as their auroras have more range than other t1 units and to benefit from that you need to be able to shoot farther than your direct vision sees.
- Try to have as many radars as possible, the t1 radar is very cheap and extremely necessary.
- Always have a sonar or frigates (they have sonar and radar) when playing navy.
- This mechanic becomes much more obvious when you get some high-tier artillery as they have immense range but standard small vision, you will most likely need omni and air scouts to effectively use your arty.

### Firing randomness

In FA shooting mechanics are not hit-scan and you can dodge any projectile. They of course have their physics. In general, this randomness is negligible on most units but it's useful to know which units have big firing randomness to not get disappointed in the critical moment.
- The bigger the range the more effect firing randomness will have, this is why T3 artillery and such are usually not very accurate.
- You can try to use ground fire to slightly change the target of fire if you see that your units are misbehaving and not getting their shots in the proper place.
- Firing randomness is most prominent on artillery-type units but is also present for units with direct fire. A good example would be a cybran destroyer, it often misses a lot of shots when firing at small targets, so be careful with choosing your target.

### EMP

EMP is a mechanic that allows you to stun enemy units for a short period. It's rare and only a few units have it.
Aeon ACU upgrade: Chrono dampener
Stuns when ACU shoots, has a separate reload time
- Cybran t1 arty, medusa - will stun any t1-t2 unit (including navy and air, excluding buildings) that it hits directly. Very powerful in big numbers.
- Cybran t3 bot, loyalist - will explode and stun any enemy units nearby after its death. By the time of writing this guide, it stuns everything including even ACUs and even some air units. This is potentially to be rebalanced.
- Cybran t2 transport, firefly - has a weak stun gun that will shoot and consistently stun single units up to the t2 tier. Rarely useful but you can try something creative with it.
- Cybran nuke - has an EMP radius that slightly exceeds the damage radius. A commander lucky enough to escape the nuke can be air-sniped more easily while stunned.
- Aeon t1 bomber - stuns weak units over a short period.
- Aeon commander upgrade, Chrono dampener, will continuously stun all units except T4, ACU and buildings upon your commander shooting. Trivia: Technically not a real EMP, since the stasis freezes the units in time.
- Having a personal shield doesn't stop the EMP.

### Individual Units vs Groups

- Individuals - are easy to micro, and don't have pathfinding problems except getting stuck in terrain.
- Attack Move, Patrol, Assist - If ordered to a big group of units they can easily misbehave, for instance, an ASF force put on patrol will chase a single spy plane flying by and suicide into enemy cruisers. If assisting something big groups of units spread out a lot which can be used to advantage (avoiding splash) but also disorganises your forces. Engineers of course act differently, they clump up to assist in the building of something. On attack move units can clump up and become a target for splash.
- Order Sequences - we already looked into unit behaviour using different movement types in the Formation basics. Big unit groups as a result of bad pathfinding tend to get messy and get in the way of each other when executing movement orders, this especially stands for sequences of orders. This is why if you are in big face-to-face engagements it's recommended to give small orders so that the formation of units doesn't break.

The default hotkey for "spreading" is shift+g. To do it you have to select a group of units, issue an order and still hold shift using the spread command.

- Group Spread Attack - Select a group of units, holding shift queue several attack orders on different enemy units and then use the spread command. Now using a special algorithm your attack sequence will get shuffled for each unit, resulting in your force attacking all of the queued enemy units right away instead of one after another. Useful when you have units with a splash to hit many different units at once.
- Group Spread Move - As illustrated in pictures, issue a move order for your force then press the spread command and the move command will split into individual move commands for every unit. The way game mechanics work this will allow them to basically ignore pathfinding and each unit will move to the destination point as quickly as possible. The downside is that upon reaching your destination your units will be very clumped up and if you don't pay attention anything with a splash can devastate them.
