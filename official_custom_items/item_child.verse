using { /UnrealEngine.com/Itemization }
using { /Fortnite.com/Itemization/AbsoluteDoomItems }
using { /Fortnite.com/Itemization }
using { /Fortnite.com/Itemization/FortniteItemCategories }
using { /Verse.org/Simulation }
using { /Fortnite.com/Playspaces }
using { /Verse.org }
using { /Verse.org/Assets }
using { /Verse.org/SceneGraph }

#Example usage
#-----------------------------------------------------
# copy this into a new folder and rename the class
#-----------------------------------------------------
my_item := class(agent_item_base_component):

    ItemStackChanged<override>(NewAmount : int,MaybeAgent : ?agent) : void =
        Print("There are now {NewAmount} items in the stack")

    Initialized<override>() : void =
        Print("Initializing code here")

    Equipped<override>(Agent : agent) : void =
        Print("Equipped")

    Unequipped<override>(Agent : agent) : void =
        Print("Unequipped")
            
    PickedUp<override>(Agent : agent) : void =
        Print("Picked up")

    Dropped<override>(Agent : agent) : void =
        Print("Dropped")
#------------------------------------------------------

