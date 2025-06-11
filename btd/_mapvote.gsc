/***********************************************************************************************************
 MAP VOTE PACKAGE
 ORIGINALLY MADE BY NC-17 (codam, powerserver), REWORKED BY wizard220, MODIFIED BY FrAnCkY55, Modified again by bell, 
 
 Modified again by 0ddball
 
 Ported over to COD4 by Tally and Marc ( Wildcard - Marc did most of the new Array code )
***********************************************************************************************************/
#include btd\_dvardef;

init()
{
	level.btd_mapvote	= createdvar("btd_map_vote", 1, 0, 1, "int");
	level.btd_mapvotetime = createdvar("btd_mapvote_time", 20, 10, 180, "int");
	level.btd_mapvotereplay	= createdvar("btd_map_vote_replay", 0, 0, 1,"int");

	// Map voting
	if( !level.btd_mapvote )
		return;

	// Setup strings
	level.mapvotetext["MapVote"] = &"Press ^2FIRE^7 to vote";
	level.mapvotetext["TimeLeft"] = &"Time Left: ";
	level.mapvotetext["MapVoteHeader"] = &"Next Map Vote";

	// Precache stuff used by map voting
	precacheString(level.mapvotetext["MapVote"]);
	precacheString(level.mapvotetext["TimeLeft"]);
	precacheString(level.mapvotetext["MapVoteHeader"]);
}

Initialise()
{
	if(!level.btd_mapvote)
		return;

	level.btd_mapvotehudoffset = -7;

	// Small wait
	wait .5;

	// Create HUD
	CreateHud();

	// Start mapvote thread	
	thread RunMapVote();

	// Wait for voting to finish
	level waittill("VotingComplete");

	// Delete HUD
	DeleteHud();
}


