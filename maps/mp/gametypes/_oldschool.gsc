#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include btd\_dvardef;

init()
{
	precacheModel("ld_death_ground_pose_01");

	level.pickupson = createdvar("btd_pickup_on",1,0,1,"int");
	level.pickupspawntime = createdvar("btd_pickup_spawn_time",15,5,300,"int");
	level.pickupbodies = createdvar("btd_pickup_bodies",1,0,1,"int");
	level.pickupspin = createdvar("btd_pickup_spin",0,0,1,"int");
	level.pickupfx = createdvar("btd_pickup_fx",1,0,1,"int");
	level.pickuprandom = createdvar("btd_pickup_random",1,0,1,"int");
	level.dropDeleteTime = createdvar("btd_drop_delete_time",0.5,0.25,10,"float");

	level.btd_changepickups = 0;

	if( level.pickuprandom == 1 || level.traderon == 1)
	{
		level.btd_changepickups = 1;
	}

	if( level.pickupson == 0 || level.btd_devmode != 0)
	{
		deletePickups();
	}

	if( level.pickupson == 1 && level.btd_devmode == 0 )
	{
		thread initPickups();	
	}

	// Zombotron: Can't run this as it removes all of the players perks.
	if(level.traderon == 1)
	   thread onPlayerConnect();

	oldschoolWeaponPrimary = getDvar("btd_oldschool_primary");	
	oldschoolWeaponSecondary = getDvar("btd_oldschool_secondary");
	oldschoolSecondaryGrenade = getDvar("btd_oldschool_secondary_grenade");

	//if(!checksub(oldschoolWeaponPrimary))
	if( !btd_menus\buy_menu\_buymenu_response::doesWeaponExist(oldschoolWeaponPrimary) )
	{
		oldschoolWeaponPrimary = "mp5_mp";
	}

	if(!checkpistol(oldschoolWeaponSecondary))
	{
		oldschoolWeaponSecondary = "usp_mp";
	}

	//Default oldschool loadout
	oldschoolLoadout = spawnstruct();
	oldschoolLoadout.primaryWeapon = oldschoolWeaponPrimary;
	oldschoolLoadout.secondaryWeapon = oldschoolWeaponSecondary;
	oldschoolLoadout.inventoryWeapon = "";
	oldschoolLoadout.inventoryWeaponAmmo = 0;	

	//grenade types: "", "frag", "smoke", "flash"
	oldschoolLoadout.grenadeTypePrimary = "frag";
	oldschoolLoadout.grenadeCountPrimary = 2;
	oldschoolLoadout.grenadeTypeSecondary = oldschoolSecondaryGrenade;
	oldschoolLoadout.grenadeCountSecondary = 2;

	level.oldschoolLoadout = oldschoolLoadout;

	// mp_player_join
	level.oldschoolPickupSound = "oldschool_pickup";
	level.oldschoolRespawnSound = "oldschool_return";

	level.validPerks = [];
	for( i = 150; i < 199; i++ )
	{
		perk = tableLookup( "mp/statstable.csv", 0, i, 4 );
		if ( issubstr( perk, "specialty_" ) )
			level.validPerks[ level.validPerks.size ] = perk;
	}

	level.perkPickupHints = [];
	level.perkPickupHints[ "specialty_bulletdamage"			] = &"PLATFORM_PICK_UP_STOPPING_POWER";
	level.perkPickupHints[ "specialty_armorvest"			] = &"PLATFORM_PICK_UP_JUGGERNAUT";
	level.perkPickupHints[ "specialty_rof"				] = &"PLATFORM_PICK_UP_DOUBLE_TAP";
	level.perkPickupHints[ "specialty_pistoldeath"			] = &"PLATFORM_PICK_UP_LAST_STAND";
	level.perkPickupHints[ "specialty_grenadepulldeath"		] = &"PLATFORM_PICK_UP_MARTYRDOM";
	level.perkPickupHints[ "specialty_fastreload"			] = &"PLATFORM_PICK_UP_SLEIGHT_OF_HAND";

	perkPickupKeys = getArrayKeys( level.perkPickupHints ); 

	for ( i = 0; i < perkPickupKeys.size; i++ )
		precacheString( level.perkPickupHints[ perkPickupKeys[i] ] );
}

