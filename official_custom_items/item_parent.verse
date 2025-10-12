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
    @editable
    var Icon<override>:texture

    CanDrop : logic = true
    Drop<override>()<transacts><decides>: void =
        if (CanDrop?):
            (super:)Drop[]


    PickUp<override>(Inventory:inventory_component)<transacts><decides>:void =
        (super:)PickUp[Inventory]


        #var PickupLifetime<override>:float = 1000.0

    var StoredAgent : ?agent = false
    GetHoldingAgent() : tuple(?agent,logic) =
        MaybeAgent := option:
            GetParentInventory[].GetOwningAgent[]
        if (MaybeAgent?):
            set StoredAgent = MaybeAgent
            return (MaybeAgent,true)

        if (StoredAgent?):
            Agent := StoredAgent
            set StoredAgent = false
            return (Agent,false)



        set StoredAgent = MaybeAgent
        return (MaybeAgent,false)


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
        MaybeAgent := GetHoldingAgent()
        if (Agent := MaybeAgent(0)?):
            if (MaybeAgent(1)?):
                PickedUp(Agent)
                spawn{ControlEquip()}
            else:
                Dropped(Agent)
        spawn:
            ControlStackSize()

    ControlStackSize()<suspends> : void =
        race:
            SimulationEnded.Await()
            loop:
                Result := StackSizeChangedEvent.Await()
                ItemStackChanged(Result.CurrentStackSize,GetHoldingAgent()(0))

    SimulationEnded : event() =event(){}
    ControlEquip()<suspends> : void =
        race:
            SimulationEnded.Await()
            loop:
                Result := EquippedChangedEvent.Await()
                MaybeAgent := GetHoldingAgent()
                if (Agent := MaybeAgent(0)?,MaybeAgent(1)?):
                    if (Result.IsItemEquipped?):
                        Equipped(Agent)
                    else:
                        Unequipped(Agent)


    OnEndSimulation<override>():void = 
        (super:)OnEndSimulation()
        SimulationEnded.Signal()
        


    ItemStackChanged(NewAmount : int,MaybeAgent : ?agent) : void =
        Print("There are now {NewAmount} items in the stack")

    Initialized() : void =
        Print("Initializing code here")

    Equipped(Agent : agent) : void =
        Print("Equipped")

    Unequipped(Agent : agent) : void =
        Print("Unequipped")
            
    PickedUp(Agent : agent) : void =
        Print("Picked up")

    Dropped(Agent : agent) : void =
        Print("Dropped")