CreateHud()
{
	// top line
	level.MapVoteHud[0] = newHudElem();
	level.MapVoteHud[0].hideWhenInMenu = true;
	level.MapVoteHud[0].alignX = "center";
	level.MapVoteHud[0].x = 320;
	level.MapVoteHud[0].y = 55;
	level.MapVoteHud[0].alpha = 0.3;
	level.MapVoteHud[0].sort = 9994;
	level.MapVoteHud[0] setShader("white", 318, 2);
	level.MapVoteHud[0].horzAlign = "fullscreen";
	level.MapVoteHud[0].vertAlign = "fullscreen";

	// mid line
	level.MapVoteHud[1] = newHudElem();
	level.MapVoteHud[1].hideWhenInMenu = true;
	level.MapVoteHud[1].alignX = "center";
	level.MapVoteHud[1].x = 320;
	level.MapVoteHud[1].y = 188;
	level.MapVoteHud[1].alpha = 0.3;
	level.MapVoteHud[1].sort = 9994;
	level.MapVoteHud[1] setShader("white", 318, 2);
	level.MapVoteHud[1].horzAlign = "fullscreen";
	level.MapVoteHud[1].vertAlign = "fullscreen";

	// btm line
	level.MapVoteHud[2] = newHudElem();
	level.MapVoteHud[2].hideWhenInMenu = true;
	level.MapVoteHud[2].alignX = "center";
	level.MapVoteHud[2].x = 320;
	level.MapVoteHud[2].y = 213;
	level.MapVoteHud[2].alpha = 0.3;
	level.MapVoteHud[2].sort = 9994;
	level.MapVoteHud[2] setShader("white", 318, 2);
	level.MapVoteHud[2].horzAlign = "fullscreen";
	level.MapVoteHud[2].vertAlign = "fullscreen";

	// background
	level.MapVoteHud[7] = newHudElem();
	level.MapVoteHud[7].hideWhenInMenu = true;
	level.MapVoteHud[7].alignX = "center";
	level.MapVoteHud[7].x = 320;
	level.MapVoteHud[7].y = 53;
	level.MapVoteHud[7].alpha = 0.7;
	level.MapVoteHud[7].color = (0,0,0);
	level.MapVoteHud[7].sort = 9993;
	level.MapVoteHud[7] setShader("white", 326, 164);
	level.MapVoteHud[7].horzAlign = "fullscreen";
	level.MapVoteHud[7].vertAlign = "fullscreen";

	// left line
	level.MapVoteHud[3] = newHudElem();
	level.MapVoteHud[3].hideWhenInMenu = true;
	level.MapVoteHud[3].alignX = "center";
	level.MapVoteHud[3].x = 160;
	level.MapVoteHud[3].y = 55;
	level.MapVoteHud[3].alpha = 0.3;
	level.MapVoteHud[3].sort = 9994;
	level.MapVoteHud[3] setShader("white", 2, 160);
	level.MapVoteHud[3].horzAlign = "fullscreen";
	level.MapVoteHud[3].vertAlign = "fullscreen";

	// right line
	level.MapVoteHud[4] = newHudElem();
	level.MapVoteHud[4].hideWhenInMenu = true;
	level.MapVoteHud[4].alignX = "center";
	level.MapVoteHud[4].x = 480;
	level.MapVoteHud[4].y = 55;
	level.MapVoteHud[4].alpha = 0.3;
	level.MapVoteHud[4].sort = 9994;
	level.MapVoteHud[4] setShader("white", 2, 160);
	level.MapVoteHud[4].horzAlign = "fullscreen";
	level.MapVoteHud[4].vertAlign = "fullscreen";

	// header
	level.MapVoteHud[5] = newHudElem();
	level.MapVoteHud[5].hideWhenInMenu = true;
	level.MapVoteHud[5].x = 200;
	level.MapVoteHud[5].y = 193;
	level.MapVoteHud[5].alpha = 1;
	level.MapVoteHud[5].fontscale = 1.4;
	level.MapVoteHud[5].sort = 9994;
	level.MapVoteHud[5] setText("Press ^2FIRE^7 to vote");
	level.MapVoteHud[5].horzAlign = "fullscreen";
	level.MapVoteHud[5].vertAlign = "fullscreen";

	// time
	level.MapVoteHud[6] = newHudElem();
	level.MapVoteHud[6].hideWhenInMenu = true;
	level.MapVoteHud[6].alignX = "right";
	level.MapVoteHud[6].x = 465;
	level.MapVoteHud[6].y = 193;
	level.MapVoteHud[6].alpha = 1;
	level.MapVoteHud[6].color = (0,1,0);
	level.MapVoteHud[6].fontscale = 1.4;
	level.MapVoteHud[6].sort = 9994;
	level.MapVoteHud[6].label = level.mapvotetext["TimeLeft"];
	level.MapVoteHud[6] setValue(level.btd_mapvotetime);
	level.MapVoteHud[6].horzAlign = "fullscreen";
	level.MapVoteHud[6].vertAlign = "fullscreen";

	// choice of maps/gametypes
	level.MapVoteNames[0] = newHudElem();
	level.MapVoteNames[1] = newHudElem();
	level.MapVoteNames[2] = newHudElem();
	level.MapVoteNames[3] = newHudElem();
	level.MapVoteNames[4] = newHudElem();
	level.MapVoteNames[5] = newHudElem();
	level.MapVoteNames[6] = newHudElem();

	// values for each selection
	level.MapVoteVotes[0] = newHudElem();
	level.MapVoteVotes[1] = newHudElem();
	level.MapVoteVotes[2] = newHudElem();
	level.MapVoteVotes[3] = newHudElem();
	level.MapVoteVotes[4] = newHudElem();
	level.MapVoteVotes[5] = newHudElem();
	level.MapVoteVotes[6] = newHudElem();

	yPos = 62;
	for (i = 0; i < level.MapVoteNames.size; i++)
	{
		level.MapVoteNames[i].archived = false;
		level.MapVoteNames[i].hideWhenInMenu = true;
		level.MapVoteNames[i].x = 200;
		level.MapVoteNames[i].y = yPos;
		level.MapVoteNames[i].alpha = 1;
		level.MapVoteNames[i].sort = 9995;
		level.MapVoteNames[i].fontscale = 1.4;
		level.MapVoteNames[i].horzAlign = "fullscreen";
		level.MapVoteNames[i].vertAlign = "fullscreen";
		//
		level.MapVoteVotes[i].archived = false;
		level.MapVoteVotes[i].hideWhenInMenu = true;
		level.MapVoteVotes[i].alignX = "right";
		level.MapVoteVotes[i].x = 465;
		level.MapVoteVotes[i].y = yPos;
		level.MapVoteVotes[i].alpha = 1;
		level.MapVoteVotes[i].sort = 9996;
		level.MapVoteVotes[i].fontscale = 1.4;
		level.MapVoteVotes[i].horzAlign = "fullscreen";
		level.MapVoteVotes[i].vertAlign = "fullscreen";
		//
		yPos += 17;

		wait 0.05;
	}
}

