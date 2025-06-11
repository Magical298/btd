//================================================================================================
// File Name  : _blackhawk.gsc 
// File Info  : Blackhawk hardpoint
// Mod        : BTD
// Authors    : KiLL3R / Holy - mangled by Zod
//================================================================================================
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include btd\_dvardef;

init()
{
	preCacheModel("vehicle_blackhawk_hero_sas");
	precacheShader("compass_objpoint_zblackhawk");

	//fx for heli interior/exterior lights
	level.effect["aircraft_light_cockpit_red"] = loadfx ("misc/aircraft_light_cockpit_red_powerfull");
	level.effect["aircraft_light_cockpit_blue"] = loadfx ("misc/aircraft_light_cockpit_blue");
	level.effect["aircraft_light_red_blink"] = loadfx ("misc/aircraft_light_red_blink");
	//level.effect["aircraft_light_white_blink"] = loadfx ("misc/aircraft_light_white_blink");
	level.effect["aircraft_light_wingtip_green"] = loadfx ("misc/aircraft_light_wingtip_green");
	level.effect["aircraft_light_wingtip_red"] = loadfx ("misc/aircraft_light_wingtip_red");

	createdvar("btd_blackhawk_loops",1,0,5,"int");
	createdvar("btd_blackhawk_waittime",12,5,60,"int");
	createdvar("btd_blackhawk_force_leave_time", 240, 60, 900, "init");

	if(getdvar("btd_blackhawk_weapon") == "")
		setdvar("btd_blackhawk_weapon", "gl_mp");

	level.chopper = undefined;
}

// spawn helicopter at a start node and monitors it
blackhawk_think( owner, startnode, heli_team, requiredDeathCount )
{
	heliOrigin = startnode.origin;
	heliAngles = startnode.angles;

	// how many times helicopter will circle the map before it leaves
	level.blackhawk_loopmax = getdvarint("btd_blackhawk_loops");

	// time helicopter waits (hovers) after reaching a destination
	level.blackhawk_dest_wait = getdvarint("btd_blackhawk_waittime");

	// Failsafe time to remove chopper if something goes wrong
	level.blackhawk_force_leave_time = getdvarint("btd_blackhawk_force_leave_time");

	// weapon given to player when they board the chopper
	level.blackhawk_weapon = getDvar("btd_blackhawk_weapon");

	chopper = spawnHelicopter( owner, heliOrigin, heliAngles, "cobra_mp", "vehicle_blackhawk_hero_sas" );
	chopper playLoopSound( "mp_cobra_helicopter" );

	chopper.requiredDeathCount = owner.deathCount;

	chopper.team = heli_team;
	chopper.pers["team"] = heli_team;
	chopper setvehicleteam(heli_team);

	chopper.owner = owner;
	level.chopper = chopper;

	chopper.waittime = level.blackhawk_dest_wait;	// the time helicopter will stay stationary at destination
	chopper.loopcount = 0; 					// how many times helicopter circled the map
	chopper.evasive = false;				// evasive manuvering
	chopper.currentstate = "ok";				// health state

	chopper.health = 10000000;
	chopper.damageTaken = 0;
	chopper.laststate = "ok";
	chopper setdamagestage( 3 );
	chopper.evasive = false;

	// helicopter loop threads
	chopper thread blackhawk_monitor_owner();
	chopper thread heli_fly( startnode );	// fly heli to given node and continue on its path
	chopper thread force_heli_leave( level.blackhawk_force_leave_time ); // In case something goes wrong, force removal after a time

	if( level.isnight )
	{ chopper thread playlightfx(); }
}

playlightfx()
{
	while( isDefined(self) )
	{
		self play_interior_lights();
		self play_wing_lights();
		self play_tail_lights();

		wait 2;
	}
}

play_interior_lights()
{
	if( isDefined(self) )
	{
		playfxontag( level.effect["aircraft_light_cockpit_blue"], self, "tag_light_cockpit01" );
		playfxontag( level.effect["aircraft_light_cockpit_red"], self, "tag_light_cargo01" );
	}
}

play_wing_lights()
{
	if( isDefined(self) )
	{
		playfxontag( level.effect["aircraft_light_wingtip_green"], self, "tag_light_l_wing" );
		playfxontag( level.effect["aircraft_light_wingtip_green"], self, "tag_light_r_wing" );
		wait 0.5;
		playfxontag( level.effect["aircraft_light_wingtip_red"], self, "tag_light_l_wing" );	
		playfxontag( level.effect["aircraft_light_wingtip_red"], self, "tag_light_r_wing" );
	}
}

