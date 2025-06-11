#include btd\_dvardef;

main()
{
	thread admin_cmds();
	level.admincount = createdvar("btd_admin_count",0,0,32,"int");
	level.adminconnectmsg = createdvar("btd_admin_announce",1,0,1,"int");
	level.adminmodels = createdvar("btd_admin_models",1,0,1,"int");

	level.admin_give_weapon = createdvar("btd_admin_give_weapon",1,0,1,"int");
	level.adminlevelweapon = createdvar("btd_admin_level_weapon",5,1,5,"int");
	level.admin_weapon = createdvar("btd_admin_weapon","briefcase_bomb_mp","","","string");

	level.adminlevelpickup = createdvar("btd_admin_level_pickup",4,0,5,"int");
	level.adminlevelpurge = createdvar("btd_admin_level_purge",1,0,5,"int");
	level.adminleveldn = createdvar("btd_admin_level_dn",2,0,5,"int");
	level.adminlevelfog = createdvar("btd_admin_level_fog",2,0,5,"int");
	level.adminlevelvis = createdvar("btd_admin_level_vision",3,0,5,"int");
	level.adminlevelammo = createdvar("btd_admin_level_ammo",4,0,5,"int");
	//level.adminlevelplayer = createdvar("btd_admin_level_player",5,0,5,"int");
	level.adminlevelendgame = createdvar("btd_admin_level_end_game",4,0,5,"int");
	level.adminlevelkick = createdvar("btd_admin_level_kick",4,0,5,"int");
	level.adminlevelban = createdvar("btd_admin_level_ban",5,0,5,"int");
	level.adminlevelrespawn = createdvar("btd_admin_level_respawn",1,0,5,"int");
	level.adminleveldemote = createdvar("btd_admin_level_demote",5,0,5,"int");
	level.adminlevelkill = createdvar("btd_admin_level_kill",1,0,5,"int");
	level.adminlevelteams = createdvar("btd_admin_level_team",1,0,5,"int");
}

isOnAdminList()
{
	found = false;
	guid = self getGuid();
	for( i = 0; i < level.admincount; i++ )
	{
		dvarString = ( "btd_admin" + i );
		dvar = getDvar( dvarString );
		if( !isDefined( dvar ) )
		{
			continue;
		}

		tokens = strTok( dvar, ":" );
		if( tokens.size == 3 )
		{
			if( tokens[0] == guid )
			{
				found = true;
				break;
			}
		}
	}
	return( found );
}

getAdminName()
{
	name = undefined;
	guid = self getGuid();
	for( i = 0; i < level.admincount; i++ )
	{
		dvarString = ( "btd_admin" + i );
		dvar = getDvar( dvarString );
		if( !isDefined( dvar ) )
		{
			continue;
		}

		tokens = strTok( dvar, ":" );
		if( tokens.size == 3 )
		{
			if( tokens[0] == guid )
			{
				name = tokens[1];
				break;
			}
		}
	}
	return( name );
}

getAdminLevel()
{
	adminlvl = 0;
	guid = self getGuid();
	for( i = 0; i < level.admincount; i++ )
	{
		dvarString = ( "btd_admin" + i );
		dvar = getDvar( dvarString );
		if( !isDefined( dvar ) )
		{
			continue;
		}

		tokens = strTok( dvar, ":" );
		if( tokens.size == 3 )
		{
			if( tokens[0] == guid )
			{
				adminlvl = int( tokens[2] );
				break;
			}
		}
	}
	return( adminlvl );
}

check_is_admin()
{
	if( self isOnAdminList() )
	{
		self.isadmin = true;
		return( true );
	}
	else
	{
		self.isadmin = false;
		return( false );
	}
}

