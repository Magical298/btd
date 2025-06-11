#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include btd\_hud_util;
#include btd\_dvardef;

init()
{
	precacheItem( "radar_mp" );
	precacheItem( "airstrike_mp" );
	precacheItem( "helicopter_mp" );
	precacheItem( "artillery_mp" );
	precacheItem( "blackhawk_mp" );
	precacheItem( "napalm_mp" );
	precacheItem( "ac130_mp" );
	precacheItem( "nuke_mp" );

	precacheShader("compass_objpoint_satallite");
	precacheShader("compass_objpoint_helicopter");
	precacheShader("compass_objpoint_airstrike");
	precacheShader("compassping_explosion");

	btd\_rampage::main();
	btd\_flyby::init();

	makeDvarServerInfo( "ui_uav_allies", 0 );
	makeDvarServerInfo( "ui_uav_axis", 0 );
	setDvar( "ui_uav_allies", 0 );
	setDvar( "ui_uav_axis", 0 );
	setDvar( "ui_uav_client", 0 );

	level.btd_life_award = createdvar("btd_award_lives",0,0,1,"int");
	level.btd_life_killstreak = createdvar("btd_lives_killstreak",250,10,10000,"int");

	level.btd_perk_awards = createdvar("btd_perk_awards",1,0,1,"int");
	level.btd_blackhawk = createdvar("btd_blackhawk",1,0,1,"int");
	level.btd_napalm = createdvar("btd_napalm",0,0,1,"int");
	level.btd_ac130 = createdvar("btd_ac130",1,0,1,"int");
	level.btd_nuke = createdvar("btd_tactical_nuke",1,0,1,"int");

	level.btd_perk_stopping_power_streak = createdvar("btd_perk_stopping_power_streak",10,10,10000,"int");
	level.btd_perk_extreme_conditioning_streak = createdvar("btd_perk_extreme_conditioning_streak",20,10,10000,"int");
	level.btd_perk_sonic_boom_streak = createdvar("btd_perk_sonic_boom_streak",30,10,10000,"int");
	level.btd_perk_double_tap_streak = createdvar("btd_perk_double_tap_streak",40,10,10000,"int");
	level.btd_perk_sleight_hand_streak = createdvar("btd_perk_sleight_of_hand_streak",50,10,10000,"int");
	level.btd_perk_deep_impact_streak = createdvar("btd_perk_deep_impact_streak",60,10,10000,"int");
	level.btd_perk_steady_aim_streak = createdvar("btd_perk_steady_aim_streak",70,10,10000,"int");

	level.btd_helicopter_killstreak = createdvar("btd_helicopter_streak",100,10,10000,"int");
	level.btd_airstrike_killstreak = createdvar("btd_airstrike_streak",145,10,10000,"int");
	level.btd_blackhawk_killstreak = createdvar("btd_blackhawk_streak",320,10,10000,"int");
	level.btd_napalm_killstreak = createdvar("btd_napalm_streak",283,10,10000,"int");
	level.btd_ac130_killstreak = createdvar("btd_ac130_streak",485,10,10000,"int");
	level.btd_woz_killstreak = createdvar("btd_woz_streak",500,10,10000,"int");
	level.btd_nuke_killstreak = createdvar("btd_tactical_nuke_streak",666,10,10000,"int");

	level.wrath_effect["lightning_flash"] = loadfx("weather/horizon_flash_runner");
	level.wrath_effect["lightning_bolt"] = loadfx("weather/lightning_bolt");
	level.wrath_effect["woz_strike"] = loadfx("weather/woz_strike");
	level.wrath_active = false;

	level.hardpointItems = [];
	priority = 0;

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "hardpoint", "allowartillery" ) )
	{
		level.hardpointItems["airstrike_mp"] = priority;
		priority++;
	}

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "hardpoint", "allowhelicopter" ) )
	{
		level.hardpointItems["helicopter_mp"] = priority;
		priority++;
	}

	if ( level.btd_rampage == 1 )
	{
		level.hardpointItems["briefcase_bomb_defuse_mp"] = priority;
		priority++;
	}

	if ( level.btd_blackhawk == 1 )
	{
		level.hardpointItems["blackhawk_mp"] = priority;
		priority++;
	}

	if ( level.btd_napalm == 1 )
	{
		level.hardpointItems["napalm_mp"] = priority;
		priority++;
	}

	if ( level.btd_ac130 == 1 )
	{
		level.hardpointItems["ac130_mp"] = priority;
		priority++;
	}

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "hardpoint", "allowuav" ) )
	{
		level.hardpointItems["radar_mp"] = priority;
		priority++;
	}

	if ( level.btd_nuke == 1 )
	{
		level.hardpointItems["nuke_mp"] = priority;
		priority++;
	}

	level.hardpointHints["radar_mp"] = &"BTDZ_EARNED_WOZ";
	level.hardpointHints["airstrike_mp"] = &"MP_EARNED_AIRSTRIKE";
	level.hardpointHints["helicopter_mp"] = &"MP_EARNED_HELICOPTER";
	level.hardpointHints["briefcase_bomb_defuse_mp"] = &"BTDZ_EARNED_RAMPAGE";
	level.hardpointHints["blackhawk_mp"] = &"BTDZ_EARNED_BLACKHAWK";
	level.hardpointHints["napalm_mp"] = &"BTDZ_EARNED_NAPALM";
	level.hardpointHints["ac130_mp"] = &"BTDZ_EARNED_AC130";
	level.hardpointHints["nuke_mp"] = &"BTDZ_EARNED_NUKE";

	level.hardpointHints["radar_mp_not_available"] = &"BTDZ_WOZ_NOT_AVAILABLE";
	level.hardpointHints["airstrike_mp_not_available"] = &"MP_AIRSTRIKE_NOT_AVAILABLE";
	level.hardpointHints["helicopter_mp_not_available"] = &"MP_HELICOPTER_NOT_AVAILABLE";
	level.hardpointHints["briefcase_bomb_defuse_mp_not_available"] = &"BTDZ_RAMPAGE_NOT_AVAILABLE";
	level.hardpointHints["blackhawk_mp_not_available"] = &"BTDZ_BLACKHAWK_NOT_AVAILABLE";
	level.hardpointHints["napalm_mp_not_available"] = &"BTDZ_NAPALM_NOT_AVAILABLE";
	level.hardpointHints["ac130_mp_not_available"] = &"BTDZ_AC130_NOT_AVAILABLE";
	level.hardpointHints["nuke_mp_not_available"] = &"BTDZ_NUKE_NOT_AVAILABLE";

	level.hardpointInforms["radar_mp"] = "killstreak_won";
	level.hardpointInforms["airstrike_mp"] = "mp_killstreak_jet";
	level.hardpointInforms["helicopter_mp"] = "mp_killstreak_heli";
	level.hardpointInforms["briefcase_bomb_defuse_mp"] = "rampage";
	level.hardpointInforms["blackhawk_mp"] = "mp_killstreak_heli";
	level.hardpointInforms["napalm_mp"] = "killstreak_won";
	level.hardpointInforms["ac130_mp"] = "mp_killstreak_jet";
	level.hardpointInforms["nuke_mp"] = "mp_level_up";

	maps\mp\gametypes\_rank::registerScoreInfo( "hardpoint", 10 );

	precacheString( level.hardpointHints["radar_mp"] );
	precacheString( level.hardpointHints["airstrike_mp"] );
	precacheString( level.hardpointHints["helicopter_mp"] );
	precacheString( level.hardpointHints["briefcase_bomb_defuse_mp"] );
	precacheString( level.hardpointHints["blackhawk_mp"] );
	precacheString( level.hardpointHints["napalm_mp"] );
	precacheString( level.hardpointHints["ac130_mp"] );
	precacheString( level.hardpointHints["nuke_mp"] );
	precacheString( level.hardpointHints["radar_mp_not_available"] );
	precacheString( level.hardpointHints["airstrike_mp_not_available"] );
	precacheString( level.hardpointHints["helicopter_mp_not_available"] );
	precacheString( level.hardpointHints["briefcase_bomb_defuse_mp_not_available"] );
	precacheString( level.hardpointHints["blackhawk_mp_not_available"] );
	precacheString( level.hardpointHints["napalm_mp_not_available"] );
	precacheString( level.hardpointHints["ac130_mp_not_available"] );
	precacheString( level.hardpointHints["nuke_mp_not_available"] );

	precacheString( &"MP_KILLSTREAK_N" );

	precacheString( &"BTDZ_RAMPAGE_INBOUND" );
	precacheString( &"BTDZ_BLACKHAWK_INBOUND" );
	precacheString( &"BTDZ_NAPALM_INBOUND" );
	precacheString( &"BTDZ_AC130_INBOUND" );
	precacheString( &"BTDZ_WOZ_INBOUND" );
	precacheString( &"BTDZ_NUKE_INBOUND" );

	precacheLocationSelector( "map_artillery_selector" );

	level.airstrikefx = loadfx ("explosions/clusterbomb");
	level.mortareffect = loadfx ("explosions/artilleryExp_dirt_brown");
	level.bombstrike = loadfx ("explosions/wall_explosion_pm_a");

	level.fx_airstrike_afterburner = loadfx ("fire/jet_afterburner");
	level.fx_airstrike_contrail = loadfx ("smoke/jet_contrail");

	level.fx_heli_dust = loadfx ("treadfx/heli_dust_default");
	level.fx_heli_water = loadfx ("treadfx/heli_water");

	level.fx_nuke = loadfx ("explosions/nuke");
	level.fx_nukeflash = loadfx ( "explosions/nuke_flash" );

	level.fx_napalm = loadfx ("explosions/napalm");
	level.napalm_active = false;

	game["dialog"]["uav_online"] = "ouruavonline";
	game["dialog"]["uav_offline"] = "";
	game["dialog"]["enemy_uav_online"] = "enemyuavair";
	game["dialog"]["enemy_uav_offline"] = "";
	game["dialog"]["airstrike_inbound"] = "friendlyair";
	game["dialog"]["enemy_airstrike_inbound"] = "enemyair";
	game["dialog"]["helicopter_inbound"] = "friendlyheli";
	game["dialog"]["enemy_helicopter_inbound"] = "enemyheli";

	game["dialog"]["radar_mp"] = "uavrecon";
	game["dialog"]["airstrike_mp"] = "airstrike";
	game["dialog"]["helicopter_mp"] = "helisupport";
	game["dialog"]["briefcase_bomb_defuse_mp"] = "uavrecon";
	game["dialog"]["blackhawk_mp"] = "helisupport";
	game["dialog"]["napalm_mp"] = "airstrike";
	game["dialog"]["ac130_mp"] = "airstrike";
	game["dialog"]["nuke_mp"] = "airstrike";

	// time interval between usage of helicopter hardpoint
	if ( getdvar( "scr_heli_hardpoint_interval" ) != "" )
		level.helicopterInterval = getdvarfloat( "scr_heli_hardpoint_interval" );
	else
	{
		setdvar( "scr_heli_hardpoint_interval" , 180 );
		level.helicopterInterval = 180; // time between allowed uses of helicopter
	}

	// airstrike danger area is the circle of radius artilleryDangerMaxRadius 
	// stretched by a factor of artilleryDangerOvalScale in the direction of the incoming airstrike,
	// moved by artilleryDangerForwardPush * artilleryDangerMaxRadius in the same direction.
	// use scr_airstrikedebug to visualize.

	level.artilleryDangerMaxRadius = 450;
	level.artilleryDangerMinRadius = 300;
	level.artilleryDangerForwardPush = 1.5;
	level.artilleryDangerOvalScale = 6.0;

	level.artilleryMapRange = level.artilleryDangerMinRadius * .3 + level.artilleryDangerMaxRadius * .7;

	level.artilleryDangerMaxRadiusSq = level.artilleryDangerMaxRadius * level.artilleryDangerMaxRadius;

	level.artilleryDangerCenters = [];

	level.radarViewTime = 30; // time radar remains active

	level.numHardpointReservedObjectives = 0;

	maps\mp\_nuke::init();
	maps\mp\_helicopter::init();
	maps\mp\_blackhawk::init();
	maps\mp\_ac130::init();
}