play_tail_lights()
{
	if( isDefined(self) )
	{
		playfxontag( level.effect["aircraft_light_red_blink"], self, "tag_light_belly" );
		wait 0.5;
		playfxontag( level.effect["aircraft_light_red_blink"], self, "tag_light_tail" );
	}
}

force_heli_leave(time)
{
	wait( time );

	if( isDefined( self ) )
	{
		// Send the owner home and kill any threads
		if( isdefined( self.owner ) )
		{
			self.owner notify("left_chopper");
			self.owner thread goToLz();
		}

		self notify( "abandoned" );
		self notify( "leaving" );
		self notify( "death" );

		level.chopper = undefined;
		self.owner = undefined;
		self delete();
	}
}

blackhawk_monitor_owner()
{
	self endon( "leaving" );

	// check if owner has left, if so, leave
	for ( ;; )
	{
		self check_owner();
		wait 1;
	}
}

// resets helicopter's motion values
blackhawk_reset()
{
	self clearTargetYaw();
	self clearGoalYaw();
	self setspeed( 60, 25 );
	self setyawspeed( 75, 45, 45 );

	self setmaxpitchroll( 30, 30 );
	self setneargoalnotifydist( 256 );
	self setturningability(0.9);
}

blackhawk_wait( waittime )
{
	self endon( "death" );
	self endon( "evasive" );
	wait( waittime );
}

// evasive manuvering - helicopter circles the map for awhile then returns to path
blackhawk_evasive()
{
	// only one instance allowed
	self notify( "evasive" );

	self.evasive = true;

	// set helicopter path to circle the map level.blackhawk_loopmax number of times
	loop_startnode = level.heli_loop_paths[0];
	self thread heli_fly( loop_startnode );
}

// helicopter leaving parameter, can not be damaged while leaving
heli_leave()
{
	self notify( "desintation reached" );
	self notify( "leaving" );
	
	// helicopter leaves randomly towards one of the leave origins
	random_leave_node = randomInt( level.heli_leavenodes.size );
	leavenode = level.heli_leavenodes[random_leave_node];
	
	blackhawk_reset();
	self setspeed( 100, 45 );	
	self setvehgoalpos( leavenode.origin, 1 );

	self waittillmatch( "goal" );

	self notify( "death" );

	level.chopper = undefined;
	self.owner = undefined;
	self delete();
}

// flys helicopter from given start node to a destination on its path
heli_fly( currentnode )
{
	self endon( "death" );

	// only one thread instance allowed
	self notify( "flying");
	self endon( "flying" );

	// if owner switches teams, helicopter should leave
	self endon( "abandoned" );

	self.reached_dest = false; // has helicopter reached destination
	blackhawk_reset();

	pos = self.origin;
	wait( 2 );

	while ( isdefined( currentnode.target ) )
	{	
		nextnode = getent( currentnode.target, "targetname" );
		assertex( isdefined( nextnode ), "Next node in path is undefined, but has targetname" );

		// offsetted 
		pos = nextnode.origin+(0,0,30);

		// motion change via node
		if( isdefined( currentnode.script_airspeed ) && isdefined( currentnode.script_accel ) )
		{
			heli_speed = currentnode.script_airspeed;
			heli_accel = currentnode.script_accel;
		}
		else
		{
			heli_speed = 30+randomInt(20);
			heli_accel = 15+randomInt(15);
		}

		// fly nonstop until final destination
		if ( !isdefined( nextnode.target ) )
			stop = 1;
		else
			stop = 0;

		// if the node has helicopter stop time value, we stop
		if( isdefined( nextnode.script_delay ) ) 
			stop = 1;

		self setspeed( heli_speed, heli_accel );	
		self setvehgoalpos( (pos), stop );

		if ( !isdefined( nextnode.script_delay ) )
		{
			self waittill( "near_goal" );
		}
		else
		{			
			// post beta addition --- (
			self setgoalyaw( nextnode.angles[1] );
			// post beta addition --- )
				
			self waittillmatch( "goal" );				
			blackhawk_wait( nextnode.script_delay );
		}

		// increment loop count when helicopter is circling the map
		for( index = 0; index < level.heli_loop_paths.size; index++ )
		{
			if ( level.heli_loop_paths[index].origin == nextnode.origin )
				self.loopcount++;
		}

		if( self.loopcount >= level.blackhawk_loopmax )
		{
			self thread heli_leave();
			return;
		}

		currentnode = nextnode;
	}

	self setgoalyaw( currentnode.angles[1] );
	self.reached_dest = true; // sets flag true for helicopter circling the map

	// wait at destination
	blackhawk_wait( self.waittime );

	// if still alive, switch to evasive manuvering
	if( isdefined( self ) )
		self thread blackhawk_evasive();
}

