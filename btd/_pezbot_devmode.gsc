main()
{
	// start in dev mode
	if(level.btd_devmode != 0)
	{
		setDvar("g_gametype", "war");
		setDvar("scr_war_scorelimit", 0);
		setDvar("scr_war_timelimit", 0);
		setdvar("svr_pezbots_drawdebug", 1);		

		level thread btd\_pezbot_devmode::StartDev();

		wait 1; // so all arrays can initialize

		if(level.btd_devmode == 1) // waypoints
		{
			level thread DrawStaticWaypoints();
			level thread DrawZombieSpawns();	
			level thread btd\_pezbot_devmode_hud::devhud_waypoints();
		}

		if(level.btd_devmode == 2) // zombie spawns
		{
			level thread DrawZombieSpawns();
			level thread DrawStaticWaypoints();
			level thread btd\_pezbot_devmode_hud::devhud_ZombieSpawns();
		}

		if(level.btd_devmode == 3) // trader location
		{
			level thread DrawTradeSpawns();
			level thread btd\_pezbot_devmode_hud::devhud_TradeSpawns();
		}

		if(level.btd_devmode == 4) // chopper drop locations
		{
			level thread DrawChopperSpawns();
			level thread btd\_pezbot_devmode_hud::devhud_ChopperSpawns();
		}

		if(level.btd_devmode == 5) // custom pickup location
		{
			level thread DrawPickupSpawns();
			level thread btd\_pezbot_devmode_hud::devhud_PickupSpawns();
		}

		if(level.btd_devmode == 6) // anticamp teleports
		{
			level thread DrawTeleport();
			level thread DrawGoTo();
			level thread btd\_pezbot_devmode_hud::devhud_anticampSpawns();
		}

		if(level.btd_devmode == 7) // player spawns
		{
			level thread DrawPlayerSpawns();
			level thread DrawZombieSpawns();
			level thread DrawStaticWaypoints();
			level thread btd\_pezbot_devmode_hud::devhud_playerspawns();
		}
/*
		if(level.btd_devmode == 8) // zombie teleporters
		{
			level thread DrawZombieTeles();
			level thread DrawStaticWaypoints();
			level thread btd\_pezbot_devmode_hud::devhud_zombietele();
		}
*/
	}
	else
	{
		//level.status = "postgame";
		setdvar("svr_pezbots_drawdebug", 0);
	}
}

////////////////////////////////////////////////////////////
// Start in dev mode 
///////////////////////////////////////////////////////////
StartDev()
{
	if( !isDefined( level.waypoints ) )
	{
		level.waypointCount = 0;
		level.waypoints = [];
	}

	if( !isDefined( level.zomspawns ) )
	{
		level.zomspawns = [];
		level.zomSpawnCount = 0;
		level.zomSpawnPoint = [];
	}
	else
	{
		// Show what is already placed so we can edit them
		level.zomSpawnCount = level.zomspawns.size;
		level.zomSpawnPoint = [];
		for(i = 0; i < level.zomspawns.size; i++)
		{
			level.zomSpawnPoint[i] = level.zomspawns[i];
		}
	}

	if( !isDefined( level.tradeSpawns ) )
	{
		level.tradeSpawnCount = 0;
		level.tradeSpawns = [];
	}

	if( !isDefined( level.chopperSpawnCount ) )
	{
		level.chopperSpawnCount = 0;
		level.chopperSpawns = [];
	}

	if( !isDefined( level.pickupSpawns ) )
	{
		level.pickupSpawnCount = 0;
		level.pickupSpawns = [];
	}
	else
	{
		level.pickupSpawnCount = level.newpickupspawns.size;
		level.pickupSpawns = [];
		for(i = 0; i < level.newpickupspawns.size; i++)
		{
			level.pickupSpawns[i] = level.newpickupspawns[i];
		}
	}

	if( !isDefined( level.playerSpawns ) )
	{
		level.playerSpawnCount = 0;
		level.playerSpawns = [];
	}

	level.trigCount = 0;
	level.teleports = [];
	level.gotoCount = 0;
	level.goto = [];
	level.gotoStart = 0;

	level.zomtelesCount = 0;
	level.zomteles = [];
	level.zomgotoCount = 0;
	level.zomgoto = [];
	level.zomgotoStart = 0;


	level.wpToLink = -1;
	level.linkSpamTimer = gettime();
	level.saveSpamTimer = gettime();

	wait 10;

	iPrintlnBold("^0[^1BTD^0] ^5Developer Mode Activated");

	while(1)
	{
		level.playerPos = level.players[0].origin;
		level.playerAngles = level.players[0] GetPlayerAngles();

		switch(level.players[0] GetButtonPressed())
		{
			// ========== WAYPOINTS ==========
			case "AddWaypoint":
			{			
				AddWaypoint(level.playerPos,level.playerAngles);
				break;
			}	
			case "DeleteWaypoint":
			{
				DeleteWaypoint(level.playerPos);
				level.wpToLink = -1;
				break;
			}
			case "LinkWaypoint":
			{
				LinkWaypoint(level.playerPos);
				break;
			}
			case "UnlinkWaypoint":
			{
				UnLinkWaypoint(level.playerPos);
				break;
			}
			case "SaveWaypoints":
			{
				SaveStaticWaypoints(); 				
				break;
			}
			
			// ========== ZOMBIE SPAWNS ==========
			case "AddZomSpawn":
			{			
				AddZomSpawn(level.playerPos,level.playerAngles);
				break;
			}	
			case "DeleteZomSpawn":
			{
				DeleteZomSpawn(level.playerPos);
				break;
			}
			case "SaveZomSpawns":
			{
				SaveZomSpawns(); 				
				break;
			}
			
			// ========== TRADE SHOP LOCATIONS ==========
			case "AddTradeSpawn":
			{			
				AddTradeSpawn(level.playerPos,level.playerAngles);
				break;
			}	
			case "DeleteTradeSpawn":
			{
				DeleteTradeSpawn(level.playerPos);
				break;
			}
			case "SaveTradeSpawns":
			{
				SaveTradeSpawns(); 				
				break;
			}
			
			// ========== CHOPPER DROP LOCATIONS ==========
			case "AddChopperSpawn":
			{			
				AddChopperSpawn(level.playerPos,level.playerAngles);
				break;
			}	
			case "DeleteChopperSpawn":
			{
				DeleteChopperSpawn(level.playerPos);
				break;
			}
			case "SaveChopperSpawns":
			{
				SaveChopperSpawns(); 				
				break;
			}
			
			// ========== CUSTOM PICKUP LOCATIONS ==========
			case "AddPickUp":
			{			
				AddPickUp(level.playerPos,level.playerAngles);
				break;
			}	
			case "DeletePickUp":
			{
				DeletePickup(level.playerPos);
				break;
			}
			case "SavePickUps":
			{
				SavePickUps(); 				
				break;
			}

			// ========== PLAYER SPAWNS ==========
			case "AddPlayerSpawn":
			{			
				AddPlayerSpawn(level.playerPos,level.playerAngles);
				break;
			}	
			case "DeletePlayerSpawn":
			{
				DeletePlayerSpawn(level.playerPos);
				break;
			}
			case "SavePlayerSpawns":
			{
				SavePlayerSpawns(); 				
				break;
			}

			// ========== ANTI CAM TELEPORTS ==========
			case "AddTeleport":
			{			
				AddTeleport(level.playerPos);
				break;
			}	
			case "AddGoTo":
			{			
				AddGoTo(level.playerPos);
				break;
			}	
			case "DeleteTeleport":
			{
				DeleteTeleport(level.playerPos);
				break;
			}
			case "SaveAntiCamp":
			{
				SaveAntiCamp(); 				
				break;
			}
/*
			// ========== ZOMBIE TELEPORTS ==========
			case "AddZomTeleport":
			{			
				AddZomTeleport(level.playerPos);
				break;
			}	
			case "AddZomGoTo":
			{			
				AddZomGoTo(level.playerPos);
				break;
			}	
			case "DeleteZomTeleport":
			{
				DeleteZomTeleport(level.playerPos);
				break;
			}
			case "SaveZomTeleports":
			{
				SaveZomTeleports(); 				
				break;
			}
*/
			default:
			break;
		}
		
		wait  0.001;  
	}
}

