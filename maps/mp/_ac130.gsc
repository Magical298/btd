//================================================================================================
// File Name  : _ac130.gsc 
// File Info  : AC 130 hardpoint
// Mod        : X4 eXtreme Mod. http://www.mycallofduty.com
// Authors    : IW & X4 eXtreme Mod Team - Mangled by Zod
//================================================================================================
#include maps\mp\_utility;
#include btd\_dvardef;

init()
{
	precacheModel("c130_zoomrig");
	precacheModel("vehicle_ac130_low");

	precacheShader("ac130_overlay_25mm");
	precacheShader("ac130_overlay_105mm");
	precacheShader("ac130_overlay_grain");
	precacheShader( "hud_ac130" );

	level.ac130_time = createdvar("btd_ac130_time",60,0,300,"int");
	level.ac130_rotationSpeed = createdvar("btd_ac130_speed",60,0,150,"int");
	level.ac130_useVision = createdvar("btd_ac130_vision",1,0,1,"int");

	level.physicsSphereRadius["cobra_FFAR_mp"] = 200;
	level.physicsSphereRadius["hind_FFAR_mp"] = 1000;

	level.physicsSphereForce["cobra_FFAR_mp"] = 0.5;
	level.physicsSphereForce["hind_FFAR_mp"] = 6.0;

	level.ac130 = undefined;
	level.ac130Model = undefined;

	// get the map dimensions and playing field dimensions
	GetMapDim();
	GetFieldDim();

	level.ac130Origin = getAboveBuildingsLocation(level.ex_playArea_Centre);
}

ac130_start()
{
	level.ac130 = spawn("script_model", level.ac130Origin);
	level.ac130 setModel("c130_zoomrig");
	level.ac130.angles = (0,75,0);

	level.ac130.team = self.pers["team"];
	level.ac130.pers["team"] = self.pers["team"];
	level.ac130.owner = self;
	level.ac130 hide();

	level.ac130Model = spawn("script_model", level.ac130Origin);
	level.ac130Model setModel("vehicle_ac130_low");
	level.ac130Model.angles = (0,75,0);
	level.ac130Model linkTo(level.ac130, "tag_player", (0,0,0), (0,0,0));

	level.ac130 thread rotatePlane(true);
}

ac130_monitor_owner()
{
	self endon( "leaving" );

	// check if owner has left, if so, leave
	while(1)
	{
		if ( !isdefined( self.owner ) || !isdefined( self.owner.pers["team"] ) || self.owner.pers["team"] != self.team )
		{
			self thread ac130_leave();	
		}
		wait 1;
	}
}

ac130_leave()
{
	self notify( "leaving" );

	wait 1;

	level.ac130Model delete();
	level.ac130Model = undefined;
	self delete();
	level.ac130 = undefined;
}

ac130_attachPlayer(plane)
{
	self endon("joined_spectators");
	self endon("disconnect");
	self endon("death");

	// Run some checks before we bother
	if( level.inPrematchPeriod || self.sessionstate != "playing" || !isDefined( level.ac130 ) || !isDefined( level.ac130model ) )
	{
		if( isDefined( level.ac130 ) )
		{ level.ac130 ac130_leave(); }

		return;
	}

	// Give all the ac130 weapons
    	if( !self hasWeapon( "cobra_FFAR_mp" ) )
	{
		self giveweapon( "cobra_FFAR_mp" );
		self SetWeaponAmmoClip( "cobra_FFAR_mp", 999 );
	}
	if( !self hasWeapon( "hind_FFAR_mp" ) )
	{
		self giveweapon( "hind_FFAR_mp" );
		self SetWeaponAmmoClip( "hind_FFAR_mp", 50 );
	}

	// Mount to rig and hide
	self.inAc130 = true; // Lets not kill ourselves mmmk? Checked in _globallogic.gsc function Callback_PlayerDamage
	self linkTo(plane, "tag_player", (3500,0,0), (0,0,0));

	//self playLoopSound( "ambient_ac130" );

	self hide(); // Not working
/*
	// Hax
	self detachAll();
	self setmodel("");
*/
	// More weapon handling
	self thread changeWeapons();
	self thread shotFired();

	// Kill ourselves off if gunner drops out
	plane thread ac130_monitor_owner();

	self iprintlnbold("You have ^3" + level.ac130_time + " ^7seconds. Press ^3[{+melee}] ^7to exit.");

	wait level.ac130_time;

	if( isPlayer(self) && isAlive(self) && self.inAc130 && isDefined(level.ac130) )
	{ self thread goToLz(); }
}

