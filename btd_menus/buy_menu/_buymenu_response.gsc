#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include btd\_dvardef;

init()
{
	if( level.btd_devmode != 0 || level.traderon == 0 )
		return;

	thread btd_menus\buy_menu\_buymenu_dvars::createValues();

	game["menu_buymenu"] = "buymenu";
	game["menu_trade_list"] = "tradelist";

	precacheMenu(game["menu_buymenu"]);
	precacheMenu(game["menu_trade_list"]);

	if(getdvar("btd_secondary_weap_count") == "")
		setdvar("btd_secondary_weap_count",1);

	if(getdvar("btd_primary_weap_count") == "")
		setdvar("btd_primary_weap_count",2);

	if(getDvar("btd_startmoney")== "")
		setDvar("btd_startmoney", 2000);
}

onMenuResponse()
{
	self endon("disconnect");
	self.totalweaponsprimary = 1;
	self.totalweaponssecondary = 1;
	self.startmoney = getDvarInt("btd_startmoney");
	self.startbudget = self.startmoney;
	self.money = self.startbudget;
	self setClientDvar( "ui_player_money", self.money );

	self.allowedweapons = getdvarint("btd_primary_weap_count");
	self.allowedweapons2 = getdvarint("btd_secondary_weap_count");

	price = 0;
	self.tradeMenu = "buymenu";
	while(1)
	{
		self waittill("menuresponse", menu, response);

		self setClientDvar( "ui_player_money", self.money );

		if(menu == game["menu_buymenu"])
		{
			switch(response)
			{
				case "pistol":
					self.tradeMenu = "pistol";
					self setClientDvars("ui_trade_item_1", ("^1[^7M9 Beretta^1]^7 - " + level.trade_m9_price), 
						"ui_trade_item_2", ("^1[^7USP^1]^7 - " + level.trade_usp_price), 
						"ui_trade_item_3", ("^1[^7Colt 45^1]^7 - " + level.trade_colt_price), 
						"ui_trade_item_4", ("^1[^7Desert Eagle^1]^7 - " + level.trade_eagle_price), 
						"ui_trade_item_5", ("^1[^7Desert Eagle Gold^1]^7 - " + level.trade_eaglegold_price),
						"ui_trade_item_6", ("^1[^7" + getDvar("btd_special5_weap_name") + "^1]^7 - " + level.trade_special5_price),
						"ui_trade_item_7", "",
						"ui_trade_item_8", "",
						"ui_trade_item_9", "",
						"ui_trade_item_10", "",
						"ui_trade_item_11", "",
						"ui_trade_item_12", "",
						"ui_trade_item_13", "",
						"ui_trade_item_14", "",
						"ui_trade_item_15", "");
					wait 0.25;
					self openMenu(game["menu_trade_list"]);					
				break;

				case "smg":
					self.tradeMenu = "smg";
					self setClientDvars("ui_trade_item_1", ("^1[^7MP5^1]^7 - " + level.trade_mp5_price), 
						"ui_trade_item_2", ("^1[^7Skorpian^1]^7 - " + level.trade_skorp_price), 
						"ui_trade_item_3", ("^1[^7Mini Uzi^1]^7 - " + level.trade_uzi_price), 
						"ui_trade_item_4", ("^1[^7AK74u^1]^7 - " + level.trade_ak74u_price), 
						"ui_trade_item_5", ("^1[^7P90^1]^7 - " + level.trade_p90_price),
						"ui_trade_item_6", ("^1[^7" + getDvar("btd_special4_weap_name") + "^1]^7 - " + level.trade_special4_price),
						"ui_trade_item_7", "",
						"ui_trade_item_8", "",
						"ui_trade_item_9", "",
						"ui_trade_item_10", "",
						"ui_trade_item_11", "",
						"ui_trade_item_12", "",
						"ui_trade_item_13", "",
						"ui_trade_item_14", "",
						"ui_trade_item_15", "");
					wait 0.25;
					self openMenu(game["menu_trade_list"]);
				break;

				case "assault":
					self.tradeMenu = "assault";
					self setClientDvars("ui_trade_item_1", ("^1[^7M16^1]^7 - " + level.trade_m16_price), 
						"ui_trade_item_2", ("^1[^7AK47^1]^7 - " + level.trade_ak47_price), 
						"ui_trade_item_3", ("^1[^7M4^1]^7 - " + level.trade_m4_price), 
						"ui_trade_item_4", ("^1[^7G3^1]^7 - " + level.trade_g3_price), 
						"ui_trade_item_5", ("^1[^7G36C^1]^7 - " + level.trade_g36c_price),
						"ui_trade_item_6", ("^1[^7M14^1]^7 - " + level.trade_m14_price),
						"ui_trade_item_7", ("^1[^7MP44^1]^7 - " + level.trade_mp44_price),
						"ui_trade_item_8", ("^1[^7" + getDvar("btd_special3_weap_name") + "^1]^7 - " + level.trade_special3_price),
						"ui_trade_item_9", "",
						"ui_trade_item_10", "",
						"ui_trade_item_11", "",
						"ui_trade_item_12", "",
						"ui_trade_item_13", "",
						"ui_trade_item_14", "",
						"ui_trade_item_15", "");
					wait 0.25;
					self openMenu(game["menu_trade_list"]);
				break;

				case "lmgmenu":
					self.tradeMenu = "lmgmenu";
					self setClientDvars("ui_trade_item_1", ("^1[^7SAW^1]^7 - " + level.trade_saw_price), 
						"ui_trade_item_2", ("^1[^7RPD^1]^7 - " + level.trade_rpd_price), 
						"ui_trade_item_3", ("^1[^7M60E4^1]^7 - " + level.trade_m60_price),
						"ui_trade_item_4", ("^1[^7" + getDvar("btd_special6_weap_name") + "^1]^7 - " + level.trade_special6_price),
						"ui_trade_item_5", "",
						"ui_trade_item_6", "",
						"ui_trade_item_7", "",
						"ui_trade_item_8", "",
						"ui_trade_item_9", "",
						"ui_trade_item_10", "",
						"ui_trade_item_11", "",
						"ui_trade_item_12", "",
						"ui_trade_item_13", "",
						"ui_trade_item_14", "",
						"ui_trade_item_15", "");
					wait 0.25;
					self openMenu(game["menu_trade_list"]);					
				break;

				case "shotgun":
					self.tradeMenu = "shotgun";
					self setClientDvars("ui_trade_item_1", ("^1[^7W1200^1]^7 - " + level.trade_w1200_price), 
						"ui_trade_item_2", ("^1[^7M1014^1]^7 - " + level.trade_m1014_price),
						"ui_trade_item_3", ("^1[^7" + getDvar("btd_special2_weap_name") + "^1]^7 - " + level.trade_special2_price),
						"ui_trade_item_4", "", 
						"ui_trade_item_5", "",
						"ui_trade_item_6", "",
						"ui_trade_item_7", "",
						"ui_trade_item_8", "",
						"ui_trade_item_9", "",
						"ui_trade_item_10", "",
						"ui_trade_item_11", "",
						"ui_trade_item_12", "",
						"ui_trade_item_13", "",
						"ui_trade_item_14", "",
						"ui_trade_item_15", "");
					wait 0.25;
					self openMenu(game["menu_trade_list"]);
				break;

				case "sniper":
					self.tradeMenu = "sniper";
					self setClientDvars("ui_trade_item_1", ("^1[^7M40A3^1]^7 - " + level.trade_m40a3_price), 
						"ui_trade_item_2", ("^1[^7M21^1]^7 - " + level.trade_m21_price), 
						"ui_trade_item_3", ("^1[^7Dragunov^1]^7 - " + level.trade_drag_price), 
						"ui_trade_item_4", ("^1[^7Remington 700^1]^7 - " + level.trade_r700_price), 
						"ui_trade_item_5", ("^1[^7Barrett M82^1]^7 - " + level.trade_m82_price),
						"ui_trade_item_6", ("^1[^7" + getDvar("btd_special1_weap_name") + "^1]^7 - " + level.trade_special1_price),
						"ui_trade_item_7", "",
						"ui_trade_item_8", "",
						"ui_trade_item_9", "",
						"ui_trade_item_10", "",
						"ui_trade_item_11", "",
						"ui_trade_item_12", "",
						"ui_trade_item_13", "",
						"ui_trade_item_14", "",
						"ui_trade_item_15", "");
					wait 0.25;
					self openMenu(game["menu_trade_list"]);
				break;

				case "grenade":
					self.tradeMenu = "grenade";
					self setClientDvars("ui_trade_item_1", ("^1[^72x M2 Frag Grenade^1]^7 - " + level.trade_grenade_price), 
						"ui_trade_item_2", ("^1[^72x Flare Grenade^1]^7 - " + level.trade_grenade_price),
						"ui_trade_item_3", ("^1[^72x Gas Grenade^1]^7 - " + level.trade_grenade_price),
						"ui_trade_item_4", ("^1[^72x Blood Grenade^1]^7 - " + level.trade_grenade_price), 
						"ui_trade_item_5", "",
						"ui_trade_item_6", "",
						"ui_trade_item_7", "",
						"ui_trade_item_8", "",
						"ui_trade_item_9", "",
						"ui_trade_item_10", "",
						"ui_trade_item_11", "",
						"ui_trade_item_12", "",
						"ui_trade_item_13", "",
						"ui_trade_item_14", "",
						"ui_trade_item_15", "");
					wait 0.25;
					self openMenu(game["menu_trade_list"]);
				break;

				case "inventory":
					self.tradeMenu = "inventory";
					self setClientDvars("ui_trade_item_1", ("^1[^7C4^1]^7 - "+ level.trade_inventory_price),
						"ui_trade_item_2", ("^1[^7Claymore^1]^7 - "+ level.trade_inventory_price),
						"ui_trade_item_3", ("^1[^7RPG^1]^7 - "+ level.trade_inventory_price),
						"ui_trade_item_4", "", 
						"ui_trade_item_5", "",
						"ui_trade_item_6", "",
						"ui_trade_item_7", "",
						"ui_trade_item_8", "",
						"ui_trade_item_9", "",
						"ui_trade_item_10", "",
						"ui_trade_item_11", "",
						"ui_trade_item_12", "",
						"ui_trade_item_13", "",
						"ui_trade_item_14", "",
						"ui_trade_item_15", "");
					wait 0.25;
					self openMenu(game["menu_trade_list"]);
				break;

				case "attachment":
					self.tradeMenu = "attachment";
					self setClientDvars("ui_trade_item_1", ("^1[^7Red Dot Sight^1]^7 - " + level.trade_reddot_price), 
						"ui_trade_item_2", ("^1[^7ACOG Scope^1]^7 - " + level.trade_acog_price), 
						"ui_trade_item_3", ("^1[^7Silencer^1]^7 - " + level.trade_silencer_price), 
						"ui_trade_item_4", ("^1[^7Grenade Launcher^1]^7 - " + level.trade_gl_price), 
						"ui_trade_item_5", ("^1[^7Grip^1]^7 - " + level.trade_grip_price),
						"ui_trade_item_6", "",
						"ui_trade_item_7", "",
						"ui_trade_item_8", "",
						"ui_trade_item_9", "",
						"ui_trade_item_10", "",
						"ui_trade_item_11", "",
						"ui_trade_item_12", "",
						"ui_trade_item_13", "",
						"ui_trade_item_14", "",
						"ui_trade_item_15", "");
					wait 0.25;
					self openMenu(game["menu_trade_list"]);
				break;

				case "hardpoints":
					self.tradeMenu = "hardpoints";
					self setClientDvars("ui_trade_item_1", ("^1[^7Helicopter^1]^7 - " + level.trade_helicopter_price), 
						"ui_trade_item_2", ("^1[^7Airstrike^1]^7 - " + level.trade_airstrike_price), 
						"ui_trade_item_3", ("^1[^7Artillery^1]^7 - " + level.trade_artillery_price), 
						"ui_trade_item_4", ("^1[^7Blackhawk^1]^7 - " + level.trade_blackhawk_price), 
						"ui_trade_item_5", ("^1[^7AC 130^1]^7 - " + level.trade_ac130_price),
						"ui_trade_item_6", ("^1[^7Napalm Strike^1]^7 - " + level.trade_napalm_price),
						"ui_trade_item_7", ("^1[^7Wrath of Zod^1]^7 - " + level.trade_woz_price),
						"ui_trade_item_8", ("^1[^7Tactical Nuke^1]^7 - " + level.trade_nuke_price),
						"ui_trade_item_9", "",
						"ui_trade_item_10", "",
						"ui_trade_item_11", "",
						"ui_trade_item_12", "",
						"ui_trade_item_13", "",
						"ui_trade_item_14", "",
						"ui_trade_item_15", "");
					wait 0.25;
					self openMenu(game["menu_trade_list"]);
				break;

				case "perksmenu":
					self.tradeMenu = "perksmenu";
					self setClientDvars("ui_trade_item_1", ("^1[^7Bandolier^1] ^7 - " + level.trade_perk_price), 
						"ui_trade_item_2", ("^1[^7Frag x3^1] ^7 - " + level.trade_perk_price),
						"ui_trade_item_3", ("^1[^7Special Grenades x3^1] ^7 - " + level.trade_perk_price),
						"ui_trade_item_4", ("^1[^7Juggernaut^1] ^7 - " + level.trade_perk_price),
						"ui_trade_item_5", ("^1[^7Stopping Power^1] ^7 - " + level.trade_perk_price),
						"ui_trade_item_6", ("^1[^7Deep Impact^1] ^7 - " + level.trade_perk_price),
						"ui_trade_item_7", ("^1[^7Double Tap^1] ^7 - " + level.trade_perk_price),
						"ui_trade_item_8", ("^1[^7Sleight Of Hand^1] ^7 - " + level.trade_perk_price),
						"ui_trade_item_9", ("^1[^7Steady Aim^1] ^7 - " + level.trade_perk_price),
						"ui_trade_item_10", ("^1[^7UAV Jammer^1] ^7 - " + level.trade_perk_price),
						"ui_trade_item_11", ("^1[^7Extreme Conditioning^1] ^7 - " + level.trade_perk_price),
						"ui_trade_item_12", ("^1[^7Sonic Boom^1] ^7 - " + level.trade_perk_price),
						"ui_trade_item_13", ("^1[^7Last Stand^1] ^7 - " + level.trade_perk_price),
						"ui_trade_item_14", ("^1[^7Martydom^1] ^7 - " + level.trade_perk_price),
						"ui_trade_item_15", "");
					wait 0.25;
					self openMenu(game["menu_trade_list"]);
				break;

				case "sell":
					weapon = self getCurrentWeapon();
					price = getTradeValue(weapon);
					self thread makeWeaponSale(weapon, price);
				break;

				case "close":
					self maps\mp\gametypes\_class::replenishLoadout();
					self.buymenuopen = false;
				break;
			}
		}
		else if(menu == game["menu_trade_list"])
		{
			self thread menuTradeResponse(response, self.tradeMenu );
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

menuTradeResponse(response, menu)
{
	switch(menu)
	{
		case "pistol":
			self thread menuPistolResponse(response);
		break;

		case "smg":
			self thread menuSmgResponse(response);
		break;

		case "assault":
			self thread menuAssaultResponse(response);
		break;

		case "lmgmenu":
			self thread menuLmgResponse(response);
		break;

		case "shotgun":
			self thread menuShotgunResponse(response);;
		break;

		case "sniper":
			self thread menuSniperResponse(response);
		break;

		case "inventory":
			self thread menuInventoryResponse(response);
		break;

		case "attachment":
			self thread menuAttachmentResponse(response);
		break;

		case "grenade":
			self thread  menuGrenadeResponse(response);
		break;

		case "hardpoints":
			self thread  menuHardpointResponse(response);
		break;

		case "perksmenu":
			self thread  menuPerkResponse(response);
		break;
	}
}

menuPistolResponse(response)
{
	selectedweapon = undefined;
	price  = undefined;

	if(response == "1")
	{
		selectedweapon = "beretta_mp";
		price = level.trade_m9_price;
	}
	else if(response == "2")
	{
		selectedweapon = "usp_mp";
		price = level.trade_usp_price;
	}
	else if(response == "3")
	{
		selectedweapon = "colt45_mp";
		price = level.trade_colt_price;
	}
	else if(response == "4")
	{
		selectedweapon = "deserteagle_mp";
		price = level.trade_eagle_price;
	}
	else if(response == "5")
	{
		selectedweapon = "deserteaglegold_mp";
		price = level.trade_eaglegold_price;
	}
	else if(response == "6")
	{
		selectedweapon = "special5_mp";
		price = level.trade_special5_price;
	}
	else
	{
		return;
	}

	check1 = secondaryweapon();
	check2 = enoughmoney(price);
	check3 = sameweapon(selectedweapon);
	if(check1 && check2 && check3)
		self thread giveWeaponBuy(price,selectedweapon);
}

menuLmgResponse(response)
{
	selectedweapon = undefined;
	price  = undefined;

	if(response == "1")
	{
		selectedweapon = "saw_mp";
		price = level.trade_saw_price;
	}
	else if(response == "2")
	{
		selectedweapon = "rpd_mp";
		price = level.trade_rpd_price;
	}
	else if(response == "3")
	{
		selectedweapon = "m60e4_mp";
		price = level.trade_m60_price;
	}
	else if(response == "4")
	{
		selectedweapon = "special6_mp";
		price = level.trade_special6_price;
	}
	else
	{
		return;
	}

	check1 = primaryweapon();
	check2 = enoughmoney(price);
	check3 = sameweapon(selectedweapon);
	if(check1 && check2 && check3)
		self thread giveWeaponBuy(price,selectedweapon);
}


menuAssaultResponse(response)
{
	selectedweapon = undefined;
	price  = undefined;

	if(response == "1")
	{
		selectedweapon = "m16_mp";
		price = level.trade_m16_price;
	}
	else if(response == "2")
	{
		selectedweapon = "ak47_mp";
		price = level.trade_ak47_price;
	}
	else if(response == "3")
	{
		selectedweapon = "m4_mp";
		price = level.trade_m4_price;
	}
	else if(response == "4")
	{
		selectedweapon = "g3_mp";
		price = level.trade_g3_price;
	}
	else if(response == "5")
	{
		selectedweapon = "g36c_mp";
		price = level.trade_g36c_price;
	}
	else if(response == "6")
	{
		selectedweapon = "m14_mp";
		price = level.trade_m14_price;
	}
	else if(response == "7")
	{
		selectedweapon = "mp44_mp";
		price = level.trade_mp44_price;
	}
	else if(response == "8")
	{
		selectedweapon = "special3_mp";
		price = level.trade_special3_price;
	}
	else
	{
		return;
	}

	check1 = primaryweapon();
	check2 = enoughmoney(price);
	check3 = sameweapon(selectedweapon);
	if(check1 && check2 && check3)
		self thread giveWeaponBuy(price,selectedweapon);
}

menuSmgResponse(response)
{
	selectedweapon = undefined;
	price  = undefined;

	if(response == "1")
	{
		selectedweapon = "mp5_mp";
		price = level.trade_mp5_price;
	}
	else if(response == "2")
	{
		selectedweapon = "skorpion_mp";
		price = level.trade_skorp_price;
	}
	else if(response == "3")
	{
		selectedweapon = "uzi_mp";
		price = level.trade_uzi_price;
	}
	else if(response == "4")
	{
		selectedweapon = "ak74u_mp";
		price = level.trade_ak74u_price;
	}
	else if(response == "5")
	{
		selectedweapon = "p90_mp";
		price = level.trade_p90_price;
	}
	else if(response == "6")
	{
		selectedweapon = "special4_mp";
		price = level.trade_special4_price;
	}
	else
	{
		return;
	}

	check1 = primaryweapon();
	check2 = enoughmoney(price);
	check3 = sameweapon(selectedweapon);
	if(check1 && check2 && check3)
		self thread giveWeaponBuy(price,selectedweapon);
}

menuShotgunResponse(response)
{
	selectedweapon = undefined;
	price  = undefined;

	if(response == "1")
	{
		selectedweapon = "winchester1200_mp";
		price = level.trade_w1200_price;
	}
	else if(response == "2")
	{
		selectedweapon = "m1014_mp";
		price = level.trade_m1014_price;
	}
	else if(response == "3")
	{
		selectedweapon = "special2_mp";
		price = level.trade_special2_price;
	}
	else
	{
		return;
	}

	check1 = primaryweapon();
	check2 = enoughmoney(price);
	check3 = sameweapon(selectedweapon);
	if(check1 && check2 && check3)
		self thread giveWeaponBuy(price,selectedweapon);
}

menuSniperResponse(response)
{
	selectedweapon = undefined;
	price  = undefined;

	if(response == "1")
	{
		selectedweapon = "m40a3_mp";
		price  = level.trade_m40a3_price;
	}
	else if(response == "2")
	{
		selectedweapon = "m21_mp";
		price = level.trade_m21_price;
	}
	else if(response == "3")
	{
		selectedweapon = "dragunov_mp";
		price  = level.trade_drag_price;
	}
	else if(response == "4")
	{
		selectedweapon = "remington700_mp";
		price  = level.trade_r700_price;
	}
	else if(response == "5")
	{
		selectedweapon = "barrett_mp";
		price  = level.trade_m82_price;
	}
	else if(response == "6")
	{
		selectedweapon = "special1_mp";
		price  = level.trade_special1_price;
	}
	else
	{
		return;
	}

	check1 = primaryweapon();
	check2 = enoughmoney(price);
	check3 = sameweapon(selectedweapon);
	if(check1 && check2 && check3)
		self thread giveWeaponBuy(price,selectedweapon);
}
/*
menuSpecialResponse(response)
{
	selectedweapon = undefined;
	price  = undefined;

	if(response == "1")
	{
		selectedweapon = "special1_mp";
		price = level.trade_special1_price;
	}
	else if(response == "2")
	{
		selectedweapon = "special2_mp";
		price = level.trade_special2_price;
	}
	else if(response == "3")
	{
		selectedweapon = "special3_mp";
		price = level.trade_special3_price;
	}
	else if(response == "4")
	{
		selectedweapon = "special4_mp";
		price = level.trade_special4_price;
	}
	else if(response == "5")
	{
		selectedweapon = "special5_mp";
		price = level.trade_special5_price;
	}
	else if(response == "6")
	{
		selectedweapon = "special6_mp";
		price = level.trade_special6_price;
	}
	else
	{
		return;
	}

	check1 = primaryweapon();
	check2 = enoughmoney(price);
	check3 = sameweapon(selectedweapon);
	if(check1 && check2 && check3)
		self thread giveWeaponBuy(price,selectedweapon);

}
*/
menuAttachmentResponse(response)
{
	attachment = undefined;
	price  = undefined;
	weapon = self getCurrentWeapon();

	if( !isDefined(weapon) )
		return;

	if(response == "1")
	{
		attachment = "reflex";
		price = level.trade_reddot_price;
	}
	else if(response == "2")
	{
		attachment = "acog";
		price = level.trade_acog_price;
	}
	else if(response == "3")
	{
		attachment = "silencer";
		price = level.trade_silencer_price;
	}
	else if(response == "4")
	{
		attachment = "gl";
		price = level.trade_gl_price;
	}
	else if(response == "5")
	{
		attachment = "grip";
		price = level.trade_grip_price;
	}
	else
	{
		return;
	}

	check1 = enoughmoney(price);
	if(check1)
		self thread giveAttachmentBuy(price, attachment, weapon);
}

menuInventoryResponse(response)
{
	selectedweapon = undefined;
	price  = undefined;

	if(response == "1")
	{
		inventory = "c4_mp";
		price = level.trade_inventory_price;
	}
	else if(response == "2")
	{
		inventory = "claymore_mp";
		price = level.trade_inventory_price;
	}
	else if(response == "3")
	{
		inventory = "rpg_mp";
		price = level.trade_inventory_price;
	}
	else
	{
		return;
	}
	check1 = enoughmoney(price);
	check2 = sameweapon(inventory);
	if(check1 && check2)
		self thread giveInventoryBuy(price, inventory);
}

menuGrenadeResponse(response)
{
	grenade = undefined;
	price = level.trade_grenade_price;

	if(response == "1")
	{
		grenade = "frag_grenade_mp";
	}
	else if(response == "2")
	{
		grenade = "flash_grenade_mp";
	}
	else if(response == "3")
	{
		grenade = "smoke_grenade_mp";
	}
	else if(response == "4")
	{
		grenade = "concussion_grenade_mp";
	}
	else
	{
		return;
	}

	check1 = enoughmoney(price);
	if(check1)
		self thread giveGrenadeBuy(price, grenade);
}

menuHardpointResponse(response)
{
	hardpoint = undefined;
	price = undefined;

	if(response == "1")
	{
		hardpoint = "helicopter_mp";
		price = level.trade_helicopter_price;
	}
	else if(response == "2")
	{
		hardpoint = "airstrike_mp";
		price = level.trade_airstrike_price;
	}
	else if(response == "3")
	{
		hardpoint = "artillery";
		price = level.trade_artillery_price;
	}
	else if(response == "4")
	{
		hardpoint = "blackhawk_mp";
		price = level.trade_blackhawk_price;
	}
	else if(response == "5")
	{
		hardpoint = "ac130_mp";
		price = level.trade_ac130_price;
	}
	else if(response == "6")
	{
		hardpoint = "napalm_mp";
		price = level.trade_napalm_price;
	}
	else if(response == "7")
	{
		hardpoint = "radar_mp";
		price = level.trade_woz_price;
	}
	else if(response == "8")
	{
		hardpoint = "nuke_mp";
		price = level.trade_nuke_price;
	}
	else
	{
		return;
	}

	check1 = enoughmoney(price);
	check2 = sameweapon(hardpoint);
	if(check1 && check2)
		self thread giveHardpointBuy(price, hardpoint);
}

menuPerkResponse(perk)
{
	if(perk == "1")
	{
		string = "specialty_extraammo";
	}
	else if(perk == "2")
	{
		string = "specialty_fraggrenade";
	}
	else if(perk == "3")
	{
		string = "specialty_specialgrenade";
	}
	else if(perk == "4")
	{
		string = "specialty_armorvest";
	}
	else if(perk == "5")
	{
		string = "specialty_bulletdamage";
	}
	else if(perk == "6")
	{
		string = "specialty_bulletpenetration";
	}
	else if(perk == "7")
	{
		string = "specialty_rof";
	}
	else if(perk == "8")
	{
		string = "specialty_fastreload";
	}
	else if(perk == "9")
	{
		string = "specialty_bulletaccuracy";
	}
	else if(perk == "10")
	{
		string = "specialty_gpsjammer";
	}
	else if(perk == "11")
	{
		string = "specialty_longersprint";
	}
	else if(perk == "12")
	{
		string = "specialty_explosivedamage";
	}
	else if(perk == "13")
	{
		string = "specialty_pistoldeath";
	}
	else if(perk == "14")
	{
		string = "specialty_grenadepulldeath";
	}
	else
	{
		return;
	}

	price  = level.trade_perk_price;
	check1 = enoughmoney(price);
	check2 = self hasPerk(string);
	if(check1)
	{
		if(!check2)
		{ self thread givePerkBuy(price, string); }
		else
		{
			self closeMenu();
			self iPrintLn("You already have " + perk + ".");
			self playLocalSound( "trade_fail" );
			self openMenu(game["menu_buymenu"]);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

enoughmoney(price, type)
{
	if( self.money - price < 0 )
	{
		self closeMenu();
		self iPrintLn("Sorry - Insufficient Funds!");
		self playLocalSound( "trade_no_money" );
		self openMenu(game["menu_buymenu"]);
		return( false );
	}
	else
	{
		return( true );
	}
}

primaryweapon()
{
	if( level.pickupson ) //Pickups make limiting types of weapons impossible
		return( true );

	if( self.totalweaponsprimary >= self.allowedweapons )
	{
		self closeMenu();
		self iPrintLn("Main Weapon Inventory Full");
		self playLocalSound( "trade_fail" );
		self openMenu(game["menu_buymenu"]);
		return( false );
	}
	else
	{
		self.totalweaponsprimary += 1;
		return( true );
	}
}

secondaryweapon()
{
	if( level.pickupson ) //Pickups make limiting types of weapons impossible
		return( true );

	if( self.totalweaponssecondary >= self.allowedweapons2 )
	{
		self closeMenu();
		self iPrintLn("Pistol Inventory Full");
		self playLocalSound( "trade_fail" );
		
		self openMenu(game["menu_buymenu"]);
		return( false );
	}
	else
	{
		self.totalweaponssecondary += 1;
		return( true );
	}
}

sameweapon(selectedweapon)
{
	if( self HasWeapon(selectedweapon) )
	{
		self closeMenu();
		self iPrintLn("You already have a " + selectedweapon + ".");
	   	self playLocalSound( "trade_dupe" );
		self openMenu(game["menu_buymenu"]);
		return( false );
	}
	return( true );
/*
	//ownweapon = self getCurrentWeapon();
	found = false;
	weaponsList = self GetWeaponsList();
	for( idx = 0; idx < weaponsList.size; idx++ )
	{
		weapon = weaponsList[idx];
		if( weapon == selectedweapon )
		{
			found = true;
			break;
		}
	}

	if(found)
	{
		self closeMenu();
		self iPrintLn("You already have this weapon.");
	   	self playLocalSound( "trade_dupe" );
		self openMenu(game["menu_buymenu"]);
		return( false );
	}

	return( true );
*/
}

doesWeaponExist(weapon)
{
	//Check to see if weapon exists in the array. Used for attachments
	found = false;
	for( i = 0; i < level.weaponIDs.size; i++ )
	{
		if( !isdefined( level.weaponIDs[i] ) || level.weaponIDs[i] == "")
			continue;

		if( level.weaponIDs[i] == weapon )
		{
			found = true;
			break;
		}
		//self iPrintLn( "^2Weapon: " + level.weaponIDs[i] );
		//wait(0.05);
	}
	return found;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

makeWeaponSale(weapon, price)
{
	if( !level.enable_weapon_sales )
	{
		self closeMenu();
		self.buymenuopen = false;
		self iPrintLn("Sale Failed - Weapon sales are disabled.");
		self playLocalSound( "trade_fail" );
		return;
	}

	if( maps\mp\gametypes\_weapons::isSideArm( weapon ) )
	{
		self.totalweaponssecondary -= 1;
	}

	if( maps\mp\gametypes\_weapons::isPrimaryWeapon( weapon ) )
	{
		self.totalweaponsprimary -= 1;
	}

	self takeWeapon( weapon );	
	self.money += price;
	self iPrintLn("Sale Successful - ^1[^7 " + getWeaponName(weapon) + " ^1]");
	self playLocalSound( "sale_made" );
	self setClientDvar( "ui_player_money", self.money );

	self closeMenu();
	self openMenu(game["menu_buymenu"]);
}

giveWeaponBuy(price, selectedweapon)
{
	self giveWeapon( selectedweapon );
	self giveStartAmmo( selectedweapon );
	self SetWeaponAmmoClip( selectedweapon, 9999 );
	self switchToWeapon(selectedweapon);

	self iPrintLn("Purchase Successful - ^1[^7 " + getWeaponName(selectedweapon) + " ^1]");
	self playLocalSound( "trade_made" );

	self.money -= price;
	self setClientDvar( "ui_player_money", self.money );

	self closeMenu();
	self openMenu(game["menu_buymenu"]);
}

giveInventoryBuy(price, inventory)
{
	self TakeWeapon("c4_mp");
	self TakeWeapon("claymore_mp");
	self TakeWeapon("rpg_mp");

	self giveWeapon( inventory );
	if ( inventory == "claymore_mp" || inventory == "rpg_mp")
	{
		self setWeaponAmmoStock( inventory, 6 );
	}
	else
	{
		self maps\mp\gametypes\_class::setWeaponAmmoOverall( inventory, 999 );
	}
	self.inventoryWeapon = inventory;
	self SetActionSlot( 3, "weapon", inventory );
	self switchtoweapon( inventory );

	self iPrintLn("Purchase Successful - ^1[^7 " + getWeaponName(inventory) + " ^1]");
	self playLocalSound( "trade_made" );

	self.money -= price;
	self setClientDvar( "ui_player_money", self.money );

	self closeMenu();
	self openMenu(game["menu_buymenu"]);
}

giveAttachmentBuy(price, attachment, weapon)
{
	name = getWeaponName(weapon);
	selectedweapon = name + "_" + attachment + "_mp";

	if ( !doesWeaponExist(selectedweapon) )
	{
		self closeMenu();
		self.buymenuopen = false;
		self iPrintLn("Purchase Failed - ^1[^7 " + selectedweapon + " ^1] ^7does not exist.");
		self playLocalSound( "trade_fail" );
		return;
	}

	tradeWeapon = self getCurrentWeapon();
	self takeWeapon( tradeWeapon );

	self giveWeapon( selectedweapon );
	self giveStartAmmo( selectedweapon );
	self SetWeaponAmmoClip( selectedweapon, 9999 );
	self switchToWeapon(selectedweapon);

	self iPrintLn("Purchase Successful - ^1[^7 " + attachment + " ^1]");
	self playLocalSound( "trade_made" );

	self.money -= price;
	self setClientDvar( "ui_player_money", self.money );

	self closeMenu();
	self openMenu(game["menu_buymenu"]);
}

giveGrenadeBuy(price, grenade)
{
	max = 2;
	if( grenade == "frag_grenade_mp" )
	{
		if( self hasPerk( "specialty_fraggrenade" ) )
		{ max = 6; }
		else
		{ max = 2; }
	}
	else
	{
		if( self hasPerk( "specialty_specialgrenade" ) )
		{ max = 6; }
		else
		{ max = 2; }
	}

	if( self getAmmoCount( grenade ) >= max )
	{
		self closeMenu();
		self.buymenuopen = false;
		self iPrintLn("Purchase Failed - ^1[^7 " + getWeaponName(grenade) + " ^1] ^7Maxed out.");
		self playLocalSound( "trade_fail" );
		return;
	}

	self giveWeapon( grenade );
	self SetWeaponAmmoClip( grenade, self getAmmoCount( grenade ) + 2 );

	if ( grenade == level.weapons["flash"])
		self setOffhandSecondaryClass("flash");
	else if ( grenade == level.weapons["smoke"])
		self setOffhandSecondaryClass("smoke");
	else if ( grenade == level.weapons["concussion"])
		self setOffhandSecondaryClass("concussion");
	else
		self SwitchToOffhand( grenade );

	self iPrintLn("Purchase Successful - ^1[^7 " + getWeaponName(grenade) + " ^1]");
	self playLocalSound( "trade_made" );

	self.money -= price;
	self setClientDvar( "ui_player_money", self.money );

	self closeMenu();
	self openMenu(game["menu_buymenu"]);
}

giveHardpointBuy(price, hardpoint)
{
	if( hardpoint == "artillery")
	{
		self playLocalSound( "killstreak_won" );
		self thread btd\_hud_util::dohud("Artillery Acquired");
		self.num_arty++;
	}
	else
	{
		self maps\mp\gametypes\_hardpoints::giveHardpoint( hardpoint, 0 );
	}

	self iPrintLn("Purchase Successful - ^1[^7 " + getWeaponName(hardpoint) + " ^1]");
	self playLocalSound( "trade_made" );

	self.money -= price;
	self setClientDvar( "ui_player_money", self.money );

	self closeMenu();
	self openMenu(game["menu_buymenu"]);
}

givePerkBuy(price, perk)
{
	self setPerk( perk );
	self.extraPerks[ perk ] = 1;
	self showPerk( 0, perk, -50 );
	self thread maps\mp\gametypes\_globallogic::hidePerksAfterTime( 6.0 );
	self thread maps\mp\gametypes\_globallogic::hidePerksOnDeath();
	self.numPerks++;

	self iPrintLn("Purchase Successful - ^1[^7 " + perk + " ^1]");
	self playLocalSound( "trade_made" );

	self.money -= price;
	self setClientDvar( "ui_player_money", self.money );

	self closeMenu();
	self openMenu(game["menu_buymenu"]);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

getTradeValue(tradeWeapon)
{
	value = 0;

	if(tradeWeapon == "beretta_mp" || tradeWeapon == "beretta_silencer_mp")
	{ value = level.trade_m9_price; }
	else if(tradeWeapon == "usp_mp" || tradeWeapon == "usp_silencer_mp")
	{ value = level.trade_usp_price; }
	else if(tradeWeapon == "colt45_mp" || tradeWeapon == "colt45_silencer_mp")
	{ value = level.trade_colt_price; }
	else if(tradeWeapon == "deserteagle_mp")
	{ value = level.trade_eagle_price; }
	else if(tradeWeapon == "deserteaglegold_mp")
	{ value = level.trade_eaglegold_price; }
	else if(tradeWeapon == "mp5_acog_mp" || tradeWeapon == "mp5_mp" || tradeWeapon == "mp5_reflex_mp" || tradeWeapon == "mp5_silencer_mp")
	{ value = level.trade_mp5_price; }
	else if(tradeWeapon == "skorpion_acog_mp" || tradeWeapon == "skorpion_mp" || tradeWeapon == "skorpion_reflex_mp" || tradeWeapon == "skorpion_silencer_mp")
	{ value = level.trade_skorp_price; }
	else if(tradeWeapon == "uzi_acog_mp" || tradeWeapon == "uzi_mp" || tradeWeapon == "uzi_reflex_mp" || tradeWeapon == "uzi_silencer_mp")
	{ value = level.trade_uzi_price; }
	else if(tradeWeapon == "ak74u_acog_mp" || tradeWeapon == "ak74u_mp" || tradeWeapon == "ak74u_reflex_mp" || tradeWeapon == "ak74u_silencer_mp")
	{ value = level.trade_ak74u_price; }
	else if(tradeWeapon == "p90_acog_mp" || tradeWeapon == "p90_mp" || tradeWeapon == "p90_reflex_mp" || tradeWeapon == "p90_silencer_mp")
	{ value = level.trade_p90_price; }
	else if(tradeWeapon == "m16_acog_mp" || tradeWeapon == "m16_gl_mp" || tradeWeapon == "m16_mp" || tradeWeapon == "m16_reflex_mp" || tradeWeapon == "m16_silencer_mp")
	{ value = level.trade_m16_price; }
	else if(tradeWeapon == "ak47_acog_mp" || tradeWeapon == "ak47_gl_mp" || tradeWeapon == "ak47_mp" || tradeWeapon == "ak47_reflex_mp" || tradeWeapon == "ak47_silencer_mp")
	{ value = level.trade_ak47_price; }
	else if(tradeWeapon == "m4_acog_mp" || tradeWeapon == "m4_gl_mp" || tradeWeapon == "m4_mp" || tradeWeapon == "m4_reflex_mp" || tradeWeapon == "m4_silencer_mp")
	{ value = level.trade_m4_price; }
	else if(tradeWeapon == "g3_acog_mp" || tradeWeapon == "g3_gl_mp" || tradeWeapon == "g3_mp" || tradeWeapon == "g3_reflex_mp" || tradeWeapon == "g3_silencer_mp")
	{ value = level.trade_g3_price; }
	else if(tradeWeapon == "g36c_acog_mp" || tradeWeapon == "g36c_gl_mp" || tradeWeapon == "g36c_mp" || tradeWeapon == "g36c_reflex_mp" || tradeWeapon == "g36c_silencer_mp")
	{ value = level.trade_g36c_price; }
	else if(tradeWeapon == "m14_acog_mp" || tradeWeapon == "m14_gl_mp" || tradeWeapon == "m14_mp" || tradeWeapon == "m14_reflex_mp" || tradeWeapon == "m14_silencer_mp")
	{ value = level.trade_m14_price; }
	else if(tradeWeapon == "mp44_mp")
	{ value = level.trade_mp44_price; }
	else if(tradeWeapon == "saw_acog_mp" || tradeWeapon == "saw_grip_mp" || tradeWeapon == "saw_mp" || tradeWeapon == "saw_reflex_mp")
	{ value = level.trade_saw_price; }
	else if(tradeWeapon == "rpd_acog_mp" || tradeWeapon == "rpd_grip_mp" || tradeWeapon == "rpd_mp" || tradeWeapon == "rpd_reflex_mp")
	{ value = level.trade_rpd_price; }
	else if(tradeWeapon == "m60e4_acog_mp" || tradeWeapon == "m60e4_grip_mp" || tradeWeapon == "m60e4_mp" || tradeWeapon == "m60e4_reflex_mp")
	{ value = level.trade_m60_price; }
	else if(tradeWeapon == "winchester1200_grip_mp" || tradeWeapon == "winchester1200_mp" || tradeWeapon == "winchester1200_reflex_mp")
	{ value = level.trade_w1200_price; }
	else if(tradeWeapon == "m1014_grip_mp" || tradeWeapon == "m1014_mp" || tradeWeapon == "m1014_reflex_mp")
	{ value = level.trade_m1014_price; }
	else if(tradeWeapon == "m40a3_acog_mp" || tradeWeapon == "m40a3_mp")
	{ value = level.trade_m40a3_price; }
	else if(tradeWeapon == "m21_acog_mp" || tradeWeapon == "m21_mp")
	{ value = level.trade_m21_price; }
	else if(tradeWeapon == "dragunov_acog_mp" || tradeWeapon == "dragunov_mp")
	{ value = level.trade_drag_price; }
	else if(tradeWeapon == "remington700_acog_mp" || tradeWeapon == "remington700_mp")
	{ value = level.trade_r700_price; }
	else if(tradeWeapon == "barrett_acog_mp" || tradeWeapon == "barrett_mp")
	{ value = level.trade_m82_price; }
	else if(tradeWeapon == "special1_mp")
	{ value = level.trade_special1_price; }
	else if(tradeWeapon == "special2_mp")
	{ value = level.trade_special2_price; }
	else if(tradeWeapon == "special3_mp")
	{ value = level.trade_special3_price; }
	else if(tradeWeapon == "special4_mp")
	{ value = level.trade_special4_price; }
	else if(tradeWeapon == "special5_mp")
	{ value = level.trade_special5_price; }
	else if(tradeWeapon == "special6_mp")
	{ value = level.trade_special6_price; }
	else if(tradeWeapon == "c4_mp" || tradeWeapon == "claymore_mp" || tradeWeapon == "claymore_detonator_mp" || tradeWeapon == "rpg_mp")
	{ value = level.trade_inventory_price; }

	price = int(value / 2);
	if(price <= 0)
		price = 0;

	return price;
}

getWeaponName(weapon)
{
	if(weapon == "special1_mp")
	{ return( getDvar("btd_special1_weap_name") ); }
	else if(weapon == "special2_mp")
	{ return( getDvar("btd_special2_weap_name") ); }
	else if(weapon == "special3_mp")
	{ return( getDvar("btd_special3_weap_name") ); }
	else if(weapon == "special4_mp")
	{ return( getDvar("btd_special4_weap_name") ); }
	else if(weapon == "special5_mp")
	{ return( getDvar("btd_special5_weap_name") ); }
	else if(weapon == "special6_mp")
	{ return( getDvar("btd_special6_weap_name") ); }
	else if(weapon == "hind_FFAR_mp")
	{ return( "105mm Cannon" ); }
	else if(weapon == "cobra_FFAR_mp")
	{ return( "40mm Cannon" ); }
	else if(weapon == "briefcase_bomb_defuse_mp")
	{ return( "25mm Turret" ); }
	else if(weapon == "ac130_mp")
	{ return( "ac130" ); }
	else if(weapon == "airstrike_mp" || weapon == "artillery_mp")
	{ return( "airstrike" ); }
	else if(weapon == "helicopter_mp")
	{ return( "helicopter" ); }
	else if(weapon == "blackhawk_mp")
	{ return( "blackhawk" ); }
	else if(weapon == "napalm_mp")
	{ return( "napalm" ); }
	else if(weapon == "radar_mp")
	{ return( "WrathOfZod" ); }
	else if(weapon == "artillery")
	{ return( "artillery" ); }
	else if(weapon == "defaultweapon_mp")
	{ return( "artillery" ); }
	else if(weapon == "nuke_mp")
	{ return( "nuke" ); }
	else
	{
		name = tablelookup( "mp/statstable.csv", 0, level.weaponNames[weapon], 4 );
		if( isDefined(name) )
			return( name );
		else
			return( "unknown" );
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

makehud()
{
	self notify("stop_money_thread");
	self endon("disconnect");
	self endon("stop_money_thread");

	if(isDefined(self.moneyhud))
		self.moneyhud destroy();

	if(isDefined(self.money_num))
		self.money_num destroy();

	x = 586; // Left/Right - Lower is more left
	y = 50; // Top/Bottom lower = higher
	self.moneyhud = newClientHudElem(self);
	self.moneyhud.alignX = "right";
	self.moneyhud.alignY = "middle";
	self.moneyhud.horzAlign = "fullscreen";
	self.moneyhud.vertAlign = "fullscreen";
	self.moneyhud.x = x;
	self.moneyhud.y = y;
	self.moneyhud.alpha = 1;
	self.moneyhud.glowAlpha = 0.1;
	self.moneyhud.glowColor = (1, 0, 0);
	self.moneyhud.sort = 2;
	self.moneyhud.fontscale = 1.4;
	self.moneyhud.color = (1,1,1);//(1,0,0);
	self.moneyhud.archived = false;
	self.moneyhud setText("Money:");

	self.money_num = newClientHudElem(self);
	self.money_num.alignX = "right";
	self.money_num.alignY = "middle";
	self.money_num.horzAlign = "fullscreen";
	self.money_num.vertAlign = "fullscreen";
	self.money_num.x = x + 49;//35
	self.money_num.y = y;
	self.money_num.alpha = 1;
	self.money_num.glowAlpha = 0.1;
	self.money_num.glowColor = (0, 1, 0);
	self.money_num.sort = 2;
	self.money_num.fontscale = 1.4;
	self.money_num.color = (1,1,1);//(0,1,0);
	self.money_num.archived = false;

	while(1)
	{
		self.money_num setValue(self.money);
		wait 0.5;
	}
}
