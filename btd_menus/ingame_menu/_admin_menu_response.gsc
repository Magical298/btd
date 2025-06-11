#include btd\_admin;

adminMenuResponse(response)
{
	switch(response)
	{
		// night on/off
		case "1":
			if( self.adminLevel >= level.adminleveldn )
			{
				if(getDvar("btd_night") == "1")
				{
					setDvar("btd_night", 0);
					iPrintlnbold("^3" + self.name + " ^7SWITCHED TO DAY");
				}
				else if(getDvar("btd_night") == "0")
				{
					setDvar("btd_night", 1);
					iPrintlnbold("^3" + self.name + " ^7SWITCHED TO NIGHT");
				}
			}		
			else
			{ self iprintlnbold("Access to this feature is denied."); }		
		break;

		// Respawn all
		case"2":
			if( self.adminLevel >= level.adminlevelrespawn )
			{
				setDvar("btdz_respawn", "all");
				iPrintlnbold( "^3" + self.name + " ^7Re-Spawned everyone." );
			}
			else
			{ self iprintlnbold("Access to this feature is denied."); }
		break;

		// Purge Zombies
		case"3":
			if( self.adminLevel >= level.adminlevelpurge )
			{
				btd\_pezbot_zombies::RemoveAllBots();
				iPrintlnbold("^3" + self.name + " ^7PURGED ZOMBIES");
			}
			else
			{ self iprintlnbold("Access to this feature is denied."); }
		break;

		case "4":
			if( self.adminLevel >= level.adminlevelammo )
			{
				if( !level.infinite_ammo )
				{
					level.infinite_ammo = true;
					iPrintlnbold("^3" + self.name + " ^7ENABLED INFINITE AMMO");
				}
				else
				{
					level.infinite_ammo = false;
					iPrintlnbold("^3" + self.name + " ^7DISABLED INFINITE AMMO");
				}
			}
			else
			{ self iprintlnbold("Access to this feature is denied."); }
		break;

		case "5":
			if( self.adminLevel >= level.adminlevelendgame )
			{
				iPrintlnbold("^3" + self.name + " ^7ENDING GAME");
				level thread maps\mp\gametypes\_globallogic::forceEnd();
			}
			else
			{ self iprintlnbold("Access to this feature is denied."); }
		break;

		case "6":
			//if( self.adminLevel >= level.adminlevelplayer )
			//{
				self openmenu(game["menu_admin_player"]);
				if( !self.inAdminMenu )
				{ self.inAdminMenu = true; }
			//}
			//else
			//{ self iprintlnbold("Access to this feature is denied."); }
		break;
	}
}

adminTwoMenuResponse(response)
{
	switch(response)
	{
		// Self pickups on or off
		case"1":
			if( self.adminLevel >= level.adminlevelpickup )
			{
				if(self.can_admin_pickup == false)
				{
					self.can_admin_pickup = true;
					self iprintlnBold("^7PICKUPS: ^3ENABLED");
				}
				else if(self.can_admin_pickup == true)
				{
					self.can_admin_pickup = false;
					self iprintlnBold("^7PICKUPS: ^3DISABLED");
				}
			}
			else
			{ self iprintlnbold("Access to this feature is denied."); }
		break;

		// Head Icon on or off
		case"2":
			if( isPlayer(self) && isAlive(self) && self.sessionstate == "playing" )
			{
				if( self.headiconon == false )
				{
					self.headicon = "headicon_admn";
					self.headiconteam = self.team;
					self.headiconon = true;
					self iprintlnBold("^7ADMIN HEAD ICON: ^3ENABLED");
				}
				else
				{
					self.headicon = "";
					self.headiconon = false;
					self iprintlnBold("^7ADMIN HEAD ICON: ^3DISABLED");
				}
			}
			else
			{ self iprintlnbold("Must be spawned and alive to use feature."); }
		break;

		// Admin player model
		case "3":
			if( level.adminmodels )
			{
				if( self.useadminmodel )
				{
					self.useadminmodel = false;
					self iprintlnbold("^3Admin ^7model is ^3Disabled.");
				}
				else
				{
					self.useadminmodel = true;
					self iprintlnbold("^3Admin ^7model ^3Enabled.");
				}

				if( isPlayer(self) && isAlive(self) && self.sessionstate == "playing" )
				{
					self maps\mp\gametypes\_teams::playerModelForWeapon( self.pers["primaryWeapon"] );
					self maps\mp\gametypes\_weapons::stow_on_back();
					self maps\mp\gametypes\_weapons::stow_on_hip();
				}
			}
			else
			{ self iprintlnbold("Admin models are disabled."); }
		break;

		// Admin weapon
		case"4":
			if( self.adminLevel >= level.adminlevelweapon && level.admin_give_weapon )
			{
				if ( !self hasWeapon( level.admin_weapon ) )
				{
					self giveweapon(level.admin_weapon);
					self giveMaxAmmo(level.admin_weapon);
					self playlocalsound("weap_pickup");
				}
				else
				{ self iprintlnbold("You Already have the Admin Weapon!"); }
			}
			else
			{ self iprintlnbold("Access to this feature is denied."); }
		break;
	}
}