goToLz()
{
	self iprintln("Leaving AC 130.");

	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( "allies" );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );

	// Take the goodies away
    	if( self hasWeapon( "cobra_FFAR_mp" ) )
	{ self takeWeapon( "cobra_FFAR_mp" ); }

	if( self hasWeapon( "hind_FFAR_mp" ) )
	{ self takeWeapon( "hind_FFAR_mp" ); }

	//self stopLoopSound("ambient_ac130");

	wait 1;

	self unlink();
	self setorigin(spawnpoint.origin);
	self setplayerangles(spawnpoint.angles);
	self show();
/*
	// Hax: Reset model - Primary should have been defined during spawn routines
	self maps\mp\gametypes\_teams::playerModelForWeapon( self.pers["primaryWeapon"] );
	self maps\mp\gametypes\_weapons::stow_on_back();
	self maps\mp\gametypes\_weapons::stow_on_hip();
*/
	self notify("left_ac130");
	//self btd\_utils::execClientCommand("+gostand"); //EDIT: Causes problems with client
	self.inAc130 = false;

	// This sucks but it does work
	weaponsList = self GetWeaponsList();
	primary = undefined;
	for( idx = 0; idx < weaponsList.size; idx++ )
	{
		weapon = weaponsList[idx];
		if ( maps\mp\gametypes\_weapons::isPrimaryWeapon( weapon ) )
		{
			if( weapon == "gl_ak47_mp" || weapon == "gl_g3_mp" || weapon == "gl_g36c_mp" || weapon == "gl_m4_mp" || weapon == "gl_m14_mp" || weapon == "gl_m16_mp" || weapon == "gl_mp" || weapon == "c4_mp" || weapon == "claymore_mp" || weapon == "rpg_mp" )
			{ continue; }

			primary = weapon;
			break;
		}
	}

	if ( isDefined( primary ) && self hasWeapon( primary ) )
	{ self switchToWeapon( primary ); }

	self thread btd\_spawn_protection::do_sp();

	wait 0.5;

	if( isDefined( level.ac130 ) )
	{ level.ac130 thread ac130_leave(); }
}

changeWeapons()
{
	self endon("death");
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("left_ac130");

	weapon = [];

	weapon[0] = spawnstruct();
	weapon[0].weapon = "cobra_FFAR_mp";
	weapon[0].overlay = "ac130_overlay_25mm";
	weapon[0].name = "25mm Turret";

	weapon[1] = spawnstruct();
	weapon[1].weapon = "hind_FFAR_mp";
	weapon[1].overlay = "ac130_overlay_105mm";
	weapon[1].name = "105mm Cannon";

	// Switch right off
	self switchToWeapon( weapon[0].weapon );     
	self thread setOverlay( weapon[0].overlay );

	currentWeapon = 0;

	while(1)
	{
		wait 0.05;
		if(self useButtonPressed())
		{
			currentWeapon++;
			if (currentWeapon >= weapon.size)
			{ currentWeapon = 0; }
       
			self switchToWeapon( weapon[currentWeapon].weapon );     
			self thread setOverlay( weapon[currentWeapon].overlay );
			self iPrintln( "Switched to: " + weapon[currentWeapon].name );

			while(self useButtonPressed())
			{ wait 0.05; }
		}
		else if(self meleeButtonPressed())
		{
			wait 1;
			if(!self meleeButtonPressed())
			{ continue; }

			self thread goToLz();
			break;
		}
	}
}

