setSpecialWeapNames()
{
	self setClientDvar("special1_weap_name", "^1[^71^1] ^7lvl " + level.s_rank1_name + ": " + getDvar("btd_special1_weap_name"));
	wait 0.05;
	self setClientDvar("special2_weap_name", "^1[^72^1] ^7lvl " + level.s_rank2_name + ": " + getDvar("btd_special2_weap_name"));
	wait 0.05;
	self setClientDvar("special3_weap_name", "^1[^73^1] ^7lvl " + level.s_rank3_name + ": " + getDvar("btd_special3_weap_name"));
	wait 0.05;
	self setClientDvar("special4_weap_name", "^1[^74^1] ^7lvl " + level.s_rank4_name + ": " + getDvar("btd_special4_weap_name"));
	wait 0.05;
	self setClientDvar("special5_weap_name", "^1[^75^1] ^7lvl " + level.s_rank5_name + ": " + getDvar("btd_special5_weap_name"));
	wait 0.05;
	self setClientDvar("special6_weap_name", "^1[^76^1] ^7lvl " + level.s_rank6_name + ": " + getDvar("btd_special6_weap_name"));
}

removeSpecialWeapons(weaponsList)
{
	for( idx = 0; idx < weaponsList.size; idx++ )
	{
		weapon = weaponsList[idx];
		if(weapon == "special1_mp" || weapon == "special2_mp" || weapon == "special3_mp" || weapon == "special4_mp" || weapon == "special5_mp" || weapon == "special6_mp")
		{
			self takeWeapon(weapon);
		}
	}
}

hasSpecialWeapon(weaponsList)
{
	found = false;
	for( i=1; i < 7; i++ )
	{
		if ( self hasWeapon( "special" + i + "_mp" ) )
		{
			found = true;
			break;
		}
	}
/*
	for( idx = 0; idx < weaponsList.size; idx++ )
	{
		weapon = weaponsList[idx];
		if( weapon == "special1_mp" || weapon == "special2_mp" || weapon == "special3_mp" || weapon == "special4_mp" || weapon == "special5_mp" || weapon == "special6_mp" )
		{
			found = true;
			break;
		}
	}
*/
	return( found );
}

getWeaponCount()
{
	count = 0;
	weaponsList = self GetWeaponsList();
	for( idx = 0; idx < weaponsList.size; idx++ )
	{
		weapon = weaponsList[idx];
		if( !maps\mp\gametypes\_weapons::isPrimaryWeapon( weaponsList[idx] ) && !maps\mp\gametypes\_weapons::isSideArm( weaponsList[idx] ) )
			continue;

		if( weapon == "gl_ak47_mp" || weapon == "gl_g3_mp" || weapon == "gl_g36c_mp" || weapon == "gl_m4_mp" || weapon == "gl_m14_mp" || weapon == "gl_m16_mp" || weapon == "gl_mp" || weapon == "c4_mp" || weapon == "claymore_mp" || weapon == "rpg_mp" )
			continue;

		count++;
	}
	return count;
}

