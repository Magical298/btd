#include btd\_dvardef;

init()
{
	game["menu_admin"] = "admin";
	game["menu_admintwo"] = "admintwo";
	game["menu_admin_player"] = "bxmod_admin";
	game["menu_client"] = "client";
	game["level.menu_fogsettings"] = "fogsettings";
	game["menu_quickmessageold"] = "quickmessage";
	game["menu_music"] = "music";
	game["menu_specweapons"] = "specweapons";
	game["menu_visionsettings"] = "visionsettings";
	game["menu_dev"] = "btddev";

	precacheMenu(game["menu_admin"]);
	precacheMenu(game["menu_admintwo"]);
	precacheMenu(game["menu_admin_player"]);
	precacheMenu(game["menu_client"]);
	precacheMenu(game["level.menu_fogsettings"]);
	precacheMenu(game["menu_quickmessageold"]);
	precacheMenu(game["menu_music"]);
	precacheMenu(game["menu_specweapons"]);
	precacheMenu(game["menu_visionsettings"]);
	precacheMenu(game["menu_dev"]);

	level.can_discard_weapon = createdvar("btd_can_discard_weapons",0,0,1,"int");
	level.showcrosshair = true;

	level.special1_rank = createdvar("btd_special1_rank",39,0,69,"int");
	level.special2_rank = createdvar("btd_special2_rank",44,0,69,"int");
	level.special3_rank = createdvar("btd_special3_rank",49,0,69,"int");
	level.special4_rank = createdvar("btd_special4_rank",54,0,69,"int");
	level.special5_rank = createdvar("btd_special5_rank",59,0,69,"int");
	level.special6_rank = createdvar("btd_special6_rank",64,0,69,"int");

	wait( 0.15 );

	level.s_rank1_name = (1 + level.special1_rank);
	level.s_rank2_name = (1 + level.special2_rank);
	level.s_rank3_name = (1 + level.special3_rank);
	level.s_rank4_name = (1 + level.special4_rank);
	level.s_rank5_name = (1 + level.special5_rank);
	level.s_rank6_name = (1 + level.special6_rank);
}

onMenuResponse()
{
	self endon("disconnect");
	
	// 3rd person
	self setClientDvar("cg_thirdperson", 0);
	self.thirdperson = false;
	
	// laser
	self setClientDvar("cg_laserforceon", 0);
	self.laseron = false;	
	
	// croshair
	self setClientDvar("cg_drawcrosshair", 1);
	self.crosshairon = true;
	
	// field of view
	//self setClientDvar("cg_fov", "65");
	self.maxfov = false;

	for(;;)
	{
		self waittill("menuresponse", menu, response);

		switch(menu)
		{
			case "quickmessage":
				self btd_menus\ingame_menu\_main_menu_response::mainMenuResponse(response);
			break;

			case "btddev":
				if( self.isdev )
				{ self btd_menus\ingame_menu\_dev_menu_response::devMenuResponse(response); }
				else
				{ self iprintlnbold("Access to this feature is denied."); }	
			break;

			case "client":
				self btd_menus\ingame_menu\_client_menu_response::clientMenuResponse(response);
			break;

			case "admin":
				if( self.isadmin )
				{ self btd_menus\ingame_menu\_admin_menu_response::adminMenuResponse(response); }		
				else
				{ self iprintlnbold("Access to this feature is denied."); }		
			break;

			case "bxmod_admin":
				if( self.isadmin )
				{ self btd_menus\ingame_menu\_admin_menu_response::bxAdminOnMenuResponse(response); }		
				else
				{ self iprintlnbold("Access to this feature is denied."); }		
			break;

			case "admintwo":
				if( self.isadmin )
				{ self btd_menus\ingame_menu\_admin_menu_response::adminTwoMenuResponse(response); }		
				else
				{ self iprintlnbold("Access to this feature is denied."); }		
			break;
			case "fogsettings":
				self btd_menus\ingame_menu\_fog_menu_response::fogMenuResponse(response);
			break;

			case "specweapons":
				if( level.special_weapons_menu )
				{ self btd_menus\ingame_menu\_specweapons_menu_response::specialMenuResponse(response); }
				else
				{ self iprintlnbold("Access to this feature is disabled."); }	
			break;

			case "visionsettings":
				self btd_menus\ingame_menu\_vision_menu_response::visionMenuResponse(response);
			break;

			case "music":
				self btd_menus\ingame_menu\_music_menu_response::musicMenuResponse(response);
			break;
		}
	}
}