distance2d(a,b)
{
	return distance((a[0],a[1],0), (b[0],b[1],0));
}

teamHasRadar(team)
{
	return getTeamRadar(team);
}

doArtillery(origin, owner, team)
{
	num = 17 + randomint(3);
	
	level.airstrikeInProgress = true;
	trace = bullettrace(origin, origin + (0,0,-10000), false, undefined);
	targetpos = trace["position"];
	
	yaw = getBestPlaneDirection( targetpos );
	
	if ( level.teambased )
	{
		players = level.players;
		if ( !level.hardcoreMode )
		{
			for(i = 0; i < players.size; i++)
			{
				if(isalive(players[i]) && (isdefined(players[i].pers["team"])) && (players[i].pers["team"] == team)) {
					if ( pointIsInAirstrikeArea( players[i].origin, targetpos, yaw ) )
						players[i] iprintlnbold(&"MP_WAR_AIRSTRIKE_INBOUND_NEAR_YOUR_POSITION");
				}
			}
		}
		
		maps\mp\gametypes\_globallogic::leaderDialog( "airstrike_inbound", team );
//		maps\mp\gametypes\_globallogic::leaderDialog( "enemy_airstrike_inbound", level.otherTeam[team] );
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			playerteam = player.pers["team"];
			if ( isdefined( playerteam ) )
			{
				if ( playerteam == team )
					player iprintln( &"MP_WAR_AIRSTRIKE_INBOUND", owner );
			}
		}
	}
	else
	{
		owner maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "airstrike_inbound" );
		/*
		for ( i = 0; i < level.players.size; i++ )
		{
			if ( level.players[i] != owner && isDefined( level.players[i].team ) )
				level.players[i] maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "enemy_airstrike_inbound" );
		}
		*/

		if ( !level.hardcoreMode )
		{
			if ( pointIsInAirstrikeArea( owner.origin, targetpos, yaw ) )
				owner iprintlnbold(&"MP_WAR_AIRSTRIKE_INBOUND_NEAR_YOUR_POSITION");
		}
	}
	
	wait 2;

	if ( !isDefined( owner ) )
	{
		level.airstrikeInProgress = undefined;
		return;
	}
	
	owner notify ( "begin_airstrike" );
	
	dangerCenter = spawnstruct();
	dangerCenter.origin = targetpos;
	dangerCenter.forward = anglesToForward( (0,yaw,0) );
	level.artilleryDangerCenters[ level.artilleryDangerCenters.size ] = dangerCenter;
	/# level thread debugArtilleryDangerCenters(); #/
	
	callStrike( owner, targetpos, yaw );
	
	wait 8.5;
	
	found = false;
	newarray = [];
	for ( i = 0; i < level.artilleryDangerCenters.size; i++ )
	{
		if ( !found && level.artilleryDangerCenters[i].origin == targetpos )
		{
			found = true;
			continue;
		}
		
		newarray[ newarray.size ] = level.artilleryDangerCenters[i];
	}
	assert( found );
	assert( newarray.size == level.artilleryDangerCenters.size - 1 );
	level.artilleryDangerCenters = newarray;

	level.airstrikeInProgress = undefined;
}

