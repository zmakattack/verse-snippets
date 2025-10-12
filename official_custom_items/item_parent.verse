using { /UnrealEngine.com/Itemization }
using { /Fortnite.com/Itemization/AbsoluteDoomItems }
using { /Fortnite.com/Itemization }
using { /Fortnite.com/Itemization/FortniteItemCategories }
using { /Verse.org/Simulation }
using { /Fortnite.com/Playspaces }
using { /Verse.org }
using { /Verse.org/Assets }
using { /Verse.org/SceneGraph }

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

agent_item_base_component := class(item_component,has_description,has_icon):


    CanDrop : logic = true
    Drop<override>()<transacts><decides>: void =
        if (CanDrop?):
            (super:)Drop[]


    PickUp<override>(Inventory:inventory_component)<transacts><decides>:void =
        (super:)PickUp[Inventory]


        #var PickupLifetime<override>:float = 1000.0

    var StoredPlayer : ?agent = false
    GetHoldingPlayer() : tuple(?agent,logic) =
        MaybePlayer := option:
            GetParentInventory[].GetOwningAgent[]
        if (MaybePlayer?):
            set StoredPlayer = MaybePlayer
            return (MaybePlayer,true)

        if (StoredPlayer?):
            Player := StoredPlayer
            set StoredPlayer = false
            return (Player,false)



        set StoredPlayer = MaybePlayer
        return (MaybePlayer,false)


    var<private> Inited<private> : logic = false
    OnBeginSimulation<override>():void = 
        (super:)OnBeginSimulation()
        if (not Inited?):
            set Inited = true
            Initialized()
            #if (not Entity.GetComponent[])
            DetailsComp : component = item_details_component:
                Entity := Entity
                Name := Name
                Description := Description
                ShortDescription := ShortDescription
            IconComp : component = item_icon_component:
                Entity := Entity
                Icon := Icon
            PickupComp : component = fort_item_pickup_component:
                Entity := Entity
            Entity.AddComponents(array{DetailsComp,IconComp,PickupComp})
        MaybePlayer := GetHoldingPlayer()
        if (Player := MaybePlayer(0)?):
            if (MaybePlayer(1)?):
                PickedUp(Player)
                spawn{ControlEquip()}
            else:
                Dropped(Player)
        spawn:
            ControlStackSize()

    ControlStackSize()<suspends> : void =
        race:
            SimulationEnded.Await()
            loop:
                Result := StackSizeChangedEvent.Await()
                ItemStackChanged(Result.CurrentStackSize,GetHoldingPlayer()(0))

    SimulationEnded : event() =event(){}
    ControlEquip()<suspends> : void =
        race:
            SimulationEnded.Await()
            loop:
                Result := EquippedChangedEvent.Await()
                MaybePlayer := GetHoldingPlayer()
                if (Player := MaybePlayer(0)?,MaybePlayer(1)?):
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