setOverlay(overlay)
{
	self endon("death");
	self endon("disconnect");
	self endon("joined_spectators");

	//Setup some huds
	if( !isDefined( self.ac130_timer ) )
	{
		self.ac130_timer = newClientHudElem( self );
		self.ac130_timer.x = 635;
		self.ac130_timer.y = 250;
		self.ac130_timer.alignx = "right";
		self.ac130_timer.aligny = "middle";
		self.ac130_timer.horzAlign = "fullscreen";
		self.ac130_timer.vertAlign = "fullscreen";
		self.ac130_timer.alpha = 1.0;
		self.ac130_timer.fontScale = 2;
		self.ac130_timer.sort = 100;
		self.ac130_timer.foreground = true;
		self.ac130_timer.glowAlpha = 0.1;
		self.ac130_timer.glowColor = (1, 1, 0);
		self.ac130_timer setTimer( level.ac130_time );
	}

	if( !isDefined( self.ac130_overlay ) )
	{
		self.ac130_overlay = newClientHudElem( self );
		self.ac130_overlay.x = 0;
		self.ac130_overlay.y = 0;
		self.ac130_overlay.alignX = "center";
		self.ac130_overlay.alignY = "middle";
		self.ac130_overlay.horzAlign = "center";
		self.ac130_overlay.vertAlign = "middle";
		self.ac130_overlay.foreground = true;
	}
	self.ac130_overlay setshader(overlay, 640, 480);

	// Ac130 vision
	if( level.ac130_useVision == 1 )
	{
		self setClientDvar( "ui_player_ac130", 1 );
/*
		if( !isDefined( self.ac130_grain ) )
		{
			self.ac130_grain = newClientHudElem( self );
			self.ac130_grain.x = 0;
			self.ac130_grain.y = 0;
			self.ac130_grain.alignX = "left";
			self.ac130_grain.alignY = "top";
			self.ac130_grain.horzAlign = "fullscreen";
			self.ac130_grain.vertAlign = "fullscreen";
			self.ac130_grain.foreground = true;
			self.ac130_grain.alpha = 0.5;
			self.ac130_grain setshader("ac130_overlay_grain", 640, 480);
		}
*/
		if( level.isnight )
		{ self btd\_utils::setFilmTweaks(1, 0, 1, "1 1 1",  "1 1 1", 1, 3.5); }
/*
		//Ac130 inverted vision
		self btd\_utils::setFilmTweaks(1, 1, 1, "1 1 1",  "1 1 1", 0.13, 1.55);
		self btd\_utils::setGlowTweaks(1, 0.99, 0.65, 0.36, 7);
*/
	}

	self waittill("left_ac130");

	if( level.ac130_useVision == 1 )
	{
		self setClientDvar( "ui_player_ac130", 0 );
		self btd\_utils::setFilmTweaksOff();
		self btd\_utils::setGlowTweaksOff();
	}

	if( isDefined(self.ac130_timer ) )
	{ self.ac130_timer destroy(); }

	//if (isDefined(self.ac130_grain))
	//{ self.ac130_grain destroy(); }

	if (isDefined(self.ac130_overlay))
	{ self.ac130_overlay destroy(); }
}

shotFired()
{
	self endon("death");
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("left_ac130");

	for(;;)
	{
		self waittill("projectile_impact", weapon, position, radius);

		self thread shotFiredScreenShake( weapon );
		self thread shotFiredPhysicsSphere(position, weapon);
		wait 0.05;
	}
}

shotFiredScreenShake(weapon)
{
	self endon("death");
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("left_ac130");

	switch(weapon)
	{
		case "hind_FFAR_mp":
			duration = 1;
		break;

		default:
			duration = 0;
		break;
	}

	if(duration)
	{ earthquake(duration, 1, self.origin, 1000); }
}

shotFiredPhysicsSphere(center, weapon)
{
	wait 0.1;
	physicsExplosionSphere(center, level.physicsSphereRadius[weapon], level.physicsSphereRadius[weapon] / 2, level.physicsSphereForce[weapon]);
}

//================================================================================================

getAboveBuildingsLocation(location)
{
   trace = bullettrace(location + (0,0,10000), location, false, undefined);
   startorigin = trace["position"] + (0,0,-514);
   
   zpos = 0;
   
   maxxpos = 13; maxypos = 13;
   for (xpos = 0; xpos < maxxpos; xpos++)
   {
      for (ypos = 0; ypos < maxypos; ypos++)
      {
         thisstartorigin = startorigin + ((xpos/(maxxpos-1) - .5) * 1024, (ypos/(maxypos-1) - .5) * 1024, 0);
         thisorigin = bullettrace(thisstartorigin, thisstartorigin + (0,0,-10000), false, undefined);
         zpos += thisorigin["position"][2];
      }
   }

   zpos = zpos / (maxxpos*maxypos);
   //zpos = zpos + 1000;

   return(location[0], location[1], zpos);
}

rotatePlane(toggle)
{
	self notify("stop_rotatePlane_thread");
	self endon("stop_rotatePlane_thread");
	self endon( "leaving" );

	if(toggle)
	{
		for(;;)
		{
			self rotateyaw( 360, level.ac130_rotationSpeed );
			wait level.ac130_rotationSpeed;
		}
	}
	else
	{
		self rotateyaw( self.angles[2], 0.05 );
	}
}

addToArray(array, entname)
{
	if(!isDefined(array))
	{
		array = [];
	}

	if(!isDefined(entname))
	{
		return array;
	}

	entarray = getEntArray(entname, "classname");
	for(i = 0; i < entarray.size; i++)
	{
		array[array.size] = entarray[i];
	}

	return array;
}