////////////////////////////////////////////////////////////
// returns one of the buttons pressed
////////////////////////////////////////////////////////////
GetButtonPressed()
{
	if(isDefined(self))
	{
		// waypoints
		if(level.btd_devmode == 1)
		{
			if(self attackbuttonpressed())
			{
				return "AddWaypoint";
			}
			else
			if(self adsbuttonpressed())
			{
				return "DeleteWaypoint";
			}
			else
			if(self usebuttonpressed())
			{
				return "LinkWaypoint";
			}		
			else
			if(self fragbuttonpressed())
			{
				return "UnlinkWaypoint";
			}
			if(self meleebuttonpressed())
			{
				return "SaveWaypoints";
			}		
		}
		else
		// zombie spawns
		if(level.btd_devmode == 2)
		{
			if(self attackbuttonpressed())
			{
				return "AddZomSpawn";
			}
			else
			if(self adsbuttonpressed())
			{
				return "DeleteZomSpawn";
			}
			else
			if(self meleebuttonpressed())
			{
				return "SaveZomSpawns";
			}	
		}
		else
		// trader spawns
		if(level.btd_devmode == 3)
		{
			if(self attackbuttonpressed())
			{
				return "AddTradeSpawn";
			}
			else
			if(self adsbuttonpressed())
			{
				return "DeleteTradeSpawn";
			}
			else
			if(self meleebuttonpressed())
			{
				return "SaveTradeSpawns";
			}			
		}
		else
		// chopper drop points
		if(level.btd_devmode == 4)
		{
			if(self attackbuttonpressed())
			{
				return "AddChopperSpawn";
			}
			else
			if(self adsbuttonpressed())
			{
				return "DeleteChopperSpawn";
			}
			else
			if(self meleebuttonpressed())
			{
				return "SaveChopperSpawns";
			}	
		}
		else
		// custom pickups
		if(level.btd_devmode == 5)
		{
			if(self attackbuttonpressed())
			{
				return "AddPickUp";
			}
			else
			if(self adsbuttonpressed())
			{
				return "DeletePickUp";
			}
			else
			if(self meleebuttonpressed())
			{
				return "SavePickUps";
			}	
		}
		else
		// anitcamp
		if(level.btd_devmode == 6)
		{
			if(self attackbuttonpressed())
			{
				return "AddTeleport";
			}
			else
			if(self usebuttonpressed())
			{
				return "AddGoTo";
			}
			else
			if(self adsbuttonpressed())
			{
				return "DeleteTeleport";
			}
			else
			if(self meleebuttonpressed())
			{
				return "SaveAntiCamp";
			}	
		}
		else
		// not yet coded
		if(level.btd_devmode == 7)
		{
			if(self attackbuttonpressed())
			{
				return "AddPlayerSpawn";
			}
			else
			if(self adsbuttonpressed())
			{
				return "DeletePlayerSpawn";
			}
			else
			if(self meleebuttonpressed())
			{
				return "SavePlayerSpawns";
			}
		}
/*
		else
		// zombie teleports
		if(level.btd_devmode == 8)
		{
			if(self attackbuttonpressed())
			{
				return "AddZomTeleport";
			}
			else
			if(self usebuttonpressed())
			{
				return "AddZomGoTo";
			}
			else
			if(self adsbuttonpressed())
			{
				return "DeleteZomTeleport";
			}
			else
			if(self meleebuttonpressed())
			{
				return "SaveZomTeleports";
			}	
		}
*/
	}
	
	return "none";
}

////////////////////////////////////////////////////////////
// info to be added at start of each saved file
////////////////////////////////////////////////////////////
printInfo()
{
	mapname = tolower(getdvar("mapname"));
	filename = "";
	bla = "";
	
	if(level.btd_devmode == 1) { filename = mapname + "_waypoints.gsc"; bla = "waypoints"; }
	if(level.btd_devmode == 2) { filename = mapname + "_zomspawns.gsc"; bla = "zombie spawns"; }
	if(level.btd_devmode == 3) { filename = mapname + "_tradespawns.gsc"; bla = "trader spawns"; }
	if(level.btd_devmode == 4) { filename = mapname + "_chopperdrops.gsc"; bla = "helicopter drop locations"; }
	if(level.btd_devmode == 5) { filename = mapname + "_newpickups.gsc"; bla = "new custom pickups"; }
	if(level.btd_devmode == 6) { filename = mapname + "_anticamp.gsc"; bla = "anti camp points"; }
	if(level.btd_devmode == 7) { filename = mapname + "_playerspawns.gsc"; bla = "player spawns"; }

	info = [];
	info[0] = "// =========================================================================================";
	info[1] = "// File Name = '" + filename + "'";
	info[2] = "// Map Name  = '" + mapname + "'";
	info[3] = "// =========================================================================================";
	info[4] = "// ";
	info[5] = "// This is an auto generated script file created by the BTD Mod - DO NOT MODIFY!";
	info[6] = "// ";
	info[7] = "// =========================================================================================";
	info[8] = "// ";
	info[9] = "// This file contains the " + bla + " for the map '" + mapname + "'.";	
	info[10] = "// ";
	info[11] = "// You now need to save this file as the file name at the top of this file.";
	info[12] = "// in the 'waypoint.iwd' file in a folder called the same as the map name.";
	info[13] = "// Delete the first two lines of this file and the 'dvar set logfile 0' at the end of the file.";
	info[14] = "// Create the new folder if you havent already done so and rename it to the map name.";
	info[15] = "// So - waypoint.iwd/" + mapname + "/" + filename;
	info[16] = "// ";
	info[17] = "// you now need to edit the file 'select_map.gsc' in the btd_waypoints folder if you havent already.";
	info[18] = "// just follow the instructions at the top of the file. you will need to add the following code.";
	info[19] = "// I couldnt output double quotes to file so replace the single quotes with double quotes.";
	info[20] = "// Also i couldnt output back slashs to file so replace the forward slashs with back slashs.";
	info[21] = "// ";
	info[22] = "// Uncomment the correct line once you have created and added the scripts (remove the // )";
	info[23] = "// ";
	info[24] = "/*";
	info[25] = " ";
	info[26] = "    else if(mapname == '"+ mapname +"')";
	info[27] = "    {";
	info[28] = "        // thread btd_waypoints/" + mapname + "/" + mapname + "_waypoints::load_waypoints(); ";
	info[29] = "        // thread btd_waypoints/" + mapname + "/" + mapname + "_zomspawns::load_zomspawns(); ";
	info[30] = "        // thread btd_waypoints/" + mapname + "/" + mapname + "_tradespawns::load_tradespawns(); ";
	info[31] = "		// thread btd_waypoints/" + mapname + "/" + mapname + "_chopperdrops::load_chopperdrops(); ";
	info[32] = "		// thread btd_waypoints/" + mapname + "/" + mapname + "_newpickups::load_newpickups(); ";
	info[33] = "        // thread btd_waypoints/" + mapname + "/" + mapname + "_anticamp::load_anticamp(); "; 
	info[34] = "        // thread btd_waypoints/" + mapname + "/" + mapname + "_playerspawns::load_playerspawns(); "; 
	info[35] = "    }";
	info[36] = " ";
	info[37] = "*/ ";
	info[38] = "// =========================================================================================";
	info[39] = " ";	
	
	for(i = 0; i < info.size; i++)
	{
		println(info[i]);
	}
}

//=========================================================================================
// W A Y P O I N T S
//=========================================================================================

////////////////////////////////////////////////////////////
// Adds a waypoint to the static waypoint list
////////////////////////////////////////////////////////////
AddWaypoint(pos,angles)
{
	for(i = 0; i < level.waypointCount; i++)
	{
		distance = distance(level.waypoints[i].origin, pos);

		if(distance <= 50.0)
		{
			return;
		}
	}

	level.waypoints[level.waypointCount] = spawnstruct();
	level.waypoints[level.waypointCount].origin = pos;
	level.waypoints[level.waypointCount].angles = angles;
	level.waypoints[level.waypointCount].children = [];
	level.waypoints[level.waypointCount].childCount = 0;
	level.waypointCount++;

	iprintln("Waypoint Added"); 	
}

