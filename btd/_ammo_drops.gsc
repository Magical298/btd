#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include btd\_dvardef;

main()
{
	precacheModel("com_bomb_objective");
	precacheModel( "shaneys_chute_i" ); // Parachute from eXtreme mod
	precacheShader("waypoint_ammo_box");

	level.ammo_drops = createdvar("btd_ammo_drops",1,0,1,"int");
	level.ammo_drops_locations = createdvar("btd_ammo_drops_locations",1,0,1,"int");
	level.ammo_drops_number = createdvar("btd_ammo_drops_number",2,1,3,"int");
	level.ammo_drops_heal = createdvar("btd_ammo_drops_heal",1,0,1,"int");
	level.ammo_chopper = createdvar("btd_ammo_drops_choppers",0,0,1,"int");
}

startAmmoDrops()
{
	if( level.ammo_drops == 0 || level.btd_devmode != 0 )
	{
		return;
	}

	if( level.ammo_chopper == 1 )
	{
		heli_path_graph();

		thread spawndrops_chopper();
	}
	else
	{
		thread spawndrops_normal();
	}
}

spawndrops_normal()
{
	if( !isDefined( level.chopperspawns ) )
	{
		level.chopperspawns = level.teamSpawnPoints["allies"];
	}

	bad = level.ammo_drops_number + 1;

	spawn = [];
	spawn[0] = bad;
	spawn[1] = bad;
	spawn[2] = bad;

	for( d = 0; d < 3; d++ )
	{
		num = randomInt(level.chopperspawns.size);
		if(num == spawn[0] || num == spawn[1] || num == spawn[2])
		{
			d --;
		}
		else
		{
			spawn[d] = num;
		}			
	}

	ammodrop = [];
	for(i = 0; i < level.ammo_drops_number; i++)
	{
		sp_here = spawn[i];

		trace = bulletTrace(level.chopperspawns[sp_here].origin + (0,0,40), level.chopperspawns[sp_here].origin + (0,0,-100), false, undefined);

		ammodrop[i] = spawn("script_model", trace["position"] + (0,0,1));
		ammodrop[i].angles = maps\mp\_utility::orientToNormal(trace["normal"]);

		ammodrop[i] setModel("com_bomb_objective");

		ammodrop[i].trigger = spawn("trigger_radius",ammodrop[i].origin,0,120,120);
		ammodrop[i].trigger thread ammodrop();

		if(level.ammo_drops_locations == 1)
		{
			ammodrop[i].marker = newHudElem();
			ammodrop[i].marker.hideWhenInMenu = true;
			ammodrop[i].marker SetTargetEnt(ammodrop[i]);
			ammodrop[i].marker.sort = 1;
			ammodrop[i].marker setWayPoint(true, "waypoint_ammo_box");
		}
	}

	iPrintlnBold("Ammo drops are now ready! Ending in ^3" + level.grace_time + " ^7seconds.");

	level waittill("ammo_end");

	for( i = 0; i < level.ammo_drops_number; i++ )
	{
		if(level.ammo_drops_locations == 1)
		{
			ammodrop[i].marker clearTargetEnt();
			ammodrop[i].marker destroy();
		}
		ammodrop[i].trigger delete();
		ammodrop[i] delete();
	}
}


spawndrops_chopper()
{
	iPrintlnBold("Ammo drops on way! Ending in ^3" + level.grace_time + " ^7seconds.");

	level.chopper_drop_count = 0;

	if( !isDefined( level.chopperspawns ) )
	{
		level.chopperspawns = level.teamSpawnPoints["allies"];
	}

	bad = level.ammo_drops_number + 1;

	level.chopspawn = [];
	level.chopspawn[0] = bad;
	level.chopspawn[1] = bad;
	level.chopspawn[2] = bad;

	for(i = 0; i < level.ammo_drops_number; i++)
	{
		start_chopper_drop();
		wait 2;
	}
}

