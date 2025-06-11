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

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( "elim", 666, 0, 666 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( "elim", 0, 0, 5000 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( "elim", 1, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( "elim", 0, 0, 10 );

	level.zombies = [];
	level.zomspawns = [];
	level.canjoin = true;
	level.currentspawnnum = 0;
	level.wavetospawn = 0;
	level.currentwave = 0;
	level.totalzomsinwave = 0;
	level.boss = false;

	level.wave_settings = dvarIntValue( "wave_settings", 2, 1, 2 ); //scr_elim_wave_settings
	level.number_of_waves = dvarIntValue( "num_waves", 6, 1, 10 ); //scr_elim_num_waves
	level.zom_dynamic_factor = dvarIntValue( "dynamic_factor", 6, 1, 10 ); //scr_elim_dynamic_factor
	level.start_zoms = dvarIntValue( "start_zoms", 100, 5, 100 ); //scr_elim_start_zoms
	level.end_of_round_boss = dvarIntValue( "end_boss", 1, 0, 1 ); //scr_elim_end_boss
	level.boss_count = dvarIntValue( "end_boss_count", 1, 1, 10 ); //scr_elim_end_boss_count
	level.grace_time = dvarIntValue( "grace_time", 80, 10, 300 ); //scr_elim_grace_time
	level.maxzombies = dvarIntValue( "max_zoms", 32, 10, 100 ); //scr_elim_max_zoms
	level.minzombies = dvarIntValue( "min_zoms", 26, 1, 100 ); //scr_elim_min_zoms
	level.zom_spawn_delay = dvarFloatValue( "zom_spawn_delay", 0.5, 0.05, 5 ); //scr_elim_zom_spawn_delay
	level.zom_spawn_delay_auto = dvarIntValue( "zom_delay_auto", 1, 0, 1 ); //scr_elim_zom_delay_auto
	level.zom_point_scale = dvarIntValue( "point_scale", 1, 0, 100 ); //scr_elim_point_scale

	if(level.wave_settings == 2)
	{
		level.surzoms_wave[0] = 50;
		level.surzoms_wave[1] = dvarIntValue( "zoms_wave1", 100, 10, 10000 ); //scr_elim_zoms_wave1
		level.surzoms_wave[2] = dvarIntValue( "zoms_wave2", 200, 10, 10000 );
		level.surzoms_wave[3] = dvarIntValue( "zoms_wave3", 300, 10, 10000 );
		level.surzoms_wave[4] = dvarIntValue( "zoms_wave4", 400, 10, 10000 );
		level.surzoms_wave[5] = dvarIntValue( "zoms_wave5", 500, 10, 10000 );
		level.surzoms_wave[6] = dvarIntValue( "zoms_wave6", 600, 10, 10000 );
		level.surzoms_wave[7] = dvarIntValue( "zoms_wave7", 700, 10, 10000 );
		level.surzoms_wave[8] = dvarIntValue( "zoms_wave8", 800, 10, 10000 );
		level.surzoms_wave[9] = dvarIntValue( "zoms_wave9", 900, 10, 10000 );
		level.surzoms_wave[10] = dvarIntValue( "zoms_wave10", 1000, 10, 10000 );
	}


	level.teamBased = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;

	if( !isDefined( level.wave_timer ) )
	{
		level.wave_timerText = newhudelem();
		level.wave_timerText.x = 600;
		level.wave_timerText.y = 110;
		level.wave_timerText.alignx = "right";
		level.wave_timerText.aligny = "middle";
		level.wave_timerText.horzAlign = "fullscreen";
		level.wave_timerText.vertAlign = "fullscreen";
		level.wave_timerText.alpha = 1.0;
		level.wave_timerText.glowAlpha = 0.1;
		level.wave_timerText.glowColor = (1, 0, 0);
		level.wave_timerText.fontScale = 1.4;
		level.wave_timerText.sort = 100;
		level.wave_timerText.foreground = false;
		level.wave_timerText.hideWhenInMenu = true;
		level.wave_timerText setText("Elapsed:");

		level.wave_timer = newhudelem();
		level.wave_timer.x = 635;
		level.wave_timer.y = 110;
		level.wave_timer.alignx = "right";
		level.wave_timer.aligny = "middle";
		level.wave_timer.horzAlign = "fullscreen";
		level.wave_timer.vertAlign = "fullscreen";
		level.wave_timer.alpha = 1.0;
		level.wave_timer.glowAlpha = 0.1;
		level.wave_timer.glowColor = (0, 1, 0);
		level.wave_timer.fontScale = 1.4;
		level.wave_timer.sort = 100;
		level.wave_timer.foreground = false;
		level.wave_timer.hideWhenInMenu = true;
	}

	game["dialog"]["gametype"] = "team_deathmtch";
}

onStartGameType()
{
	setClientNameMode("auto_change");

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"BTDZ_ELIM" );
	
	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"BTDZ_ELIM" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"BTDZ_ELIM_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"BTDZ_ELIM_HINT" );
			
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

	level.wave_timer setTimerUp( 1 );

	level thread check_start();
	wait 0.5;
	level thread grace_start();
	wait 0.5;
	level thread survival_start();
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
	level endon("game_ended");

	while(1)
	{
		level waittill("wave_end");

		level.canjoin = true;
		level.status = "grace";
		level notify("grace_start");

		while(!level.thereArePlayers)
		{ wait 1; }

		respawn();

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

		level.status = "play";
		level.canjoin = false;
		level notify("wave_start");		
	}
}

survival_start()
{
	// for grace before first waves
	level notify("wave_end");
	level endon("game_ended");

	// these are here so we dont get some stupid undefined errors
	num = 0;
	num_zoms = 0;
	wave_num_zoms = 0;
	spawn_interval = 1;
	count = 0;

	// for however many number of waves
	for(w =0; w < level.number_of_waves; w++)
	{
		level waittill("wave_start");
		level thread players();
		level thread zombies(); // Zod: While the intention is good, the functionality for this mode is not..
		level thread spec();
		level.boss = 0; // This is reset in _zombie_boss.gsc

		level.currentwave = w + 1;				

		zoms_left_to_do = 0;	

		// this is where we work out how many zombies are in a wave	

		// dynamicly based on number of players and the current wave number						
		if( level.wave_settings == 1 )
		{
			waveFactor = level.zom_dynamic_factor;
			players = getentarray("player","classname");									
			num = int (level.start_zoms + (players.size * (waveFactor + level.currentwave)) + (level.currentwave * (level.currentwave * (waveFactor / 2)))) ;					
			wave_num_zoms = num;			
		}
		else if( level.wave_settings == 2 ) // players can choose the number of zombies in a wave
		{
			num_zoms = level.surzoms_wave[level.currentwave];
			
			num = num_zoms;
			wave_num_zoms = num_zoms;
		}

		level.totalzomsinwave = num;
		level.wavetospawn = level.totalzomsinwave;

		///////////////////////////////////////////////////////////////////////////
		// Zod: Add the wave number to the number spawned for increasing difficulty
		scale = level.minzombies + level.currentwave;
		if( scale <= getdvarint("scr_elim_max_zoms") )
		{ level.maxzombies = scale; }
		///////////////////////////////////////////////////////////////////////////

		// Clamps the amount of zombies spawned to dvar btd_max_zoms
		if( level.maxzombies && num > level.maxzombies )
		{
			num = level.maxzombies;
			zoms_left_to_do = wave_num_zoms - num;
		}

		///////////////////////////////////////////////////////////////////////////
		//Zombie spawn speed
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
		///////////////////////////////////////////////////////////////////////////
		iPrintlnBold("^1" + wave_num_zoms + " ^2INCOMMING ^1ZOMBIES!!!");

		while(1)
		{
			// Spawn max zombies allowed at once
			for( i = 0; i < num; i++ )
			{
				level thread btd\_prob::choose();

				if( level.wavetospawn > 0 )
				{ level.wavetospawn = level.wavetospawn - 1; }

				wait spawn_interval;
			}

			if(zoms_left_to_do > 0)
			{
				while(level.maxzombies && level.zombies.size >= level.maxzombies - int(level.maxzombies / 3) )
				{ wait 0.05; }
			}
			else
			{ break; }

			num = level.maxzombies - level.zombies.size;
			zoms_left_to_do = zoms_left_to_do - num;
			if(zoms_left_to_do < 0)
			{ zoms_left_to_do = 0; }
		}

		while( level.zombies.size > 0 ) // stay here until theres 0 zoms left
		{ wait 0.5; }

		// Wave completed spawn the beast!
		if ( level.end_of_round_boss && level.zombies.size == 0 )
		{
			maps\mp\_utility::playSoundOnPlayers( "bossarrive", "allies" );
			iPrintlnBold("^1HERE COMES TROUBLE!");

			wait 2;

			for( i = 1; i <= level.boss_count; i++ )
			{
				boss = btd\_zombie_boss::spawn_bosszombie();
				boss thread btd\_pezbot_zombies::Connected();
				level.boss++;
			}
		}

		// Stay here until boss is killed.
		while(level.boss > 0)
		{ wait 0.5; }

		level notify("wave_end");	
		wait 2;
		iPrintlnBold("^1Zombie ^2attack wave ^1" + (w + 1) + " ^2has been defeated!");				
	}

	iPrintlnBold("^2Well done, ^1zombies ^2sent back to ^1hell!");

	wait 5;
	thread maps\mp\gametypes\_globallogic::endGame("allies", "^1The zombies have been defeated!");	
}

getBossCount()
{
	players = getentarray("player","classname");
	alive = 0;
	count = 1;

	for( p = 0; p < players.size; p++ )
	{
		if( isAlive( players[p] ) || players[p].sessionstate == "playing" )
		{ alive++; }
	}

	if( alive <= 5 )
	{ count = 3; }
	else if( alive > 5 && alive <= 10 )
	{ count = 6; }
	else if( alive > 10 )
	{ count = 12; }

	return( count );
}

respawn()
{
	level endon("wave_end");
	level endon("game_ended");

	players = getentarray("player","classname");
	for( p = 0; p < players.size; p++ )
	{
		if( players[p].pers["team"] == "spectator" )
		{ continue; }

		players[p].pers["lives"] = level.numLives + players[p].pers["extra_lives"];
		if( players[p].respawnedInSpec == true )
		{
			players[p].respawnedInSpec = false;
			if( !isAlive( players[p] ) || players[p].sessionstate != "playing" )
			{
				players[p] thread maps\mp\gametypes\_globallogic::spawnPlayer();
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
				if( ( players[p].sessionstate == "playing" && players[p].team == "allies" ) || players[p] maps\mp\gametypes\_globallogic::maySpawn() )
				{ playersAlive = true; }
			}
			wait 0.1;
		}

		if ( playersAlive == false )
		{
			iPrintlnBold("^1The zombies have eaten all of us!");
			wait 5;
			thread maps\mp\gametypes\_globallogic::endGame("axis", "^1The humans have been eliminated!");
			return;
		}

		wait 1;
	}
}

zombies()
{
	level endon("game_ended");
	level endon("wave_end");

	num1 = 0;
	num2 = 0;

	while(1)
	{
		zombies = getentarray("zom","targetname");
		if( zombies.size <= 10 && level.wavetospawn == 0 )
		{
			num1 = zombies.size;

			wait 45;

			num2 = zombies.size;

			if( num1 == num2 )
			{
				if ( isDefined(level.zombies[0]) )
				{
					if( level.zombies[0].isNormalzom != true )
					{
						level.zombies[0].wasbugged = true;
						level.zombies[0] notify("damage", level.zombies[0].maxhealth, undefined, (0,1,0), level.zombies[0].origin, "MOD_SUICIDE", "", "", "", 1);
						iprintln("^0[^1BTDz^0] ^7- Zombie Removed By Mod!");
					}
				}
			}
		}
		wait 5;
	}
}

spec()
{
	level endon("game_ended");
	level endon("wave_end");

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