////////////////////////////////////////////////////////////
// removes a waypoint from the static waypoint list
////////////////////////////////////////////////////////////
DeleteWaypoint(pos)
{
  for(i = 0; i < level.waypointCount; i++)
  {
    distance = distance(level.waypoints[i].origin, pos);
    
    if(distance <= 50.0)
    {

		  //remove all links in children
		  //for each child c
		  for(c = 0; c < level.waypoints[i].childCount; c++)
		  {
			//remove links to its parent i
			for(c2 = 0; c2 < level.waypoints[level.waypoints[i].children[c]].childCount; c2++)
			{
			  // child of i has a link to i as one of its children, so remove it
			  if(level.waypoints[level.waypoints[i].children[c]].children[c2] == i)
			  {
				//remove entry by shuffling list over top of entry
				for(c3 = c2; c3 < level.waypoints[level.waypoints[i].children[c]].childCount-1; c3++)
				{
				  level.waypoints[level.waypoints[i].children[c]].children[c3] = level.waypoints[level.waypoints[i].children[c]].children[c3+1];
				}
				//removed child
				level.waypoints[level.waypoints[i].children[c]].childCount--;
				break;
			  }
			}
		  }
     
      
      //remove waypoint from list
      for(x = i; x < level.waypointCount-1; x++)
      {
        level.waypoints[x] = level.waypoints[x+1];
      }
      level.waypointCount--;
      
      //reassign all child links to their correct values
      for(r = 0; r < level.waypointCount; r++)
      {
        for(c = 0; c < level.waypoints[r].childCount; c++)
        {
          if(level.waypoints[r].children[c] > i)
          {
            level.waypoints[r].children[c]--;
          }
        }
      
      }
      
    iprintln("Waypoint Deleted");
      
      return;
    }
  }
}

////////////////////////////////////////////////////////////
//Links one waypoint to another
////////////////////////////////////////////////////////////
LinkWaypoint(pos)
{
  //dont spam linkage
  if((gettime()-level.linkSpamTimer) < 1000)
  {
    return;
  }
  level.linkSpamTimer = gettime();
  
  wpToLink = -1;
  
  for(i = 0; i < level.waypointCount; i++)
  {
    distance = distance(level.waypoints[i].origin, pos);
    
    if(distance <= 30.0)
    {
      wpToLink = i;
      break;
    }
  }
  
  //if the nearest waypoint is valid
  if(wpToLink != -1)
  {
    //if we have already pressed link on another waypoint, then link them up
    if(level.wpToLink != -1 && level.wpToLink != wpToLink)
    {
      level.waypoints[level.wpToLink].children[level.waypoints[level.wpToLink].childcount] = wpToLink;
      level.waypoints[level.wpToLink].childcount++;
      
      level.waypoints[wpToLink].children[level.waypoints[wpToLink].childcount] = level.wpToLink;
      level.waypoints[wpToLink].childcount++;
      
      iprintln("Waypoint ^5[^7" + (wpToLink + 1) + "^5]^7 Linked to ^5[^7" + (level.wpToLink + 1) + "^5]");
      level.wpToLink = -1;
    }
    else //otherwise store the first link point
    {
      level.wpToLink = wpToLink;
      iprintln("Waypoint Link Started");
    }

  }
  else
  {
    level.wpToLink = -1;
    iprintln("Waypoint Link Cancelled");
  }
}

////////////////////////////////////////////////////////////
//Breaks the link between two waypoints
////////////////////////////////////////////////////////////
UnLinkWaypoint(pos)
{
  //dont spam linkage
  if((gettime()-level.linkSpamTimer) < 1000)
  {
    return;
  }
  level.linkSpamTimer = gettime();
  
  wpToLink = -1;
  
  for(i = 0; i < level.waypointCount; i++)
  {
    distance = distance(level.waypoints[i].origin, pos);
    
    if(distance <= 30.0)
    {
      wpToLink = i;
      break;
    }
  }
  
  //if the nearest waypoint is valid
  if(wpToLink != -1)
  {
    //if we have already pressed link on another waypoint, then break the link
    if(level.wpToLink != -1 && level.wpToLink != wpToLink)
    {
      //do first waypoint
      for(i = 0; i < level.waypoints[level.wpToLink].childCount; i++)
      {
        if(level.waypoints[level.wpToLink].children[i] == wpToLink)
        {
          //shuffle list down
          for(c = i; c < level.waypoints[level.wpToLink].childCount-1; c++)
          {
            level.waypoints[level.wpToLink].children[c] = level.waypoints[level.wpToLink].children[c+1];
          }
          level.waypoints[level.wpToLink].childCount--;
          break;
        }
      }
      
      //do second waypoint  
      for(i = 0; i < level.waypoints[wpToLink].childCount; i++)
      {
        if(level.waypoints[wpToLink].children[i] == level.wpToLink)
        {
          //shuffle list down
          for(c = i; c < level.waypoints[wpToLink].childCount-1; c++)
          {
            level.waypoints[wpToLink].children[c] = level.waypoints[wpToLink].children[c+1];
          }
          level.waypoints[wpToLink].childCount--;
          break;
        }
      }
      
      iprintln("Waypoint " + wpToLink + " Broken to " + level.wpToLink);
      level.wpToLink = -1;
    }
    else //otherwise store the first link point
    {
      level.wpToLink = wpToLink;
      iprintln("Waypoint Link Started");
    }
  }
  else
  {
    level.wpToLink = -1;
    iprintln("Waypoint Link Cancelled");
  }
}

////////////////////////////////////////////////////////////
// Saves waypoints out to a file
////////////////////////////////////////////////////////////
SaveStaticWaypoints()
{
	if((gettime()-level.saveSpamTimer) < 1500)
	{
		return;
	}
	level.saveSpamTimer = gettime();

	setDvar("logfile", "1");

	printInfo();
	
	scriptstart = [];
	scriptstart[0] = "load_waypoints()";
	scriptstart[1] = "{";
	scriptstart[2] = "    level.waypoints = [];";
	scriptstart[3] = " ";
	
	for(i = 0; i < scriptstart.size; i++)
	{
		println(scriptstart[i]);
	}

	for(w = 0; w < level.waypointCount; w++)
	{
		waypointstruct = "    level.waypoints[" + w + "] = spawnstruct();";
		println(waypointstruct);
	
		waypointstring = "    level.waypoints[" + w + "].origin = "+ "(" + level.waypoints[w].origin[0] + "," + level.waypoints[w].origin[1] + "," + level.waypoints[w].origin[2] + ");";
		println(waypointstring);
		
		waypointchild = "    level.waypoints[" + w + "].childCount = " + level.waypoints[w].childCount + ";";
		println(waypointchild);

		for(c = 0; c < level.waypoints[w].childCount; c++)
		{
			childstring = "    level.waypoints[" + w + "].children[" + c + "] = " + level.waypoints[w].children[c] + ";";
			println(childstring);      
		}
		
		iprintln("Waypoint " + (w + 1)+ " Saved.");		
	}
	
	scriptend = [];
	scriptend[0] = " ";
	scriptend[1] = "    level.waypointCount = level.waypoints.size;";
	scriptend[2] = "}";
	
	for(i = 0; i < scriptend.size; i++)
	{
		println(scriptend[i]);
	}

	setdvar("logfile", 0);
  
	wait 1;
	iprintlnBold("^5Waypoints Outputted To Console Log In Mod Folder");
	wait 1;
	iprintlnBold("^5Close Game & Follow Instructions In File");
}