checkpistol( weapon )
{	
	if( weapon == "beretta_mp" ||  weapon == "beretta_silencer_mp" || 
		weapon == "colt45_mp" ||  weapon == "colt45_silencer_mp" || 
		weapon == "usp_mp" ||  weapon == "usp_silencer_mp" || 
		weapon == "deserteagle_mp" || weapon == "deserteaglegold_mp" || weapon == "special5_mp" )
	{		
		return true; // yes is pistol	
	}
	else
	{
		return false; // no not pistol	
	}
}

checksub( weapon )
{	
	if( weapon == "p90_silencer_mp" ||  weapon == "p90_reflex_mp" ||  weapon == "p90_mp" ||  weapon == "p90_acog_mp" ||
		weapon == "mp5_silencer_mp" ||  weapon == "mp5_reflex_mp" ||  weapon == "mp5_mp" ||  weapon == "mp5_acog_mp" ||
		weapon == "skorpion_silencer_mp" ||  weapon == "skorpion_reflex_mp" ||  weapon == "skorpion_mp" ||  weapon == "skorpion_acog_mp" ||
		weapon == "uzi_silencer_mp" ||  weapon == "uzi_reflex_mp" ||  weapon == "uzi_mp" ||  weapon == "uzi_acog_mp" ||
		weapon == "ak74u_silencer_mp" ||  weapon == "ak74u_reflex_mp" ||  weapon == "ak47u_mp" ||  weapon == "ak74u_acog_mp" || weapon == "special4_mp")

	{		
		return true; // yes is submachine gun	
	}
	else
	{
		return false; // no not submachine gun
	}
}

giveLoadout()
{
	assert( isdefined( level.oldschoolLoadout ) );
	
	loadout = level.oldschoolLoadout;
	
	primaryTokens = strtok( loadout.primaryWeapon, "_" );
	self.pers["primaryWeapon"] = primaryTokens[0];
	
	self maps\mp\gametypes\_teams::playerModelForWeapon( self.pers["primaryWeapon"] );	

	self GiveWeapon( loadout.primaryWeapon );
	self giveStartAmmo( loadout.primaryWeapon );
	self setSpawnWeapon( loadout.primaryWeapon );
	
	// give secondary weapon
	self GiveWeapon( loadout.secondaryWeapon );
	self giveStartAmmo( loadout.secondaryWeapon );
	
	self SetActionSlot( 1, "nightvision" );
	
	if ( loadout.inventoryWeapon != "" )
	{
		self GiveWeapon( loadout.inventoryWeapon );
		self maps\mp\gametypes\_class::setWeaponAmmoOverall( loadout.inventoryWeapon, loadout.inventoryWeaponAmmo );
		
		self.inventoryWeapon = loadout.inventoryWeapon;
		
		self SetActionSlot( 3, "weapon", loadout.inventoryWeapon );
		self SetActionSlot( 4, "" );
	}
	else
	{
		self SetActionSlot( 3, "altMode" );
		self SetActionSlot( 4, "" );
	}
	
	if ( loadout.grenadeTypePrimary != "" )
	{
		grenadeTypePrimary = level.weapons[ loadout.grenadeTypePrimary ];
		
		self GiveWeapon( grenadeTypePrimary );
		self SetWeaponAmmoClip( grenadeTypePrimary, loadout.grenadeCountPrimary );
		self SwitchToOffhand( grenadeTypePrimary );
	}
	
	if ( loadout.grenadeTypeSecondary != "" )
	{
		grenadeTypeSecondary = level.weapons[ loadout.grenadeTypeSecondary ];

		if ( grenadeTypeSecondary == level.weapons["flash"])
		{ self setOffhandSecondaryClass("flash"); }
		//else if ( grenadeTypeSecondary == level.weapons["concussion"])
		//{ self setOffhandSecondaryClass("concussion"); }
		else
		{ self setOffhandSecondaryClass("smoke"); }

		self giveWeapon( grenadeTypeSecondary );
		self SetWeaponAmmoClip( grenadeTypeSecondary, loadout.grenadeCountSecondary );
	}
}

// deletes the pickups
deletePickups()
{
	pickups = getentarray( "oldschool_pickup", "targetname" );
	
	for ( i = 0; i < pickups.size; i++ )
	{
		if ( isdefined( pickups[i].target ) )
			getent( pickups[i].target, "targetname" ) delete();
		pickups[i] delete();
	}
}

