/*-----------------------------------------------------------------------------------------------------
	Ravir's cvardef for vCOD, with modifications by Bell and Number7
	Revised for COD4 by Tally
-------------------------------------------------------------------------------------------------------*/

GetPlainMapRotation(number)
{
	return GetMapRotation(false, false, number);
}

GetRandomMapRotation()
{
	return GetMapRotation(true, false, undefined);
}

GetCurrentMapRotation(number)
{
	return GetMapRotation(false, true, number);
}

GetMapRotation(random, current, number)
{
	maprot = "";

	if(!isdefined(number))
		number = 0;

	// Get current maprotation
	if(current)
		maprot = strip(getDvar("sv_maprotationcurrent"));	

	// Get maprotation if current empty or not the one we want
//	if(level.awe_debug) iprintln("(cvar)maprot: " + getDvar("sv_maprotation").size);

	if(maprot == "") maprot = strip(getDvar("sv_maprotation"));	
		
//	if(level.awe_debug) iprintln("(var)maprot: " + maprot.size);

	// No map rotation setup!
	if(maprot == "")
		return undefined;
	j=0;
	temparr2[j] = "";	
	for(i=0;i<maprot.size;i++)
	{
		if(maprot[i]==" ")
		{
			j++;
			temparr2[j] = "";
		}
		else
			temparr2[j] += maprot[i];
	}

	// Remove empty elements (double spaces)
	temparr = [];
	for(i=0;i<temparr2.size;i++)
	{
		element = strip(temparr2[i]);
		if(element != "")
		{
		//	if(level.awe_debug) iprintln("maprot" + temparr.size + ":" + element);
			temparr[temparr.size] = element;
		}
	}

	// Spawn entity to hold the array
	x = spawn("script_origin",(0,0,0));

	x.maps = [];
	lastexec = undefined;
	lastgt = level.gametype;
	for(i=0;i<temparr.size;)
	{
		switch(temparr[i])
		{
			case "exec":
				if(isdefined(temparr[i+1]))
					lastexec = temparr[i+1];
				i += 2;
				break;

			case "gametype":
				if(isdefined(temparr[i+1]))
					lastgt = temparr[i+1];
				i += 2;
				break;

			case "map":
				if(isdefined(temparr[i+1]))
				{
					x.maps[x.maps.size]["exec"]		= lastexec;
					x.maps[x.maps.size-1]["gametype"]	= lastgt;
					x.maps[x.maps.size-1]["map"]	= temparr[i+1];
				}
				// Only need to save this for random rotations
				if(!random)
				{
					lastexec = undefined;
					lastjeep = undefined;
					lasttank = undefined;
					lastgt = undefined;
				}

				i += 2;
				break;

			// If code get here, then the maprotation is corrupt so we have to fix it
			default:
				iprintlnbold( "BTDz: Error in Map Rotation" );
	
				if(isGametype(temparr[i]))
					lastgt = temparr[i];
				else if(isConfig(temparr[i]))
					lastexec = temparr[i];
				else
				{
					x.maps[x.maps.size]["exec"]		= lastexec;
					x.maps[x.maps.size-1]["gametype"]	= lastgt;
					x.maps[x.maps.size-1]["map"]	= temparr[i];
	
					// Only need to save this for random rotations
					if(!random)
					{
						lastexec = undefined;
						lastjeep = undefined;
						lasttank = undefined;
						lastgt = undefined;
					}
				}
					

				i += 1;
				break;
		}
		if(number && x.maps.size >= number)
			break;
	}

	if(random)
	{
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
	}

	return x;
}

isConfig(cfg)
{
	temparr = explode(cfg,".");
	if(temparr.size == 2 && temparr[1] == "cfg")
		return true;
	else
		return false;
}

isGametype(gt)
{
	switch(gt)
	{
		case "elim":
		case "ons":
		case "sur":
		case "dm":
		case "war":
		case "sd":
		case "dom":
		case "koth":
		case "sab":
		case "ctfb":
		case "htf":
		case "ctf":
			return true;

		default:
			return false;
	}
}

getGametypeName(gt)
{
	switch(gt)
	{
		
		case "war":
			gtname = "Team Deathmatch";
			break;

		case "sd":
			gtname = "Search & Destroy";
			break;

		case "koth":
			gtname = "Headquarters";
			break;

		case "dom":
			gtname = "Domination";
			break;
			
		case "sab":
			gtname = "Sabotage";
			break;

		case "ctfb":
			gtname = "Capture the Flag (back)";
			break;
		
		case "htf":
			gtname = "Hold the Flag";
			break;

		case "ctf":
			gtname = "Capture the Flag";
			break;

		case "elim":
			gtname = "Elimination";
			break;

		case "ons":
			gtname = "Onslaught";
			break;

		case "sur":
			gtname = "Survival";
			break;

		default:
			gtname = gt;
			break;
	}

	return gtname;
}