RunMapVote()
{
	maps = undefined;
	x = undefined;

	currentgt = getDvar("g_gametype");
	currentmap = getdvar("mapname");
 
	if(getdvar ("btd_map_vote_gametypes") != "")
	{ x = GetRandomMapVoteRotation(); }
	else
	{ x = btd\_utils::GetRandomMapRotation(); }
				
	if(isdefined(x))
	{
		if(isdefined(x.maps))
			maps = x.maps;

		x delete();
	}

	// Any maps?
	if(!isdefined(maps))
	{
		wait 0.05;
		level notify("VotingComplete");
		return;
	}

	// Fill all alternatives with the current map in case there is not enough unique maps
	for(j=0;j<7;j++)
	{
		level.mapcandidate[j]["map"] = currentmap;
		level.mapcandidate[j]["mapname"] = "Replay this map";
		level.mapcandidate[j]["gametype"] = currentgt;
		level.mapcandidate[j]["votes"] = 0;
	}
	
	//get candidates
	i = 0;
	for(j=0;j<7;j++)
	{
		// Skip current map and gametype combination
		if(maps[i]["map"] == currentmap && maps[i]["gametype"] == currentgt)
			i++;

		// Any maps left?
		if(!isdefined(maps[i]))
			break;

		level.mapcandidate[j]["map"] = maps[i]["map"];
		level.mapcandidate[j]["mapname"] = btd\_utils::getMapName(maps[i]["map"]);
		level.mapcandidate[j]["gametype"] = maps[i]["gametype"];
		level.mapcandidate[j]["votes"] = 0;

		i++;

		// Any maps left?
		if(!isdefined(maps[i]))
			break;

		// Keep current map as last alternative?
		if(level.btd_mapvotereplay && j>4)
			break;
	}
	
	thread DisplayMapChoices();
	
	game["menu_team"] = "";

	//start a voting thread per player
	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		players[i] thread PlayerVote();
	
	thread VoteLogic();	
}

DeleteHud()
{
	level.MapVoteHud[0] destroy();
	level.MapVoteHud[1] destroy();
	level.MapVoteHud[2] destroy();
	level.MapVoteHud[3] destroy();
	level.MapVoteHud[4] destroy();
	level.MapVoteHud[5] destroy();
	level.MapVoteHud[6] destroy();
	level.MapVoteHud[7] destroy();

	level.MapVoteNames[0] destroy();
	level.MapVoteNames[1] destroy();
	level.MapVoteNames[2] destroy();
	level.MapVoteNames[3] destroy();
	level.MapVoteNames[4] destroy();
	level.MapVoteNames[5] destroy();
	level.MapVoteNames[6] destroy();

	level.MapVoteVotes[0] destroy();
	level.MapVoteVotes[1] destroy();
	level.MapVoteVotes[2] destroy();
	level.MapVoteVotes[3] destroy();	
	level.MapVoteVotes[4] destroy();
	level.MapVoteVotes[5] destroy();
	level.MapVoteVotes[6] destroy();

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
		if(isdefined(players[i].vote_indicator))
			players[i].vote_indicator destroy();
}

//Displays the map candidates
DisplayMapChoices()
{
	level endon("VotingDone");

	for( i = 0; i < level.MapVoteNames.size; i++ )
	{
		if( isDefined(level.mapcandidate[i]) )
		{
			if( isDefined(level.mapcandidate[i]["gametype"]) )
			{
				level.MapVoteNames[i] setText( level.mapcandidate[i]["mapname"] + " (" + btd\_utils::GetGametypeName(level.mapcandidate[i]["gametype"]) +")" );
				iprintlnbold(" ");
				//iprintlnbold(level.mapcandidate[i]["mapname"] + " (" + level.mapcandidate[i]["gametype"] +")");
			}
			else
			{
				level.MapVoteNames[i] setText(level.mapcandidate[i]["mapname"]);
				iprintlnbold(" ");
				//iprintlnbold(level.mapcandidate[i]["mapname"]);
			}
		}
		wait 0.05;
	}
}