////////////////////////////////////////////////////////////
// debug draw static waypoint list
////////////////////////////////////////////////////////////
DrawStaticWaypoints()
{
	colourRed = (1,0,0);		
	colourGreen = (0,1,0); 		
	colourBlue = (0,0,1); 			
	colourCyan = (0,1,1); 
	colourPurple = (1,0,1);
	colourWhite = (1,1,1);
		
  while(1)
  {
    if(CanDebugDraw() && isDefined(level.waypoints) && isDefined(level.waypointCount) && level.waypointCount > 0)
    {
      wpDrawDistance = 1000;
    
      for(i = 0; i < level.waypointCount; i++)
      {
        if(isdefined(level.players) && isdefined(level.players[0]))
        {
          distance = distance(level.players[0].origin, level.waypoints[i].origin);
          if(distance > wpDrawDistance)
          {
            continue;
          }
        }
      
        color = (0,0,1);


			//red for unlinked wps
			if(level.waypoints[i].childCount == 0)
			{
			  color = colourRed;			  
			}
			else
			if(level.waypoints[i].childCount == 1) //purple for dead ends
			{
			  color = colourPurple;			  
			}
			else 
			{
			  color = colourGreen;			  
			}						
				

        if(isdefined(level.players) && isdefined(level.players[0]))
        {
          distance = distance(level.waypoints[i].origin, level.players[0].origin);
          if(distance <= 30.0)
          {
            strobe = abs(sin(gettime()/10.0));
            color = (color[0]*strobe,color[1]*strobe,color[2]*strobe);
          }
        }

		line(level.waypoints[i].origin, level.waypoints[i].origin + (2,2,120), color);
		
	for(x = 0; x < level.waypoints[i].childCount; x++)
	{
		line(level.waypoints[i].origin + (0,0,5), level.waypoints[level.waypoints[i].children[x]].origin + (0,0,5), (0,0,1));
	}
      }  
      
      //draw spawnpoints  
      DrawSpawnPoints(getentarray("mp_sab_spawn_axis", "classname"), "sabS");
      DrawSpawnPoints(getentarray("mp_sab_spawn_allies", "classname"), "sabS");
      DrawSpawnPoints(getentarray("mp_sab_spawn_axis_start", "classname"), "sabS");
      DrawSpawnPoints(getentarray("mp_sab_spawn_allies_start", "classname"), "sabS");
      DrawSpawnPoints(getentarray("mp_sd_spawn_attacker", "classname"), "sdS");
      DrawSpawnPoints(getentarray("mp_sd_spawn_defender", "classname"), "sdS");
      
      DrawSpawnPoints(getentarray("mp_dm_spawn", "classname"), "dmS");
      DrawSpawnPoints(getentarray("mp_tdm_spawn", "classname"), "tdmS");
      DrawSpawnPoints(getentarray("mp_dom_spawn", "classname"), "domS"); 
    }
    wait 0.001;
  }
}

//=========================================================================================
// Z O M B I E	 S P A W N S
//=========================================================================================

////////////////////////////////////////////////////////////
// Adds a zom spawn
////////////////////////////////////////////////////////////
AddZomSpawn(pos, angles)
{
	for(i = 0; i < level.zomSpawnCount; i++)
	{
		distance = distance(level.zomSpawnPoint[i].origin, pos);

		if(distance <= 25.0)
		{
			return;
		}
	}

	// 5 full spawn sets max.
	if(level.zomSpawnCount < 64)
	{
		level.zomSpawnPoint[level.zomSpawnCount] = spawnstruct();
		level.zomSpawnPoint[level.zomSpawnCount].origin = pos;
		level.zomSpawnCount++;

		iprintln("Zombie Spawn Added: " + pos); 
	}
	else
	{
		iprintln("Zombie Spawn Limit Reached"); 
	}
}

////////////////////////////////////////////////////////////
// deletes a zom spawn
////////////////////////////////////////////////////////////
DeleteZomSpawn(pos)
{ 
	for(i = 0; i < level.zomSpawnCount; i++)
	{
		distance = distance(level.zomSpawnPoint[i].origin, pos);

		if(distance <= 25.0)
		{			
			//remove spawn from list
			for(x = i; x < level.zomSpawnCount-1; x++)
			{
				level.zomSpawnPoint[x] = level.zomSpawnPoint[x+1];
			}
			level.zomSpawnCount--;

			iprintln("Zombie Spawn Deleted");

			return;
		}
	}
}

////////////////////////////////////////////////////////////
// saves zombie spawns
////////////////////////////////////////////////////////////
SaveZomSpawns()
{
	if(level.zomSpawnCount >= 8)
	{
		if((gettime()-level.saveSpamTimer) < 1500)
		{
			return;
		}
		level.saveSpamTimer = gettime();

		setdvar("logfile", "1");

		printInfo();

		scriptstart = [];
		scriptstart[0] = "load_zomspawns()";
		scriptstart[1] = "{";
		scriptstart[2] = "    zomspawnpoint = [];";
		scriptstart[3] = " ";

		for(i = 0; i < scriptstart.size; i++)
		{
			println(scriptstart[i]);
		}

		for(w = 0; w < level.zomSpawnCount; w++)
		{
			string = "";
			string = "      zomspawnpoint[" + w + "] = (" + level.zomspawnpoint[w].origin[0] + "," + level.zomspawnpoint[w].origin[1] + "," + level.zomspawnpoint[w].origin[2] + ");";
			println(string);

			iprintln("Spawn " + (w + 1) + " Saved.");
		}

		scriptendc = [];
		scriptendc[0] = " ";
		scriptendc[1] = "    for(n = 0; n < zomspawnpoint.size; n++)";
		scriptendc[2] = "    {";
		scriptendc[3] = "        temp = spawnStruct();";
		scriptendc[4] = "        temp.origin = zomspawnpoint[n];";
		scriptendc[5] = "        level.zomspawns[level.zomspawns.size] = temp;";
		scriptendc[6] = "    }";
		scriptendc[7] = "}";
		
		for(i = 0; i < scriptendc.size; i++)
		{
			println(scriptendc[i]);
		}

		setdvar("logfile", 0);
	  
		wait 1;
		iprintlnBold("^5Zombie Spawns Outputted To Console Log In Mod Folder");
		wait 1;
		iprintlnBold("^5Close Game & Follow Instructions In File");
	}
	else
	{
		wait 1;
		iprintlnBold("^5Zombie Spawns Not Saved.");
		wait 1;
		iprintlnBold("^5Please Create At Least 8 Zombie spawns.");
	} 
}

////////////////////////////////////////////////////////////
// draw zombie spawn points
////////////////////////////////////////////////////////////
DrawZombieSpawns()
{
	color = (0,0,0);
	colourRed = (1,0,0);		
	colourGreen = (0,1,0); 		
	colourBlue = (0,0,1); 			
	colourCyan = (0,1,1); 
	colourPurple = (1,0,1);
	colourWhite = (1,1,1);

	while(1)
	{
		if(CanDebugDraw() && isDefined(level.zomSpawnPoint) && isDefined(level.zomSpawnCount) && level.zomSpawnCount > 0)
		{
			wpDrawDistance = 1500;

			for(i = 0; i < level.zomSpawnCount; i++)
			{
				if(isdefined(level.players) && isdefined(level.players[0]))
				{
					distance = distance(level.players[0].origin, level.zomSpawnPoint[i].origin);
					if(distance > wpDrawDistance)
					{
						continue;
					}
				}

				color = (0,0,1);	

				if(isdefined(level.players) && isdefined(level.players[0]))
				{
					distance = distance(level.zomSpawnPoint[i].origin, level.players[0].origin);
					if(distance <= 30.0)
					{
						strobe = abs(sin(gettime()/10.0));
						color = (color[0]*strobe,color[1]*strobe,color[2]*strobe);
					}
				}

				if( i < 25) 
				{ 
					line(level.zomSpawnPoint[i].origin, level.zomSpawnPoint[i].origin + (2,2,120), colourRed); 
				}
				else if( i > 24 && i < 50) 
				{ 
					line(level.zomSpawnPoint[i].origin, level.zomSpawnPoint[i].origin + (2,2,120), colourBlue);
				}
				else if( i > 49 && i < 75) 
				{ 
					line(level.zomSpawnPoint[i].origin, level.zomSpawnPoint[i].origin + (2,2,120), colourWhite);
				}
				else if( i > 74 && i < 100) 
				{ 
					line(level.zomSpawnPoint[i].origin, level.zomSpawnPoint[i].origin + (2,2,120), colourGreen);
				}
				else if( i > 99 && i < 125) 
				{ 
					line(level.zomSpawnPoint[i].origin, level.zomSpawnPoint[i].origin + (2,2,120), colourPurple);
				}
			}  
      
			//draw spawnpoints  
			DrawSpawnPoints(getentarray("mp_sab_spawn_axis", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_allies", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_axis_start", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_allies_start", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sd_spawn_attacker", "classname"), "sdS");
			DrawSpawnPoints(getentarray("mp_sd_spawn_defender", "classname"), "sdS");

			DrawSpawnPoints(getentarray("mp_dm_spawn", "classname"), "dmS");
			DrawSpawnPoints(getentarray("mp_tdm_spawn", "classname"), "tdmS");
			DrawSpawnPoints(getentarray("mp_dom_spawn", "classname"), "domS");

			//draw domination flags
			DrawSpawnPoints(getEntArray("flag_primary", "targetname"), "F");
			DrawSpawnPoints(getEntArray("flag_secondary", "targetname"), "F");

			//draw radios
			DrawSpawnPoints(getentarray("hq_hardpoint", "targetname"), "R");

			//draw bombzones
			DrawSpawnPoints(getEntArray("bombzone", "targetname"), "B");
			DrawSpawnPoints(getEntArray("sab_bomb_axis", "targetname"), "B");
			DrawSpawnPoints(getEntArray("sab_bomb_allies", "targetname"), "B");
		}
		wait 0.001;
	}
}

