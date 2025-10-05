using { /UnrealEngine.com/Itemization }
using { /Fortnite.com/Itemization/AbsoluteDoomItems }
using { /Fortnite.com/Itemization }
using { /Fortnite.com/Itemization/FortniteItemCategories }
using { /Verse.org/Simulation }
using { /Fortnite.com/Playspaces }
(Inventory:inventory_component).GetOwningAgent()<transacts><decides>:agent = {
    var _InventoryOwner : ?agent = false

    loop {
        for (
            Player : Inventory.Entity.GetPlayspaceForEntity[].GetPlayers()
            Agent := agent[Player]
            PlayerRootInventory := Agent.GetInventory[]
            PlayerInventory : PlayerRootInventory.FindInventories()
            PlayerInventory = Inventory
        ) {
            set _InventoryOwner = option{Agent}
            break
        }
        break
    }
    _InventoryOwner?
}

agent_item_base_component := class(item_component):


    CanDrop : logic = true
    Drop<override>()<transacts><decides>: void =
        if (CanDrop?):
            (super:)Drop[]


    PickUp<override>(Inventory:inventory_component)<transacts><decides>:void =
        (super:)PickUp[Inventory]


        #var PickupLifetime<override>:float = 1000.0

    var StoredPlayer : ?agent = false
    GetHoldingPlayer() : ?agent =
        if (StoredPlayer?):
            Player := StoredPlayer
            set StoredPlayer = false
            return Player

        MaybePlayer := option:
            GetParentInventory[].GetOwningAgent[]


        set StoredPlayer = MaybePlayer
        return MaybePlayer
    var FlipFlop : logic = false
    OnBeginSimulation<override>():void = 
        (super:)OnBeginSimulation()
 
        MaybePlayer := GetHoldingPlayer()
        if (Player := MaybePlayer?):
            if (not FlipFlop?):
                set FlipFlop = true
                PickedUp(Player)
                spawn{ControlEquip()}
            else:
                set FlipFlop = false
                Dropped(Player)
        spawn:
            ControlStackSize()
    ControlStackSize()<suspends> : void =
        race:
            SimulationEnded.Await()
            loop:
                Result := StackSizeChangedEvent.Await()
                ItemStackChanged(Result.CurrentStackSize,GetHoldingPlayer())

    SimulationEnded : event() =event(){}
    ControlEquip()<suspends> : void =
        Print("Started loop")
        race:
            SimulationEnded.Await()
            loop:
                Result := EquippedChangedEvent.Await()
                MaybePlayer := GetHoldingPlayer()
                if (Player := MaybePlayer?):
                    if (Result.IsItemEquipped?):
                        Equipped(Player)
                    else:
                        Unequipped(Player)


    OnEndSimulation<override>():void = 
        (super:)OnEndSimulation()
        SimulationEnded.Signal()
        


    ItemStackChanged(NewAmount : int,MaybePlayer : ?agent) : void =
        Print("There are now {NewAmount} items in the stack")

    Initialized() : void =
        Print("Initializing code here")

    Equipped(Player : agent) : void =
        Print("Equipped")

    Unequipped(Player : agent) : void =
        Print("Unequipped")
            
    PickedUp(Player : agent) : void =
        Print("Picked up")

    Dropped(Player : agent) : void =
        Print("Dropped")
