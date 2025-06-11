#include btd\_dvardef;

init()
{
	level.hostname = getdvar("sv_hostname");
	if(level.hostname == "")
		level.hostname = "CoDHost";
	setdvar("sv_hostname", level.hostname);
	setdvar("ui_hostname", level.hostname);
	makedvarserverinfo("ui_hostname", "CoDHost");

	level.motd = getdvar("scr_motd");
	if(level.motd == "")
		level.motd = "";
	setdvar("scr_motd", level.motd);
	setdvar("ui_motd", level.motd);
	makedvarserverinfo("ui_motd", "");

	level.allowvote = getdvar("g_allowvote");
	if(level.allowvote == "")
		level.allowvote = "1";
	setdvar("g_allowvote", level.allowvote);
	setdvar("ui_allowvote", level.allowvote);
	makedvarserverinfo("ui_allowvote", "1");

//================================================================================================
// Zombotron: Override server settings for team damage..
	//level.friendlyfire = maps\mp\gametypes\_tweakables::getTweakableValue( "team", "fftype" );
	//setdvar("ui_friendlyfire", level.friendlyfire);
	//makedvarserverinfo("ui_friendlyfire", "0");

	level.friendlyfire = 0;
	setdvar("ui_friendlyfire", level.friendlyfire);
	makedvarserverinfo("ui_friendlyfire", "0");
//================================================================================================

	if(getdvar("scr_mapsize") == "")
		setdvar("scr_mapsize", "64");
	else if(getdvarFloat("scr_mapsize") >= 64)
		setdvar("scr_mapsize", "64");
	else if(getdvarFloat("scr_mapsize") >= 32)
		setdvar("scr_mapsize", "32");
	else if(getdvarFloat("scr_mapsize") >= 16)
		setdvar("scr_mapsize", "16");
	else
		setdvar("scr_mapsize", "8");
	level.mapsize = getdvarFloat("scr_mapsize");

//================================================================================================
// Zombotron: Added variables
	level.allowragdoll = 1;
	level.btdz_version_string = "BTDz v16.2";

	setDvar( "_ModVer", "v16.2" );
	setDvar( "_Mod", "BTD Zombotron" );
	setDvar( "_ModUpdate", "September 2, 2010" );

	// For add to favorites.
	game["server_address"] = getDvar("net_ip") + ":" + getDvar("net_port");

	setDvar("scr_spawnsimple", 1);

	level.btd_g_speed = createdvar("btd_g_speed",190,0,500,"int");
	setDvar("g_speed", level.btd_g_speed);

	// Handled by maps\mp\gametypes\_weapons.gsc
	level.infinite_ammo = createdvar("btd_infinite_ammo",0,0,1,"int");

	//_rank.gsc
	createdvar("btd_disable_xpgains",0,0,1,"int");

	level.markernum = createdvar("btd_numzomsmarker",5,0,10,"int");

	level.killsprees = createdvar("btd_killsprees",1,0,1,"int");
	level.multikill = createdvar("btd_multikill",1,0,1,"int");
	level.painsounds = createdvar("btd_painsounds",75,0,100,"int");
	level.deathsounds = createdvar("btd_deathsounds",75,0,100,"int");
	level.death_messages = createdvar("btd_deathmessages",0,0,1,"int");

	level.btdcustomhealth = createdvar("btd_customhealth",1,0,1,"int");
	level.btdplayerhealth = createdvar("btd_playerhealth",100,50,500,"int");
	level.btd_healthRegen = createdvar("btd_healthregen",5,0,100,"int");

	level.unlock_attachment = createdvar("btd_unlock_attachment_rank",49,1,69,"int");
	level.unlock_camo = createdvar("btd_unlock_camo_rank",59,1,69,"int");
	level.unlock_gold = createdvar("btd_unlock_gold_rank",64,1,69,"int");

	//_globallogic.gsc
	createdvar("btd_auto_promotion",0,0,1,"int");
	createdvar("btd_auto_promotion_rank",44,10,64,"int");
	createdvar("btd_remove_hardpoint_on_death",0,0,1,"int");

	level.special_weapons_menu = createdvar("btd_special_weapons_menu",1,0,1,"int");
	level.special_weapons_grace_only = createdvar("btd_special_weapons_grace_only",1,0,1,"int");

	//Special weapons names so if server admins change weapons, special weapons menu will reflect this.
	// These are used by _weap_award.gsc, _buymenu_dvars.gsc and specweapons.menu
	if(getdvar( "btd_special1_weap_name" ) == "")
	{ setdvar("btd_special1_weap_name", "^1M^021 ^1Sile^0nced"); }
	if(getdvar( "btd_special2_weap_name" ) == "")
	{ setdvar("btd_special2_weap_name", "^1P^0o^1PP^0i^1N ^1S^0hotty"); }
	if(getdvar( "btd_special3_weap_name" ) == "")
	{ setdvar("btd_special3_weap_name", "^1HaC^0kEr ^1M^04"); }
	if(getdvar( "btd_special4_weap_name" ) == "")
	{ setdvar("btd_special4_weap_name", "^1S^0moking ^1A^0ce ^1P^090"); }
	if(getdvar( "btd_special5_weap_name" ) == "")
	{ setdvar("btd_special5_weap_name", "^1Death ^0Dealer"); }
	if(getdvar( "btd_special6_weap_name" ) == "")
	{ setdvar("btd_special6_weap_name", "^1Mi^0ni^1gu^0n"); }

	waitTime = createdvar("btd_zom_attack_wait_time",2,1,3,"int");		
	if(waitTime == 1)
	{
		level.zom_attack_wait_time = 0.05;
	}
	else if(waitTime == 2)
	{
		level.zom_attack_wait_time = 0.1;
	}
	else
	{
		level.zom_attack_wait_time = 0.2;
	}
	// Server info screen
	level.btd_welcome_enable = createdvar("btd_welcome_enable",1,0,1,"int");
	level.random_zom_spawns = 1;
//================================================================================================

	constrainGameType(getdvar("g_gametype"));
	constrainMapSize(level.mapsize);

	for(;;)
	{
		updateServerSettings();
		wait 5;
	}
}