//=========================================================================================
// T R A D E R		S P A W N S
//=========================================================================================

////////////////////////////////////////////////////////////
// Adds a trade spawn
////////////////////////////////////////////////////////////
AddTradeSpawn(pos, angles)
{		
	for(i = 0; i < level.tradeSpawnCount; i++)
	{
		distance = distance(level.tradeSpawns[i].origin, pos);

		if(distance <= 50.0)
		{
			return;
		}
	}

	// 3 trader spawns max
	if(level.tradeSpawnCount < 3)
	{
		level.tradespawns[level.tradeSpawnCount] = spawnstruct();
		level.tradespawns[level.tradeSpawnCount].origin = pos;
		level.tradespawns[level.tradeSpawnCount].angles = angles;
		level.tradeSpawnCount++;
		
		iprintln("Trade Spawn Added"); 
	}
	else
	{
		iprintln("Trade Spawn Limit Reached"); 
	}
}

////////////////////////////////////////////////////////////
// deletes a TRADE spawn
////////////////////////////////////////////////////////////
DeleteTradeSpawn(pos)
{ 
	for(i = 0; i < level.tradeSpawnCount; i++)
	{
		distance = distance(level.tradeSpawns[i].origin, pos);
		
		if(distance <= 50)
		{			
			//remove spawn from list
			for(x = i; x < level.tradeSpawnCount-1; x++)
			{
				level.tradeSpawns[x] = level.tradeSpawns[x+1];
			}
			level.tradeSpawnCount--;

			iprintln("Trade Spawn Deleted");

			return;
		}
	}
}

////////////////////////////////////////////////////////////
// save trader spawn points
////////////////////////////////////////////////////////////
SaveTradeSpawns()
{
	if(level.tradeSpawnCount >= 3)
	{
		if((gettime()-level.saveSpamTimer) < 1500)
		{
			return;
		}
		level.saveSpamTimer = gettime();

		setdvar("logfile", 1);

		printInfo();
		
		scriptstart = [];
		scriptstart[0] = "load_tradespawns()";
		scriptstart[1] = "{";
		scriptstart[2] = "    level.tradespawns = [];";
		scriptstart[3] = " ";
		
		for(i = 0; i < scriptstart.size; i++)
		{
			println(scriptstart[i]);
		}

		for(w = 0; w < level.tradeSpawnCount; w++)
		{
			tradestruct = "    level.tradespawns[" + w + "] = spawnstruct();";
			println(tradestruct);
		
			tradeorigin = "    level.tradespawns[" + w + "].origin = "+ "(" + level.tradespawns[w].origin[0] + "," + level.tradespawns[w].origin[1] + "," + level.tradespawns[w].origin[2] + ");";
			println(tradeorigin);
			
			tradeangles = "    level.tradespawns[" + w + "].angles = "+ "(" + level.tradespawns[w].angles[0] + "," + level.tradespawns[w].angles[1] + "," + level.tradespawns[w].angles[2] + ");";
			println(tradeangles);
			
			iprintln("Trade Spawn " + (w + 1) + " Saved.");		
		}	
			
			
		scriptend = [];
		scriptend[0] = " ";
		scriptend[1] = "    level.tradeSpawnCount = level.tradespawns.size;";
		scriptend[2] = "}";
		
		for(i = 0; i < scriptend.size; i++)
		{
			println(scriptend[i]);
		} 

		setdvar("logfile", 0);
	  
		wait 1;
		iprintlnBold("^5Trade Spawns Outputted To Console Log In Mod Folder");
		wait 1;
		iprintlnBold("^5Close Game & Follow Instructions In File");
	}
	else
	{
		wait 1;
		iprintlnBold("^5Trader Spawns Not Saved");
		wait 1;
		iprintlnBold("^5Please Create 3 Trader Spawns Then Save");
	} 
}

////////////////////////////////////////////////////////////
// draws the trader spawns lines on screen
////////////////////////////////////////////////////////////
DrawTradeSpawns()
{
	colourRed = (1,0,0);

	while(1)
	{
		if(CanDebugDraw() && isDefined(level.tradeSpawns) && isDefined(level.tradeSpawnCount) && level.tradeSpawnCount > 0)
		{
			wpDrawDistance = 5000;

			for(i = 0; i < level.tradeSpawnCount; i++)
			{
				if(isdefined(level.players) && isdefined(level.players[0]))
				{
					distance = distance(level.players[0].origin, level.tradeSpawns[i].origin);
					if(distance > wpDrawDistance)
					{
						continue;
					}
				}

				color = (0,0,1);
				color = colourRed;	

				if(isdefined(level.players) && isdefined(level.players[0]))
				{
					distance = distance(level.tradeSpawns[i].origin, level.players[0].origin);
					if(distance <= 50.0)
					{
						strobe = abs(sin(gettime()/10.0));
						color = (color[0]*strobe,color[1]*strobe,color[2]*strobe);
					}
				}

				line(level.tradeSpawns[i].origin, level.tradeSpawns[i].origin + (2,2,120), color);
			} 
			       
			//draw spawnpoints  
			DrawSpawnPoints(getentarray("mp_sab_spawn_axis", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_allies", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_axis_start", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_allies_start", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sd_spawn_attacker", "classname"), "sdS");
			DrawSpawnPoints(getentarray("mp_sd_spawn_defender", "classname"), "sdS");

			DrawSpawnPoints(getentarray("mp_dm_spawn", "classname"), "dmS");
			DrawSpawnPoints(getentarray("mp_tdm_spawn", "classname"), "tdmS");
			DrawSpawnPoints(getentarray("mp_dom_spawn", "classname"), "domS"); 
		}
		
		wait 0.001;
	}
}

//=========================================================================================
// C H O P P E R		S P A W N S
//=========================================================================================

////////////////////////////////////////////////////////////
// Adds a CHOPPER spawn
////////////////////////////////////////////////////////////
AddchopperSpawn(pos, angles)
{		
	for(i = 0; i < level.chopperSpawnCount; i++)
	{
		distance = distance(level.chopperSpawns[i].origin, pos);

		if(distance <= 200.0)
		{
			return;
		}
	}

	// 3 chopperr spawns max
	if(level.chopperSpawnCount < 20)
	{
		level.chopperspawns[level.chopperSpawnCount] = spawnstruct();
		level.chopperspawns[level.chopperSpawnCount].origin = pos;
		level.chopperspawns[level.chopperSpawnCount].angles = angles;
		level.chopperSpawnCount++;
		
		iprintln("Chopper Spawn Added"); 
	}
	else
	{
		iprintln("Chopper Spawn Limit Reached"); 
	}
}

////////////////////////////////////////////////////////////
// deletes a chopper spawn
////////////////////////////////////////////////////////////
DeleteChopperSpawn(pos)
{ 
	for(i = 0; i < level.chopperSpawnCount; i++)
	{
		distance = distance(level.chopperSpawns[i].origin, pos);
		
		if(distance <= 200)
		{			
			//remove spawn from list
			for(x = i; x < level.chopperSpawnCount-1; x++)
			{
				level.chopperSpawns[x] = level.chopperSpawns[x+1];
			}
			level.chopperSpawnCount--;

			iprintln("Chopper Spawn Deleted");

			return;
		}
	}
}

