#include btd\_dvardef;
#include btd\_sound_util;

main()
{
	level.fx_rampage = loadfx ("misc/rampage");

	level.btd_rampage = createdvar("btd_rampage",0,0,1,"int");
	level.btd_rampage_damage = createdvar("btd_rampage_damage",100,5,500000,"int");
	level.btd_rampage_time = createdvar("btd_rampage_time",30,10,120,"int");
	level.btd_rampage_killstreak = createdvar("btd_rampage_killstreak",512,10,10000,"int");
}
/*
check_for_rampage(streak)
{
	if( isPlayer(self) && isAlive(self) && self.sessionstate == "playing" )
	{
		if( !self.on_rampage && !self.isarty && !self.inHelicopter && !self.inAc130 && !isDefined( self.lastStand ) )
		{
			if ( ( streak % level.btd_rampage_killstreak ) == 0 )
			{

				notifyData = spawnStruct();
				notifyData.titleLabel = &"MP_KILLSTREAK_N";
				notifyData.titleText = streak;
				notifyData.notifyText = &"BTDZ_EARNED_RAMPAGE";
				notifyData.sound = "rampage";
				notifyData.iconName = game["icons"]["allies"];
				notifyData.glowColor = (0,0,1);

				self maps\mp\gametypes\_hud_message::notifyMessage( notifyData );

				self thread start_rampage();
			}
		}
	}
}
*/
start_rampage()
{
	self endon("disconnect");
	self endon("game_ended");
	self endon("death");
	self endon("joined_spectators");

	self iprintlnbold("Press and hold ^3[{+melee}] ^7to end Rampage.");

	if( !isDefined( self.rampage_timer ) )
	{
		self.rampage_timer = newClientHudElem( self );
		self.rampage_timer.x = 635;
		self.rampage_timer.y = 250;
		self.rampage_timer.alignx = "right";
		self.rampage_timer.aligny = "middle";
		self.rampage_timer.horzAlign = "fullscreen";
		self.rampage_timer.vertAlign = "fullscreen";
		self.rampage_timer.alpha = 1.0;
		self.rampage_timer.fontScale = 2;
		self.rampage_timer.sort = 100;
		self.rampage_timer.foreground = true;
		self.rampage_timer.glowAlpha = 0.1;
		self.rampage_timer.glowColor = (1, 1, 0);
		self.rampage_timer setTimer( level.btd_rampage_time );
	}

	self.on_rampage = true;
	self.sp_active = true;
	self disableWeapons();
	self thread playlooplocalsound( "mp_time_running_out_losing", 8, "rampage_over" );
	self setMoveSpeedScale( 1.5 );
	self btd\_utils::setFilmTweaks(1, 0, 0, "1 0.8 1.2",  "0.2 0.7 1.5", 0.25, 1.5);
	self btd\_utils::setGlowTweaks(1, 0, 0, 2, 5);
	self thread monitor_rampage();
	self thread watchForCancelRampage();

	while( self.on_rampage && isAlive(self) )
	{
		wait 0.25;
		playFxOnTag( level.fx_rampage, self, "tag_origin" );
		setplayerignoreradiusdamage( true );
		radiusDamage( self getOrigin(), 200, level.btd_rampage_damage, int( level.btd_rampage_damage * 0.5 ), self );
		setplayerignoreradiusdamage( false );
	}
}

monitor_rampage()
{
	self endon("rampage_over");
	self endon("disconnect");
	self endon("game_ended");
	self endon("death");
	self endon("joined_spectators");

	wait level.btd_rampage_time;

	self thread end_rampage();
}

watchForCancelRampage()
{
	self endon("rampage_over");
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("death");

	while( isDefined(self) && self.on_rampage )
	{
		wait 0.05;
		if( self meleeButtonPressed() )
		{
			wait 1;
			if( !self meleeButtonPressed() )
			{ continue; }

			self thread end_rampage();
			break;
		}
	}
}

end_rampage()
{
	if( !isDefined(self) || !isAlive(self) || !self.on_rampage )
	{ return; }

	if( isDefined(self.rampage_timer ) )
	{ self.rampage_timer destroy(); }

	self reset_move_speed();

	self btd\_utils::setFilmTweaksOff();
	self btd\_utils::setGlowTweaksOff();

	self enableWeapons();
	self.on_rampage = false;
	wait 1;
	self.sp_active = false;

	self notify( "rampage_over" );
	self iprintlnbold("Rampage : ^3EXPIRED");
}

reset_move_speed()
{
	class = self.pers["class"];
	if( !isDefined( class ) )
	{
		self setMoveSpeedScale( 1.0 );
		return;
	}

	primary = undefined;
	if( isSubstr( class, "CLASS_CUSTOM" ) )
	{
		class_num = int( class[class.size-1] )-1;
		if ( isDefined( self.pers["weapon"] ) && self.pers["weapon"] != "none" )
			primary = self.pers["weapon"];
		else
			primary = self.custom_class[class_num]["primary"];
	}
	else
	{
		if ( isDefined( self.pers["weapon"] ) && self.pers["weapon"] != "none" )
			primary = self.pers["weapon"];
		else
			primary = level.classWeapons[self.pers["team"]][class][0];
	}

	switch ( weaponClass( primary ) )
	{
		case "rifle":
			self setMoveSpeedScale( 0.95 );
			break;
		case "pistol":
			self setMoveSpeedScale( 1.0 );
			break;
		case "mg":
			self setMoveSpeedScale( 0.875 );
			break;
		case "smg":
			self setMoveSpeedScale( 1.0 );
			break;
		case "spread":
			self setMoveSpeedScale( 1.0 );
			break;
		default:
			self setMoveSpeedScale( 1.0 );
			break;
	}
}

