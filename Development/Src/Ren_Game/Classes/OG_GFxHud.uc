class OG_GFxHud extends Rx_GFxHud;

function UpdateVeterancyGFx(bool bInitial)
{
	if(bInitial)
	{
		VeterancyContainer = HealthBlock.GetObject("vet");
		VeterancyLabel = VeterancyContainer.GetObject("vet_tf");
		
		VeterancyIcon = VeterancyContainer.GetObject("vet_icon");
		
		VeterancyBar = GetVariableObject("_root.HealthBlock.vet.vet_bar.bar");		
	}

	VeterancyContainer.SetVisible(false);
}