class FA_GFxPurchaseMenu_Loadout extends TS_GFxPurchaseMenu_Loadout;


event bool WidgetInitialized(name WidgetName, name WidgetPath, GFxObject Widget)
{
    local bool bWasHandled;

    `log("TS_GFxPurchaseMenu::WidgetInitialized"@`showvar(WidgetName),true,'DevGFxUI');

    bWasHandled = false;

    switch (WidgetName)
    {    
        case 'B_Characters':
            if(CharactersButton == None || CharactersButton != Widget)
            {
                CharactersButton = GFxClikWidget(Widget);
                CharactersButton.SetVisible(false);
                CharactersButton.SetBool("enabled",false);                
                bWasHandled = true;
            }            
            break;
    
        case 'B_Vehicles':
            if(VehiclesButton == None || VehiclesButton != Widget)
            {
                VehiclesButton = GFxClikWidget(Widget);
                VehiclesButton.SetVisible(false);
                VehiclesButton.SetBool("enabled",false);
                bWasHandled = true;
            }    
            break;

        default:
            bWasHandled = super.WidgetInitialized(WidgetName, WidgetPath, Widget);
            break;


    }    

    return bWasHandled;
}

DefaultProperties
{
} 