getMapName(map)
{
	switch(map)
	{
		case "mp_backlot":
			mapname = "Backlot";
			break;
	
		case "mp_broadcast":
			mapname = "Broadcast";
			break;

		case "mp_bloc":
			mapname = "Bloc";
			break;

		case "mp_bog":
			mapname = "Bog";
			break;

		case "mp_cargoship":
			mapname = "Wet Work";
			break;

		case "mp_carentan":
			mapname = "Chinatown";
			break;

		case "mp_convoy":
			mapname = "Ambush";
			break;
		
		case "mp_crash":
			mapname = "Crash";
			break;

		case "mp_crash_snow":
			mapname = "Winter Crash";
			break;

		case "mp_creek":
			mapname = "Creek";
			break;

		case "mp_crossfire":
			mapname = "Crossfire";
			break;

		case "mp_farm":
			mapname = "Farm";
			break;

		case "mp_killhouse":
			mapname = "Killhouse";
			break;

		case "mp_overgrown":
			mapname = "Overgrown";
			break;

		case "mp_pipeline":
			mapname = "Pipeline";
			break;
		
		case "mp_shipment":
			mapname = "Shipment";
			break;

		case "mp_showdown":
			mapname = "Showdown";
			break;

		case "mp_strike":
			mapname = "Strike";
			break;

		case "mp_vacant":
			mapname = "Vacant";
			break;

		case "mp_ava_crossroads":
			mapname = "The Crossroads";
			break;

		case "mp_ctan":
			mapname = "Carentan";
			break;

		case "mp_hhk_ballroom":
			mapname = "Ballroom";
			break;

		case "mp_lolv2":
			mapname = "MOHAA Lol V2";
			break;

		case "mp_scrap":
			mapname = "Scrap Yard";
			break;

		case "mp_sbase":
			mapname = "Sub Base";
			break;

		case "mp_v2_b1":
			mapname = "V2 Beta 1";
			break;

		default:
			mapname = map;
			break;
	}

	return mapname;
}

explode(s,delimiter)
{
	j=0;
	temparr[j] = "";	

	for(i=0;i<s.size;i++)
	{
		if(s[i]==delimiter)
		{
			j++;
			temparr[j] = "";
		}
		else
			temparr[j] += s[i];
	}
	return temparr;
}

// Strip blanks at start and end of string
strip(s)
{
	if(s=="")
		return "";

	s2="";
	s3="";

	i=0;
	while(i<s.size && s[i]==" ")
		i++;

	// String is just blanks?
	if(i==s.size)
		return "";
	
	for(;i<s.size;i++)
	{
		s2 += s[i];
	}

	i=s2.size-1;
	while(s2[i]==" " && i>0)
		i--;

	for(j=0;j<=i;j++)
	{
		s3 += s2[j];
	}
		
	return s3;
}

/*
//EDIT: Causes problems with client
execClientCommand(cmd)
{
	self setClientDvar( "ui_ex_clientcmd", cmd );
	self openMenuNoMouse( game["menu_clientcmd"] );
	self closeMenu( game["menu_clientcmd"] );
}
*/
setGlowTweaks(on, cutoff, desaturation, intensity, radius)
{
	self setClientDvars( "r_glowUseTweaks", 1, "r_glow", 1, "r_glowTweakEnable", on, "r_glowTweakBloomCutOff", cutoff, 
	"r_glowTweakBloomDesaturation", desaturation, "r_glowTweakBloomIntensity0", intensity, "r_glowTweakRadius0", radius );
}

setFilmTweaks(on, invert, desaturation, darktint, lighttint, brightness, contrast)
{
	self setClientDvars( "r_filmusetweaks", 1, "r_filmtweaks", 1, "r_filmtweakenable", on, "r_filmtweakinvert", invert, "r_filmtweakdesaturation", desaturation , "r_filmtweakdarktint", 
	darktint, "r_filmtweaklighttint", lighttint, "r_filmtweakbrightness", brightness, "r_filmtweakcontrast", contrast );
}

setGlowTweaksOff()
{
	self setClientDvars( "r_glowUseTweaks", 0 );
}

setFilmTweaksOff()
{
	self setClientDvars( "r_filmusetweaks", 0 );
}

vecscale(vec, scalar)
{
	return (vec[0]*scalar, vec[1]*scalar, vec[2]*scalar);
}

abs( test )
{
	if( 0 > test )
	{
		test = test * -1;
	}
	return test;
}

absminus( arg1, arg2 )
{
	if( arg1 - arg2 < 0 )
		value = arg2 - arg1;
	else
		value = arg1 - arg2;
	return value;
}

sqrt( m )
{
	x2 = 0;
	i = 0;
	while( (i*i) <= m )
	{
		i += 0.1;
	}
	x1 = i;
	for( j = 0; j < 10; j++ )
	{
		x2 = m;
		x2 /= x1;
		x2 += x1;
		x2 /= 2;
		x1 = x2;
	}
	return x2;
}

isodd( test )
{
	if( test % 2 )
		return true;
	else
		return false;
}

//******************************************************************************
//  _____                  _    _             __
// |  _  |                | |  | |           / _|
// | | | |_ __   ___ _ __ | |  | | __ _ _ __| |_ __ _ _ __ ___
// | | | | '_ \ / _ \ '_ \| |/\| |/ _` | '__|  _/ _` | '__/ _ \
// \ \_/ / |_) |  __/ | | \  /\  / (_| | |  | || (_| | | |  __/
//  \___/| .__/ \___|_| |_|\/  \/ \__,_|_|  |_| \__,_|_|  \___|
//       | |               We don't make the game you play.
//       |_|                 We make the game you play BETTER.
//
//            Website: http://openwarfaremod.com/
//******************************************************************************
_disableSprint()
{
   if ( !isDefined( self.disabledSprint ) )
      self.disabledSprint = 0;
      
   self.disabledSprint++;
   self allowSprint(false);
}

_enableSprint()
{
   if ( !isDefined( self.disabledSprint ) )
      self.disabledSprint = 0;

   self.disabledSprint--;

   if ( self.disabledSprint <= 0 ) {
      self.disabledSprint = 0;
      self allowSprint(true);
   }
}


_disableJump()
{
   if ( !isDefined( self.disabledJump ) )
      self.disabledJump = 0;
      
   self.disabledJump++;
   self allowJump(false);
}

_enableJump()
{
   if ( !isDefined( self.disabledJump ) )
      self.disabledJump = 0;

   self.disabledJump--;

   if ( self.disabledJump <= 0 ) {
      self.disabledJump = 0;
      self allowJump(true);
   }
}