/#
debugArtilleryDangerCenters()
{
	level notify("debugArtilleryDangerCenters_thread");
	level endon("debugArtilleryDangerCenters_thread");
	
	if ( getdvar("scr_airstrikedebug") != "1" && getdvar("scr_spawnpointdebug") == "0" )
	{
		return;
	}
	
	while( level.artilleryDangerCenters.size > 0 )
	{
		for ( i = 0; i < level.artilleryDangerCenters.size; i++ )
		{
			origin = level.artilleryDangerCenters[i].origin;
			forward = level.artilleryDangerCenters[i].forward;
			
			origin += forward * level.artilleryDangerForwardPush * level.artilleryDangerMaxRadius;
			
			previnnerpos = (0,0,0);
			prevouterpos = (0,0,0);
			for ( j = 0; j <= 40; j++ )
			{
				frac = (j * 1.0) / 40;
				angle = frac * 360;
				dir = anglesToForward((0,angle,0));
				forwardPart = vectordot( dir, forward ) * forward;
				perpendicularPart = dir - forwardPart;
				pos = forwardPart * level.artilleryDangerOvalScale + perpendicularPart;
				innerpos = pos * level.artilleryDangerMinRadius;
				innerpos += origin;
				outerpos = pos * level.artilleryDangerMaxRadius;
				outerpos += origin;
				
				if ( j > 0 )
				{
					line( innerpos, previnnerpos, (1, 0, 0) );
					line( outerpos, prevouterpos, (1,.5,.5) );
				}
				
				previnnerpos = innerpos;
				prevouterpos = outerpos;
			}
		}
		wait .05;
	}
}
#/

getAirstrikeDanger( point )
{
	danger = 0;
	for ( i = 0; i < level.artilleryDangerCenters.size; i++ )
	{
		origin = level.artilleryDangerCenters[i].origin;
		forward = level.artilleryDangerCenters[i].forward;
		
		danger += getSingleAirstrikeDanger( point, origin, forward );
	}
	return danger;
}

getSingleAirstrikeDanger( point, origin, forward )
{
	center = origin + level.artilleryDangerForwardPush * level.artilleryDangerMaxRadius * forward;

	diff = point - center;
	diff = (diff[0], diff[1], 0);

	forwardPart = vectorDot( diff, forward ) * forward;
	perpendicularPart = diff - forwardPart;

	circlePos = perpendicularPart + forwardPart / level.artilleryDangerOvalScale;

	/* /#
	if ( getdvar("scr_airstrikedebug") == "1" )
	{
		thread airstrikeLine( center, center + perpendicularPart, (1,1,1), 30 );
		thread airstrikeLine( center + perpendicularPart, center + circlePos, (1,1,1), 30 );
		thread airstrikeLine( center + circlePos, point, (.5,.5,.5), 30 );
	}
	#/ */
	
	distsq = lengthSquared( circlePos );

	if ( distsq > level.artilleryDangerMaxRadius * level.artilleryDangerMaxRadius )
		return 0;

	if ( distsq < level.artilleryDangerMinRadius * level.artilleryDangerMinRadius )
		return 1;

	dist = sqrt( distsq );
	distFrac = (dist - level.artilleryDangerMinRadius) / (level.artilleryDangerMaxRadius - level.artilleryDangerMinRadius);

	assertEx( distFrac >= 0 && distFrac <= 1, distFrac );

	return 1 - distFrac;
}

pointIsInAirstrikeArea( point, targetpos, yaw )
{
	return distance2d( point, targetpos ) <= level.artilleryDangerMaxRadius * 1.25;
	// TODO
	//return getSingleAirstrikeDanger( point, targetpos, yaw ) > 0;
}

losRadiusDamage(pos, radius, max, min, owner, eInflictor)
{
	ents = maps\mp\gametypes\_weapons::getDamageableEnts(pos, radius, true);

	for (i = 0; i < ents.size; i++)
	{
		if (ents[i].entity == self)
			continue;

		dist = distance(pos, ents[i].damageCenter);

		if ( ents[i].isPlayer )
		{
			// check if there is a path to this entity 130 units above his feet. if not, they're probably indoors
			indoors = !maps\mp\gametypes\_weapons::weaponDamageTracePassed( ents[i].entity.origin, ents[i].entity.origin + (0,0,130), 0, undefined );
			if ( !indoors )
			{
				indoors = !maps\mp\gametypes\_weapons::weaponDamageTracePassed( ents[i].entity.origin + (0,0,130), pos + (0,0,130 - 16), 0, undefined );
				if ( indoors )
				{
					// give them a distance advantage for being indoors.
					dist *= 4;
					if ( dist > radius )
						continue;
				}
			}
		}

		ents[i].damage = int(max + (min-max)*dist/radius);
		ents[i].pos = pos;
		ents[i].damageOwner = owner;
		ents[i].eInflictor = eInflictor;
		level.airStrikeDamagedEnts[level.airStrikeDamagedEntsCount] = ents[i];
		level.airStrikeDamagedEntsCount++;
	}
	
	thread airstrikeDamageEntsThread();
}

airstrikeDamageEntsThread()
{
	self notify ( "airstrikeDamageEntsThread" );
	self endon ( "airstrikeDamageEntsThread" );

	for ( ; level.airstrikeDamagedEntsIndex < level.airstrikeDamagedEntsCount; level.airstrikeDamagedEntsIndex++ )
	{
		if ( !isDefined( level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex] ) )
			continue;

		ent = level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex];
		
		if ( !isDefined( ent.entity ) )
			continue; 

		if ( !ent.isPlayer || isAlive( ent.entity )  )
		{
			ent maps\mp\gametypes\_weapons::damageEnt(
				ent.eInflictor, // eInflictor = the entity that causes the damage (e.g. a claymore)
				ent.damageOwner, // eAttacker = the player that is attacking
				ent.damage, // iDamage = the amount of damage to do
				"MOD_PROJECTILE_SPLASH", // sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
				"artillery_mp", // sWeapon = string specifying the weapon used (e.g. "claymore_mp")
				ent.pos, // damagepos = the position damage is coming from
				vectornormalize(ent.damageCenter - ent.pos) // damagedir = the direction damage is moving in
			);			

			level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex] = undefined;
			
			if ( ent.isPlayer )
				wait ( 0.05 );
		}
		else
		{
			level.airstrikeDamagedEnts[level.airstrikeDamagedEntsIndex] = undefined;
		}
	}
}

radiusArtilleryShellshock(pos, radius, maxduration, minduration)
{
	players = level.players;
	for (i = 0; i < players.size; i++)
	{
		if (!isalive(players[i]))
			continue;
		
		playerpos = players[i].origin + (0,0,32);
		dist = distance(pos, playerpos);
		if (dist < radius) {
			duration = int(maxduration + (minduration-maxduration)*dist/radius);
			
			players[i] thread artilleryShellshock("default", duration);
		}
	}
}

artilleryShellshock(type, duration)
{
	if (isdefined(self.beingArtilleryShellshocked) && self.beingArtilleryShellshocked)
		return;
	self.beingArtilleryShellshocked = true;
	
	self shellshock(type, duration);
	wait(duration + 1);
	
	self.beingArtilleryShellshocked = false;
}


/#
airstrikeLine( start, end, color, duration )
{
	frames = duration * 20;
	for ( i = 0; i < frames; i++ )
	{
		line(start,end,color);
		wait .05;
	}
}

traceBomb()
{
	self endon("death");
	prevpos = self.origin;
	while(1)
	{
		thread airstrikeLine( prevpos, self.origin, (.5,1,0), 20 );
		prevpos = self.origin;
		wait .2;
	}
}
#/

doPlaneStrike( owner, requiredDeathCount, bombsite, startPoint, endPoint, bombTime, flyTime, direction )
{
	// plane spawning randomness = up to 125 units, biased towards 0
	// radius of bomb damage is 512

	if ( !isDefined( owner ) ) 
		return;
	
	startPathRandomness = 100;
	endPathRandomness = 150;
	
	pathStart = startPoint + ( (randomfloat(2) - 1)*startPathRandomness, (randomfloat(2) - 1)*startPathRandomness, 0 );
	pathEnd   = endPoint   + ( (randomfloat(2) - 1)*endPathRandomness  , (randomfloat(2) - 1)*endPathRandomness  , 0 );
	
	// Spawn the planes
	plane = spawnplane( owner, "script_model", pathStart );
	plane setModel( "vehicle_mig29_desert" );
	plane.angles = direction;
	
	plane thread playPlaneFx();
	
	plane moveTo( pathEnd, flyTime, 0, 0 );
	
	/#
	if ( getdvar("scr_airstrikedebug") == "1" )
		thread airstrikeLine( pathStart, pathEnd, (1,1,1), 10 );
	#/
	
	thread callStrike_planeSound( plane, bombsite );
	
	thread callStrike_bombEffect( plane, bombTime - 1.0, owner, requiredDeathCount );
	
	// Delete the plane after its flyby
	wait flyTime;
	plane notify( "delete" );
	plane delete();
}