GetMapDim()
{
	xMax = -30000;
	xMin = 30000;

	yMax = -30000;
	yMin = 30000;

	zMax = -30000;
	zMin = 30000;

	xMin_e[0] = xMax;
	yMin_e[1] = yMax;
	zMin_e[2] = zMax;

	xMax_e[0] = xMin;
	yMax_e[1] = yMin;
	zMax_e[2] = zMin;       

	entitytypes = getentarray();

	for(i = 1; i < entitytypes.size; i++)
	{
		if(isDefined(entitytypes[i].origin))
		{
			trace = bulletTrace(entitytypes[i].origin, entitytypes[i].origin - (30000,0,0), false, undefined);
			if(trace["fraction"] != 1) xMin_e = trace["position"];
	
			trace = bulletTrace(entitytypes[i].origin, entitytypes[i].origin + (30000,0,0), false, undefined);
			if(trace["fraction"] != 1) xMax_e = trace["position"];
	
			trace = bulletTrace(entitytypes[i].origin, entitytypes[i].origin - (0,30000,0), false, undefined);
			if(trace["fraction"] != 1) yMin_e = trace["position"];
	
			trace = bulletTrace(entitytypes[i].origin, entitytypes[i].origin + (0,30000,0), false, undefined);
			if(trace["fraction"] != 1) yMax_e = trace["position"];
	
			trace = bulletTrace(entitytypes[i].origin, entitytypes[i].origin - (0,0,30000), false, undefined);
			if(trace["fraction"] != 1) zMin_e = trace["position"];
	
			trace = bulletTrace(entitytypes[i].origin, entitytypes[i].origin + (0,0,30000), false, undefined);
			if(trace["fraction"] != 1) zMax_e = trace["position"];

			if(xMin_e[0] < xMin) xMin = xMin_e[0];
			if(yMin_e[1] < yMin) yMin = yMin_e[1];
			if(zMin_e[2] < zMin) zMin = zMin_e[2];
	
			if(xMax_e[0] > xMax) xMax = xMax_e[0];
			if(yMax_e[1] > yMax) yMax = yMax_e[1];
			if(zMax_e[2] > zMax) zMax = zMax_e[2];       
		}
		wait 0.05;
	}

	level.ex_playArea_Centre = (int(xMax + xMin)/2, int(yMax + yMin)/2, int(zMax + zMin)/2);
	level.ex_mapArea_Max = (xMax, yMax, zMax);
	level.ex_mapArea_Min = (xMin, yMin, zMin);
	level.ex_mapArea_Width = int(distance((xMin,yMin,zMax),(xMax,yMin,zMax)));
	level.ex_mapArea_Length = int(distance((xMin,yMin,zMax),(xMin,yMax,zMax)));

	entitytypes = [];
	entitytypes = undefined;
}

GetFieldDim()
{
	spawnpoints = [];
	spawnpoints = addToArray(spawnpoints, "mp_dm_spawn");
	spawnpoints = addToArray(spawnpoints, "mp_tdm_spawn");
	spawnpoints = addToArray(spawnpoints, "mp_dom_spawn");
	spawnpoints = addToArray(spawnpoints, "mp_sab_spawn_allies");
	spawnpoints = addToArray(spawnpoints, "mp_sab_spawn_axis");
	spawnpoints = addToArray(spawnpoints, "mp_sd_spawn_attacker");
	spawnpoints = addToArray(spawnpoints, "mp_sd_spawn_defender");

	xMax = spawnpoints[0].origin[0];
	xMin = spawnpoints[0].origin[0];

	yMax = spawnpoints[0].origin[1];
	yMin = spawnpoints[0].origin[1];

	zMax = spawnpoints[0].origin[2];
	zMin = spawnpoints[0].origin[2];

	for(i = 1; i < spawnpoints.size; i++)
	{
		if (spawnpoints[i].origin[0] > xMax) xMax = spawnpoints[i].origin[0];
		if (spawnpoints[i].origin[1] > yMax) yMax = spawnpoints[i].origin[1];
		if (spawnpoints[i].origin[2] > zMax) zMax = spawnpoints[i].origin[2];
		if (spawnpoints[i].origin[0] < xMin) xMin = spawnpoints[i].origin[0];
		if (spawnpoints[i].origin[1] < yMin) yMin = spawnpoints[i].origin[1];
		if (spawnpoints[i].origin[2] < zMin) zMin = spawnpoints[i].origin[2];
	}

	level.ex_playArea_Centre = (int(xMax + xMin)/2, int(yMax + yMin)/2, int(zMax + zMin)/2);
	level.ex_playArea_Min = (xMin, yMin, zMin);
	level.ex_playArea_Max = (xMax, yMax, zMax);
	level.ex_playArea_Width = int(distance((xMin, yMin, 800),(xMax, yMin, 800)));
	level.ex_playArea_Length = int(distance((xMin, yMin, 800),(xMin, yMax, 800)));
}
