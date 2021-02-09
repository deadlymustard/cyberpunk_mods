@replaceMethod(FullscreenVendorGameController)
protected cb func OnInventoryItemHoverOver(evt: ref<ItemDisplayHoverOverEvent>) -> Bool {
  let itemToComapre: InventoryItemData;
  let itemData: InventoryItemData;
  let controller: ref<DropdownListController>;
  let localizedHint: String;
  itemData = evt.itemData;
  controller = (inkWidgetRef.GetController(this.m_sortingDropdown) as DropdownListController);
  if !controller.IsOpened() {
    if !InventoryItemData.IsEmpty(itemData) {
      itemToComapre = this.m_comparisonResolver.GetPreferredComparisonItem(itemData);
      this.ShowTooltipsForItemController(evt.widget, itemToComapre, itemData, evt.display.DEBUG_GetIconErrorInfo(), evt.isBuybackStack);
    };
    if InventoryItemData.IsVendorItem(itemData) && this.m_storageUserData==null && this.m_vendorUserData!=null {
      localizedHint = GetLocalizedText("LocKey#17847");
    } else {
      if this.m_VendorDataManager.CanPlayerSellItem(InventoryItemData.GetID(itemData)) && this.m_storageUserData==null && this.m_vendorUserData!=null {
        localizedHint = GetLocalizedText("LocKey#17848");
      };
      if this.m_storageUserData!=null && this.m_vendorUserData==null {
        localizedHint = LocKeyToString(n"UI-UserActions-TransferItem");
      };
    };
    this.m_buttonHintsController.AddButtonHint(n"select", localizedHint);

    let itemId = InventoryItemData.GetID(itemData);
    let itemIsConsumable = Equals(RPGManager.GetItemCategory(itemId), gamedataItemCategory.Consumable);
    let cursorData= new MenuCursorUserData();

    if InventoryItemData.IsVendorItem(itemData) && this.m_storageUserData==null && this.m_vendorUserData!=null && itemIsConsumable {
      let buttonHintText = "[" + GetLocalizedText("Gameplay-Devices-Interactions-Helpers-Hold") + "] " + GetLocalizedText("LocKey#17847") + " & " + GetLocalizedText("LocKey#6891");
      this.m_buttonHintsController.AddButtonHint(n"disassemble_item", buttonHintText);
      cursorData.AddAction(n"disassemble_item");
    };

    if cursorData.GetActionsListSize() >= 0 {
      this.SetCursorContext(n"HoldToComplete", cursorData);
    } else {
      this.SetCursorContext(n"Hover");
    };
  };
}

@replaceMethod(FullscreenVendorGameController)
protected cb func OnInventoryItemHoverOut(evt: ref<ItemDisplayHoverOutEvent>) -> Bool {
  this.m_TooltipsManager.HideTooltips();
  this.m_buttonHintsController.RemoveButtonHint(n"disassemble_item");
}

@addMethod(FullscreenVendorGameController)
protected cb func OnItemDisplayHold(evt: ref<ItemDisplayHoldEvent>) -> Bool {
  this.HandleItemHold(evt.itemData, evt.actionName);
}


@addMethod(FullscreenVendorGameController)
protected cb func OnItemInventoryHold(evt: ref<inkPointerEvent>) -> Bool {
  let controller: wref<InventoryItemDisplayController>;
  let progress: Float;
  controller = this.GetInventoryItemDisplayControllerFromTarget(evt);
  progress = evt.GetHoldProgress();
  if progress >= 1.00 {
    this.HandleItemHold(controller.GetItemData(), evt.GetActionName());
  };
}

@addMethod(FullscreenVendorGameController)
private final func GetInventoryItemDisplayControllerFromTarget(evt: ref<inkPointerEvent>) -> ref<InventoryItemDisplayController> {
  let widget: ref<inkWidget>;
  let controller: wref<InventoryItemDisplayController>;
  widget = evt.GetCurrentTarget();
  controller = (widget.GetController() as InventoryItemDisplayController);
  return controller;
}

@addMethod(FullscreenVendorGameController)
private final func HandleItemHold(itemData: InventoryItemData, actionName: ref<inkActionName>) -> Void {
  let itemTransaction: SItemTransaction;
  let moneyStack: SItemStack;
  let uiSystem: ref<UISystem>;
  let itemsBoughtEvent: ref<UIVendorItemsBoughtEvent>;
  let playerPuppet: ref<PlayerPuppet>;
  let vendorObject: ref<GameObject>;
  let vendor: ref<Vendor>;
  uiSystem = GameInstance.GetUISystem(GetGameInstance());
  itemsBoughtEvent = new UIVendorItemsBoughtEvent();
  vendorObject = this.m_VendorDataManager.GetVendorInstance();

  vendor = MarketSystem.GetVendorRef(vendorObject) as Vendor;

  let itemId = InventoryItemData.GetID(itemData);
  let itemIsConsumable = Equals(RPGManager.GetItemCategory(itemId), gamedataItemCategory.Consumable);

  if actionName.IsAction(n"disassemble_item") && itemIsConsumable {
    vendor.BuyItemFromVendorAndConsume(itemData);
    this.PlaySound(Cast("Item"), Cast("OnBuy"));
    this.SetCursorContext(n"Default");
  };
}

@addMethod(Vendor)
public final func BuyItemFromVendorAndConsume(itemData: InventoryItemData) -> Void {
  let itemTransaction: SItemTransaction;
  let moneyStack: SItemStack;
  let uiSystem: ref<UISystem>;
  let itemsBoughtEvent: ref<UIVendorItemsBoughtEvent>;
  let playerPuppet: ref<PlayerPuppet>;
  uiSystem = GameInstance.GetUISystem(this.m_gameInstance);
  playerPuppet = GetPlayer(this.m_gameInstance);
  itemsBoughtEvent = new UIVendorItemsBoughtEvent();

  let itemsStack: SItemStack;
  itemsStack.itemID = InventoryItemData.GetID(itemData);
  itemsStack.quantity = 1;

  itemTransaction.itemStack = itemsStack;
  itemTransaction.pricePerItem = MarketSystem.GetBuyPrice(this.m_vendorObject, itemsStack.itemID);
  if this.PerformItemTransfer(playerPuppet, this.m_vendorObject, itemTransaction) {
    this.RemoveItemsFromStock(itemTransaction.itemStack);
    moneyStack.itemID = MarketSystem.Money();
    moneyStack.quantity = itemTransaction.pricePerItem * itemTransaction.itemStack.quantity;
    this.AddItemsToStock(moneyStack);
    ArrayPush(itemsBoughtEvent.itemsID, itemsStack.itemID);
    ArrayPush(itemsBoughtEvent.quantity, itemsStack.quantity);
    ItemActionsHelper.PerformItemAction(playerPuppet, InventoryItemData.GetID(itemData));
  };

  if ArraySize(itemsBoughtEvent.itemsID) > 0 {
    uiSystem.QueueEvent(itemsBoughtEvent);
  };
}

@addMethod(MarketSystem)
public final static func GetVendorRef(vendorObject: ref<GameObject>) -> ref<Vendor> {
    let marketSystem: ref<MarketSystem>;
    let vendor: ref<Vendor>;
    marketSystem = MarketSystem.GetInstance(vendorObject.GetGame());
    vendor = marketSystem.GetVendor(vendorObject);
    return vendor;
}