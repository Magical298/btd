#include btd\_dvardef;
#include maps\mp\gametypes\_hud_util;

main()
{	
	level.btd_anticamp = createdvar("btd_anticamp",3,0,3,"int");

	createdvar("btd_camp_max_time",45,10,300,"int");
	createdvar("btd_camp_warn_time",30,10,300,"int");
	createdvar("btd_camp_punishment",1,1,3,"int");
	createdvar("btd_camp_drophealth",15,5,100,"int");
	createdvar("btd_camp_distance",96,48,240,"int");
	createdvar("btd_antiglitch_warning",0,0,1,"int");
	createdvar("btd_antiglitch_warning_num",3,1,12,"int");
}

//================================================================================================
// What is the anti camp system to be used
//================================================================================================
initCampTime()
{
	choice = getDvarInt("btd_anticamp");

	if( (choice == 2 || choice == 3) && (!self.isadmin && !self.isdev) )
	{
		self thread campcheck();
	}
}

//================================================================================================
// Time System
//================================================================================================
check_player_mg()
{
	//weapon = self getCurrentWeapon();
	//return isSubStr( weapon, "_bipod_" );

	turretsTypes = [];
	turretsTypes[0] = "misc_turret";
	turretsTypes[1] = "misc_mg42";

	for( i = 0; i < turretsTypes.size; i++ )
	{
		turrets = getentarray( turretsTypes[i], "classname" );
	
		if( isDefined( turrets ) ) 
		{
			for( j = 0; j < turrets.size; j++ ) 
			{
				if( self isTouching( turrets[j] ) ) 
				{
					return true;
				}
			}
		}
	}

	return false;
}

campcheck()
{
	self endon("death");
	self endon("disconnect");
	self endon("joined_spectators");

	self.campingtime = 0;
	show_warning = false;
	self.iscamper = false;
	
	maxcamptime = getDvarInt("btd_camp_max_time");
	warntime = getDvarInt("btd_camp_warn_time");
	punishment = getDvarInt("btd_camp_punishment");
	dist = getDvarInt("btd_camp_distance");

	// continus loop
	while(1)
	{
		wait 0.05;

		// campsystem only counts while zombies have spawned
		if( level.status == "play" )
		{
			// spec doesnt count
			if( self.sessionstate != "playing" || self.isarty || self.inHelicopter || isDefined( self.lastStand ) || self check_player_mg() )
			{
				wait 1;
				continue;
			}

			startpos = self.origin;
			wait 1;
			endpos = self.origin;

			// camp distance
			if(distance(startpos, endpos) < dist)
			{
				self.campingtime++;
				self.iscamper = true;
			}
			else
			{
				self.campingtime = 0;
				self.iscamper = false;
				show_warning = false;
			}

			// do we show warning messages to campers
			if(self.campingtime >= warntime && warntime != 0)
			{
				show_warning = true;
			}

			// show warning message if time is right
			if(show_warning)
			{
				self iprintlnbold("^3Get off your butt and fight soldier!");
			}

			// camper ingnored warning punish them
			if(self.campingtime >= maxcamptime)
			{
				switch(punishment)
				{
					case 1:
					// move to spec
					movetospec();
					break;
					
					case 2: // drop health
					drophealth();
					break;
					
					case 3: // kill player
					killplayer();
					break;
				}			
			}
		}
	}
}

//================================================================================================
// Camper Time Punishments 
//================================================================================================

movetospec()
{
	if(self.pers["team"] != "spectator" && self.sessionstate == "playing" && self.iscamper == true)
	{
		self maps\mp\gametypes\_globallogic::menuSpectator();
		self iprintln("You have been moved to spec for camping!");
		self.campingtime = 0;
		self.iscamper = false;
	}
}

drophealth()
{
	health = getDvarInt("btd_camp_drophealth");
	if(!isDefined(health))
	{
		health = 5;
	}

	if(self.iscamper == true)
	{
		self.health = self.health - getDvarInt("btd_camp_drophealth");
		self iprintln("You are losing health for camping!");

		if(self.health < 1)
		{
			killplayer();
		}
	}
}

killplayer()
{	
	self iprintlnBold("You were killed because you ingnored the camping warning!");
	self suicide();

	self.campingtime = 0;
	self.iscamper = false;
}

//================================================================================================
// Teleport System
//================================================================================================
// trig = spawn("trigger_radius",(x,y,z),0,radius,height);

// moniters triggers till a player moves within range
waitfortrig()
{
	level endon("game_ended");

	while(1)
	{
		self waittill("trigger",player);
		if( player.sessionstate != "playing" || player.isadmin )
			continue;

		player setOrigin(self.goto);

		if( getDvar("btd_antiglitch_warning") == "1" )
		{
			player.glitch_warning++;
			player iPrintLnBold("^1GLITCH WARNING - ^1" + player.glitch_warning + " ^7out of ^1" + (getDvarInt("btd_antiglitch_warning_num")));

			if( player.glitch_warning == getDvarInt("btd_antiglitch_warning_num") )
			{
				player.glitch_warning = 0;
				iPrintLn("GLITCH WARNING - ^1" + player.name + " ^7killed for ^1" + player.glitch_warning + "^7/^1" + (getDvarInt("btd_antiglitch_warning_num")) + " ^7warnings");
				player suicide();		
			}
		}
		else
		{ player iPrintlnBold("You have been moved from a glitch area!"); }
	}
}