callStrike_bombEffect( plane, launchTime, owner, requiredDeathCount )
{
	wait ( launchTime );
	
	plane thread play_sound_in_space( "veh_mig29_sonic_boom" );

	bomb = spawnbomb( plane.origin, plane.angles );
	bomb moveGravity( vector_scale( anglestoforward( plane.angles ), 7000/1.5 ), 3.0 );
	
	bomb.ownerRequiredDeathCount = requiredDeathCount;
	
	/#
	if ( getdvar("scr_airstrikedebug") == "1" )
		 bomb thread traceBomb();
	#/
	
	wait ( 0.85 );
	bomb.killCamEnt = spawn( "script_model", bomb.origin + (0,0,200) );
	bomb.killCamEnt.angles = bomb.angles;
	bomb.killCamEnt thread deleteAfterTime( 10.0 );
	bomb.killCamEnt moveTo( bomb.killCamEnt.origin + vector_scale( anglestoforward( plane.angles ), 1000 ), 3.0 );
	wait ( 0.15 );

	newBomb = spawn( "script_model", bomb.origin );
 	newBomb setModel( "tag_origin" );
  	newBomb.origin = bomb.origin;
  	newBomb.angles = bomb.angles;

	bomb setModel( "tag_origin" );
	//plane moveTo( endPoint + ( (randomint( 300 ) - 150 ), (randomint( 300 ) - 150 ), 0 ), flyTime, 0, 0 );
	wait (0.05);

	bombOrigin = newBomb.origin;
	bombAngles = newBomb.angles;
	playfxontag( level.airstrikefx, newBomb, "tag_origin" );

	wait ( 0.5 );
	repeat = 12;
	minAngles = 5;
	maxAngles = 55;
	angleDiff = (maxAngles - minAngles) / repeat;

	for( i = 0; i < repeat; i++ )
	{
		traceDir = anglesToForward( bombAngles + (maxAngles-(angleDiff * i),randomInt( 10 )-5,0) );
		traceEnd = bombOrigin + vector_scale( traceDir, 10000 );
		trace = bulletTrace( bombOrigin, traceEnd, false, undefined );
	
		traceHit = trace["position"];
	
		/#
		if ( getdvar("scr_airstrikedebug") == "1" )
			thread airstrikeLine( bombOrigin, traceHit, (1,0,0), 20 );
		#/
//================================================================================================
// Zombotron: removed for easier radiusDamage method below..
		//thread losRadiusDamage( traceHit + (0,0,16), 512, 300, 50, owner, bomb ); // targetpos, radius, maxdamage, mindamage, player causing damage, entity that player used to cause damage

		setplayerignoreradiusdamage( true );
		radiusDamage( traceHit  + (0,0,16), 512, 300, 100, owner );
		setplayerignoreradiusdamage( false );

//================================================================================================
		if ( i%3 == 0 )
		{
			thread playsoundinspace( "artillery_impact", traceHit );
			playRumbleOnPosition( "artillery_rumble", traceHit );
			earthquake( 0.7, 0.75, traceHit, 1000 );
		}

		wait ( 0.05 );
	}
	wait ( 5.0 );
	newBomb delete();
	bomb delete();
}

spawnbomb( origin, angles )
{
	bomb = spawn( "script_model", origin );
	bomb.angles = angles;
	bomb setModel( "projectile_cbu97_clusterbomb" );

	return bomb;
}

deleteAfterTime( time )
{
	self endon ( "death" );
	wait ( 10.0 );
	
	self delete();
}

drawLine( start, end, timeSlice )
{
	drawTime = int(timeSlice * 20);
	for( time = 0; time < drawTime; time++ )
	{
		line( start, end, (1,0,0),false, 1 );
		wait ( 0.05 );
	}
}

playPlaneFx()
{
	self endon ( "death" );

	playfxontag( level.fx_airstrike_afterburner, self, "tag_engine_right" );
	playfxontag( level.fx_airstrike_afterburner, self, "tag_engine_left" );
	playfxontag( level.fx_airstrike_contrail, self, "tag_right_wingtip" );
	playfxontag( level.fx_airstrike_contrail, self, "tag_left_wingtip" );
}

getBestPlaneDirection( hitpos )
{
	if ( getdvarint("scr_airstrikebestangle") != 1 )
		return randomfloat( 360 );

	checkPitch = -25;

	numChecks = 15;

	startpos = hitpos + (0,0,64);

	bestangle = randomfloat( 360 );
	bestanglefrac = 0;

	fullTraceResults = [];

	for ( i = 0; i < numChecks; i++ )
	{
		yaw = ((i * 1.0 + randomfloat(1)) / numChecks) * 360.0;
		angle = (checkPitch, yaw + 180, 0);
		dir = anglesToForward( angle );
		
		endpos = startpos + dir * 1500;
		
		trace = bullettrace( startpos, endpos, false, undefined );
		
		/#
		if ( getdvar("scr_airstrikedebug") == "1" )
			thread airstrikeLine( startpos, trace["position"], (1,1,0), 20 );
		#/
		
		if ( trace["fraction"] > bestanglefrac )
		{
			bestanglefrac = trace["fraction"];
			bestangle = yaw;
			
			if ( trace["fraction"] >= 1 )
				fullTraceResults[ fullTraceResults.size ] = yaw;
		}
		
		if ( i % 3 == 0 )
			wait .05;
	}

	if ( fullTraceResults.size > 0 )
		return fullTraceResults[ randomint( fullTraceResults.size ) ];

	return bestangle;
}

callStrike( owner, coord, yaw )
{
	// Get starting and ending point for the plane
	direction = ( 0, yaw, 0 );
	planeHalfDistance = 24000;
	planeBombExplodeDistance = 1500;
	planeFlyHeight = 850;
	planeFlySpeed = 7000;

	if ( isdefined( level.airstrikeHeightScale ) )
	{
		planeFlyHeight *= level.airstrikeHeightScale;
	}

	startPoint = coord + vector_scale( anglestoforward( direction ), -1 * planeHalfDistance );
	startPoint += ( 0, 0, planeFlyHeight );

	endPoint = coord + vector_scale( anglestoforward( direction ), planeHalfDistance );
	endPoint += ( 0, 0, planeFlyHeight );

	// Make the plane fly by
	d = length( startPoint - endPoint );
	flyTime = ( d / planeFlySpeed );

	// bomb explodes planeBombExplodeDistance after the plane passes the center
	d = abs( d/2 + planeBombExplodeDistance  );
	bombTime = ( d / planeFlySpeed );

	assert( flyTime > bombTime );

	owner endon("disconnect");

	requiredDeathCount = owner.deathCount;

	level.airstrikeDamagedEnts = [];
	level.airStrikeDamagedEntsCount = 0;
	level.airStrikeDamagedEntsIndex = 0;
	level thread doPlaneStrike( owner, requiredDeathCount, coord, startPoint+(0,0,randomInt(500)), endPoint+(0,0,randomInt(500)), bombTime, flyTime, direction );
	wait randomfloatrange( 1.5, 2.5 );
	level thread doPlaneStrike( owner, requiredDeathCount, coord, startPoint+(0,0,randomInt(200)), endPoint+(0,0,randomInt(200)), bombTime, flyTime, direction );
	wait randomfloatrange( 1.5, 2.5 );
	level thread doPlaneStrike( owner, requiredDeathCount, coord, startPoint+(0,0,randomInt(200)), endPoint+(0,0,randomInt(200)), bombTime, flyTime, direction );
}

