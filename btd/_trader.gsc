#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include btd\_dvardef;

main()
{
	precacheModel("body_trader");
	precacheShader("waypoint_trader");

	level.traderon = createdvar("btd_trader",0,0,1,"int");
	level.trade_drop_number = createdvar("btd_trader_drops_number",6,1,16,"int");
	level.trade_drop_locations = createdvar("btd_trader_locations",1,0,1,"int");
	level.enable_weapon_sales = createdvar("btd_trader_enable_sales",1,0,1,"int");
}

startTrader()
{
	if( level.btd_devmode != 0 || level.traderon == 0 )
	{ return; }

	level thread spawn_trader();
}

spawn_trader()
{
	traderdrop = [];
		
	for(i = 0; i < level.trade_drop_number; i++)
	{
		spawnPoints[i] = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( "allies" );
		spawnPoint[i] = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints[i] );

		trace = bulletTrace(spawnPoint[i].origin + (0,0,40), spawnPoint[i].origin, false, undefined);

		traderdrop[i] = spawn("script_model", trace["position"] + (0,0,2));
		traderdrop[i].angles = (spawnPoint[i].angles);	
		traderdrop[i] setModel("body_trader");
		traderdrop[i].trigger = spawn("trigger_radius", spawnPoint[i].origin, 0, 100, 100);		

		traderdrop[i].trigger thread traderdrop();

		if(level.trade_drop_locations == 1)
		{
			traderdrop[i].marker = newHudElem();
			traderdrop[i].marker.hideWhenInMenu = true;
			traderdrop[i].marker SetTargetEnt(traderdrop[i]);
			traderdrop[i].marker.sort = 1;
			traderdrop[i].marker setWayPoint(true, "waypoint_trader");
		}		
	}

	iPrintlnBold("Trader shop is open! Closing in ^3" + level.grace_time + " ^7seconds.");

	level waittill("trade_end");

	players = getentarray("player","classname");
	for( p = 0; p < players.size; p++ )
	{
		players[p] maps\mp\gametypes\_globallogic::closeMenus();
		players[p].buymenuopen = false;
		players[p] iPrintln("Trader shop is closed!");
	}

	for(i = 0; i < level.trade_drop_number; i++)
	{
		if( level.trade_drop_locations == 1 )
		{ traderdrop[i].marker destroy(); }
		traderdrop[i].trigger delete();
		traderdrop[i] delete();
	}
}

traderdrop()
{
	level endon("trade_end");
	level endon("game_ended");

	while(true)
	{
		self waittill("trigger", player);

		if( player.sessionstate != "playing" || !isAlive( player ) )
		{ continue;	}

		if( player.buymenuopen == false )
		{
			if ( player UseButtonPressed())
			{
				player setClientDvar( "ui_player_money", player.money );
				player openMenu(game["menu_buymenu"]);
				player.buymenuopen = true;
				player thread tradingwait();
			}
		}
/*
		if( player.hasntfullammo )
		{
			player maps\mp\gametypes\_class::replenishLoadout();
			player.hasntfullammo = false;
			player thread clearammowait();
		}
*/
		if( player.health <= player.maxhealth - 10 )
		{ player.health = player.health + 10; }
		else if( player.health > player.maxhealth - 10 )
		{ player.health = player.maxhealth; }
	}
}

tradingwait()
{
	wait( 1 );
	if ( isDefined( self ) )
	{ self.buymenuopen = false; }
}

clearammowait()
{
	wait 5;
	if ( isDefined( self ) )
	{ self.hasntfullammo = true; }
}

