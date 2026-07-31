
class Rx_Defence_Weapon extends Rx_Vehicle_Weapon_Reloadable;

var float weaponRangeOverride;

/**
 * Sets the Maximum Range for this weapon in Unreal Units
 * @Param float inRange - The new range for this weapon
 */
simulated function SetRange(float inRange)
{
	weaponRangeOverride = inRange;
	CachedMaxRange = 0;
}

/**
 * Returns the Maximum Range for this weapon - modified to take into account the range override
 */
simulated function float MaxRange()
{
	local int i;
	local class<Rx_Projectile> RxProj;
	
	if ( CachedMaxRange > 0 )
	{
		return CachedMaxRange;
	}

	// return the range of the fire mode that fires farthest
	if (bInstantHit)
	{
		CachedMaxRange = WeaponRange;
	}

	for (i = 0; i < WeaponProjectiles.length; i++)
	{
		if(WeaponProjectiles[i] == none) continue;
		if (class<Rx_Projectile>(WeaponProjectiles[i]) != None)
		{
			RxProj=class<Rx_Projectile>(WeaponProjectiles[i]);
			if(weaponRangeOverride > 0)
				CachedMaxRange = FMax(CachedMaxRange, weaponRangeOverride);
			else
				CachedMaxRange = FMax(CachedMaxRange, WeaponProjectiles[i].static.GetRange()*RxProj.default.VetRankInfo[VRank].SpeedModifier*RxProj.default.VetRankInfo[VRank].LifeSpanModifier );
		}
		else
		CachedMaxRange = FMax(CachedMaxRange, WeaponProjectiles[i].static.GetRange());
	}
	return CachedMaxRange;
}

// Overriding function to get access to the projectile right after firing
simulated function Projectile ProjectileFire()	
{
	local Projectile firedProjectile;

	firedProjectile = Super.ProjectileFire();

	// If the override is set (over 0) then change the lifespan so the weapon can shoot that far
	if(weaponRangeOverride > 0)
	{
		// Don't forgor about veterancy!
		if(Rx_Projectile(firedProjectile) != None)
		{
			firedProjectile.Lifespan = weaponRangeOverride / (firedProjectile.default.MaxSpeed * Rx_Projectile(firedProjectile).default.VetRankInfo[VRank].SpeedModifier);
			Rx_Projectile(firedProjectile).replicatedLifeSpan = firedProjectile.Lifespan;
		}
		else
			firedProjectile.Lifespan = weaponRangeOverride / firedProjectile.default.MaxSpeed;
		bNetDirty = true;	
	}	

	return firedProjectile;
}


DefaultProperties
{
	weaponRangeOverride = 0.0
}