callStrike_bomb( bombTime, coord, repeat, owner )
{
	accuracyRadius = 512;

	for( i = 0; i < repeat; i++ )
	{
		randVec = ( 0, randomint( 360 ), 0 );
		bombPoint = coord + vector_scale( anglestoforward( randVec ), accuracyRadius );

		wait bombTime;

		thread playsoundinspace( "artillery_impact", bombPoint );
		radiusArtilleryShellshock( bombPoint, 512, 8, 4);
		losRadiusDamage( bombPoint + (0,0,16), 768, 300, 50, owner); // targetpos, radius, maxdamage, mindamage, player causing damage
	}
}

flat_origin(org)
{
	rorg = (org[0],org[1],0);
	return rorg;
}

flat_angle(angle)
{
	rangle = (0,angle[1],0);
	return rangle;
}

targetisclose(other, target)
{
	infront = targetisinfront(other, target);
	if(infront)
		dir = 1;
	else
		dir = -1;
	a = flat_origin(other.origin);
	b = a+vector_scale(anglestoforward(flat_angle(other.angles)), (dir*100000));
	point = pointOnSegmentNearestToPoint(a,b, target);
	dist = distance(a,point);
	if (dist < 3000)
		return true;
	else
		return false;
}

targetisinfront(other, target)
{
	forwardvec = anglestoforward(flat_angle(other.angles));
	normalvec = vectorNormalize(flat_origin(target)-other.origin);
	dot = vectordot(forwardvec,normalvec); 
	if(dot > 0)
		return true;
	else
		return false;
}

delete_on_death (ent)
{
	ent endon ("death");
	self waittill ("death");
	if (isdefined (ent))
		ent delete();
}

play_loop_sound_on_entity(alias, offset)
{
	org = spawn ("script_origin",(0,0,0));
	org endon ("death");
	thread delete_on_death (org);
	if (isdefined (offset))
	{
		org.origin = self.origin + offset;
		org.angles = self.angles;
		org linkto (self);
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org linkto (self);
	}
//	org endon ("death");
	org playloopsound (alias);
//	println ("playing loop sound ", alias," on entity at origin ", self.origin, " at ORIGIN ", org.origin);
	self waittill ("stop sound" + alias);
	org stoploopsound (alias);
	org delete();
}