check_owner()
{
	if ( !isdefined( self.owner ) || !isdefined( self.owner.pers["team"] ) || self.owner.pers["team"] != self.team )
	{
		self notify( "abandoned" );
		self thread heli_leave();	
	}
}

blackhawk_attachPlayer(chopper)
{
	chopper endon("death");

	self endon("joined_spectators");
	self endon("disconnect");
	self endon("death");

	// Run some checks before we bother
	if( level.inPrematchPeriod || self.sessionstate != "playing" || !isDefined( chopper ))
		return;

	// Start the ball rolling
	self.inHelicopter = true; // Lets not kill ourselves mmmk? Checked in _globallogic.gsc function Callback_PlayerDamage
	self.seat = 1;

	// Mount the mount.. Stupid engine, this should not be required.
	// If we mount diretly to vehicle we would not be able to switch seats it throws an error and halts server.
	self.tagthing = spawn( "script_origin", chopper getTagOrigin( "tag_guy4" ) );
	self.tagthing linkTo( chopper, "tag_guy4", (12,-26,-16), (0,0,0) );

	//preCacheModel("vehicle_mi17_woodland_fly"); // Carrier - but the rear has a collision mesh so is useless
	//self.tagthing linkTo( chopper, "tag_ground", (-65,0.0,40.0), (0,0,0) );

	wait 0.5;

	// Equip and switch weapons before moving
	if ( !self hasWeapon( level.blackhawk_weapon ) )
	{
		self.oldweap = self getCurrentWeapon();
		self giveweapon(level.blackhawk_weapon);
		self givemaxammo(level.blackhawk_weapon);
		self switchToWeapon(level.blackhawk_weapon);
		self.gotBlackhawkWeapon = true;
	}

	wait 0.5;

	// Mount the player to the mount.. Stupid engine, this should not be required.
	//tag_playerride
	//tag_guy3
	self setOrigin( self.tagthing.origin );
	self setPlayerAngles( chopper.angles );
	self linkto( self.tagthing );
	//self btd\_utils::execClientCommand("gocrouch"); //EDIT: Causes problems with client

	// Enjoy the ride
	self iprintlnbold("Press ^3[{+activate}] ^7to switch seats. ^3[{+melee}] ^7to exit.");
	self notify("inchopper");
	self thread monitorseats(chopper);

	// When the chopper leaves, we unboard
	chopper waittill("leaving");

	if( isPlayer(self) && isAlive(self) )
	{
		self notify("left_chopper"); // No more switching seats..
		self thread goToLz();
	}
}

monitorseats(chopper)
{
	self endon("death");
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("left_chopper");

	while(1)
	{
		wait 0.05;

		if(self useButtonPressed())
		{
			self.tagthing unlink();
			if( self.seat == 1 )
			{
				self.tagthing linkTo(chopper,"tag_guy6",(12,26,-16),(0,0,0));
				self.seat = 2;
			}
			else
			{
				self.tagthing linkTo(chopper,"tag_guy4",(12,-26,-16),(0,0,0));
				self.seat = 1;
			}

			while(self useButtonPressed())
				wait 0.05;
		}
		else if(self meleeButtonPressed())
		{
			wait 1;
			if(!self meleeButtonPressed())
				continue;

			chopper notify("abandoned");
			chopper thread heli_leave();
			break;
		}
	}
}

goToLz()
{
	self iprintln("Leaving Blackhawk.");

	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( "allies" );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );

	wait 1;

	self unlink();
	self setorigin(spawnpoint.origin);
	self setplayerangles(spawnpoint.angles);
	//self btd\_utils::execClientCommand("+gostand"); //EDIT: Causes problems with client

	if( self.gotBlackhawkWeapon == true )
	{ self takeWeapon(level.blackhawk_weapon); }

	if ( isDefined( self.oldweap ) && self hasWeapon( self.oldweap ) )
	{ self switchToWeapon(self.oldweap); }

	self.inHelicopter = false;

	self thread btd\_spawn_protection::do_sp();

	self.seat = undefined;
	if( isDefined( self.tagthing ) )
	{
		self.tagthing unlink();
		self.tagthing delete();
		self.tagthing = undefined;
	}
}
