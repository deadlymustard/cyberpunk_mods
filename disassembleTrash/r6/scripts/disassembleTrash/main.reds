@replaceMethod(BackpackMainGameController)
private final func RefreshUI() -> Void {
    this.PopulateInventory();
    this.SetupDisassembleButtonHints();
    this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnHandleGlobalInput");
}

@addMethod(BackpackMainGameController)
private final func GetJunkItems() -> array<InventoryItemData> {
    return this.m_InventoryManager.GetPlayerItemsByType(gamedataItemType.Gen_Junk);
}

@addMethod(BackpackMainGameController)
private final func DisassembleAllJunkItems() -> Void {
    let items: array<InventoryItemData> = this.GetJunkItems();
    let i = 0;
    while i < ArraySize(items) {
        let itemData = items[i];
        ItemActionsHelper.DisassembleItem(this.m_player, InventoryItemData.GetID(itemData));
        i += 1;
    };
    this.PlaySound(Cast("Item"), Cast("OnBuy"));
}

@addMethod(BackpackMainGameController)
protected cb func OnHandleGlobalInput(e: ref<inkPointerEvent>) -> Bool {
    if e.IsAction(n"world_map_menu_jump_to_player") {
        this.DisassembleAllJunkItems();
    }
}

@addMethod(BackpackMainGameController)
private final func SetupDisassembleButtonHints() -> Void {
    let items: array<InventoryItemData> = this.GetJunkItems();
    if ArraySize(items) > 0 {
        this.m_buttonHintsController.AddButtonHint(n"world_map_menu_jump_to_player", GetLocalizedText("UI-ScriptExports-Disassemble0") + " Trash");
    } else {
        this.m_buttonHintsController.RemoveButtonHint(n"world_map_menu_jump_to_player");
    }
}