callStrike_planeSound( plane, bombsite )
{
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	while( !targetisclose( plane, bombsite ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_close_loop" );
	while( targetisinfront( plane, bombsite ) )
		wait .05;
	wait .5;
	//plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	while( targetisclose( plane, bombsite ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_close_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	plane waittill( "delete" );
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
}

playSoundinSpace (alias, origin, master)
{
	org = spawn ("script_origin",(0,0,1));
	if (!isdefined (origin))
		origin = self.origin;
	org.origin = origin;
	if (isdefined(master) && master)
		org playsoundasmaster (alias);
	else
		org playsound (alias);
	wait ( 10.0 );
	org delete();
}

giveHardpointItemForStreak()
{
	streak = self.cur_kill_streak;

	if ( streak < 10 )
		return;
/*
	if ( !getDvarInt( "scr_game_forceuav" ) )
	{
		if ( streak == 100 )
			self giveHardpoint( "radar_mp", streak );
		else if ( streak == 5 )
			self giveHardpoint( "airstrike_mp", streak );
		else if ( streak == 7 )
			self giveHardpoint( "helicopter_mp", streak );
		else if ( streak >= 10 )
		{
			if ( (streak % 5) == 0 )
				self streakNotify( streak );
		}
	}
	else
	{
		if ( streak == 3 )
		{
			self giveHardpoint( "airstrike_mp", streak );
		}
		else if ( streak == 5 )
		{
			self giveHardpoint( "helicopter_mp", streak );
		}
		else if ( streak >= 10 )
		{
			if ( (streak % 5) == 0 )
				self streakNotify( streak );
		}
	}
*/

	if(level.btd_perk_awards == 1)
	{
		awardedPerk = false;
		perkAward = "specialty_null";

		if ( streak == level.btd_perk_stopping_power_streak && !self hasPerk( "specialty_bulletdamage" ) )
		{
			perkAward = "specialty_bulletdamage";
			awardedPerk = true;
			self iprintln("^1You have earned ^2STOPPING POWER");
		}
		else if ( streak == level.btd_perk_extreme_conditioning_streak && !self hasPerk( "specialty_longersprint" ) )
		{
			perkAward = "specialty_longersprint";
			awardedPerk = true;
			self iprintln("^1You have earned ^2EXTREME CONDITIONING");
		}
		else if ( streak == level.btd_perk_sonic_boom_streak && !self hasPerk( "specialty_explosivedamage" ) )
		{
			perkAward = "specialty_explosivedamage";
			awardedPerk = true;
			self iprintln("^1You have earned ^2SONIC BOOM");
		}
		else if ( streak == level.btd_perk_double_tap_streak && !self hasPerk( "specialty_rof" ) )
		{
			perkAward = "specialty_rof";
			awardedPerk = true;
			self iprintln("^1You have earned ^2DOUBLE TAP");
		}
		else if ( streak == level.btd_perk_sleight_hand_streak && !self hasPerk( "specialty_fastreload" ) )
		{
			perkAward = "specialty_fastreload";
			awardedPerk = true;
			self iprintln("^1You have earned ^2SLEIGHT OF HAND");
		}
		else if ( streak == level.btd_perk_deep_impact_streak && !self hasPerk( "specialty_bulletpenetration" ) )
		{
			perkAward = "specialty_bulletpenetration";
			awardedPerk = true;
			self iprintln("^1You have earned ^2DEEP IMPACT");
		}
		else if ( streak == level.btd_perk_steady_aim_streak && !self hasPerk( "specialty_bulletaccuracy" ) )
		{
			perkAward = "specialty_bulletaccuracy";
			awardedPerk = true;
			self iprintln(" ^1You have earned ^2STEADY AIM");
		}

		if( awardedPerk )
		{
			self playLocalSound( "perk_award" );
			self setPerk( perkAward );
			self.extraPerks[ perkAward ] = 1;
			self showPerk( 0, perkAward, -50 );
			self thread maps\mp\gametypes\_globallogic::hidePerksAfterTime( 6.0 );
			self thread maps\mp\gametypes\_globallogic::hidePerksOnDeath();
			if( level.oldschool || level.traderon )
			{
				self.numPerks++;
			}
		}
	}

//================================================================================================
// Zombotron: 60 second weapon award to low rank players for a taste of things to come
	if( level.traderon == 0 && level.btd_weapon_award == 1 )
	{
		self btd\_weap_award::check_for_rampage(streak);
	}

	// Artillery award
	if( level.btd_artillery == 1 )
	{
		self btd\_arty::check_for_rampage(streak);
	}

	if( level.btd_life_award )
	{
		if ( ( streak % level.btd_life_killstreak ) == 0 )
		{
			self award_life();
		}
	}

	if ( ( streak % level.btd_helicopter_killstreak ) == 0 )
	{
		self giveHardpoint( "helicopter_mp", streak );
	}
	else if ( ( streak % level.btd_airstrike_killstreak ) == 0 )
	{
		self giveHardpoint( "airstrike_mp", streak );
	}
	else if ( ( streak % level.btd_rampage_killstreak ) == 0 )
	{
		self giveHardpoint( "briefcase_bomb_defuse_mp", streak );
	}
	else if ( ( streak % level.btd_blackhawk_killstreak ) == 0 )
	{
		self giveHardpoint( "blackhawk_mp", streak );
	}
	else if ( ( streak % level.btd_napalm_killstreak ) == 0 )
	{
		self giveHardpoint( "napalm_mp", streak );
	}
	else if ( ( streak % level.btd_ac130_killstreak ) == 0 )
	{
		self giveHardpoint( "ac130_mp", streak );
	}
	else if ( ( streak % level.btd_woz_killstreak ) == 0 )
	{
		self giveHardpoint( "radar_mp", streak );
	}
	else if ( ( streak % level.btd_nuke_killstreak ) == 0 )
	{
		self giveHardpoint( "nuke_mp", streak );
	}
	//else if ( streak >= 530 )
	//{
	//   if ( (streak % 100) == 0 )
	//      self streakNotify( streak );
	//}
//================================================================================================
}

streakNotify( streakVal )
{
	self endon("disconnect");

	// wait until any challenges have been processed
	self waittill( "playerKilledChallengesProcessed" );
	wait .05;
	
	notifyData = spawnStruct();
	notifyData.titleLabel = &"MP_KILLSTREAK_N";
	notifyData.titleText = streakVal;

	self maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
	
	iprintln( &"RANK_KILL_STREAK_N", self, streakVal );
}

giveHardpoint( hardpointType, streak )
{
	if ( self maps\mp\gametypes\_hardpoints::giveHardpointItem( hardpointType ) )
	{
		self thread hardpointNotify( hardpointType, streak );
	}
}

hardpointNotify( hardpointType, streakVal )
{
	self endon("disconnect");

	// wait until any challenges have been processed
	self waittill( "playerKilledChallengesProcessed" );
	wait .05;

	notifyData = spawnStruct();
	notifyData.titleLabel = &"MP_KILLSTREAK_N";
	notifyData.titleText = streakVal;
	notifyData.notifyText = level.hardpointHints[hardpointType];
	notifyData.sound = level.hardpointInforms[hardpointType];
	notifyData.leaderSound = hardpointType;
	notifyData.glowColor = (0,0,1);

	self maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}

giveHardpointItem( hardpointType )
{
	if ( level.gameEnded )
	{ return; }

	if ( isDefined( self.selectingLocation ) )
	{ return false; }

	if ( !isDefined( level.hardpointItems[hardpointType] ) )
	{ return false; }

	//if ( (!isDefined( level.heli_paths ) || !level.heli_paths.size) && hardpointType == "helicopter_mp" )
	if ( (!isDefined( level.heli_paths ) || !level.heli_paths.size) && (hardpointType == "helicopter_mp" || hardpointType == "blackhawk_mp" || hardpointType == "ac130_mp"))
	{ return false; }

	if ( isDefined( self.pers["hardPointItem"] ) )
	{
		if ( level.hardpointItems[hardpointType] < level.hardpointItems[self.pers["hardPointItem"]] )
			return false;
	}

	self giveWeapon( hardpointType );
	self giveMaxAmmo( hardpointType );
	self setActionSlot( 4, "weapon", hardpointType );
	self.pers["hardPointItem"] = hardpointType;	

	return true;
}

upgradeHardpointItem()
{
	if ( isDefined( self.selectingLocation ) )
		return;

	if ( !level.hardpointItems.size )
		return;

	hardpointType = getNextHardpointItem( self.pers["hardPointItem"] );

	if ( isDefined( self.pers["hardPointItem"] ) && level.hardpointItems[hardpointType] < level.hardpointItems[self.pers["hardPointItem"]] )
		return;

	self giveWeapon( hardpointType );
	self giveMaxAmmo( hardpointType );
	self setActionSlot( 4, "weapon", hardpointType );
	self.pers["hardPointItem"] = hardpointType;

	self thread maps\mp\gametypes\_hud_message::hintMessage( level.hardpointHints[hardpointType] );
}

getNextHardpointItem( hardpointType )
{
	hardpoints = getArrayKeys( level.hardpointItems );
	
	if ( !isDefined( hardpointType ) )
		return hardpoints[hardpoints.size-1];

	for ( index = hardpoints.size-1; index >= 0; index-- )
	{
		if ( hardpoints[index] != hardpointType )
			continue;

		if ( index != 0 )
			return hardpoints[index-1];
		else
			return hardpoints[index];
	}
}

giveOwnedHardpointItem()
{
	if ( isDefined( self.pers["hardPointItem"] ) )
		self giveHardpointItem( self.pers["hardPointItem"] );
}

hardpointItemWaiter()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	lastWeapon = self getCurrentWeapon();

	self giveOwnedHardpointItem();

	for ( ;; )
	{
		self waittill( "weapon_change" );

		currentWeapon = self getCurrentWeapon();

		switch( currentWeapon )
		{
			case "airstrike_mp":

			case "helicopter_mp":
				if ( self triggerHardpoint( currentWeapon ) )
				{	
					logString( "hardpoint: " + currentWeapon );
					self thread maps\mp\gametypes\_missions::useHardpoint( self.pers["hardPointItem"] );
					self thread [[level.onXPEvent]]( "hardpoint" );

					if( level.traderon == 1 )
					{
						self.money += 50;
					}

					self takeWeapon( currentWeapon );
					self setActionSlot( 4, "" );
					self.pers["hardPointItem"] = undefined;
				}

				if ( lastWeapon != "none" )
					self switchToWeapon( lastWeapon );
			break;

			case "briefcase_bomb_defuse_mp":
				if ( self triggerHardpoint( currentWeapon ) )
				{
					logString( "hardpoint: " + currentWeapon );
					self thread maps\mp\gametypes\_missions::useHardpoint( self.pers["hardPointItem"] );
					self thread [[level.onXPEvent]]( "hardpoint" );

					if( level.traderon == 1 )
					{ self.money += 50; }

					self takeWeapon( currentWeapon );
					self setActionSlot( 4, "" );
					self.pers["hardPointItem"] = undefined;
				}

				if ( lastWeapon != "none" )
					self switchToWeapon( lastWeapon );
			break;

			case "blackhawk_mp":
				if ( self triggerHardpoint( currentWeapon ) )
				{
					logString( "hardpoint: " + currentWeapon );
					self thread maps\mp\gametypes\_missions::useHardpoint( self.pers["hardPointItem"] );
					self thread [[level.onXPEvent]]( "hardpoint" );

					if( level.traderon == 1 )
					{
						self.money += 50;
					}

					self takeWeapon( currentWeapon );
					self setActionSlot( 4, "" );
					self.pers["hardPointItem"] = undefined;
				}

				if ( lastWeapon != "none" )
					self switchToWeapon( lastWeapon );
			break;

			case "napalm_mp":
				if ( self triggerHardpoint( currentWeapon ) )
				{
					logString( "hardpoint: " + currentWeapon );
					self thread maps\mp\gametypes\_missions::useHardpoint( self.pers["hardPointItem"] );
					self thread [[level.onXPEvent]]( "hardpoint" );

					if( level.traderon == 1 )
					{
						self.money += 50;
					}

					self takeWeapon( currentWeapon );
					self setActionSlot( 4, "" );
					self.pers["hardPointItem"] = undefined;
				}

				if ( lastWeapon != "none" )
					self switchToWeapon( lastWeapon );
			break;

			case "ac130_mp":
				if ( self triggerHardpoint( currentWeapon ) )
				{
					logString( "hardpoint: " + currentWeapon );
					self thread maps\mp\gametypes\_missions::useHardpoint( self.pers["hardPointItem"] );
					self thread [[level.onXPEvent]]( "hardpoint" );

					if( level.traderon == 1 )
					{
						self.money += 50;
					}

					self takeWeapon( currentWeapon );
					self setActionSlot( 4, "" );
					self.pers["hardPointItem"] = undefined;
				}
				else
				{
					if ( lastWeapon != "none" )
						self switchToWeapon( lastWeapon );
				}
			break;

			case "radar_mp":
				if ( self triggerHardpoint( currentWeapon ) )
				{
					logString( "hardpoint: " + currentWeapon );
					self thread maps\mp\gametypes\_missions::useHardpoint( self.pers["hardPointItem"] );
					self thread [[level.onXPEvent]]( "hardpoint" );

					if( level.traderon == 1 )
					{
						self.money += 50;
					}

					self takeWeapon( currentWeapon );
					self setActionSlot( 4, "" );
					self.pers["hardPointItem"] = undefined;
				}

				if ( lastWeapon != "none" )
					self switchToWeapon( lastWeapon );
			break;

			case "nuke_mp":
				if ( self triggerHardpoint( currentWeapon ) )
				{
					logString( "hardpoint: " + currentWeapon );
					self thread maps\mp\gametypes\_missions::useHardpoint( self.pers["hardPointItem"] );
					self thread [[level.onXPEvent]]( "hardpoint" );

					if( level.traderon == 1 )
					{
						self.money += 50;
					}

					self takeWeapon( currentWeapon );
					self setActionSlot( 4, "" );
					self.pers["hardPointItem"] = undefined;
				}

				if ( lastWeapon != "none" )
					self switchToWeapon( lastWeapon );
			break;

			case "none":
				break;
	
			default:
				lastWeapon = self getCurrentWeapon();
			break;
		}
	}
}

triggerHardPoint( hardpointType )
{
	if ( hardpointType == "radar_mp" )
	{
		if( level.wrath_active || level.napalm_active || isDefined( level.nukeInProgress ) )
		{
			self iPrintLnBold( level.hardpointHints[hardpointType+"_not_available"] );
			return false;	
		}
		else
		{
			team = self.pers["team"];
			for ( i = 0; i < level.players.size; i++ )
			{
				player = level.players[i];
				if( player == self )
				{ continue; }

				playerteam = player.pers["team"];
				if ( isdefined( playerteam ) )
				{
					if ( playerteam == team )
						player iprintln( &"BTDZ_WOZ_INBOUND", self );
				}
			}

			// Lay the smack down..
			self thread useRadarItem();
		}
	}
	else if ( hardpointType == "airstrike_mp" )
	{
		if ( isDefined( level.airstrikeInProgress ) )
		{
			self iPrintLnBold( level.hardpointHints[hardpointType+"_not_available"] );
			return false;
		}
		else
		{
  			result = self selectAirstrikeLocation();
  		}

		if ( !isDefined( result ) || !result )
			return false;

		if( level.traderon == 1 )
		{
			self.money += 50;
		}
	}
	else if ( hardpointType == "helicopter_mp" )
	{
		if ( isDefined( level.chopper ) )
		{
			self iPrintLnBold( level.hardpointHints[hardpointType+"_not_available"] );
			return false;
		}

		destination = 0;
		random_path = randomint( level.heli_paths[destination].size );
		startnode = level.heli_paths[destination][random_path];

		team = self.pers["team"];
		otherTeam = level.otherTeam[team];

		if ( level.teambased )
		{
			maps\mp\gametypes\_globallogic::leaderDialog( "helicopter_inbound", team );
			//maps\mp\gametypes\_globallogic::leaderDialog( "enemy_helicopter_inbound", otherTeam );
			for ( i = 0; i < level.players.size; i++ )
			{
				player = level.players[i];
				if( player == self )
				{ continue; }

				playerteam = player.pers["team"];
				if ( isdefined( playerteam ) )
				{
					if ( playerteam == team )
						player iprintln( &"MP_HELICOPTER_INBOUND", self );
				}
			}
		}
		else
		{
			self maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "helicopter_inbound" );
			selfarray = [];
			selfarray[0] = self;
			maps\mp\gametypes\_globallogic::leaderDialog( "enemy_helicopter_inbound", undefined, undefined, selfarray );
		}
		
		thread maps\mp\_helicopter::heli_think( self, startnode, self.pers["team"] );
	}
	else if ( hardpointType == "briefcase_bomb_defuse_mp" )
	{
		if( self.on_rampage || self.isarty || self.inHelicopter || self.inAc130 || isDefined( self.lastStand ) )
		{
			self iPrintLnBold( level.hardpointHints[hardpointType+"_not_available"] );
			return false;	
		}
		else
		{
			team = self.pers["team"];
			for ( i = 0; i < level.players.size; i++ )
			{
				player = level.players[i];
				if( player == self )
				{ continue; }

				playerteam = player.pers["team"];
				if ( isdefined( playerteam ) )
				{
					if ( playerteam == team )
						player iprintln( &"BTDZ_RAMPAGE_INBOUND", self );
				}
			}
			self thread btd\_rampage::start_rampage();
		}
	}
	else if ( hardpointType == "blackhawk_mp"  )
	{	
		if ( isDefined( level.chopper ) || self.isarty == true || self.inHelicopter == true || self.inAc130 == true || self.on_rampage || isDefined( self.lastStand ) )
		{
			self iPrintLnBold( level.hardpointHints[hardpointType+"_not_available"] );
			return false;
		}
		
		destination = 0;
		random_path = randomint( level.heli_paths[destination].size );
		startnode = level.heli_paths[destination][random_path];
		team = self.pers["team"];

		maps\mp\gametypes\_globallogic::leaderDialog( "helicopter_inbound", team );
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			if( player == self )
			{ continue; }

			playerteam = player.pers["team"];
			if ( isdefined( playerteam ) )
			{
				if ( playerteam == team )
					player iprintln( &"BTDZ_BLACKHAWK_INBOUND", self );
			}
		}

		thread maps\mp\_blackhawk::blackhawk_think( self, startnode, self.pers["team"] );
		thread maps\mp\_blackhawk::blackhawk_attachPlayer(level.chopper);
	}
	else if ( hardpointType == "napalm_mp" )
	{
		if( level.wrath_active || level.napalm_active || isDefined( level.nukeInProgress ) )
		{
			self iPrintLnBold( level.hardpointHints[hardpointType+"_not_available"] );
			return false;	
		}
		else
		{
			team = self.pers["team"];
			for ( i = 0; i < level.players.size; i++ )
			{
				player = level.players[i];
				if( player == self )
				{ continue; }

				playerteam = player.pers["team"];
				if ( isdefined( playerteam ) )
				{
					if ( playerteam == team )
						player iprintln( &"BTDZ_NAPALM_INBOUND", self );
				}
			}

			// Lay the smack down..
			self thread useNapalm();
		}
	}
	else if ( hardpointType == "ac130_mp" )
	{
		if ( isDefined( level.ac130 ) || self.isarty == true || self.inHelicopter == true || self.inAc130 == true || self.on_rampage || isDefined( self.lastStand ) )
		{
			self iPrintLnBold( level.hardpointHints[hardpointType+"_not_available"] );
			return false;
		}
		else
		{
			team = self.pers["team"];
			maps\mp\gametypes\_globallogic::leaderDialog( "airstrike_inbound", team );
			for ( i = 0; i < level.players.size; i++ )
			{
				player = level.players[i];
				if( player == self )
				{ continue; }

				playerteam = player.pers["team"];
				if ( isdefined( playerteam ) )
				{
					if ( playerteam == team )
						player iprintln( &"BTDZ_AC130_INBOUND", self );
				}
			}
			self thread maps\mp\_ac130::ac130_start();
			self thread maps\mp\_ac130::ac130_attachPlayer(level.ac130);
		}
	}
	else if ( hardpointType == "nuke_mp" )
	{
		if ( isDefined( level.nukeInProgress ) || level.wrath_active || level.napalm_active )
		{
			self iPrintLnBold( level.hardpointHints[hardpointType+"_not_available"] );
			return false;
		}
		else
		{
  			result = self maps\mp\_nuke::selectNukeLocation();
			if ( isDefined( result ) && result == true )
			{
				team = self.pers["team"];
				maps\mp\gametypes\_globallogic::leaderDialog( "airstrike_inbound", team );
				for ( i = 0; i < level.players.size; i++ )
				{
					player = level.players[i];
					if( player == self )
					{ continue; }

					playerteam = player.pers["team"];
					if ( isdefined( playerteam ) )
					{
						if ( playerteam == team )
							player iprintln( &"BTDZ_NUKE_INBOUND", self );
					}
				}
			}
  		}

		if ( !isDefined( result ) || !result )
			return false;
	}

	return true;
}