//Changes the players vote as he hits the attack button and updates HUD
PlayerVote()
{
	level endon( "VotingDone" );
	self endon( "disconnect" );
	self notify( "reset_outcome" );

	novote = false;
	
	// No voting for spectators
	if( self.pers["team"] == "spectator" )
		novote = true;

	// Spawn player as spectator
	self maps\mp\gametypes\_globallogic::spawnSpectator();
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	resettimeout();
	
	//remove the scoreboard
	self setClientdvar("g_scriptMainMenu", "");
	self closeMenu();

	self allowSpectateTeam( "allies", false );
	self allowSpectateTeam( "axis", false );
	self allowSpectateTeam( "freelook", false );
	self allowSpectateTeam( "none", true );

	if( novote )
		return;

	colors[0] = (0,   0,  1);
	colors[1] = (0, 0.5,  1);
	colors[2] = (0,   1,  1);
	colors[3] = (0,   1,0.5);
	colors[4] = (0,   1,  0);
	colors[5] = (1,   0,  1);
	colors[6] = (1, 0.5,  1);
	
	self.vote_indicator = newClientHudElem( self );
	self.vote_indicator.alignY = "middle";
	self.vote_indicator.x = 161;
	self.vote_indicator.y = level.btd_mapvotehudoffset + 60;
	self.vote_indicator.archived = false;
	self.vote_indicator.sort = 9997;
	self.vote_indicator.alpha = 0;
	self.vote_indicator.color = colors[0];
	self.vote_indicator setShader("white", 318, 17);
	
	hasVoted = false;

	for(;;)
	{
		wait .01;

		if(self attackButtonPressed() == true)
		{
			// -- Added by Number7 --
			if(!hasVoted)
			{
				self.vote_indicator.alpha = .3;
				self.votechoice = 0;
				hasVoted = true;
			}
			else
				self.votechoice++;

			if (self.votechoice == 7)
				self.votechoice = 0;

			self iprintln("You have voted for ^3" + btd\_utils::GetGametypeName(level.mapcandidate[self.votechoice]["gametype"]) + " ^4" + level.mapcandidate[self.votechoice]["mapname"]);
			self.vote_indicator.y = 70 + self.votechoice * 17;			
			self.vote_indicator.color = colors[self.votechoice];

			self playLocalSound("ui_mp_timer_countdown");
		}					
		while(self attackButtonPressed() == true)
			wait.01;

		self.sessionstate = "spectator";
		self.spectatorclient = -1;
	}
}

//Determines winning map and sets rotation
VoteLogic()
{
	//Vote Timer
	for ( ; level.btd_mapvotetime >= 0; level.btd_mapvotetime--)
	{
		for(j=0;j<10;j++)
		{
			// Count votes
			for(i=0;i<7;i++)	level.mapcandidate[i]["votes"] = 0;
			players = getentarray("player", "classname");
			for(i = 0; i < players.size; i++)
				if(isdefined(players[i].votechoice))
					level.mapcandidate[players[i].votechoice]["votes"]++;

			// Update HUD
			level.MapVoteVotes[0] setValue( level.mapcandidate[0]["votes"] );
			level.MapVoteVotes[1] setValue( level.mapcandidate[1]["votes"] );
			level.MapVoteVotes[2] setValue( level.mapcandidate[2]["votes"] );
			level.MapVoteVotes[3] setValue( level.mapcandidate[3]["votes"] );
			level.MapVoteVotes[4] setValue( level.mapcandidate[4]["votes"] );
			level.MapVoteVotes[5] setValue( level.mapcandidate[5]["votes"] );
			level.MapVoteVotes[6] setValue( level.mapcandidate[6]["votes"] );
			wait .1;
		}
		
		level.MapVoteHud[6] setValue( level.btd_mapvotetime );
	}	

	wait 0.2;
	
	newmapnum = 0;
	topvotes = 0;
	for(i=0;i<7;i++)
	{
		if (level.mapcandidate[i]["votes"] > topvotes)
		{
			newmapnum = i;
			topvotes = level.mapcandidate[i]["votes"];
		}
	}

	SetMapWinner(newmapnum);
}