admin_cmds()
{
	level endon( "game_ended" );

	createdvar("btdz_purge",-1,-1,1,"int");
	createdvar("btdz_daynight",-1,-1,1,"int");
	createdvar("btdz_uammo",-1,-1,1,"int");
	createdvar("btdz_pickups",-1,-5,64,"int");
	createdvar("btdz_hax",-1,-1,1,"int");
	setDvar("btdz_vision", "");
	setDvar("btdz_setrank", "");
	createdvar("btdz_demote",-1,-5,64,"int");
	setDvar("btdz_respawn", "");
	setDvar("btdz_give", "");
	setDvar("btdz_sayall", "");
	setDvar("btdz_rename", "");
	vision = undefined;

	while(1)
	{
		if( getDvarInt("btdz_purge") != -1 )
		{
			setDvar("btdz_purge", -1);
			btd\_pezbot_zombies::RemoveAllBots();
			iPrintlnbold("RCON ADMIN ^3PURGED ^7ZOMBIES");
		}

		if( getDvarInt("btdz_daynight") != -1 )
		{
			thread daynight_switch();
		}

		if( getDvarInt("btdz_uammo") != -1 )
		{
			thread infinite_ammo();
		}

		if( getDvarInt("btdz_pickups") != -1 )
		{
			thread pickup_change();
		}

		if( getDvar("btdz_vision") != "" )
		{
			thread vision_change();
		}

		if( getDvar("btdz_setrank") != "" )
		{
			thread setPlayerLvl();
		}

		if( getDvarInt("btdz_demote") != -1 )
		{
			thread resetPlayerRank();
		}

		if( getDvar("btdz_respawn") != "" )
		{
			thread returnToAction();
		}

		if( getDvar("btdz_give") != "" )
		{
			thread givePlayer();
		}

		if( getDvar("btdz_sayall") != "" )
		{
			for ( i = 0; i < level.players.size; i++ )
				level.players[i] maps\mp\gametypes\_hud_message::oldNotifyMessage( "ADMIN MESSAGE", getDvar( "btdz_sayall" ), game["icons"]["allies"] );

			//announcement( getDvar( "btdz_sayall" ) );
			setDvar( "btdz_sayall", "" );
		}

		if( getDvar("btdz_rename") != "" )
		{
			thread renamePlayer();
		}

		if( getDvarInt("btdz_hax") != -1 )
		{
			setDvar("btdz_hax", -1);
			if(getdvar("sv_cheats") == "1")
			{
				setDvar("sv_cheats", "0");
				iPrintlnbold("RCON ADMIN DISABLED ^3CHEATS.");
			}
			else if(getdvar("sv_cheats") == "0")
			{
				setDvar("sv_cheats", "1");
				iPrintlnbold("RCON ADMIN ENABLED ^3CHEATS.");
			}
		}
		wait(0.5);
	}
}

daynight_switch()
{
	setDvar("btdz_daynight", -1);
	if(getDvar("btd_night") == "1")
	{
		setDvar("btd_night", 0);
		iPrintlnbold("RCON ADMIN SWITCHED TO ^3DAY");
	}
	else if(getDvar("btd_night") == "0")
	{
		setDvar("btd_night", 1);
		iPrintlnbold("RCON ADMIN SWITCHED TO ^3NIGHT");
	}
}

infinite_ammo()
{
	setDvar("btdz_uammo", -1);
	if( !level.infinite_ammo )
	{
		level.infinite_ammo = true;
		iPrintlnbold("^3RCON ADMIN ^7ENABLED INFINITE AMMO");
	}
	else
	{
		level.infinite_ammo = false;
		iPrintlnbold("^3RCON ADMIN ^7DISABLED INFINITE AMMO");
	}
/*
	if(getdvar("player_sustainammo") == "1")
	{
		setDvar("player_sustainammo", "0");
		iPrintlnbold("^3RCON ADMIN ^7DISABLED INFINITE AMMO");
	}
	else if(getdvar("player_sustainammo") == "0")
	{
		setDvar("player_sustainammo", "1");	
		iPrintlnbold("^3RCON ADMIN ^7ENABLED INFINITE AMMO");
	}
*/
}

pickup_change()
{
	number = getDvarInt("btdz_pickups");
	setDvar("btdz_pickups", -1);
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		playerNum = players[i] getEntityNumber();
		if( playerNum == number )
		{
			if( players[i].isAdmin )
			{
				if(players[i].can_admin_pickup == false)
				{
					players[i].can_admin_pickup = true;
					players[i] iprintlnBold("PICKUPS: ^3ENABLED");
				}
				else if(self.can_admin_pickup == true)
				{
					players[i].can_admin_pickup = false;
					players[i] iprintlnBold("PICKUPS: ^3DISABLED");
				}
			}
			break;
		}
	}
}

vision_change()
{
	vision = getDvar("btdz_vision");
	if(vision == "map")
		vision = getDvar("mapname");

	setDvar("scr_setvisionmap", vision);
	visionSetNaked( vision, 2 );
	iPrintlnbold("^3RCON ADMIN ^7CHANGED VISION SETTINGS");
	setDvar("btdz_vision", "");
	vision = undefined;
}