UAVAcquiredPrintAndSound( team, otherteam, callingPlayer, numseconds )
{
	soundFriendly = game["voice"][team]      + game["dialog"]["uav_online"];
	soundEnemy    = game["voice"][otherteam] + game["dialog"]["enemy_uav_online"];

	if ( level.splitscreen )
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			playerteam = player.pers["team"];
			if ( isdefined( playerteam ) )
			{
				if ( playerteam == team )
					player iprintln( &"MP_WAR_RADAR_ACQUIRED", callingPlayer, numseconds );
				else if ( playerteam == otherteam )
					player iprintln( &"MP_WAR_RADAR_ACQUIRED_ENEMY", numseconds  );
			}
		}
		assert( level.splitscreen );

		level.players[0] playLocalSound( soundFriendly );
	}
	else
	{
		maps\mp\gametypes\_globallogic::leaderDialog( "uav_online", team );
		maps\mp\gametypes\_globallogic::leaderDialog( "enemy_uav_online", otherTeam );
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			playerteam = player.pers["team"];
			if ( isdefined( playerteam ) )
			{
				if ( playerteam == team )
					player iprintln( &"MP_WAR_RADAR_ACQUIRED", callingPlayer, numseconds );
				else if ( playerteam == otherteam )
					player iprintln( &"MP_WAR_RADAR_ACQUIRED_ENEMY", numseconds  );
			}
		}
	}
}

