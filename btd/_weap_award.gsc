#include btd\_hud_util;
#include btd\_dvardef;

main()
{
	level.btd_weapon_award = createdvar("btd_Weapon_Award",0,0,1,"int");
	level.btd_weap_special1_streak = createdvar("btd_weap_special1_streak",55,10,10000,"int");
	level.btd_weap_special2_streak = createdvar("btd_weap_special2_streak",110,10,10000,"int");
	level.btd_weap_special3_streak = createdvar("btd_weap_special3_streak",220,10,10000,"int");
	level.btd_weap_special4_streak = createdvar("btd_weap_special4_streak",440,10,10000,"int");
	level.btd_weap_special5_streak = createdvar("btd_weap_special5_streak",880,10,10000,"int");
	level.btd_weap_special6_streak = createdvar("btd_weap_special6_streak",1020,10,10000,"int");
}

check_for_rampage(streak)
{
	if( isPlayer(self) && isAlive(self) && self.sessionstate == "playing" )
	{
		if( !self.isarty && !self.inHelicopter && !self.inAc130 && !isDefined( self.lastStand ) )
		{
			if( streak == level.btd_weap_special1_streak && !self hasWeapon( "special1_mp" ) && self.pers["rank"] < 39 )
			{
				self thread dohud(getDvar("btd_special1_weap_name") + " ^3Acquired");
				self thread WeaponAward("special1_mp");
			}

			if( streak == level.btd_weap_special2_streak && !self hasWeapon( "special2_mp" ) && self.pers["rank"] < 44 )
			{
				self thread dohud(getDvar("btd_special2_weap_name") + " ^3Acquired");
				self thread WeaponAward("special2_mp");
			}

			if( streak == level.btd_weap_special3_streak && !self hasWeapon( "special3_mp" ) && self.pers["rank"] < 49 )
			{
				self thread dohud(getDvar("btd_special3_weap_name") + " ^3Acquired");
				self thread WeaponAward("special3_mp");
			}

			if( streak == level.btd_weap_special4_streak && !self hasWeapon( "special4_mp" ) && self.pers["rank"] < 54 )
			{
				self thread dohud(getDvar("btd_special4_weap_name") + " ^3Acquired");
				self thread WeaponAward("special4_mp");
			}

			if( streak == level.btd_weap_special5_streak && !self hasWeapon( "special5_mp" ) && self.pers["rank"] < 59 )
			{
				self thread dohud(getDvar("btd_special5_weap_name") + " ^3Acquired");
				self thread WeaponAward("special5_mp");
			}

			if( streak == level.btd_weap_special6_streak && !self hasWeapon( "special6_mp" ) && self.pers["rank"] < 64 )
			{
				self thread dohud(getDvar("btd_special6_weap_name") + " ^3Acquired");
				self thread WeaponAward("special6_mp");
			}
		}
	}
}

WeaponAward(type)
{
	self endon("awardover"); // kills script after weapon award is over to help max_variable_limit being avoided
	self endon("disconnect"); // kills on player disconnect
	self endon("joined_spectators"); // kills on joining spectator
	self endon("death");

	if( !isDefined( type ) )
	{
		type = "special1_mp";
	}

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
				player iprintlnbold( "^3" + self.name + " ^7Has earned a Super Weapon!" );
		}
	}

	earthquake( 0.3, 3, self.origin, 200 );

	oldweap = self getCurrentWeapon();
	self giveweapon( type );
	self giveStartAmmo( type );
	self switchToWeapon( type );

	if( !isDefined( self.weap_timer ) )
	{
		self.weap_timer = newClientHudElem( self );
		self.weap_timer.x = 635;
		self.weap_timer.y = 250;
		self.weap_timer.alignx = "right";
		self.weap_timer.aligny = "middle";
		self.weap_timer.horzAlign = "fullscreen";
		self.weap_timer.vertAlign = "fullscreen";
		self.weap_timer.alpha = 1.0;
		self.weap_timer.fontScale = 2;
		self.weap_timer.sort = 100;
		self.weap_timer.foreground = true;
		self.weap_timer.glowAlpha = 0.1;
		self.weap_timer.glowColor = (1, 1, 0);
		self.weap_timer setTimer( 60.0 );
	}

	wait( 60 );

	self iprintlnbold("Super Weapon : ^3DISABLED");
	//iprintlnbold("^5Super Weapon Over");

	if( isDefined(self.weap_timer ) )
	{ self.weap_timer destroy(); }

	if( self hasWeapon( type ) )
	{
		self takeWeapon( type );
	}

	if( self hasWeapon( oldweap ) )
	{
		self switchToWeapon( oldweap );
	}
	self notify("awardover");
}