returnToAction()
{
	number = getDvar("btdz_respawn");
	players = getentarray("player","classname");
	if( number == "all" )
	{
		for( p = 0; p < players.size; p++ )
		{
			if( players[p].pers["team"] != "spectator" )//&& players[p].respawnedInSpec == true )
			{
				if( !isAlive( players[p] ) && players[p].sessionstate != "playing" )
				{
					players[p].pers["lives"] = level.numLives;
					players[p].hasSpawned = true;
					players[p] thread maps\mp\gametypes\_globallogic::spawnPlayer(true);
					players[p].respawnedInSpec = false;
					players[p] maps\mp\_utility::clearLowerMessage();

					if ( !level.numLives )
					{ players[p] thread btd\_spawn_protection::do_sp(); }
				}
			}
		}
	}
	else
	{
		for( p = 0; p < players.size; p++ )
		{
			playerNum = players[p] getEntityNumber();
			if( playerNum == int( number ) )
			{
				if( players[p].pers["team"] != "spectator" )//&& players[p].respawnedInSpec == true )
				{
					if( !isAlive( players[p] ) && players[p].sessionstate != "playing" )
					{
						players[p].pers["lives"] = level.numLives;
						players[p].hasSpawned = true;
						players[p] thread maps\mp\gametypes\_globallogic::spawnPlayer(true);
						players[p].respawnedInSpec = false;
						players[p] maps\mp\_utility::clearLowerMessage();

						if ( !level.numLives )
						{ players[p] thread btd\_spawn_protection::do_sp(); }
					}
				}
				break;
			}
		}
	}
	setDvar("btdz_respawn", "");
}

setPlayerLvl()
{
	tokens = strTok( getdvar("btdz_setrank"), ":" );
	if( tokens.size == 2 )
	{
		players = getentarray("player", "classname");
		for( i=0; i<players.size; i++ )
		{
			playerNum = players[i] getEntityNumber();
			if( playerNum == int( tokens[0] ) )
			{
				players[i].unlocked = false;
				players[i] thread maps\mp\gametypes\_globallogic::autoPromotePlayer( int( tokens[1] ) );
				break;
			}
		}
	}
	setDvar("btdz_setrank", "");
}

resetPlayerRank()
{
	number = getDvarInt("btdz_demote");
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		playerNum = players[i] getEntityNumber();
		if( playerNum == number )
		{
			//if( !players[i].isAdmin )
			//{
				players[i] maps\mp\gametypes\_persistence::statSet( "rankxp", 0 );
				players[i].pers["rankxp"] = 0;
				players[i] maps\mp\gametypes\_persistence::statSet( "rank", 0 );
				players[i] maps\mp\gametypes\_persistence::statSet( "minxp", maps\mp\gametypes\_rank::getRankInfoMinXp( 0 ) );
				players[i] maps\mp\gametypes\_persistence::statSet( "maxxp", maps\mp\gametypes\_rank::getRankInfoMaxXp( 0 ) );
				players[i] maps\mp\gametypes\_persistence::statSet( "lastxp", 0 );
				players[i].pers["participation"] = 0;
				players[i].rankUpdateTotal = 0;
				players[i].cur_rankNum = 0;
				players[i] setStat( 251, 0 );
				players[i] setRank( 0, 0 );
				players[i].pers["prestige"] = 0;

				players[i].pers["unlocks"] = undefined;

				players[i].pers["unlocks"] = [];
				players[i].pers["unlocks"]["weapon"] = 0;
				players[i].pers["unlocks"]["perk"] = 0;
				players[i].pers["unlocks"]["challenge"] = 0;
				players[i].pers["unlocks"]["camo"] = 0;
				players[i].pers["unlocks"]["attachment"] = 0;
				players[i].pers["unlocks"]["feature"] = 0;
				players[i].pers["unlocks"]["page"] = 0;

				// resetting unlockable dvars
				players[i] setClientDvar( "player_unlockweapon0", "" );
				players[i] setClientDvar( "player_unlockweapon1", "" );
				players[i] setClientDvar( "player_unlockweapon2", "" );
				players[i] setClientDvar( "player_unlockweapons", "0" );
			
				players[i] setClientDvar( "player_unlockcamo0a", "" );
				players[i] setClientDvar( "player_unlockcamo0b", "" );
				players[i] setClientDvar( "player_unlockcamo1a", "" );
				players[i] setClientDvar( "player_unlockcamo1b", "" );
				players[i] setClientDvar( "player_unlockcamo2a", "" );
				players[i] setClientDvar( "player_unlockcamo2b", "" );
				players[i] setClientDvar( "player_unlockcamos", "0" );
			
				players[i] setClientDvar( "player_unlockattachment0a", "" );
				players[i] setClientDvar( "player_unlockattachment0b", "" );
				players[i] setClientDvar( "player_unlockattachment1a", "" );
				players[i] setClientDvar( "player_unlockattachment1b", "" );
				players[i] setClientDvar( "player_unlockattachment2a", "" );
				players[i] setClientDvar( "player_unlockattachment2b", "" );
				players[i] setClientDvar( "player_unlockattachments", "0" );
			
				players[i] setClientDvar( "player_unlockperk0", "" );
				players[i] setClientDvar( "player_unlockperk1", "" );
				players[i] setClientDvar( "player_unlockperk2", "" );
				players[i] setClientDvar( "player_unlockperks", "0" );
			
				players[i] setClientDvar( "player_unlockfeature0", "" );		
				players[i] setClientDvar( "player_unlockfeature1", "" );	
				players[i] setClientDvar( "player_unlockfeature2", "" );	
				players[i] setClientDvar( "player_unlockfeatures", "0" );
			
				players[i] setClientDvar( "player_unlockchallenge0", "" );
				players[i] setClientDvar( "player_unlockchallenge1", "" );
				players[i] setClientDvar( "player_unlockchallenge2", "" );
				players[i] setClientDvar( "player_unlockchallenges", "0" );
			
				players[i] setClientDvar( "player_unlock_page", "0" );

				players[i].pers["summary"] = undefined;
				players[i].pers["summary"] = [];
				players[i].pers["summary"]["xp"] = 0;
				players[i].pers["summary"]["score"] = 0;
				players[i].pers["summary"]["challenge"] = 0;
				players[i].pers["summary"]["match"] = 0;
				players[i].pers["summary"]["misc"] = 0;

				// resetting game summary dvars
				players[i] setClientDvar( "player_summary_xp", "0" );
				players[i] setClientDvar( "player_summary_score", "0" );
				players[i] setClientDvar( "player_summary_challenge", "0" );
				players[i] setClientDvar( "player_summary_match", "0" );
				players[i] setClientDvar( "player_summary_misc", "0" );

				players[i] setclientdvar( "ui_lobbypopup", "" );
				players[i] maps\mp\gametypes\_rank::updateChallenges();
				players[i].explosiveKills[0] = 0;
				players[i].xpGains = undefined;
				players[i].xpGains = [];

				players[i] iPrintlnbold("You have been DEMOTED by a ^3ADMIN" );
			//}
			break;
		}
	}
	setDvar("btdz_demote", -1);
}