useNapalm()
{
	level.napalm_active = true;
	visionSetNaked( "zombie_turned", 2 );

	wait(2);

	napalm_zombies(self);
}

napalm_zombies(callingPlayer)
{
	// level.ex_playArea_Centre should have been declared already
	thread playsoundinspace( "exp_suitcase_bomb_sweet1", level.ex_playArea_Centre );

	zombies = getentarray("zom","targetname");
	count = zombies.size; // Do it this way because zombies.size could cause a infinite loop condition because of respawn.
	for (i = 0; i < count; i++)
	{
		wait (randomfloatrange(0.1, 0.5));

		if( isDefined( zombies[i] ) )
		{
			if( zombies[i].health > 0 )
			{
				pos[i] = zombies[i] getOrigin();
				playfx( level.fx_napalm, pos[i] );
				earthquake( 0.7, 1, pos[i], 60 );
				thread playsoundinspace( "fire_metal_large", pos[i] );

				if( zombies[i].isNormalzom == true )
				{
					zombies[i] notify("damage", int(zombies[i].health * 0.25), callingPlayer, (0,1,0), zombies[i].origin, "MOD_PROJECTILE_SPLASH", "", "", "", 1);
				}
				else
				{
					zombies[i] notify("damage", zombies[i].maxhealth, callingPlayer, (0,1,0), zombies[i].origin, "MOD_PROJECTILE_SPLASH", "", "", "", 1);
				}
			}
		}
	}

	if( getdvar("scr_setvisionmap") == "map" )
		visionSetNaked( getDvar( "mapname" ), 6.0 );
	else
		visionSetNaked( getdvar("scr_setvisionmap"), 6.0 );

	wait(6);

	level.napalm_active = false;
}

useRadarItem()
{
	level.wrath_active = true;
	visionSetNaked( "woz", 2 );

	wait(2);

	wrath_zombies(self);
}

wrath_zombies(callingPlayer)
{
	zombies = getentarray("zom","targetname");
	count = zombies.size; // Do it this way because zombies.size could cause a infinite loop condition because of respawn.
	for (i = 0; i < count; i++)
	{
		wait (randomfloatrange(0.1, 0.5));

		if( isDefined( zombies[i] ) )
		{
			if( zombies[i].health > 0 )
			{
				pos[i] = zombies[i] getOrigin();
				playfx( level.wrath_effect["lightning_flash"], pos[i] + (0,0,500) );
				playfx( level.wrath_effect["lightning_bolt"], pos[i] + (0,0,500), pos[i] );
				playfx( level.wrath_effect["woz_strike"], pos[i] );
				zombies[i] playsound("woz_strike");

				if( zombies[i].isNormalzom == true )
				{
					zombies[i] notify("damage", int(zombies[i].health * 0.25), callingPlayer, (0,1,0), zombies[i].origin, "MOD_EXPLOSIVE", "", "", "", 1);
				}
				else
				{
					zombies[i] notify("damage", zombies[i].maxhealth, callingPlayer, (0,1,0), zombies[i].origin, "MOD_EXPLOSIVE", "", "", "", 1);
				}
			}
		}
	}

	if( getdvar("scr_setvisionmap") == "map" )
		visionSetNaked( getDvar( "mapname" ), 1.0 );
	else
		visionSetNaked( getdvar("scr_setvisionmap"), 1.0 );

	wait(1);

	level.wrath_active = false;
}

useTeamUAV( team, otherteam )
{
	level endon("game_ended");
	level endon("radar_timer_kill_" + team);

	setTeamRadarWrapper( team, true );

	wait level.radarViewTime;

	setTeamRadarWrapper( team, false );

	printAndSoundOnEveryone( team, otherteam, &"MP_WAR_RADAR_EXPIRED", &"MP_WAR_RADAR_EXPIRED_ENEMY", undefined, undefined, "" );
}

usePlayerUAV( team, otherteam )
{
	level endon("game_ended");
	self endon("radar_timer_kill");
	self endon("disconnect");

	self.hasRadar = true;
	self setClientDvar( "ui_uav_client", 1 );

	wait level.radarViewTime;

	self.hasRadar = false;
	self setClientDvar( "ui_uav_client", 0 );

	self iprintln( &"MP_WAR_RADAR_EXPIRED" );
}

setTeamRadarWrapper( team, value )
{
	setTeamRadar( team, value );

	dvarval = 0;
	if ( value )
		dvarval = 1;
	setDvar( "ui_uav_" + team, dvarval );

	level notify( "radar_status_change", team );
}

selectAirstrikeLocation()
{
	self beginLocationSelection( "map_artillery_selector", level.artilleryDangerMaxRadius * 1.2 );
	self.selectingLocation = true;

	self thread endSelectionOn( "cancel_location" );
	self thread endSelectionOn( "death" );
	self thread endSelectionOn( "disconnect" );
	self thread endSelectionOn( "used" );
	self thread endSelectionOnGameEnd();

	self endon( "stop_location_selection" );
	self waittill( "confirm_location", location );

	if ( isDefined( level.airstrikeInProgress ) )
	{
		self iPrintLnBold( level.hardpointHints["airstrike_mp_not_available"] );
		self thread stopAirstrikeLocationSelection( false );
		return false;
	}

	self thread finishAirstrikeUsage( location, ::useAirstrike );
	return true;
}

finishAirstrikeUsage( location, usedCallback )
{
	self notify( "used" );
	wait ( 0.05 );
	self thread stopAirstrikeLocationSelection( false );
	self thread [[usedCallback]]( location );
	return true;
}

endSelectionOn( waitfor )
{
	self endon( "stop_location_selection" );

	self waittill( waitfor );

	self thread stopAirstrikeLocationSelection( (waitfor == "disconnect") );
}

endSelectionOnGameEnd()
{
	self endon( "stop_location_selection" );

	level waittill( "game_ended" );

	self thread stopAirstrikeLocationSelection( false );
}

stopAirstrikeLocationSelection( disconnected )
{
	if ( !disconnected )
	{
		self endLocationSelection();
		self.selectingLocation = undefined;
	}
	self notify( "stop_location_selection" );
}

useAirstrike( pos )
{
	trace = bullettrace( self.origin + (0,0,10000), self.origin, false, undefined );
	pos = (pos[0], pos[1], trace["position"][2] - 514);

	thread doArtillery( pos, self, self.pers["team"] );
}

award_life()
{
	notifyData = spawnStruct();
	notifyData.titleLabel = &"MP_KILLSTREAK_N";
	notifyData.titleText = self.cur_kill_streak;
	notifyData.notifyText = "Earned an extra life!";
	notifyData.sound = "plr_new_rank";
	notifyData.glowColor = (0,0,1);

	self maps\mp\gametypes\_hud_message::notifyMessage( notifyData );

	self.pers["extra_lives"]++;
	self.pers["lives"]++;
}
