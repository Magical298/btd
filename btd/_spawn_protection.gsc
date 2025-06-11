#include btd\_hud_util;
#include btd\_dvardef;

main()
{
	level.player_sp = createdvar("btd_sp_enable",1,0,1,"int");
	level.player_sp_time = createdvar("btd_sp_time",6,3,12,"int");
	level.player_sp_attack = createdvar("btd_sp_weapons",0,0,1,"int");
}

do_sp()
{
	if( level.player_sp == 0 || !isDefined( self ) )
	{ return; }

	self.sp_active = true;
	if ( level.player_sp_attack == 0 )
	{ self disableWeapons(); }

	self iprintln("Spawn Protection active for ^3" + level.player_sp_time + " ^7seconds.");
	self iprintln("Press ^3[{+activate}] ^7to disable spawn protection.");

	self thread sp_msg();
	self thread sp_wait();
	self thread sp_use();
}

sp_msg()
{
	self endon("death");
	self endon("disonnect");

	self waittill("sp_end");

	if ( isDefined( self ) )
	{
		if ( level.player_sp_attack == 0 )
		{ self iprintln("Spawn Protection ^3Disabled^7, Weapons Ready."); }
		else
		{ self iprintln("Spawn Protection ^3Disabled."); }
	}
}
	

sp_wait()
{
	self endon("death");
	self endon("disonnect");
	self endon("sp_end");

	wait level.player_sp_time;

	if ( isDefined( self ) && self.sp_active )
	{
		if ( level.player_sp_attack == 0 )
		{ self enableWeapons(); }

		self.sp_active = false;	
		self notify("sp_end");	
	}
}

sp_use()
{
	self endon("death");
	self endon("disonnect");
	self endon("sp_end");

	while( isDefined( self ) && self.sp_active )
	{
		if ( self UseButtonPressed())
		{
			if ( level.player_sp_attack == 0 )
			{ self enableWeapons(); }

			self.sp_active = false;
			self notify("sp_end");
		}

		if( self.sp_active == false )
		{ return; }

		wait 0.2;
	}
}

