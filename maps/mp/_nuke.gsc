//================================================================================================
// File Name  : _nuke.gsc 
// File Info  : Tactical Nuke Hard-Point.
// Mod        : WaffleMod v1 and Before the Dawn Zombotron
// Authors    : Waffles - mangled by Zod
//================================================================================================
#include btd\_sound_util;
#include maps\mp\_utility;

init()
{
	precacheShader( "hud_znuke" );
	level.nukeInProgress = undefined;
}

selectNukeLocation()
{
	self beginLocationSelection( "map_artillery_selector", level.artilleryDangerMaxRadius * 1.2 );
	self.selectingLocation = true;

	self thread maps\mp\gametypes\_hardpoints::endSelectionOn( "cancel_location" );
	self thread maps\mp\gametypes\_hardpoints::endSelectionOn( "death" );
	self thread maps\mp\gametypes\_hardpoints::endSelectionOn( "disconnect" );
	self thread maps\mp\gametypes\_hardpoints::endSelectionOn( "used" );
	self thread maps\mp\gametypes\_hardpoints::endSelectionOnGameEnd();

	self endon( "stop_location_selection" );
	self waittill( "confirm_location", location );

	if ( isDefined( level.nukeInProgress ) || level.wrath_active || level.napalm_active )
	{
		self iPrintLnBold( &"BTDZ_NUKE_NOT_AVAILABLE" );
		self thread maps\mp\gametypes\_hardpoints::stopAirstrikeLocationSelection( false );
		return false;
	}

	level thread playsoundatlocation( "air_raid_siren" , location );

	level.nukeInProgress = true;

	self thread finishNukeUsage( location );

	return true;
}

finishNukeUsage(location)
{
	self notify( "used" );
	wait ( 0.05 );
	self thread maps\mp\gametypes\_hardpoints::stopAirstrikeLocationSelection( false );
	announcement("Tactical Nuke Planted by ^3" + self.name + "^7!");
	level thread nuke_detonation( self, location );
	return true;
}

nuke_detonation( owner, location )
{
	level endon("game_ended");

	announcement("Detonation in: ^33");
	wait 1;
	announcement("Detonation in: ^32");
	wait 1;
	announcement("Detonation in: ^31");
	wait 1;

	level thread playsoundatlocation("nuke_impact", location, 17);

	physicsExplosionSphere( location, 5000, 2500, 6 );
	playfx( level.fx_nukeflash, location );

	wait( 2 );

	playfx( level.fx_nuke, location );
	level thread playsoundatlocation("nuke_explode", location, 9);
	level thread nuke_earthquake(location);
	level thread nuke_radiation_damage(owner);
/*
	setplayerignoreradiusdamage( true );
	radiusDamage( location, 5000, 300, 100, owner );
	setplayerignoreradiusdamage( false );
*/

	wait( 2.5 );

	visionSetNaked( "nuclear", 6 );
	level thread nuke_affect_players();
	//setDvar("g_speed", int(level.btd_g_speed * 0.75));

	wait( 12.5 );

	level.nukeInProgress = undefined;

	if( getdvar("scr_setvisionmap") == "map" )
		visionSetNaked( getDvar( "mapname" ), 1.0 );
	else
		visionSetNaked( getdvar("scr_setvisionmap"), 1.0 );
}

nuke_radiation_damage(owner)
{
	level endon("game_ended");
	level endon("wave_end");

	while(isDefined(level.nukeInProgress))
	{
		zoms = getentarray("zom","targetname");
		for(i=0;i<zoms.size;i++)
		{
			wait(randomfloatrange(0.15, 0.25)); // Slow the killing up to avoid overflow and undefined errors

			if( isDefined(zoms[i].bIsBot) && zoms[i].bIsBot )
			{
				if( zoms[i].health > 0 )
				{
					if( level.boss > 0 && zoms[i].isNormalzom == true )
					{
						zoms[i] notify( "damage", int(zoms[i].health * 0.25), owner, (0,1,0), zoms[i].origin, "MOD_EXPLOSIVE", "", "", "", 1 );
					}
					else
					{
						zoms[i] notify( "damage", zoms[i].maxhealth, owner, (0,1,0), zoms[i].origin, "MOD_EXPLOSIVE", "", "", "", 1 );
					}
				}
			}
		}
		wait( 1 );
	}
}

nuke_earthquake(location)
{
	level endon("game_ended");
	level endon("wave_end");

	earthquake( 0.5, 1, location, 80000);

	while(isDefined(level.nukeInProgress))
	{
		earthquake( 0.2, 0.05, location, 80000);
		wait(.05);
	}
}

nuke_affect_players()
{
	while(isDefined(level.nukeInProgress))
	{
		players = getentarray("player", "classname");
		for(i = 0; i < players.size; i++)
		{
			if( isAlive( players[i] ) )
			{ players[i] playLocalSound("breathing_hurt"); }
		}
		wait .784;
		wait (0.1 + randomfloat (0.8));
	}

	//setDvar("g_speed", level.btd_g_speed);
}