specialMenuResponse(response)
{
	if( !level.special_weapons_menu )
	{
		self iprintlnbold("Special Weapons are disabled!");
		return;	
	}

	if ( level.special_weapons_grace_only && level.status != "grace" )
	{
		self iprintlnbold("Can only do this at grace, aborting!");
		return;
	}

	if( level.traderon == 1 )
	{
		self iprintlnbold("You must purchase from Trader, aborting!");
		return;
	}

	if( isDefined(self.lastStand) || !isAlive(self) )
	{
		self iprintlnbold("Cannot do this now, aborting!");
		return;
	}

	weaponsList = self GetWeaponsList();
	if ( self hasSpecialWeapon(weaponsList) )
	{
		self iprintlnbold("You already have a special weapon, aborting!");
		return;
	}

	switch(response)
	{
		case "1":
			if(self.pers["rank"] >= level.special1_rank)
			{
				count = self getWeaponCount();
				if( count < 3 )
				{
					if ( !self hasWeapon( "special1_mp" ) )
					{
						self giveweapon("special1_mp");
						self giveStartAmmo("special1_mp");
						self playlocalsound("weap_pickup");
					}
					else
					{
						self iprintlnbold("You already have this weapon!");
					}
				}
				else
				{
					self iprintlnbold("Too many weapons (^3" + count + "^7) aborting!");
				}
			}
			else
			{
				self iprintlnbold("You must be over rank ^3" + level.s_rank1_name + " ^7for this weapon!");
			}
		break;

		case "2":
			if(self.pers["rank"] >= level.special2_rank)
			{
				count = self getWeaponCount();
				if( count < 3 )
				{
					if ( !self hasWeapon( "special2_mp" ) )
					{
						self giveweapon("special2_mp");
						self giveStartAmmo("special2_mp");
						self playlocalsound("weap_pickup");
					}
					else
					{
						self iprintlnbold("You already have this weapon!");
					}
				}
				else
				{
					self iprintlnbold("Too many weapons (^3" + count + "^7) aborting!");
				}
			 }
			 else
			 {
				self iprintlnbold("You must be over rank ^5" + level.s_rank2_name + " ^7for this weapon!");
			 }
		break;	

		case "3":
			if(self.pers["rank"] >= level.special3_rank)
			{
				count = self getWeaponCount();
				if( count < 3 )
				{
					if ( !self hasWeapon( "special3_mp" ) )
					{
						self giveweapon("special3_mp");
						self giveStartAmmo("special3_mp");
						self playlocalsound("weap_pickup");
					}
					else
					{
						self iprintlnbold("You already have this weapon!");
					}
				}
				else
				{
					self iprintlnbold("Too many weapons (^3" + count + "^7) aborting!");
				}
			}
			else
			{
				self iprintlnbold("You must be over rank ^3" + level.s_rank3_name + " ^7for this weapon!");
			}
		break;	

		case "4":
			if(self.pers["rank"] >= level.special4_rank)
			{
				count = self getWeaponCount();
				if( count < 3 )
				{
					if ( !self hasWeapon( "special4_mp" ) )
					{
						self giveweapon("special4_mp");
						self giveStartAmmo("special4_mp");
						self playlocalsound("weap_pickup");
					}
					else
					{
						self iprintlnbold("You already have this weapon!");
					}
				}
				else
				{
					self iprintlnbold("Too many weapons (^3" + count + "^7) aborting!");
				}
			}
			else
			{
				self iprintlnbold("You must be over rank ^3" + level.s_rank4_name + " ^7for this weapon!");
			}
		break;

		case "5":
			if(self.pers["rank"] >= level.special5_rank)
			{
				count = self getWeaponCount();
				if( count < 3 )
				{
					if ( !self hasWeapon( "special5_mp" ) )
					{
						self giveweapon("special5_mp");
						self giveStartAmmo("special5_mp");
						self playlocalsound("weap_pickup");
					}
					else
					{
						self iprintlnbold("You already have this weapon!");
					}
				}
				else
				{
					self iprintlnbold("Too many weapons (^3" + count + "^7) aborting!");
				}
			}
			else
			{
				self iprintlnbold("You must be over rank ^3" + level.s_rank5_name + " ^7for this weapon!");
			}
		break;	

		case "6":
			if(self.pers["rank"] >= level.special6_rank)
			{
				count = self getWeaponCount();
				if( count < 3 )
				{
					if ( !self hasWeapon( "special6_mp" ) )
					{
						self giveweapon("special6_mp");
						self giveStartAmmo("special6_mp");
						self playlocalsound("weap_pickup");
					}
					else
					{
						self iprintlnbold("You already have this weapon!");
					}
				}
				else
				{
					self iprintlnbold("Too many weapons (^3" + count + "^7) aborting!");
				}
			}		
			else
			{
				self iprintlnbold("You must be rank ^3" + level.s_rank6_name + " ^7for this weapon!");
			}
		break;
	}	
}