initPickups()
{
	level.pickupAvailableEffect = loadfx( "misc/ui_pickup_available" );
	level.pickupUnavailableEffect = loadfx( "misc/ui_pickup_unavailable" );
	
	level.newPickupsDefined = 0;
	level.bypass = false;	
	
	wait 5; // so all pickups have a chance to spawn and drop to the ground
	
	pickups = getentarray( "oldschool_pickup", "targetname" );	
		
	// level.newpickupspawns is an array of new pickups created in the btd devmode so pickups can be enabled
	// if the map dosnt have any oldscholl pickups, also the default pckup spawns can be changed	

	if(isdefined(level.newpickupspawns))
	{		
		level.btd_changepickups = 1;	
		level.newPickupsdefined = 1;
		
		pickups = [];
	
		for(i = 0; i < level.newpickupspawns.size; i++)
		{
			// Hacker22 - create an entity
			//pickups[i] = level.newpickupspawns[i];
			pickups[i] = spawn( "script_origin",level.newpickupspawns[i].origin);	
		}	
	}
	else
	{
		if ( level.btd_changepickups == 1 )
		{
			redoPickups = [];
			for ( p = 0; p < pickups.size; p++ )
			{	
				redoPickups[p] = spawnstruct();
				redoPickups[p].origin =  pickups[p].origin;
				redoPickups[p].angles =  pickups[p].angles;

				// May as well delete now rather than looping again
				if ( isdefined( pickups[p].target ) )
					getent( pickups[p].target, "targetname" ) delete();

				pickups[p] delete();			
			}
		
			//deletePickups();
		
			pickups = [];
			for( r = 0; r < redoPickups.size; r++ )
			{
				pickups[r] = redoPickups[r];
				//pickups[r] = spawn( "script_origin", redoPickups[r].origin );
			}
		
			level.bypass = true;
		}
	}

	// spawns body under pickup if enabled and starts tracking of all pickups
	for ( i = 0; i < pickups.size; i++ )
	{
		// spawns a body under the pickup if enabled
		if(level.pickupbodies == 1)
		{
			bodygroundpoint = getPickupGroundpoint( pickups[i] );
			body = spawn("script_model", bodygroundpoint);
			body setModel("ld_death_ground_pose_01");		
		}				

		thread trackPickup( pickups[i], i ); 
	}	
}

spawnPickupFX( groundpoint, fx )
{
	effect = spawnFx( fx, groundpoint, (0,0,1), (1,0,0) );
	triggerFx( effect );
	
	return effect;
}

playEffectShortly( fx )
{
	self endon("death");
	wait .05;
	playFxOnTag( fx, self, "tag_origin" );
}

getPickupGroundpoint( pickup )
{
	trace = bullettrace( pickup.origin, pickup.origin + (0,0,-128), false, pickup );
	groundpoint = trace["position"];
	
	finalz = groundpoint[2];
	
	for ( radiusCounter = 1; radiusCounter <= 3; radiusCounter++ )
	{
		radius = radiusCounter / 3.0 * 50;
		
		for ( angleCounter = 0; angleCounter < 10; angleCounter++ )
		{
			angle = angleCounter / 10.0 * 360.0;
			
			pos = pickup.origin + (cos(angle), sin(angle), 0) * radius;
			
			trace = bullettrace( pos, pos + (0,0,-128), false, pickup );
			hitpos = trace["position"];
			
			if ( hitpos[2] > finalz && hitpos[2] < groundpoint[2] + 15 )
				finalz = hitpos[2];
		}
	}
	return (groundpoint[0], groundpoint[1], finalz);
}

getWeaponName( classname )
{	
	assert( getsubstr( classname, 0, 7 ) == "weapon_" );
	weapname = getsubstr( classname, 7 );
	return weapname;
}

