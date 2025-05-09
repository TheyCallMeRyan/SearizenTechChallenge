# Running Repo #
git clone https://github.com/TheyCallMeRyan/SearizenTechChallenge.git

There's a file RobloxProjectTemplate.rbxl if you don't want to compile it yourself. If you do follow the below:

cd SearizenTechChallenge

pesde install

cd scripts

./build.sh

There should now be a file RobloxProjectTemplate.rbxl in SearizenTechChallenge/

# How do I think it went? #

### Overall ###
It works, it meets the requirements, it has a lot of extensibility, but the code is sloppy in a number of places (mostly client-sided scripts as I started rushing towards the end).

### Successes ###
1. Hierarchy - Players have multiple Stances, Stances have multiple Abilities.
This makes it simple to extend the system with more stances, as well as adding more abilities.

2. Activated - Component associated with abilities and stances, makes it very easy to extend the system for better hotkey support
(E.g. abilities and stances could have hotkeys/buttons/ui associated with activating abilities.)
These systems could easily change stances/abilities by setting the Activated tag on them.

3. LocalPlayerId - Useful as part of jecs's component Singletons and made it quick to lookup the entity.

### Failures ###
1. Server Validation - Biggest failure in my opinion - there is none for either damage or cooldowns.
I was pushing the last few minutes at the end and didn't have enough time to add it.

2. Hooks - I realized a little bit after the start that I wanted a collect wrapper to functions for ContextActionService/world changes. 
The demo place provided collect() for RBXScriptSignals, but without a signal I would have had to convert it into a psuedo-signal.

3. Scheduling Systems - Given more time with jecs, I would have liked a more proper scheduler so that systems could define their phase and be loaded automatically.
I went with the scheduling defined in the demo place, but with another day of prep, I would have made the project scheduling less tedious.

4. AnimationTracks - The function to create/change tracks is a bit large and messy, I was running out of time and went for functionality over form.
I also copied it into a second script (which normally I would prefer some sort of shared util for tracks than copying and pasting large functions)