////////////////////////////////////////////////////////////
// save chopperr spawn points
////////////////////////////////////////////////////////////
SavechopperSpawns()
{
	if(level.chopperSpawnCount > 0)
	{
		if((gettime()-level.saveSpamTimer) < 1500)
		{
			return;
		}
		level.saveSpamTimer = gettime();

		setdvar("logfile", 1);

		printInfo();
		
		scriptstart = [];
		scriptstart[0] = "load_chopperdrops()";
		scriptstart[1] = "{";
		scriptstart[2] = "   level.chopperspawns = [];";
		scriptstart[3] = " ";

		for(i = 0; i < scriptstart.size; i++)
		{
			println(scriptstart[i]);
		}

		for(w = 0; w < level.chopperSpawnCount; w++)
		{
			chopperstruct = "   level.chopperspawns[" + w + "] = spawnstruct();";
			println(chopperstruct);

			chopperorigin = "   level.chopperspawns[" + w + "].origin = "+ "(" + level.chopperspawns[w].origin[0] + "," + level.chopperspawns[w].origin[1] + "," + level.chopperspawns[w].origin[2] + ");";
			println(chopperorigin);
			
			iprintln("Helicopter Drop Point " + (w + 1) + " Saved.");		
		}	
			
		scriptend = [];
		scriptend[0] = " ";
		scriptend[1] = "   level.chopperSpawnCount = level.chopperspawns.size;";
		scriptend[2] = "}";
	
		for(i = 0; i < scriptend.size; i++)
		{
			println(scriptend[i]);
		}

		setdvar("logfile", 0);
	  
		wait 1;
		iprintlnBold("^5Helicopter Drop Points Outputted To Console Log In Mod Folder");
		wait 1;
		iprintlnBold("^5Close Game & Follow Instructions In File");
	}
	else
	{
		wait 1;
		iprintlnBold("^5Helicopter Drop Points Not Saved");
		wait 1;
		iprintlnBold("^5Please Mark At Least 1 Drop Location Then Save");
	} 
}

////////////////////////////////////////////////////////////
// draws the chopper spawns lines on screen
////////////////////////////////////////////////////////////
DrawChopperSpawns()
{
	colourRed = (1,0,0);

	while(1)
	{
		if(CanDebugDraw() && isDefined(level.chopperSpawns) && isDefined(level.chopperSpawnCount) && level.chopperSpawnCount > 0)
		{
			wpDrawDistance = 5000;

			for(i = 0; i < level.chopperSpawnCount; i++)
			{
				if(isdefined(level.players) && isdefined(level.players[0]))
				{
					distance = distance(level.players[0].origin, level.chopperSpawns[i].origin);
					if(distance > wpDrawDistance)
					{
						continue;
					}
				}

				color = (0,0,1);
				color = colourRed;	

				if(isdefined(level.players) && isdefined(level.players[0]))
				{
					distance = distance(level.chopperSpawns[i].origin, level.players[0].origin);
					if(distance <= 50.0)
					{
						strobe = abs(sin(gettime()/10.0));
						color = (color[0]*strobe,color[1]*strobe,color[2]*strobe);
					}
				}

				line(level.chopperSpawns[i].origin, level.chopperSpawns[i].origin + (2,2,120), color);
			} 
			       
			//draw spawnpoints  
			DrawSpawnPoints(getentarray("mp_sab_spawn_axis", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_allies", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_axis_start", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_allies_start", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sd_spawn_attacker", "classname"), "sdS");
			DrawSpawnPoints(getentarray("mp_sd_spawn_defender", "classname"), "sdS");

			DrawSpawnPoints(getentarray("mp_dm_spawn", "classname"), "dmS");
			DrawSpawnPoints(getentarray("mp_tdm_spawn", "classname"), "tdmS");
			DrawSpawnPoints(getentarray("mp_dom_spawn", "classname"), "domS"); 
		}
		
		wait 0.001;
	}
}

//=========================================================================================
// C U S T O M		P I C K U P S
//=========================================================================================

////////////////////////////////////////////////////////////
// Adds a pickup spawn
////////////////////////////////////////////////////////////
Addpickup(pos, angles)
{		
	for(i = 0; i < level.pickupSpawnCount; i++)
	{
		distance = distance(level.pickupSpawns[i].origin, pos);

		if(distance <= 200.0)
		{
			return;
		}
	}

	// 25 pickups max
	if(level.pickupSpawnCount < 25)
	{
		level.pickupspawns[level.pickupSpawnCount] = spawnstruct();
		level.pickupspawns[level.pickupSpawnCount].origin = pos;
		level.pickupspawns[level.pickupSpawnCount].angles = angles;
		level.pickupSpawnCount++;
		
		iprintln("Pickup Spawn Added"); 
	}
	else
	{
		iprintln("Pickup Spawn Limit Reached"); 
	}
}

////////////////////////////////////////////////////////////
// deletes a pickup spawn
////////////////////////////////////////////////////////////
Deletepickup(pos)
{ 
	for(i = 0; i < level.pickupSpawnCount; i++)
	{
		distance = distance(level.pickupSpawns[i].origin, pos);
		
		if(distance <= 200)
		{			
			//remove spawn from list
			for(x = i; x < level.pickupSpawnCount-1; x++)
			{
				level.pickupSpawns[x] = level.pickupSpawns[x+1];
			}
			level.pickupSpawnCount--;

			iprintln("pickup Spawn Deleted");

			return;
		}
	}
}

////////////////////////////////////////////////////////////
// save pickup spawn points
////////////////////////////////////////////////////////////
Savepickups()
{
	if(level.pickupSpawnCount >= 5)
	{
		if((gettime()-level.saveSpamTimer) < 1500)
		{
			return;
		}
		level.saveSpamTimer = gettime();

		setdvar("logfile", 1);

		printInfo();

		scriptstart = [];
		scriptstart[0] = "load_newpickups()";
		scriptstart[1] = "{";
		scriptstart[2] = "   level.newpickupspawns = [];";
		scriptstart[3] = " ";

		for(i = 0; i < scriptstart.size; i++)
		{
			println(scriptstart[i]);
		}

		for(w = 0; w < level.pickupSpawnCount; w++)
		{
			pickupstruct = "   level.newpickupspawns[" + w + "] = spawnstruct();";
			println(pickupstruct);

			pickuporigin = "   level.newpickupspawns[" + w + "].origin = "+ "(" + level.pickupspawns[w].origin[0] + "," + level.pickupspawns[w].origin[1] + "," + (level.pickupspawns[w].origin[2] + 30) + ");";
			println(pickuporigin);

			pickupangles = "   level.newpickupspawns[" + w + "].angles = "+ "(" + level.pickupspawns[w].angles[0] + "," + level.pickupspawns[w].angles[1] + "," + level.pickupspawns[w].angles[2] + ");";
			println(pickupangles);

			iprintln("Pickup Spawn " + (w + 1) + " Saved.");		
		}	

		scriptend = [];
		scriptend[0] = " ";
		scriptend[1] = "   if(level.btd_devmode == 5)";
		scriptend[2] = "      { level.pickupSpawnCount = level.pickupspawns.size; }";
		scriptend[3] = "}";

		for(i = 0; i < scriptend.size; i++)
		{
			println(scriptend[i]);
		} 

		setdvar("logfile", 0);
	  
		wait 1;
		iprintlnBold("^5Pickup Spawns Outputted To Console Log In Mod Folder");
		wait 1;
		iprintlnBold("^5Close Game & Follow Instructions In File");
	}
	else
	{
		wait 1;
		iprintlnBold("^5Pickup Spawns Not Saved");
		wait 1;
		iprintlnBold("^5Please Mark At Least 5 Pickup Spawns Then Save");
	} 
}