ammodrop()
{
	level endon("wave_start");
	level endon("game_ended");
	while(1)
	{
		self waittill("trigger", player);

		if( player.sessionstate != "playing" || player.isammoing )
			continue;

		player.isammoing = true;
		player thread ammoingwait();		

		if( player.hasntfullammo )
		{
			player maps\mp\gametypes\_class::replenishLoadout();
			player playlocalsound("mp_suitcase_pickup");
			player.hasntfullammo = false;
			player thread hashadammo();
		}	

		if( level.ammo_drops_heal == 1 )
		{
			if( player.health <= player.maxhealth - 10 )
			{
				player.health = player.health + 10;
				player playlocalsound("weap_pickup");
			}
			else if( player.health > player.maxhealth - 10 )
			{
				player.health = player.maxhealth;
			}
		}
	}
}

ammoingwait()
{
	wait 1;
	self.isammoing = false;
}

hashadammo()
{
	wait level.grace_time;
	if ( isDefined( self ) )
		self.hasntfullammo = true;
}

//======================================================================================================
// H E L I C O P T E R      S T U F F
//======================================================================================================

// generate path graph from script_origins
heli_path_graph()
{
	// collecting all start nodes in the map to generate path arrays
	path_start = getentarray( "heli_start", "targetname" ); 		// start pointers, point to the actual start node on path
	path_dest = getentarray( "heli_dest", "targetname" ); 			// dest pointers, point to the actual dest node on path
	leave_nodes = getentarray( "heli_leave", "targetname" ); 		// points where the helicopter leaves to
	crash_start = getentarray( "heli_crash_start", "targetname" );	// start pointers, point to the actual start node on crash path	
}

// --------------------------------

start_chopper_drop()
{
	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( "allies" );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );

	pos = spawnPoint.origin + (0,0,500);
	trace = bullettrace(pos, pos + (0,0,-10000), false, undefined);
	targetpos = trace["position"];
	yaw = getBestPlaneDirection();

	wait 1;

	callChopperDrop( targetpos, yaw );
}

callChopperDrop( coord, yaw )
{
	// Get starting and ending point for the plane
	direction = ( 0, yaw, 0 );
	planeHalfDistance = 24000;
	planeBombExplodeDistance = 1500;
	planeFlyHeight = 850;
	planeFlySpeed = 1500;

	if ( isdefined( level.airstrikeHeightScale ) )
	{ planeFlyHeight *= level.airstrikeHeightScale; }

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


	wait randomfloatrange( 1.5, 2.5 );

	level thread doChooperDrop2( coord, startPoint+(0,0,randomInt(500)), endPoint+(0,0,randomInt(500)), bombTime, flyTime, direction );
}

doChooperDrop2( bombsite, startPoint, endPoint, bombTime, flyTime, direction )
{
	startPathRandomness = 100;
	endPathRandomness = 150;
	pathStart = startPoint + ( (randomfloat(2) - 1)*startPathRandomness, (randomfloat(2) - 1)*startPathRandomness, 770 );
	pathEnd = endPoint + ( (randomfloat(2) - 1)*endPathRandomness, (randomfloat(2) - 1)*endPathRandomness, 770 );
	heli_logic("allies",pathStart,pathEnd,flyTime);
}

heli_leave(leavenode)
{
	self notify( "desintation reached" );
	self notify( "leaving" );

	heli_reset();
	self setspeed( 100, 45 );	
	self setvehgoalpos( leavenode, 1 );

	self notify( "death" );
	
	self delete();
}

heli_reset()
{
	self clearTargetYaw();
	self clearGoalYaw();
	self setspeed( 60, 25 );	
	self setyawspeed( 75, 45, 45 );
	//self setjitterparams( (30, 30, 30), 4, 6 );
	self setmaxpitchroll( 30, 30 );
	self setneargoalnotifydist( 256 );
	self setturningability(0.9);
}

