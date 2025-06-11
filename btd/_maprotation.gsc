#include btd\_dvardef;

init()
{
	// Fix corrupt maprotations
	level.btd_fixmaprotation = createdvar("btd_fix_maprotation",0,0,1,"int");

	// Use random maprotation?
	level.btd_randommaprotation = createdvar("btd_random_maprotation",0,0,1,"int");

	// Rotate map if server is empty?
	level.rotateifempty = createdvar("btd_rotate_empty_map",5,0,10,"int");

	// Fallback gametype and map in case of incompatibility
	level.btd_fallbackgametypemap = createdvar("btd_fallback_gametype_map","elim mp_backlot","","","string");

	// Fix corrupt maprotations
	FixMapRotation();

	thread StartThreads();
}

StartThreads()
{
	wait .05;
	level endon("btd_killthreads");

	// Do maprotation randomization
	thread RandomMapRotation();

	// Start thread that rotates map if server is empty
	if(level.rotateifempty)
	{ thread RotateIfEmpty(); }
}

RandomMapRotation()
{
	level endon("btd_killthreads");

	// Do random maprotation?
	if(!level.btd_randommaprotation || level.btd_mapvote)
		return;

	// Randomize maps of maprotationcurrent is empty or on a fresh start
	if( btd\_utils::strip(getdvar("sv_maprotationcurrent")) == "" || level.btd_randommaprotation == 1)
	{
		maps = undefined;
		x = btd\_utils::GetRandomMapRotation();
		if(isdefined(x))
		{
			if(isdefined(x.maps))
				maps = x.maps;
			x delete();
		}

		if(!isdefined(maps) || !maps.size)
			return;
			
		lastgt = "";
		lastexec = "";

		// Build new maprotation string
		newmaprotation = "";
		for(i = 0; i < maps.size; i++)
		{
			if(!isdefined(maps[i]["exec"]) || lastexec == maps[i]["exec"])
				exec = "";
			else
			{
				lastexec = maps[i]["exec"];
				exec = " exec " + maps[i]["exec"];
			}

			if(!isdefined(maps[i]["gametype"]) || lastgt == maps[i]["gametype"])
				gametype = "";
			else
			{
				lastgt = maps[i]["gametype"];
				gametype = " gametype " + maps[i]["gametype"];	
			}
			
			temp = exec + gametype + " map " + maps[i]["map"];
			if( (newmaprotation.size + temp.size)>975)
			{
				iprintlnbold("Maprotation: ^1Limiting sv_maprotation to avoid server crash! String1 size:" + newmaprotation.size + " String2 size:" + temp.size);
				break;
			}
			newmaprotation += temp;
		}

		// Set the new rotation
		setdvar("sv_maprotationcurrent", newmaprotation);

		// Set awe_random_maprotation to "2" to indicate that initial randomizing is done
		setdvar("btd_random_maprotation", "2");
	}
}

FixMapRotation()
{
	if(!level.btd_fixmaprotation || level.btd_mapvote)
		return;

	maps = undefined;
	x = btd\_utils::GetPlainMapRotation();
	if(isdefined(x))
	{
		if(isdefined(x.maps))
			maps = x.maps;
		x delete();
	}

	if(!isdefined(maps) || !maps.size)
		return;

	// Build new maprotation string
	newmaprotation = "";
	newmaprotationcurrent = "";
	for(i = 0; i < maps.size; i++)
	{
		if(!isdefined(maps[i]["exec"]))
			exec = "";
		else
			exec = " exec " + maps[i]["exec"];

		if(!isdefined(maps[i]["gametype"]))
			gametype = "";
		else
			gametype = " gametype " + maps[i]["gametype"];

		temp = exec + gametype + " map " + maps[i]["map"];
		if( (newmaprotation.size + temp.size)>975)
		{
			break;
		}
		newmaprotation += temp;

		if(i>0)
			newmaprotationcurrent += exec + gametype + " map " + maps[i]["map"];
	}

	// Set the new rotation
	setdvar("sv_maprotation", btd\_utils::strip(newmaprotation));

	// Set the new rotationcurrent
	setdvar("sv_maprotationcurrent", newmaprotationcurrent);

	// Set btd_fix_maprotation to "0" to indicate that initial fixing has been done
	setdvar("btd_fix_maprotation", "0");
}

RotateIfEmpty()
{
	server_emptytime = 0;
	
	if(level.rotateifempty > 0)
	{
		while(server_emptytime < level.rotateifempty)
		{
			wait 60;
			num_players = 0;
			players = getentarray("player", "classname");
			
			for(i = 0; i < players.size; i++)
			{
				if(isdefined(players[i]) && isPlayer(players[i]) && players[i].sessionstate == "playing")
				{
					num_players++; 
				}
			}

			// Need at least 1 playing clients			
			if(num_players >= 1)
			{
				server_emptytime = 0;
			}
			else
			{
				server_emptytime ++;
			}
		}

		setdvar("g_gametype", level.gametype); // Restore gametype in case we are pretending
		exitLevel(false);
	}
}