////////////////////////////////////////////////////////////
// draws the pickup spawns lines on screen
////////////////////////////////////////////////////////////
DrawPickupSpawns()
{
	colourWhite = (1,1,1);

	while(1)
	{
		if(CanDebugDraw() && isDefined(level.pickupSpawns) && isDefined(level.pickupSpawnCount) && level.pickupSpawnCount > 0)
		{
			wpDrawDistance = 5000;

			for(i = 0; i < level.pickupSpawnCount; i++)
			{
				if(isdefined(level.players) && isdefined(level.players[0]))
				{
					distance = distance(level.players[0].origin, level.pickupSpawns[i].origin);
					if(distance > wpDrawDistance)
					{
						continue;
					}
				}

				color = (0,0,1);
				color = colourWhite;	

				if(isdefined(level.players) && isdefined(level.players[0]))
				{
					distance = distance(level.pickupSpawns[i].origin, level.players[0].origin);
					if(distance <= 50.0)
					{
						strobe = abs(sin(gettime()/10.0));
						color = (color[0]*strobe,color[1]*strobe,color[2]*strobe);
					}
				}

				line(level.pickupSpawns[i].origin, level.pickupSpawns[i].origin + (2,2,120), color);
			} 
			       
			//draw spawnpoints  
			DrawSpawnPoints(getentarray("mp_sab_spawn_axis", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_allies", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_axis_start", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_allies_start", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sd_spawn_attacker", "classname"), "sdS");
			DrawSpawnPoints(getentarray("mp_sd_spawn_defender", "classname"), "sdS");

			DrawSpawnPoints(getentarray("mp_dm_spawn", "classname"), "dmS");
			DrawSpawnPoints(getentarray("mp_tdm_spawn", "classname"), "tdmS");
			DrawSpawnPoints(getentarray("mp_dom_spawn", "classname"), "domS"); 
		}
		
		wait 0.001;
	}
}

//=========================================================================================
// T E L E P O R T     A N T I     C A M P
//=========================================================================================

////////////////////////////////////////////////////////////
// adds an anticamp teleport
////////////////////////////////////////////////////////////
AddTeleport(pos)
{		
	for(i = 0; i < level.trigCount; i++)
	{
		distance = distance(level.teleport[i].origin, pos);

		if(distance <= 50.0)
		{
			return;
		}
	}

	level.teleport[level.trigCount] = spawnstruct();
	level.teleport[level.trigCount].origin = pos;
	level.trigCount++;
		
	iprintln("Anti Camp Teleport Added"); 
}

AddGoTo(pos)
{		
	if(level.trigcount == 0 )
	{
		iPrintlnBold("^5Please create at least 1 Anti Camp Teleport");
		return;
	}
	
	for(i = 0; i < level.trigCount; i++)
	{
		distance = distance(level.teleport[i].origin, pos);

		if(distance <= 100)
		{
			return;
		}
	}
		
	level.goto[level.gotoCount] = spawnstruct();
	level.goto[level.gotoCount].origin = pos;
	level.gotoCount++;

	start = level.gotoStart;
	end = level.trigcount;	
	
	if ( end - start > 0 )
	{	
		for ( t = start; t < end; t++ )
		{
			level.teleport[t].goto = pos;
			iprintln("Anti Camp GoTo added for teleport " + (t+1));
		}		 
	}
	
	level.gotoStart = level.trigCount;
	
}

////////////////////////////////////////////////////////////
// deletes a teleport
////////////////////////////////////////////////////////////
DeleteTeleport(pos)
{ 
	for(i = 0; i < level.trigCount; i++)
	{
		distance = distance(level.teleport[i].origin, pos);
		
		if(distance <= 50)
		{			
			//remove teleport from list
			for(x = i; x < level.trigCount-1; x++)
			{
				level.teleport[x] = level.teleport[x+1];
			}
			level.trigCount--;

			iprintln("Teleport Deleted");

			return;
		}
	}
}

////////////////////////////////////////////////////////////
// save anti camp teleports
////////////////////////////////////////////////////////////
SaveAntiCamp()
{
	if(level.trigcount > 0 && level. gotoCount > 0)
	{
		if((gettime()-level.saveSpamTimer) < 1500)
		{
			return;
		}
		level.saveSpamTimer = gettime();

		setdvar("logfile", 1);

		printInfo();
		
		newinfo = [];
		newinfo[0] = "";
		newinfo[1] = "// because double quotes cant be outputted to file you will need to replace";
		newinfo[2] = "//  'trigger_radius'  with double quotes ";
		newinfo[3] = "";
		
		for(n = 0; n < newinfo.size; n++)
		{
			println(newinfo[n]);
		}
		
		scriptstart = [];
		scriptstart[0] = "load_anticamp()";
		scriptstart[1] = "{";
		scriptstart[2] = "	wait 5;";
		scriptstart[3] = "	if(level.btd_anticamp == 0 || level.btd_anticamp == 2)";
		scriptstart[4] = "	{";
		scriptstart[5] = "		return;";
		scriptstart[6] = "	}";
		scriptstart[7] = " ";
		
		for(i = 0; i < scriptstart.size; i++)
		{
			println(scriptstart[i]);
		}

		for(w = 0; w < level.trigcount; w++)
		{
			trig = "	trig = spawn('trigger_radius',(" + level.teleport[w].origin[0] + "," + level.teleport[w].origin[1] + "," + level.teleport[w].origin[2] + "),0,50,100);";
			println(trig);
			
			goto = "	trig.goto = (" + level.teleport[w].goto[0] + "," + level.teleport[w].goto[1] + "," + level.teleport[w].goto[2] + ");";
			println(goto);
			
			trigwait = "	trig thread btd/_anti_camp_teleport::waitfortrig();";
			println(trigwait);

			iprintln("Anti Camp Teleport " + (w + 1) + " Saved.");		
		}	
			
		scriptend = [];
		scriptend[0] = "}";
		scriptend[1] = "";
	
		for(i = 0; i < scriptend.size; i++)
		{
			println(scriptend[i]);
		} 

		setdvar("logfile", 0);
	  
		wait 1;
		iprintlnBold("^5Anti Camp Teleports Outputted To Console Log In Mod Folder");
		wait 1;
		iprintlnBold("^5Close Game & Follow Instructions In File");
	}
	else
	{
		wait 1;
		iprintlnBold("^5Anti Camp Teleports Spawns Not Saved");
		wait 1;
		iprintlnBold("^5Please Create At Least 1 Anti Camp & 1 GoTo");
	} 
}

////////////////////////////////////////////////////////////
// draws the teleports
////////////////////////////////////////////////////////////
DrawTeleport()
{
	colourRed = (1,0,0);

	while(1)
	{
		if(CanDebugDraw() && isDefined(level.teleport) && isDefined(level.trigCount) && level.trigCount > 0)
		{
			wpDrawDistance = 5000;

			for(i = 0; i < level.trigCount; i++)
			{
				if(isdefined(level.players) && isdefined(level.players[0]))
				{
					distance = distance(level.players[0].origin, level.teleport[i].origin);
					if(distance > wpDrawDistance)
					{
						continue;
					}
				}

				color = (0,0,1);
				color = colourRed;	

				if(isdefined(level.players) && isdefined(level.players[0]))
				{
					distance = distance(level.teleport[i].origin, level.players[0].origin);
					if(distance <= 50.0)
					{
						strobe = abs(sin(gettime()/10.0));
						color = (color[0]*strobe,color[1]*strobe,color[2]*strobe);
					}
				}

				line(level.teleport[i].origin, level.teleport[i].origin + (2,2,120), color);
			} 
			       
			//draw spawnpoints  
			DrawSpawnPoints(getentarray("mp_sab_spawn_axis", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_allies", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_axis_start", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_allies_start", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sd_spawn_attacker", "classname"), "sdS");
			DrawSpawnPoints(getentarray("mp_sd_spawn_defender", "classname"), "sdS");

			DrawSpawnPoints(getentarray("mp_dm_spawn", "classname"), "dmS");
			DrawSpawnPoints(getentarray("mp_tdm_spawn", "classname"), "tdmS");
			DrawSpawnPoints(getentarray("mp_dom_spawn", "classname"), "domS"); 
		}
		
		wait 0.001;
	}
}