heli_wait( waittime )
{
	self endon ( "death" );
	self endon ( "crashing" );
	self endon ( "evasive" );

	wait( waittime );	
}

heli_logic( heli_team, startnode, leavenode, flytime )
{

	heliOrigin = startnode;
	heliAngles = startnode;

	// Zod: Must have an owner entity. Choose some random player.
	// If no player exists then fallback to normal ammo drop
	owner = undefined;
	players = getEntArray("player","classname");		
	if( players.size > 0 )
	{
		for( i = 0; i < level.ammo_drops_number; i++ )
		{
			randomPlayer = randomInt(players.size);
			if( isDefined( players[randomPlayer] ) )
			{
				owner = players[randomPlayer];
				break;
			}
		}
	}

	if( !isDefined( owner ) )
	{
		level thread spawndrops_normal();
		return;
	}

	chopper = spawnHelicopter( owner, heliOrigin, heliAngles, "cobra_mp", "vehicle_blackhawk_hero_sas" );
	chopper playLoopSound( "mp_hind_helicopter" );
	if( level.isnight )
	{ chopper thread maps\mp\_blackhawk::playlightfx(); }

	chopper.team = heli_team;
	chopper.pers["team"] = heli_team;
	chopper.owner = owner;

	// TO DO: convert all helicopter attributes into dvars
	chopper.reached_dest = false;					// has helicopter reached destination
	chopper.maxhealth = level.heli_maxhealth;			// max health
	chopper.waittime = level.heli_dest_wait;			// the time helicopter will stay stationary at destination
	chopper.loopcount = 0; 						// how many times helicopter circled the map
	chopper.evasive = false;					// evasive manuvering
	chopper.missile_ammo = level.heli_missile_max;		// initial missile ammo
	chopper.currentstate = "ok";					// health state
	chopper.laststate = "ok";
	chopper setdamagestage( 3 );
	chopper.damageTaken = 0;

	//Zod: Mount the ammo
	chopper.ammodrop = spawn("script_model", heliOrigin);
	chopper.ammodrop.angles = heliAngles;
	chopper.ammodrop setModel("com_bomb_objective");
	chopper.ammodrop linkto(chopper, "tag_body", (0.0, 0.0, -150.0), (0,0,0));

	// helicopter loop threads
	chopper thread heli_fly( leavenode, flytime );	// fly heli to given node and continue on its path	
}

heli_fly( leavenode, flytime )
{
	self endon( "death" );
  	self notify( "flying");

	self.reached_dest = false;

	heli_reset();		
	num = (0,0,0);
	for( d = 0; d < level.chopperspawns.size; d++ )
	{
		d = randomInt(level.chopperspawns.size);
		if(d != level.chopspawn[0] || d != level.chopspawn[1] || d != level.chopspawn[2])
		{
			level.chopspawn[level.chopper_drop_count] = d;
			num = level.chopperspawns[d].origin;
			level.chopper_drop_count ++;
			d = level.chopperspawns.size + 1;
		}
	}

	drop_pos = num;

	random = randomintrange(1000, 2000);

	pos = ( num + (0,0,random+100) );
	pos2 = ( num + (0,0,random) );
	pos3 = ( num + (0,0,random+100) );

/*
	pos = ( num + (0,0,1000) );
	pos2 = ( num + (0,0,350) );
	pos3 = ( num + (0,0,1000) );
*/
	heli_speed = flytime+randomInt(20)+60;
	heli_accel = 15+randomInt(15);		

	// fly nonstop until final destination
	stop = 1;
	pos4 = pos - (200,400,0);

	// movement change due to damage
	self setspeed( heli_speed, heli_accel );	
	self setvehgoalpos( (pos4), stop );

	if(isDefined(level.SecondChopperInair))
	{ self waittill("spot_free"); }

	self setspeed( heli_speed, heli_accel );	
	self setvehgoalpos( (pos), stop );

	self waittill( "near_goal" ); 
	self notify( "path start" );

	self setspeed( heli_speed, heli_accel );	
	self setvehgoalpos( (pos2), stop );

	if(isDefined(level.anglemap))
	{ self setgoalyaw( level.anglemap ); }

	self waittill("goal");
	wait 5;

	thread chopper_drop( drop_pos, self );

	wait 5;

	self setspeed( heli_speed, heli_accel );	
	self setvehgoalpos( (pos3), stop );
	self setgoalyaw( 0 );
	self waittill("goal");

	wait 0.1;
	self setspeed( heli_speed, heli_accel );	
	self setvehgoalpos( (leavenode), stop );
	self waittill("goal");

	self thread heli_leave(leavenode);
	self setgoalyaw( 0 );
	self.reached_dest = true;	
	self notify ("leaving ");// sets flag true for helicopter circling the map
	self notify ( "destination reached" );

	// wait at destination
	heli_wait( 1 );
	self delete();
}

