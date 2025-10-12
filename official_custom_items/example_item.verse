using { /UnrealEngine.com/Itemization }
using { /Fortnite.com/Itemization/AbsoluteDoomItems }
using { /Fortnite.com/Itemization }
using { /Fortnite.com/Itemization/FortniteItemCategories }
using { /Verse.org/Simulation }
using { /Fortnite.com/Playspaces }
using { /Verse.org }
using { /Verse.org/Assets }
using { /Verse.org/SceneGraph }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }

example_item := class(agent_item_base_component):
    @editable VFX : visual_effect_powerup_device = visual_effect_powerup_device{}
    ItemStackChanged<override>(NewAmount : int,MaybeAgent : ?agent) : void =
        Print("There are now {NewAmount} items in the stack")

    Initialized<override>() : void =
        Print("Initializing code here")

    Equipped<override>(Agent : agent) : void =
        if (FortChar := Agent.GetFortCharacter[]):
            FortChar.Damage(10.0)
    Unequipped<override>(Agent : agent) : void =
        if (FortChar := Agent.GetFortCharacter[]):
            FortChar.Heal(10.0)
            
    PickedUp<override>(Agent : agent) : void =
        VFX.SetDuration(Inf) #This will add the VFX to the player when they pick up the item
        VFX.Pickup(Agent)

    Dropped<override>(Agent : agent) : void =
        VFX.SetDuration(0.001) #And this will remove it when dropped
        VFX.Pickup(Agent)