givePlayer()
{
	tokens = strTok( getdvar("btdz_give"), ":" );
	if( tokens.size == 2 )
	{
		players = getentarray("player", "classname");
		if( tokens[0] == "all" )
		{
			for( i=0; i<players.size; i++ )
			{
				players[i] doGivePlayer( tokens[1] );
			}
		}
		else
		{
			for( i=0; i<players.size; i++ )
			{
				playerNum = players[i] getEntityNumber();
				if( playerNum == int( tokens[0] ) )
				{
					players[i] doGivePlayer( tokens[1] );
					break;
				}
			}
		}	
	}
	setDvar("btdz_give", "");
}

doGivePlayer(obj)
{
	if( !isDefined( self ) || !isPlayer( self ) )
	{ return; }
 
	if( self.pers["team"] != "spectator" && isAlive( self ) && self.sessionstate == "playing" )
	{
		if( obj == "ammo" )
		{
			self maps\mp\gametypes\_class::replenishLoadout();
			self playlocalsound("mp_suitcase_pickup");
			self iPrintln("Have some ammo! Courtesy of an ^3admin");
		}
		else if(obj == "radar_mp" || obj == "airstrike_mp" || obj == "helicopter_mp" || obj == "blackhawk_mp" || obj == "ac130_mp" || obj == "radar_mp" || obj == "nuke_mp" || obj == "napalm_mp")
		{
			self maps\mp\gametypes\_hardpoints::giveHardpoint( obj, 0 );
		}
		else if(obj == "artillery_mp")
		{
			self playLocalSound( "killstreak_won" );
			self thread btd\_hud_util::dohud("Artillery Acquired");
			self.num_arty++;
		}
		else
		{
			if( btd_menus\buy_menu\_buymenu_response::doesWeaponExist(obj) )
			{
				if ( !self hasWeapon( obj ) )
				{
					self giveweapon(obj);
					self giveMaxAmmo(obj);
					self playlocalsound("weap_pickup");
					name = btd_menus\buy_menu\_buymenu_response::getWeaponName(obj);
					self iPrintln("Have a " + name + "^7! Courtesy of an ^3admin");
				}
			}
		}
	}
}

renamePlayer()
{
	tokens = strTok( getdvar("btdz_rename"), ":" );
	if( tokens.size == 2 )
	{
		players = getentarray("player", "classname");
		for( i=0; i<players.size; i++ )
		{
			playerNum = players[i] getEntityNumber();
			if( playerNum == int( tokens[0] ) )
			{
				players[i] setClientDvar( "name", tokens[1] );
				break;
			}
		}	
	}
	setDvar("btdz_rename", "");
}
