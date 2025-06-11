#include btd\_arty;

clientMenuResponse(response)
{		
	switch(response)
	{			
		// 1st or 3rd person	
		case "1":
			if( !self.thirdperson )
			{
				self setClientDvar("cg_thirdperson",1);
				self.thirdperson = true;
			}
			else
			{
				self setClientDvar("cg_thirdperson",0);
				self.thirdperson = false;
			}
		break;	

		// laser on or off
		case "2":
			if ( !self.laseron )
			{
				self setClientDvar("cg_laserforceon",1);
				self.laseron = true;
			}
			else
			{
				self setClientDvar("cg_laserforceon",0);
				self.laseron = false;
			}
		break;	

		// Use arty
		case "3":
			if( isPlayer(self) && isAlive(self) && self.sessionstate == "playing" && self.num_arty > 0  )
			{
				if( !self.isarty && !self.inHelicopter && !self.inAc130 && !self.on_rampage && !isDefined( self.lastStand ) )
				{
		  			self thread artillery(); // begin artillery
				}
				else
				{
					self iPrintlnBold("Artillery unavailable at this time.");
				}
			}
			else
			{
				self iPrintlnBold("Artillery unavailable");
			}
		break;

		// chrosshair on or off
		case "4":
			if( !self.crosshairon )
			{
				self setClientDvar("cg_drawcrosshair",1);
				self.crosshairon =  true;
			}
			else
			{
				self setClientDvar("cg_drawcrosshair",0);
				self.crosshairon =  false;
			}
		break;

		// change field of view
		case "5":
			if( !self.maxfov )
			{
				self setClientDvar( "cg_fov", "80" );
				self.maxfov = true;
			}
			else
			{
				self setClientDvar( "cg_fov", "65" );
				self.maxfov = false;
			}
		break;

		// client side music
		case "6":
			self iprintlnBold("Client Side Music is unavailable.");
		break;

		// Discard current weapon
		case "7":
			if( isAlive(self) && !isDefined(self.laststand) && level.can_discard_weapon )
			{
				weapon = self getCurrentWeapon();
				if( isDefined( weapon ) )
				{
					if( weapon == "special1_mp" || weapon == "special2_mp" || weapon == "special3_mp" || weapon == "special4_mp" || weapon == "special5_mp" || weapon == "special6_mp" )
					{ self iprintlnBold("You cannot discard a special weapon." ); }
					else
					{
						name = btd_menus\buy_menu\_buymenu_response::getWeaponName(weapon);
						if( name != "unknown" )
						{
							self iprintlnBold("Discarded weapon ^3" + name );
							self takeWeapon(weapon);
						}
					}
				}
			}
			else
			{ self iprintlnBold("Weapon Discarding unavailable."); }
		break;
	}
}