updateServerSettings()
{
	sv_hostname = getdvar("sv_hostname");
	if(level.hostname != sv_hostname)
	{
		level.hostname = sv_hostname;
		setdvar("ui_hostname", level.hostname);
	}

	scr_motd = getdvar("scr_motd");
	if(level.motd != scr_motd)
	{
		level.motd = scr_motd;
		setdvar("ui_motd", level.motd);
	}

	g_allowvote = getdvar("g_allowvote");
	if(level.allowvote != g_allowvote)
	{
		level.allowvote = g_allowvote;
		setdvar("ui_allowvote", level.allowvote);
	}
/*
	scr_friendlyfire = maps\mp\gametypes\_tweakables::getTweakableValue( "team", "fftype" );
	if(level.friendlyfire != scr_friendlyfire)
	{
		level.friendlyfire = scr_friendlyfire;
		setdvar("ui_friendlyfire", level.friendlyfire);
	}
*/
}

constrainGameType(gametype)
{
	entities = getentarray();
	for(i = 0; i < entities.size; i++)
	{
		entity = entities[i];
		
		if(gametype == "dm")
		{
			if(isdefined(entity.script_gametype_dm) && entity.script_gametype_dm != "1")
			{
				//iprintln("DELETED(GameType): ", entity.classname);
				entity delete();
			}
		}
		else if(gametype == "tdm")
		{
			if(isdefined(entity.script_gametype_tdm) && entity.script_gametype_tdm != "1")
			{
				//iprintln("DELETED(GameType): ", entity.classname);
				entity delete();
			}
		}
		else if(gametype == "ctf")
		{
			if(isdefined(entity.script_gametype_ctf) && entity.script_gametype_ctf != "1")
			{
				//iprintln("DELETED(GameType): ", entity.classname);
				entity delete();
			}
		}
		else if(gametype == "hq")
		{
			if(isdefined(entity.script_gametype_hq) && entity.script_gametype_hq != "1")
			{
				//iprintln("DELETED(GameType): ", entity.classname);
				entity delete();
			}
		}
		else if(gametype == "sd")
		{
			if(isdefined(entity.script_gametype_sd) && entity.script_gametype_sd != "1")
			{
				//iprintln("DELETED(GameType): ", entity.classname);
				entity delete();
			}
		}
		else if(gametype == "koth")
		{
			if(isdefined(entity.script_gametype_koth) && entity.script_gametype_koth != "1")
			{
				//iprintln("DELETED(GameType): ", entity.classname);
				entity delete();
			}
		}
	}
}

constrainMapSize(mapsize)
{
	entities = getentarray();
	for(i = 0; i < entities.size; i++)
	{
		entity = entities[i];
		
		if(int(mapsize) == 8)
		{
			if(isdefined(entity.script_mapsize_08) && entity.script_mapsize_08 != "1")
			{
				//iprintln("DELETED(MapSize): ", entity.classname);
				entity delete();
			}
		}
		else if(int(mapsize) == 16)
		{
			if(isdefined(entity.script_mapsize_16) && entity.script_mapsize_16 != "1")
			{
				//iprintln("DELETED(MapSize): ", entity.classname);
				entity delete();
			}
		}
		else if(int(mapsize) == 32)
		{
			if(isdefined(entity.script_mapsize_32) && entity.script_mapsize_32 != "1")
			{
				//iprintln("DELETED(MapSize): ", entity.classname);
				entity delete();
			}
		}
		else if(int(mapsize) == 64)
		{
			if(isdefined(entity.script_mapsize_64) && entity.script_mapsize_64 != "1")
			{
				//iprintln("DELETED(MapSize): ", entity.classname);
				entity delete();
			}
		}
	}
}