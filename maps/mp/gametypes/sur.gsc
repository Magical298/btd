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

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( "sur", 666, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( "sur", 0, 0, 5000 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( "sur", 1, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( "sur", 2, 0, 10 );

	level.zombies = [];
	level.zomspawns = [];
	level.canjoin = true;
	level.currentspawnnum = 0;
	level.wavetospawn = 0;
	level.currentwave = 0;
	level.totalzomsinwave = 0;
	level.active = false;
	level.boss = false;

	level.number_of_waves = dvarIntValue( "num_waves", 6, 1, 10 ); //scr_sur_num_waves
	level.sur_wave_time = dvarIntValue( "wave_time", 300, 120, 1800 ); //scr_sur_wave_time
	level.sur_time_multi = dvarFloatValue( "time_multiplier", 1.25, 1, 2 ); //scr_sur_time_multiplier
	level.end_of_round_boss = dvarIntValue( "end_boss", 1, 0, 1 ); //scr_sur_end_boss
	level.boss_count = dvarIntValue( "end_boss_count", 1, 1, 10 ); //scr_sur_end_boss_count
	level.grace_time = dvarIntValue( "grace_time", 80, 10, 300 ); //scr_sur_grace_time
	level.maxzombies = dvarIntValue( "max_zoms", 32, 10, 100 ); //scr_sur_max_zoms
	level.minzombies = dvarIntValue( "min_zoms", 26, 1, 100 ); //scr_sur_min_zoms
	level.zom_spawn_delay = dvarFloatValue( "zom_spawn_delay", 0.5, 0.05, 5 ); //scr_sur_zom_spawn_delay
	level.zom_spawn_delay_auto = dvarIntValue( "zom_delay_auto", 1, 0, 1 ); //scr_sur_zom_delay_auto
	level.zom_point_scale = dvarIntValue( "point_scale", 1, 0, 100 ); //scr_sur_point_scale

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
		level.wave_timerText setText("Time Left:");

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

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"BTDZ_SUR" );
	
	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"BTDZ_SUR" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"BTDZ_SUR_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"BTDZ_SUR_HINT" );
			
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
	
	// elimination style
	if ( level.roundLimit != 1 && level.numLives )
	{
		level.overrideTeamScore = true;
		level.displayRoundEndText = true;
		level.onEndGame = ::onEndGame;
	}

	if( level.ammo_chopper == 1 || level.traderon == 1 )
	{
		if(level.grace_time < 75)
		{ level.grace_time = 75; }
	}

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

		level.wave_timer setTimer( level.grace_time + 10 );

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

	num_zoms = 0;
	spawn_interval = 1;

	// for however many number of waves
	for(w =0 ;w < level.number_of_waves; w++)
	{
		level waittill("wave_start");

		iPrintlnBold("^2INCOMMING ^1ZOMBIES ^2for ^3" + (level.sur_wave_time / 60) + " ^2minutes!");

		level thread players();
		level thread spec();
		level thread wavetimer();
		level.sur_wave_time = int(level.sur_wave_time * level.sur_time_multi); // Multiplier
		level.currentwave = w + 1;
		level.boss = 0; // This is reset in _zombie_boss.gsc

		///////////////////////////////////////////////////////////////////////////
		// Zod: Add the wave number to the number spawned for increasing difficulty
		scale = level.minzombies + level.currentwave;
		if( scale <= getdvarint("scr_sur_max_zoms") )
		{ level.maxzombies = scale; }
		///////////////////////////////////////////////////////////////////////////

		while(level.active) // stay here until wave timer is up
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

		// Cleanup any zombies leftover after time limit.
		zombies = getentarray("zom","targetname");
		for (i = 0; i < zombies.size; i++)
		{
			if( isDefined( zombies[i] ) )
			{
				zombies[i] notify("damage", zombies[i].maxhealth + 1, undefined, (0,1,0), zombies[i].origin, "MOD_SUICIDE", "", "", "", 1);
			}
			wait( 0.05 );
		}

		// Wave completed spawn the beast or if the case may be, beasts!
		zombies = getentarray("zom","targetname");
		if( level.end_of_round_boss && zombies.size == 0 )
		{
			maps\mp\_utility::playSoundOnPlayers( "bossarrive", "allies" );
			iPrintlnBold("^1HERE COMES TROUBLE!");

			wait 2;

			level.wave_timer setTimerUp( 1 );

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

	thread maps\mp\gametypes\_globallogic::endGame("allies", "The zombies have been defeated!");	
}

respawn()
{
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
			thread maps\mp\gametypes\_globallogic::endGame("axis", "The humans have been defeated!");
			return;
		}

		wait 1;
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

wavetimer()
{
	level endon("game_ended");

	level.active = true;
	level.wave_timer setTimer( level.sur_wave_time );

	wait( level.sur_wave_time );

	level.active = false;
}

onEndGame( winningTeam )
{
	if ( isdefined( winningTeam ) && (winningTeam == "allies" || winningTeam == "axis") )
		[[level._setTeamScore]]( winningTeam, [[level._getTeamScore]]( winningTeam ) + 1 );	
}