//change the map rotation to represent the current selection
SetMapWinner(winner)
{
	map		= level.mapcandidate[winner]["map"];
	mapname	= level.mapcandidate[winner]["mapname"];
	gametype	= level.mapcandidate[winner]["gametype"];

	setdvar("sv_maprotationcurrent", " gametype " + gametype + " map " + map);

	wait 0.1;

	// Stop threads
	level notify( "VotingDone" );

	// Wait for threads to die
	wait 0.05;

	// Announce winner
	iprintlnbold("^3The Next Map Is");
	iprintlnbold("^2" + mapname);
	iprintlnbold("^2" + btd\_utils::GetGametypeName(gametype));

	// Fade HUD elements
	level.MapVoteHud[0] fadeOverTime (1);
	level.MapVoteHud[1] fadeOverTime (1);
	level.MapVoteHud[2] fadeOverTime (1);
	level.MapVoteHud[3] fadeOverTime (1);
	level.MapVoteHud[4] fadeOverTime (1);
	level.MapVoteHud[5] fadeOverTime (1);
	level.MapVoteHud[6] fadeOverTime (1);
	level.MapVoteHud[7] fadeOverTime (1);
	level.MapVoteNames[0] fadeOverTime (1);
	level.MapVoteNames[1] fadeOverTime (1);
	level.MapVoteNames[2] fadeOverTime (1);
	level.MapVoteNames[3] fadeOverTime (1);
	level.MapVoteNames[4] fadeOverTime (1);
	level.MapVoteNames[5] fadeOverTime (1);
	level.MapVoteNames[6] fadeOverTime (1);
	level.MapVoteVotes[0] fadeOverTime (1);
	level.MapVoteVotes[1] fadeOverTime (1);
	level.MapVoteVotes[2] fadeOverTime (1);
	level.MapVoteVotes[3] fadeOverTime (1);	
	level.MapVoteVotes[4] fadeOverTime (1);
	level.MapVoteVotes[5] fadeOverTime (1);
	level.MapVoteVotes[6] fadeOverTime (1);

	level.MapVoteHud[0].alpha = 0;
	level.MapVoteHud[1].alpha = 0;
	level.MapVoteHud[2].alpha = 0;
	level.MapVoteHud[3].alpha = 0;
	level.MapVoteHud[4].alpha = 0;
	level.MapVoteHud[5].alpha = 0;
	level.MapVoteHud[6].alpha = 0;
	level.MapVoteHud[7].alpha = 0;
	level.MapVoteNames[0].alpha = 0;
	level.MapVoteNames[1].alpha = 0;
	level.MapVoteNames[2].alpha = 0;
	level.MapVoteNames[3].alpha = 0;
	level.MapVoteNames[4].alpha = 0;
	level.MapVoteNames[5].alpha = 0;
	level.MapVoteNames[6].alpha = 0;
	level.MapVoteVotes[0].alpha = 0;
	level.MapVoteVotes[1].alpha = 0;
	level.MapVoteVotes[2].alpha = 0;
	level.MapVoteVotes[3].alpha = 0;	
	level.MapVoteVotes[4].alpha = 0;
	level.MapVoteVotes[5].alpha = 0;
	level.MapVoteVotes[6].alpha = 0;

	players = getentarray("player", "classname");
	for(i = 0; i < players.size; i++)
	{
		if(isdefined(players[i].vote_indicator))
		{
			players[i].vote_indicator fadeOverTime (1);
			players[i].vote_indicator.alpha = 0;
		}
	}

	// Show winning map for a few seconds
	wait 4;
	level notify( "VotingComplete" );
}

GetRandomMapVoteRotation()
{
	gtrotstr = getdvar("btd_map_vote_gametypes");
	gtrot_array = listOfStringsToArray(gtrotstr);
	
	// Spawn entity to hold the array
	x = spawn("script_origin",(0,0,0));
	x.maps = [];
	z=0;
		
	for (i=0; i<gtrot_array.size; i++)
	{
		gt=gtrot_array[i];
		gtmaprotstr = getdvar("btd_map_vote_" + gt + "_maps");
		if(isdefined(gtmaprotstr))
		{
			gtmaprot = listOfStringsToArray(gtmaprotstr);
		  
			for(j=0; j<gtmaprot.size; j++)
			{
				x.maps[z]["gametype"] = gt ;
				x.maps[z]["map"] = gtmaprot[j];
				z++;
			}
		}
	}

	// Shuffle the array 20 times
	for(k = 0; k < 20; k++)
	{
		for(i = 0; i < x.maps.size; i++)
		{
			j = randomInt(x.maps.size);
			element = x.maps[i];
			x.maps[i] = x.maps[j];
			x.maps[j] = element;
		}
	}


	return x;
}

listOfStringsToArray(list)
{
	list = btd\_utils::strip(list);

	j=0;
	temparr2[j] = "";	
	for(i=0;i<list.size;i++)
	{
		if(list[i]==" ")
		{
			j++;
			temparr2[j] = "";
		}
		else
			temparr2[j] += list[i];
	}

	// Remove empty elements (double spaces)
	temparr = [];
	for(i=0;i<temparr2.size;i++)
	{
		element = btd\_utils::strip(temparr2[i]);
		if(element != "")
		{
		//	if(level.awe_debug) iprintln("list" + temparr.size + ":" + element);
			temparr[temparr.size] = element;
		}
	}
	return temparr;
}


