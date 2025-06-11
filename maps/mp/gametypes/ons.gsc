#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main()
{
	if(getdvar("mapname") == "mp_background")
		return;

	// Need this here to set dvars since this isn't defined until _globallogic::init is run
	//level.gametype = toLower( getDvar( "g_gametype" ) );

	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( "ons", 15, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( "ons", 0, 0, 5000 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( "ons", 1, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( "ons", 2, 0, 10 );

	level.zombies = [];
	level.zomspawns = [];
	level.canjoin = true;
	level.number_of_waves = 1;
	level.currentwave = 1;
	level.wavetospawn = 0;
	level.currentspawnnum = 0;
	level.totalzomsinwave = 0;

	level.grace_time = dvarIntValue( "grace_time", 90, 10, 300 ); //scr_ons_grace_time
	level.maxzombies = dvarIntValue( "max_zoms", 32, 10, 100 ); //scr_ons_max_zoms
	level.zom_spawn_delay = dvarFloatValue( "zom_spawn_delay", 0.5, 0.05, 5 ); //scr_ons_zom_spawn_delay
	level.zom_spawn_delay_auto = dvarIntValue( "zom_delay_auto", 1, 0, 1 ); //scr_ons_zom_delay_auto

	level.teamBased = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;

	game["dialog"]["gametype"] = "team_deathmtch";
}

onStartGameType()
{
	setClientNameMode("auto_change");

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"BTDZ_ONS" );
	
	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"BTDZ_ONS" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"BTDZ_ONS_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"BTDZ_ONS_HINT" );
			
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	allowed[0] = "war";
	
	if ( getDvarInt( "scr_oldHardpoints" ) > 0 )
		allowed[1] = "hardpoint";
	
	level.displayRoundEndText = false;
	maps\mp\gametypes\_gameobjects::main(allowed);

	if( level.ammo_chopper == 1 || level.traderon == 1 )
	{
		if(level.grace_time < 75)
		{ level.grace_time = 75; }
	}

	level thread check_start();
	wait 0.5;
	level thread grace_start();
}

onSpawnPlayer()
{
	self.usingObj = undefined;

	if ( level.inGracePeriod )
	{
		if ( isDefined(level.playerSpawnCount) && level.playerSpawnCount > 0 )
		{
			spawnPoints = level.playerSpawns;
		}
		else
		{
			spawnPoints = getentarray("mp_tdm_spawn_" + self.pers["team"] + "_start", "classname");
		}
		
		if ( !spawnPoints.size )
			spawnPoints = getentarray("mp_sab_spawn_" + self.pers["team"] + "_start", "classname");
			
		if ( !spawnPoints.size )
		{
			spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
		}
		else
		{
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
		}		
	}
	else
	{
		if ( isDefined(level.playerSpawnCount) && level.playerSpawnCount > 0 )
		{
			spawnPoints = level.playerSpawns;
		}
		else
		{
			spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
		}

		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	}
	
	self spawn( spawnPoint.origin, spawnPoint.angles );
}

check_start()
{
	level endon("game_ended");
	level endon("wave_start");

	count = 0;

	while(1)
	{
		players = getentarray("player","classname");
		for( p = 0; p < players.size; p++)
		{
			if(players[p].sessionstate == "playing")
			{ count++; }
		}

		if(count > 0 )
		{ level.thereArePlayers = true; }
		else
		{ level.thereArePlayers = false; }

		wait 5;	
	}
}

grace_start()
{
	level endon("wave_start");
	level endon("game_ended");

	while(1)
	{
		level.canjoin = true;
		level.status = "grace";
		level notify("grace_start");

		while(!level.thereArePlayers)
		{ wait 1; }

		wait 5;

		if(level.ammo_drops == 1)
		{ btd\_ammo_drops::startAmmoDrops(); }

		if(level.traderon == 1)
		{ btd\_trader::startTrader(); }

		wait level.grace_time;

		level notify("grace_end");
		level notify("change_spawns");

		if(level.ammo_drops == 1)
		{ level notify("ammo_end"); }

		if(level.traderon == 1)
		{ level notify("trade_end"); }

		wait 5;

		thread onslaught_start();
	}
}

onslaught_start()
{
	level notify("wave_start");
	level endon("game_ended");

	level.status = "play";
	level.canjoin = false;
	level.startTime = getTime();// Check time limit
	level thread players();
	level thread onslaught_ammo_handler();
	level thread spec();

	num_zoms = 0;
	level.zomwaves = 1;
	spawn_interval = 1;

	iPrintlnBold("^2INCOMMING ^1ZOMBIES ^2for ^3" + (level.timelimit / 60) + " ^2minutes!");

	while(1)
	{
		level.wavetospawn = level.maxzombies - num_zoms;
		level.totalzomsinwave = level.maxzombies;

		if(num_zoms < level.maxzombies)
		{ level thread btd\_prob::choose(); }

		if( level.zom_spawn_delay_auto == 1 )
		{
			players = getentarray("player","classname");
			if( players.size <= 2 )
			{ spawn_interval = 1; }
			else if( players.size > 2 && players.size <= 4 )
			{ spawn_interval = 0.5; }
			else if( players.size > 4 && players.size <= 6 )
			{ spawn_interval = 0.25;	 }
			else if( players.size > 6 )
			{ spawn_interval = 0.15; }
		}
		else
		{ spawn_interval = level.zom_spawn_delay; }

		wait spawn_interval;

		zombies = getentarray("zom","targetname");
		num_zoms = zombies.size;
	}
}	

onslaught_ammo_handler()
{
	level endon("wave_end");
	level endon("game_ended");

	while(1)
	{
		time = randomIntRange( 150, 300 );
		iPrintlnBold("Ammo drops in ^3" + int(time / 60 ) + " ^7minutes.");

		wait( time );

		if(level.ammo_drops == 1)
		{ btd\_ammo_drops::startAmmoDrops(); }

		if(level.traderon == 1)
		{ btd\_trader::startTrader(); }

		spawn_newcomers();

		wait level.grace_time;

		if(level.ammo_drops == 1)
		{ level notify("ammo_end"); }

		if(level.traderon == 1)
		{ level notify("trade_end"); }
	}
}

spawn_newcomers()
{
	level endon("game_ended");

	players = getentarray("player","classname");
	for( p = 0; p < players.size; p++ )
	{
		if( players[p].pers["team"] == "spectator" )
		{ continue; }

		if( !players[p].hasSpawned )
		{
			players[p].respawnedInSpec = false;
			players[p].pers["lives"] = level.numLives;
			if( !isAlive( players[p] ) || players[p].sessionstate != "playing" )
			{
				players[p] thread maps\mp\gametypes\_globallogic::spawnPlayer(1);
				players[p] maps\mp\_utility::clearLowerMessage();
			}
		}
		wait 0.1;
	}
}

players()
{
	level endon("wave_end");
	level endon("game_ended");

	playersAlive = false;
	while(1)
	{
		playersAlive = false;
		players = getentarray("player","classname");
		for( p = 0; p < players.size; p++ )
		{
			if( isDefined( players[p] ) )
			{
				if( ( players[p].sessionstate == "playing" && players[p].team == "allies" ) || players[p] maps\mp\gametypes\_globallogic::maySpawn())
				{ playersAlive = true; }
			}
			wait 0.1;
		}

		if ( playersAlive == false )
		{
			iPrintlnBold("^1The zombies have eaten all of us!");
			wait 5;
			thread maps\mp\gametypes\_globallogic::endGame("axis", "^1The humans have been defeated!");
			level notify("wave_end");
			return;
		}

		wait 1;
	}
}

spec()
{
	level endon("wave_end");
	level endon("game_ended");

	wait 30;

	while(1)
	{
		//iprintln("^0[^1BTDz^0] ^7- Scanning for spec mode glitchers");
		specCount = 0;

		//wait 1;

		players = getentarray("player","classname");
		for( p = 0; p < players.size; p++)
		{
			if(players[p].sessionstate == "playing")
			{
				if(players[p].health <= 0)
				{
					kick(players[p]);
					iprintln( players[p].name + "has been kicked for spec glitching");
					specCount ++;
				}

				if(players[p].pers["team"] == "spectator") 
				{
					kick(players[p]);
					iprintln( players[p].name + "has been kicked for spec glitching");
					specCount ++;
				}
			}
			wait 0.5;
		}
		//wait 1;
		//iprintln("^0[^1BTDz^0] ^7- Scan complete: " + specCount + " glitchers found!");
		wait 60;
	}
}

onEndGame( winningTeam )
{
	if ( isdefined( winningTeam ) && (winningTeam == "allies" || winningTeam == "axis") )
		[[level._setTeamScore]]( winningTeam, [[level._getTeamScore]]( winningTeam ) + 1 );	
}