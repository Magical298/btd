#include btd\_hud_util;
#include btd\_dvardef;

main()
{
	precacheString( &"BTDZ_EARNED_ARTY" );

	level.btd_artillery = createdvar("btd_artillery",1,0,1,"int");
	level.btd_artillery_killstreak = createdvar("btd_artillery_spree",200,10,10000,"int");
	level.btd_artillery_time = createdvar("btd_artillery_time",45,26,120,"int");
}

check_for_rampage(streak)
{
	if ( ( streak % level.btd_artillery_killstreak ) == 0 )
	{
		notifyData = spawnStruct();
		notifyData.titleLabel = &"MP_KILLSTREAK_N";
		notifyData.titleText = streak;
		notifyData.notifyText = &"BTDZ_EARNED_ARTY";
		notifyData.sound = "plr_new_rank";
		notifyData.iconName = game["icons"]["allies"];
		notifyData.glowColor = (0,0,1);

		self maps\mp\gametypes\_hud_message::notifyMessage( notifyData );

		//self playLocalSound( "killstreak_won" );
		//self thread dohud("^5Artillery Acquired");
		self.num_arty++;
		//self thread notice(); // add, or edit, the artillery HUD elem
	}
}

notice()
{
	self endon("disconnect");
	self endon("death");

	while(1)
	{
		wait 0.5;
		if (self.num_arty > 0) // if has more than 0 keep HUD
		{
			self notify("no arty");
			self thread notify_usage("Artillery x " + self.num_arty, "no arty", 75, 406, (1.0,1.0,1.0));
		}
		else if (self.num_arty == 0) // if has no arty remove hud
		{
			self notify("no arty");	    
		}    
	}
}

artillery() // artillery main script
{
	self endon("artyover"); // kills script after artillery is over to help max_variable_limit being avoided
	self endon("disconnect"); // kills on player disconnect
	self endon("joined_spectators"); // kills on joining spectator
	self endon("death"); // kills if the player is stupid enough to suicide mid-artillery xD

	self.num_arty = self.num_arty - 1; // remove one artillery from the available
	self.isarty = true;

	self iprintlnbold("Artillery mode enabled for ^3" + level.btd_artillery_time + " ^7seconds.");

	team = self.pers["team"];
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if( !isDefined( player ) || player == self )
		{ continue; }

		playerteam = player.pers["team"];
		if ( isdefined( playerteam ) )
		{
			if ( playerteam == team )
			{ player iprintlnbold("Incoming Artillery by ^3" + self.name + "^7!"); }
		}
	}

	earthquake( 0.3, 3, self.origin, 200 );
	self.lowpoint = self.origin;

	// Some maps have low ceilings, compensate for those we know..
	mapname = getdvar("mapname");
	highpoint = undefined;
	if( mapname == "mp_dust2_classic" || mapname == "mp_dust3" || mapname == "mp_hhk_ballroom" || mapname == "mp_zom_box_fun" )
	{ highpoint = self.origin + (0,0,325); }
	else
	{ highpoint = self.origin + (0,0,950); }

	self.lifter = spawn("script_model",(0,0,0));
	self.islinked = true;
	self.lifter.origin = self.origin;
	self linkto(self.lifter);
	self.lifter.origin = self.origin;
	self.lifter moveto(highpoint, 3);

	wait 3;

	self iprintlnbold("Press and hold ^3[{+melee}] ^7to exit Artillery.");
	self thread watchForCancelArty();
	self AllowAds( false );
	self.oldweap = self getCurrentWeapon();
	self giveweapon("defaultweapon_mp");
	self givemaxammo("defaultweapon_mp");
	self switchToWeapon("defaultweapon_mp");

	if( !isDefined( self.arty_timer ) )
	{
		self.arty_timer = newClientHudElem( self );
		self.arty_timer.x = 635;
		self.arty_timer.y = 250;
		self.arty_timer.alignx = "right";
		self.arty_timer.aligny = "middle";
		self.arty_timer.horzAlign = "fullscreen";
		self.arty_timer.vertAlign = "fullscreen";
		self.arty_timer.alpha = 1.0;
		self.arty_timer.fontScale = 2;
		self.arty_timer.sort = 100;
		self.arty_timer.foreground = true;
		self.arty_timer.glowAlpha = 0.1;
		self.arty_timer.glowColor = (1, 1, 0);
		self.arty_timer setTimer( level.btd_artillery_time );
	}

	wait( level.btd_artillery_time );

	self thread end_arty();
}

watchForCancelArty()
{
	self endon("artyover");
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("death");

	while( isDefined(self) && self.isarty )
	{
		wait 0.05;
		if(self meleeButtonPressed())
		{
			wait 1;
			if(!self meleeButtonPressed())
			{ continue; }

			self thread end_arty();
			break;
		}
	}
}

end_arty()
{
	if( !isDefined(self) || !isAlive(self) || !self.isarty )
	{ return; }

	self iprintlnbold("Artillery Mode : ^3DISABLED");

	if( isDefined(self.arty_timer ) )
	{ self.arty_timer destroy(); }

	self takeWeapon("defaultweapon_mp");

	if ( isDefined( self.oldweap ) && self hasWeapon( self.oldweap ) )
	{ self switchToWeapon(self.oldweap); }

	self AllowAds( true );

	self.lifter moveto(self.lowpoint, 3);

	wait 3;

	self unlink();
	self.lifter delete();
	self.lowpoint = undefined;
	self.isarty = false;
	self notify("artyover");
}

notify_usage(message, cleanup_notify, x_position, y_position, color) 
{
	if ( !isdefined(y_position) )
	{
		y_position = 130;
	}
	if ( !isdefined(x_position) )
	{
		x_position = 30;
	}
	text = newClientHudElem(self);
	text setText(message);
	text.alignX = "left";
	text.alignY = "middle";
	text.x = x_position;
	text.y = y_position;
	text.sort = 2;
	text.foreground = false;
	text.hideWhenInMenu = true;
	text.fontscale = 1.4;
			
	if ( isdefined(color) )
	{
		text.glowAlpha = 0.1;
		text.glowColor = (1, 0, 0);
		text.color = color;
	}
	
	self waittill(cleanup_notify);
	
	text destroy();
}