////////////////////////////////////////////////////////////
// draws the go to
////////////////////////////////////////////////////////////
DrawGoTo()
{
	colourGreen = (0,1,0);

	while(1)
	{
		if(CanDebugDraw() && isDefined(level.goto) && isDefined(level.gotoCount) && level.gotoCount > 0)
		{
			wpDrawDistance = 5000;

			for(i = 0; i < level.gotoCount; i++)
			{
				if(isdefined(level.players) && isdefined(level.players[0]))
				{
					distance = distance(level.players[0].origin, level.goto[i].origin);
					if(distance > wpDrawDistance)
					{
						continue;
					}
				}

				color = (0,0,1);
				color = colourGreen;	

				if(isdefined(level.players) && isdefined(level.players[0]))
				{
					distance = distance(level.goto[i].origin, level.players[0].origin);
					if(distance <= 50.0)
					{
						strobe = abs(sin(gettime()/10.0));
						color = (color[0]*strobe,color[1]*strobe,color[2]*strobe);
					}
				}

				line(level.goto[i].origin, level.goto[i].origin + (2,2,120), color);
			} 
		}
		
		wait 0.001;
	}
}

//=========================================================================================
// P L A Y E R		S P A W N S
//=========================================================================================

////////////////////////////////////////////////////////////
// Adds a player spawn
////////////////////////////////////////////////////////////
AddPlayerSpawn(pos, angles)
{		
	for(i = 0; i < level.playerSpawnCount; i++)
	{
		distance = distance(level.playerSpawns[i].origin, pos);

		if(distance <= 50.0)
		{
			return;
		}
	}

	// 32 player spawns max
	if(level.playerSpawnCount < 32)
	{
		level.playerSpawns[level.playerSpawnCount] = spawnstruct();
		level.playerSpawns[level.playerSpawnCount].origin = pos;
		level.playerSpawns[level.playerSpawnCount].angles = angles;
		level.playerSpawnCount++;
		
		iprintln("Player Spawn Added"); 
	}
	else
	{
		iprintln("Player Spawn Limit Reached"); 
	}
}

////////////////////////////////////////////////////////////
// deletes a player spawn
////////////////////////////////////////////////////////////
DeletePlayerSpawn(pos)
{ 
	for(i = 0; i < level.playerSpawnCount; i++)
	{
		distance = distance(level.playerSpawns[i].origin, pos);
		
		if(distance <= 50)
		{			
			//remove spawn from list
			for(x = i; x < level.playerSpawnCount-1; x++)
			{
				level.playerSpawns[x] = level.playerSpawns[x+1];
			}
			level.playerSpawnCount--;

			iprintln("Player Spawn Deleted");

			return;
		}
	}
}

////////////////////////////////////////////////////////////
// save player spawn points
////////////////////////////////////////////////////////////
SavePlayerSpawns()
{
	if(level.playerSpawnCount >= 16)
	{
		if((gettime()-level.saveSpamTimer) < 1500)
		{
			return;
		}
		level.saveSpamTimer = gettime();

		setdvar("logfile", 1);

		printInfo();
		
		scriptstart = [];
		scriptstart[0] = "load_playerspawns()";
		scriptstart[1] = "{";
		scriptstart[2] = "    level.playerSpawns = [];";
		scriptstart[3] = " ";
		
		for(i = 0; i < scriptstart.size; i++)
		{
			println(scriptstart[i]);
		}

		for(w = 0; w < level.playerSpawnCount; w++)
		{
			plyrstruct = "    level.playerSpawns[" + w + "] = spawnstruct();";
			println(plyrstruct);
		
			plyrorigin = "    level.playerSpawns[" + w + "].origin = "+ "(" + level.playerSpawns[w].origin[0] + "," + level.playerSpawns[w].origin[1] + "," + level.playerSpawns[w].origin[2] + ");";
			println(plyrorigin);

			plyrangles = "    level.playerSpawns[" + w + "].angles = "+ "(" + level.playerSpawns[w].angles[0] + "," + level.playerSpawns[w].angles[1] + "," + level.playerSpawns[w].angles[2] + ");";
			println(plyrangles);

			iprintln("Player Spawn " + (w + 1) + " Saved.");		
		}	

		scriptend = [];
		scriptend[0] = " ";
		scriptend[1] = "    level.playerSpawnCount = level.playerSpawns.size;";
		scriptend[2] = "}";
		
		for(i = 0; i < scriptend.size; i++)
		{
			println(scriptend[i]);
		} 

		setdvar("logfile", 0);
	  
		wait 1;
		iprintlnBold("^5Player Spawns Outputted To Console Log In Mod Folder.");
		wait 1;
		iprintlnBold("^5Close Game & Follow Instructions In File.");
	}
	else
	{
		wait 1;
		iprintlnBold("^5Player Spawns Not Saved.");
		wait 1;
		iprintlnBold("^5Please Create 16 Player Spawns Then Save.");
	} 
}

////////////////////////////////////////////////////////////
// draws the player spawns lines on screen
////////////////////////////////////////////////////////////
DrawPlayerSpawns()
{
	colourRed = (1,1,0);

	while(1)
	{
		if(CanDebugDraw() && isDefined(level.playerSpawns) && isDefined(level.playerSpawnCount) && level.playerSpawnCount > 0)
		{
			wpDrawDistance = 5000;

			for(i = 0; i < level.playerSpawnCount; i++)
			{
				if(isdefined(level.players) && isdefined(level.players[0]))
				{
					distance = distance(level.players[0].origin, level.playerSpawns[i].origin);
					if(distance > wpDrawDistance)
					{
						continue;
					}
				}

				color = (0,0,1);
				color = colourRed;	

				if(isdefined(level.players) && isdefined(level.players[0]))
				{
					distance = distance(level.playerSpawns[i].origin, level.players[0].origin);
					if(distance <= 50.0)
					{
						strobe = abs(sin(gettime()/10.0));
						color = (color[0]*strobe,color[1]*strobe,color[2]*strobe);
					}
				}

				line(level.playerSpawns[i].origin, level.playerSpawns[i].origin + (2,2,120), color);
			} 
			       
			//draw spawnpoints  
			DrawSpawnPoints(getentarray("mp_sab_spawn_axis", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_allies", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_axis_start", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_allies_start", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sd_spawn_attacker", "classname"), "sdS");
			DrawSpawnPoints(getentarray("mp_sd_spawn_defender", "classname"), "sdS");

			DrawSpawnPoints(getentarray("mp_dm_spawn", "classname"), "dmS");
			DrawSpawnPoints(getentarray("mp_tdm_spawn", "classname"), "tdmS");
			DrawSpawnPoints(getentarray("mp_dom_spawn", "classname"), "domS"); 
		}
		
		wait 0.001;
	}
}

//=========================================================================================
// O T H E R	U S E F U L L	F U N C T I O N S
//=========================================================================================

////////////////////////////////////////////////////////////
// can we debugdraw???
///////////////////////////////////////////////////////////
CanDebugDraw()
{
	if(level.btd_devmode != 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}

//////////////////////////////////////////////////////////// 
// static waypoint implementation
// 1. Array of waypoints, each waypoint has a type (stand, crouch, prone, camp, climb, etc), and a position on the ground.
// 2. Array of connectivity, list of children for each waypoint
// Reasoning: Easy to find closest waypoint, and traverse children using connectivity
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// converts a string into a float
////////////////////////////////////////////////////////////
atof(string)
{
	setdvar("temp_float", string);
	return getdvarfloat("temp_float");
}

////////////////////////////////////////////////////////////
// converts a string into an integer
////////////////////////////////////////////////////////////
atoi(string)
{
	setdvar("temp_int", string);
	return getdvarint("temp_int");
}

////////////////////////////////////////////////////////////
// draws the spawn points
////////////////////////////////////////////////////////////
DrawSpawnPoints(spawnpoints, code)
{
	if(isdefined(spawnpoints))
	{
		for(i = 0; i < spawnpoints.size; i++)
		{
			spawnpoint = spawnpoints[i];
			DrawLOI(spawnpoint.origin, code);
		}
	}
}

////////////////////////////////////////////////////////////
// debug draw spawns, domination flags, hqs, bombs etc..
////////////////////////////////////////////////////////////
DrawLOI(pos, code)
{
	line(pos + (20,0,0), pos + (-20,0,0), (1,0.75, 0));
	line(pos + (0,20,0), pos + (0,-20,0), (1,0.75, 0));
	line(pos + (0,0,20), pos + (0,0,-20), (1,0.75, 0));

	Print3d(pos, code, (1,0,0), 4);
}