trackPickup( pickup, id )
{
	groundpoint = getPickupGroundpoint( pickup );
	
	effectObj = undefined;
	if(level.pickupfx == 1)
	{
		effectObj = spawnPickupFX( groundpoint, level.pickupAvailableEffect );	
	}

	classname = "";
	if( level.btd_changepickups == 1 )
	{							
		classname = getRandomClassname();
		spawnflags = 3;
		model = undefined;
	}			
	else
	{
		classname = pickup.classname;
		spawnflags = pickup.spawnflags;
		model = pickup.model;
	}

	origin = pickup.origin;
	angles = pickup.angles;

	isWeapon = false;
	isPerk = false;
	weapname = undefined;
	perk = undefined;
	trig = undefined;
	droped = undefined;	
	respawnTime = level.pickupspawntime;

	if ( level.btd_changepickups == 1 || issubstr( classname, "weapon_" ) )
	{
		isWeapon = true;
		weapname = getWeaponName( classname );
	}
	else if ( classname == "script_model" )
	{
		isPerk = true;
		perk = pickup.script_noteworthy;
		for ( i = 0; i < level.validPerks.size; i++ )
		{
			if ( level.validPerks[i] == perk )
				break;
		}
		if ( i == level.validPerks.size )
		{
			maps\mp\_utility::error( "oldschool_pickup with classname script_model does not have script_noteworthy set to a valid perk" );
			return;
		}
		trig = getent( pickup.target, "targetname" );
		
		if ( !getDvarInt( "scr_game_perks" ) )
		{
			pickup delete();
			trig delete();
			if(level.pickupfx == 1)
			{
				effectObj delete();
			}
			return;
		}
		
		if ( isDefined( level.perkPickupHints[ perk ] ) )
		{
			trig setHintString( level.perkPickupHints[ perk ] );
		}
	}
	else
	{
		maps\mp\_utility::error( "oldschool_pickup with classname " + classname + " is not supported (at location " + pickup.origin + ")" );
		return;
	}

	newpickuphack = false;
	if ( level.btd_changepickups == 1 )
	{
		newpickuphack = true;
	}
	
	while(1)
	{
		if(level.pickupspin == 1 && level.bypass == false )
		{
			pickup thread spinPickup();
		}
		
		player = undefined;
		
		// used for debug
		//iprintln("pickup weapname = " + weapname);
		//iprintln("pickup classname = " + pickup.classname);	
		//iprintln("pickup model = " + pickup.model);
		//iprintln("pickup spawnflag = " + pickup.spawnflags);	
		//iprintln("newpickuphack = " + newpickuphack);	

		if ( isWeapon )
		{
			if ( level.btd_changepickups ==  0 )
			{
				pickup thread changeSecondaryGrenadeType( weapname );
			}

			if(newpickuphack == false)
			{
				pickup setPickupStartAmmo( weapname );

				while(1)
				{
					pickup waittill( "trigger", player, dropped );							
					if ( !isdefined( pickup ) )
						break;

					// player only picked up ammo. the pickup still remains.
					assert( !isdefined( dropped ) );					
				}

				if ( isdefined( dropped ) )
				{
					// Zombotron: Changed to configurable
					dropDeleteTime = level.dropDeleteTime;
					//dropDeleteTime = 5;
					if ( dropDeleteTime > respawnTime )
						dropDeleteTime = respawnTime;

					dropped thread delayedDeletion( dropDeleteTime );
				}
				else
				{
					if(classname != "weapon_rpg_mp" || classname != "weapon_frag_frenade_mp")
					{
						if(player.totalweaponsprimary < 2)
						{
							player.totalweaponsprimary = player.totalweaponsprimary + 1;
						}
						else
						{
							player.totalweaponsprimary = 2;
						}
					}
				}
			}
			else if( level.bypass == false )
			{
				if( isDefined( pickup ) )
					pickup delete();
			}
		}
		else
		{
			if(newpickuphack == false)
			{	
				assert( isPerk );
				
				if(newpickuphack == false)
				{
					trig waittill( "trigger", player );		
				}	
				else
				{			
					wait 0.1;
				}

				pickup delete();
				trig triggerOff();
			}
			else
			{
				pickup delete();
				trig delete();
			}
		}

		if(newpickuphack == false)
		{
			if ( isWeapon )
			{					
				if ( weaponInventoryType( weapname ) == "item" && (!isdefined( player.inventoryWeapon ) || weapname != player.inventoryWeapon) )
				{
					player removeInventoryWeapon();
					player.inventoryWeapon = weapname;
					player SetActionSlot( 3, "weapon", weapname );
					// this used to reset the action slot to alt mode when your ammo is up for the weapon.
					// however, this isn't safe for C4, which you need to still have even when you have no ammo, so you can detonate.
					//player thread resetActionSlotToAltMode( weapname );
				}
			}
			else
			{
				assert( isPerk );
				
				if ( !player hasPerk( perk ) )
				{
					player setPerk( perk );
				}
			}
		}

		thread playSoundinSpace( level.oldschoolPickupSound, origin );

		if(level.pickupfx == 1)
		{
			effectObj delete();
			effectObj = spawnPickupFX( groundpoint, level.pickupUnavailableEffect );
		}
		
		if(newpickuphack == false)
		{			
			wait respawnTime;			
		}
		else
		{	
			wait 0.1;
			newpickuphack = false;
		}

		pickup = spawn( classname, origin, spawnflags );
		pickup.angles = angles;
		if ( isPerk )
		{
			pickup setModel( model );
			trig triggerOn();
		}

		if ( isPerk )
		{
			pickup setModel( model );
			trig triggerOn();
		}

		if(level.pickupfx == 1)
		{
			effectObj delete();
			effectObj = spawnPickupFX( groundpoint, level.pickupAvailableEffect ); 
			pickup playSound( level.oldschoolRespawnSound );		
		}  

		level.bypass = false;
	}
}