chopper_drop( pos, chopper )
{
	if( isDefined( chopper ) )
	{
		highpoint = chopper GetOrigin();
		trace = bulletTrace(pos + (0,0,40), pos + (0,0,-100), false, undefined);
		lowpoint = trace["position"];
		angles = maps\mp\_utility::orientToNormal(trace["normal"]);

		ammodrop = chopper.ammodrop;

		ammodrop.chute = spawn("script_model", ammodrop.origin);
		ammodrop.chute setModel("shaneys_chute_i");
		ammodrop.chute.angles = angles;
		ammodrop.chute linkto(ammodrop);

		ammodrop unlink();
		ammodrop.angles = angles;
		ammodrop moveto(lowpoint, 6); //2

		wait(6);

		earthquake( 0.2, 2, ammodrop getOrigin(), 500 );
		ammodrop playSound( "ammo_impact" );

		ammodrop.chute unlink();
		ammodrop.chute rotatepitch(85, 10, 9, 1);
		ammodrop.chute moveto(lowpoint + (0, -360, -360), 7, 6, 1);
	}
	else
	{
		trace = bulletTrace(pos + (0,0,40), pos + (0,0,-100), false, undefined);

		ammodrop = spawn("script_model", trace["position"] + (0,0,0.5));
		ammodrop.angles = maps\mp\_utility::orientToNormal(trace["normal"]);
		ammodrop setModel("com_bomb_objective");
	}

	ammodrop.trigger = spawn("trigger_radius", ammodrop.origin, 0, 100, 100);
	ammodrop.trigger thread ammodrop();

	if(level.ammo_drops_locations == 1)
	{
		ammodrop.marker = newHudElem();
		ammodrop.marker.hideWhenInMenu = true;
		ammodrop.marker SetTargetEnt(ammodrop);
		ammodrop.marker.sort = 1;
		ammodrop.marker setWayPoint(true, "waypoint_ammo_box");
	}

	level waittill("ammo_end");

	if(level.ammo_drops_locations == 1)
	{ ammodrop.marker destroy(); }

	if( isDefined(ammodrop.chute) )
	{ ammodrop.chute delete(); }

	ammodrop.trigger delete();
	ammodrop delete();
}

dropWait()
{
	wait level.grace_time;
	level notify("ons_ammo_end");		
}

getGroundpoint( landposition )
{
	//Do a trace the starts above landingposition and that goes down from that position till 10000 Z (just imagine a big line that draws and trace just traces where this line stops)//
	trace = bullettrace( landposition+(0,0,400), landposition-(0,0,10000), false, undefined );
	groundpoint = trace["position"];
	return (groundpoint);
}

getBestPlaneDirection()
{
	nextnode = (0,0,0);

	pos2 = nextnode+(0,0,300);	

	anglemap = 90;

	pos2 = (-1786 ,1734, 171 );		 

	hitpos = pos2;
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