bxAdminOnMenuResponse()
{
	self endon("disconnect");

	self.selected_player = 0;
	player = level.players[self.selected_player];
	//self updateMenu(player);

	for(;;)
	{
		self waittill("menuresponse", menu, response);

		if(menu == game["menu_admin_player"])
		{
			switch(response)
			{
				case "bx_admin_prev":
					// Select previous player
					if( self.selected_player >= 0 )
					{
						if( self.selected_player != 0 )
						{ player = self thread select_previous_player(); }
						else
						{ player = getFirstPlayerFromList(); }

						self updateMenu(player);
					}
				break;

				case "bx_admin_next":
					// Select next player
					if( self.selected_player <= maxPlayers() )
					{
						if( self.selected_player < maxPlayers() )
						{ player = self thread select_next_player(); }
						else
						{ player = getLastPlayerFromList(); }

						self updateMenu(player);
					}
				break;

				case "bx_admin_kick":
					// Kick player
					if( self.adminLevel >= level.adminlevelkick )
					{
						if( isDefined( player ) && player != self )
						{
							self thread admin_notify( "Kicked ^3" + player.name + "^7." );
							iPrintln( "^3" + self.name + " ^7Kicked ^3" + player.name + "^7." );
							kick( player getEntityNumber() );
						}
					}
					else
					{ self thread admin_notify( "Access to this feature is denied." ); }
				break;

				case "bx_admin_ban":
					// Ban player
					if( self.adminLevel >= level.adminlevelban )
					{
						if( isDefined( player ) && player != self )
						{
							self thread admin_notify( "Banned player ^3" + player.name + "^7." );
							iPrintln( "^3" + self.name + " ^7Banned Player ^3" + player.name + "^7." );
							ban( player getEntityNumber() );
						}
					}
					else
					{ self thread admin_notify( "Access to this feature is denied." ); }
				break;

				case "bx_admin_kill":
					// Kill player
					if( self.adminLevel >= level.adminlevelkill )
					{
						if( isDefined( player ) && isAlive( player ) )
						{
							self thread admin_notify( "Killed ^3" + player.name + "^7." );
							iPrintln( "^3" + self.name + " ^7Killed ^3" + player.name + "^7." );
							player suicide();
						}
					}
					else
					{ self thread admin_notify( "Access to this feature is denied." ); }
				break;

				case "bx_admin_move_spec": 
					// Move player to Spectator
					if( self.adminLevel >= level.adminlevelteams )
					{
						if( isDefined( player ) && player.pers["team"] != "spectator")
						{
							self thread admin_notify( "Moved ^3" + player.name + " ^7to Spectator." );
							iPrintln( "^3" + self.name + " ^7Moved ^3" + player.name + " ^7to Spectator." );
							player [[level.spectator]]();
						}
					}
					else
					{ self thread admin_notify( "Access to this feature is denied." ); }
				break;

				case "bx_admin_move_allies": 
					// Move player to Allies
					if( self.adminLevel >= level.adminlevelteams )
					{
						if( isDefined( player ) && player.pers["team"] != "allies")
						{
							self thread admin_notify( "Moved ^3" + player.name + " ^7to Survivors." );
							iPrintln( "^3" + self.name + " ^7Moved ^3" + player.name + " ^7to Survivors." );
							player [[level.allies]]();
						}
					}
					else
					{ self thread admin_notify( "Access to this feature is denied." ); }
				break;

				case "bx_admin_respawn": 
					// Respawn
					if( self.adminLevel >= level.adminlevelrespawn )
					{
						if( isDefined( player ) )
						{
							setDvar("btdz_respawn", player getEntityNumber());
							self thread admin_notify( "Re-spawned ^3" + player.name + "^7." );
							iPrintln( "^3" + self.name + " ^7re-spawned ^3" + player.name + "^7." );
						}
					}
					else
					{ self thread admin_notify( "Access to this feature is denied." ); }
				break;

				case "bx_admin_demote": 
					// Reset Rank
					if( self.adminLevel >= level.adminleveldemote )
					{
						if( isDefined( player ) )
						{
							setDvar("btdz_demote", player getEntityNumber());
							self thread admin_notify( "Demoted ^3" + player.name + "^7." );
							iPrintln( "^3" + self.name + " ^7Demoted ^3" + player.name + "^7." );
						}
					}
					else
					{ self thread admin_notify( "Access to this feature is denied." ); }
				break;

				case "bx_admin_close": 
					// Remove protection
					if( self.inAdminMenu )
					{
						self.inAdminMenu = false;
						self iPrintln( "Menu Protection: ^3Disabled" );
					}
				break;
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
// Admin player stuff

select_next_player()
{
	player = undefined;
	self.selected_player++;

	if( self.selected_player >= maxPlayers() )
	{ self.selected_player = maxPlayers(); }

	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		if( i == self.selected_player )
		{
			player = players[i];
			break;
		}
	}

	return player;
}

select_previous_player()
{
	player = undefined;
	self.selected_player--;

	if( self.selected_player <= 0 )
	{ self.selected_player = 0; }

	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		if( i == self.selected_player )
		{
			player = players[i];
			break;
		}
	}

	return player;
}

maxPlayers()
{
	num = 0;
	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
		num++;

	return (num - 1);
}

getFirstPlayerFromList()
{
	first_player = getEntArray( "player", "classname" );
	player = level.players[0];
	for ( i = 0; i < first_player.size ; i++ )
	{
		if( !isDefined( player ) )
		{
			player = first_player[i];
			break;
		}
	}

	return player;
}

getLastPlayerFromList()
{
	last_player = getEntArray( "player", "classname" );
	player = level.players[level.players.size];

	for ( i = 0; i < last_player.size ; i++ )
	{ player = last_player[i]; }

	return player;
}

admin_notify( text )
{
	self notify("kill admin notify");
	self endon("disconnect");
	self endon("kill admin notify");

	self setClientDvar("ui_btdzadm_info", text );
	wait 3;
	self setClientDvar("ui_btdzadm_info", "" );
}

updateMenu(player)
{
	if( isDefined( player ) )
	{
		self setClientDvar( "ui_sel_player_name", ( "Name: ^3" + player.name ) );
		self setClientDvar( "ui_sel_player_guid", ( "Guid: ^3" + player getGuid() ) );
		self setClientDvar( "ui_sel_player_num", ( "Number: ^3" + player getEntityNumber() ) );

		self setClientDvar( "ui_sel_player_team", ( "Team: ^3" + player.pers["team"] ) );
		self setClientDvar( "ui_sel_player_status", ( "Status: ^3" + player.sessionstate ) );
	}
	else
	{
		self setClientDvar( "ui_sel_player_name", "" );
		self setClientDvar( "ui_sel_player_guid", "" );
		self setClientDvar( "ui_sel_player_num", "" );

		self setClientDvar( "ui_sel_player_team", "" );
		self setClientDvar( "ui_sel_player_status", "" );
	}
}