hidePerkNameAfterTime( index, delay )
{
	self endon("disconnect");
	
	wait delay;
	
	self thread hidePerk( index, 2.0, true );
}


playSoundinSpace( alias, origin )
{
	org = spawn( "script_origin", origin );
	org.origin = origin;
	org playSound( alias  );
	wait 10; // MP doesn't have "sounddone" notifies =(
	org delete();
}

setPickupStartAmmo( weapname )
{
	curweapname = weapname;
	altindex = 0;

	allammo = weaponStartAmmo( curweapname );
		
	self itemWeaponSetAmmo( allammo, allammo, altindex );

}

changeSecondaryGrenadeType( weapname )
{
	self endon("trigger");
	
	if ( weapname != level.weapons["smoke"] && weapname != level.weapons["flash"] && weapname != level.weapons["concussion"] )
		return;

	offhandClass = "smoke";
	if ( weapname == level.weapons["flash"] )
		offhandClass = "flash";
	else if ( weapname == level.weapons["concussion"] )
		offhandClass = "concussion";

	trig = spawn( "trigger_radius", self.origin - (0,0,20), 0, 128, 64 );
	self thread deleteTriggerWhenPickedUp( trig );
	
	while(1)
	{
		trig waittill( "trigger", player );
		if ( player getWeaponAmmoTotal( level.weapons["smoke"] ) == 0 && 
			player getWeaponAmmoTotal( level.weapons["flash"] ) == 0 && 
			player getWeaponAmmoTotal( level.weapons["concussion"] ) == 0 )
		{
			player setOffhandSecondaryClass( offhandClass );
		}
	}
}

deleteTriggerWhenPickedUp( trig )
{
	self waittill("trigger");
	trig delete();
}

resetActionSlotToAltMode( weapname )
{
	self notify("resetting_action_slot_to_alt_mode");
	self endon("resetting_action_slot_to_alt_mode");
	
	while(1)
	{
		if ( self getWeaponAmmoTotal( weapname ) == 0 )
		{
			curweap = self getCurrentWeapon();
			if ( curweap != weapname && curweap != "none" )
				break;
		}
		wait .2;
	}
	
	self removeInventoryWeapon();
	self SetActionSlot( 3, "altmode" );
}

getWeaponAmmoTotal( weapname )
{
	return self getWeaponAmmoClip( weapname ) + self getWeaponAmmoStock( weapname );
}

removeInventoryWeapon()
{
	if ( isDefined( self.inventoryWeapon ) )
		self takeWeapon( self.inventoryWeapon );
	self.inventoryWeapon = undefined;
}

spinPickup()
{
	self endon("death");
	
	org = spawn( "script_origin", self.origin );
	org endon("death");
	
	self linkto( org );
	self thread deleteOnDeath( org );
	
	while(1)
	{
		org rotateyaw( 360, 3, 0, 0 );
		wait 2.9;
	}	
}

deleteOnDeath( ent )
{
	ent endon("death");
	self waittill("death");
	ent delete();
}

delayedDeletion( delay )
{
	self thread delayedDeletionOnSwappedWeapons( delay );
	
	wait delay;
	
	if ( isDefined( self ) )
	{
		self notify("death");
		self delete();
	}
}

delayedDeletionOnSwappedWeapons( delay )
{
	self endon("death");
	while(1)
	{
		self waittill( "trigger", player, dropped );
		if ( isdefined( dropped ) )
			break;
	}
	dropped thread delayedDeletion( delay );
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill ( "connecting", player );

		player thread onPlayerSpawned();
	}
}

onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "spawned_player" );
		
		self.inventoryWeapon = undefined;
		
		self clearPerks();
		self.numPerks = 0;
		self thread clearPerksOnDeath();

		self thread watchWeaponsList();
	}
}

clearPerksOnDeath()
{
	self endon("disconnect");
	self waittill("death");
	
	self clearPerks();
	for ( i = 0; i < self.numPerks; i++ )
	{
		self hidePerk( i, 0.05 );
	}
	self.numPerks = 0;
}

watchWeaponsList()
{
	self endon("death");
	
	waittillframeend;
	
	self.weapons = self getWeaponsList();
	
	for(;;)
	{
		self waittill( "weapon_change", newWeapon );
		
		self thread updateWeaponsList( .05 );
	}
}

updateWeaponsList( delay )
{
	self endon("death");
	self notify("updating_weapons_list");
	self endon("updating_weapons_list");
	
	self.weapons = self getWeaponsList();
}

hadWeaponBeforePickingUp( newWeapon )
{
	for ( i = 0; i < self.weapons.size; i++ )
	{
		if ( self.weapons[i] == newWeapon )
			return true;
	}
	return false;
}

getPistolClassname()
{
	newpickup = 0;
	newpickup = randomInt(5);	
	
	name = "weapon_usp_mp";

	if(newpickup == 0) { name = "weapon_beretta_silencer_mp";}
	else if(newpickup == 1) { name = "weapon_usp_mp";}
	else if(newpickup == 2) { name = "weapon_colt45_mp"; }
	else if(newpickup == 3) { name = "weapon_deserteagle_mp";} 
	else if(newpickup == 4) { name = "weapon_deserteaglegold_mp";} 
	
	return name;
}

getRandomClassname()
{
	newpickup = 0;
	newpickup = randomInt(29);				

	name = "weapon_rpg_mp";				

	if(newpickup == 1) { name = "weapon_deserteaglegold_mp"; }
	else if(newpickup == 2) { name = "weapon_m4_reflex_mp"; }
	else if(newpickup == 3) { name = "weapon_mp5_silencer_mp"; }
	//else if(newpickup == 4) { name = "weapon_smoke_grenade_mp"; }
	else if(newpickup == 4) { name = "weapon_uzi_reflex_mp"; }
	else if(newpickup == 5) { name = "weapon_skorpion_acog_mp"; }
	else if(newpickup == 6) { name = "weapon_ak74u_reflex_mp"; }
	else if(newpickup == 7) { name = "weapon_ak47_reflex_mp"; }
	else if(newpickup == 8) { name = "weapon_g36c_acog_mp"; }
	else if(newpickup == 9) { name = "weapon_m14_acog_mp"; }
	else if(newpickup == 10) { name = "weapon_deserteagle_mp"; }
	else if(newpickup == 11) { name = "weapon_mp44_mp"; }
	else if(newpickup == 12) { name = "weapon_g3_gl_mp"; }
	else if(newpickup == 13) { name = "weapon_m16_acog_mp"; }
	else if(newpickup == 14) { name = "weapon_m4_reflex_mp"; }
	//else if(newpickup == 16) { name = "weapon_flash_grenade_mp"; }
	else if(newpickup == 15) { name = "weapon_rpd_reflex_mp"; }
	else if(newpickup == 16) { name = "weapon_m60e4_acog_mp"; }
	//else if(newpickup == 19) { name = "weapon_frag_grenade_mp"; }
	else if(newpickup == 17) { name = "weapon_winchester1200_grip_mp"; }
	else if(newpickup == 18) { name = "weapon_m1014_grip_mp"; }
	else if(newpickup == 19) { name = "weapon_m40a3_mp"; }
	else if(newpickup == 20) { name = "weapon_m21_mp"; }
	else if(newpickup == 21) { name = "weapon_remington700_mp"; }
	else if(newpickup == 22) { name = "weapon_dragunov_mp"; }
	else if(newpickup == 23) { name = "weapon_barrett_mp"; }
	//else if(newpickup == 27) { name = "weapon_concussion_grenade_mp"; }
	else if(newpickup == 24) { name = "weapon_saw_grip_mp"; }
	else if(newpickup == 25) { name = "weapon_p90_reflex_mp"; }
	else { name = "weapon_rpg_mp"; }

	return name;
}
