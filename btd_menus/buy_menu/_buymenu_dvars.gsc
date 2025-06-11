#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include btd\_dvardef;

createValues()
{
	// WEAPON PRICE DVARS	

	// Pistols	
	level.trade_m9_price = createdvar("btd_m9_price",300,100,10000,"int");
	level.trade_usp_price = createdvar("btd_usp_price",600,100,10000,"int");
	level.trade_colt_price = createdvar("btd_colt45_price",800,100,10000,"int");
	level.trade_eagle_price = createdvar("btd_eagle_price",1000,100,10000,"int");
	level.trade_eaglegold_price = createdvar("btd_goldeagle_price",1200,100,10000,"int");

	// Sub machine guns
	level.trade_mp5_price = createdvar("btd_mp5_price",1700,100,10000,"int");
	level.trade_skorp_price = createdvar("btd_skorp_price",1500,100,10000,"int");
	level.trade_uzi_price = createdvar("btd_uzi_price",1550,100,10000,"int");
	level.trade_ak74u_price = createdvar("btd_ak74u_price",1700,100,10000,"int");
	level.trade_p90_price = createdvar("btd_p90_price",2000,100,10000,"int");

	// Assualt rifles
	level.trade_m16_price = createdvar("btd_m16_price",2500,100,10000,"int");
	level.trade_ak47_price = createdvar("btd_ak47_price",3000,100,10000,"int");
	level.trade_m4_price = createdvar("btd_m4_price",3000,100,10000,"int");
	level.trade_g3_price = createdvar("btd_g3_price",2700,100,10000,"int");
	level.trade_g36c_price = createdvar("btd_g36c_price",3000,100,10000,"int");
	level.trade_m14_price = createdvar("btd_m14_price",2700,100,10000,"int");
	level.trade_mp44_price = createdvar("btd_mp44_price",2500,100,10000,"int");

	// Heavy machine guns
	level.trade_saw_price = createdvar("btd_saw_price",4000,100,10000,"int");
	level.trade_rpd_price = createdvar("btd_rpd_price",4250,100,10000,"int");
	level.trade_m60_price = createdvar("btd_m60_price",4500,100,10000,"int");

	// Shotguns
	level.trade_w1200_price = createdvar("btd_w1200_price",2000,100,10000,"int");
	level.trade_m1014_price = createdvar("btd_m1014_price",2500,100,10000,"int");

	// Sniper rifles
	level.trade_m40a3_price = createdvar("btd_m40a3_price",1500,100,10000,"int");
	level.trade_m21_price = createdvar("btd_m21_price",2000,100,10000,"int");
	level.trade_drag_price = createdvar("btd_drag_price",2500,100,10000,"int");
	level.trade_r700_price = createdvar("btd_r700_price",2750,100,10000,"int");
	level.trade_m82_price = createdvar("btd_m82_price",3000,100,100000,"int");

	// Special weapons
	level.trade_special1_price = createdvar("btd_special1_price",15000,100,100000,"int");
	level.trade_special2_price = createdvar("btd_special2_price",20000,100,100000,"int");
	level.trade_special3_price = createdvar("btd_special3_price",30000,100,100000,"int");
	level.trade_special4_price = createdvar("btd_special4_price",40000,100,100000,"int");
	level.trade_special5_price = createdvar("btd_special5_price",50000,100,100000,"int");
	level.trade_special6_price = createdvar("btd_special6_price",60000,100,100000,"int");

	// Attachments
	level.trade_reddot_price = createdvar("btd_reddot_price",150,25,10000,"int");
	level.trade_acog_price = createdvar("btd_acog_price",200,25,20000,"int");
	level.trade_silencer_price = createdvar("btd_silencer_price",250,25,10000,"int");
	level.trade_gl_price = createdvar("btd_gl_price",800,25,10000,"int");
	level.trade_grip_price = createdvar("btd_grip_price",150,25,10000,"int");

	// RPG etc.
	level.trade_inventory_price = createdvar("btd_inventory_price",1500,100,10000,"int");

	// Perks
	level.trade_perk_price = createdvar("btd_perk_price",500,100,2000,"int");

	// Grenades
	level.trade_grenade_price = createdvar("btd_grenade_price",500,100,2000,"int");

	// Hardpoints
	level.trade_helicopter_price = createdvar("btd_helicopter_price",5000,100,100000,"int");
	level.trade_airstrike_price = createdvar("btd_airstrike_price",6000,100,100000,"int");
	level.trade_artillery_price = createdvar("btd_artillery_price",7000,100,100000,"int");
	level.trade_blackhawk_price = createdvar("btd_blackhawk_price",8000,100,100000,"int");
	level.trade_ac130_price = createdvar("btd_ac130_price",10000,100,100000,"int");
	level.trade_napalm_price = createdvar("btd_napalm_price",12000,100,100000,"int");
	level.trade_woz_price = createdvar("btd_woz_price",15000,100,100000,"int");
	level.trade_nuke_price = createdvar("btd_nuke_price",20000,100,100000,"int");
}

client_dvars()
{
	self setClientDvar("my_buymenu", 0 );

	wait( 0.15 );

	self setClientDvars("menu_price_m9", ("^1[^7M9 Beretta^1]^7 - " + level.trade_m9_price), 
				"menu_price_usp", ("^1[^7USP^1]^7 - " + level.trade_usp_price), 
				"menu_price_colt", ("^1[^7Colt 45^1]^7 - " + level.trade_colt_price), 
				"menu_price_eagle", ("^1[^7Desert Eagle^1]^7 - " + level.trade_eagle_price), 
				"menu_price_eaglegold", ("^1[^7Desert Eagle Gold^1]^7 - " + level.trade_eaglegold_price),
				"menu_price_special5", ("^1[^7" + getDvar("btd_special5_weap_name") + "^1]^7 - " + level.trade_special5_price));

	wait( 0.25 );

	self setClientDvars("menu_price_mp5", ("^1[^7MP5^1]^7 - " + level.trade_mp5_price), 
				"menu_price_skorp", ("^1[^7Skorpian^1]^7 - " + level.trade_skorp_price), 
				"menu_price_uzi", ("^1[^7Mini Uzi^1]^7 - " + level.trade_uzi_price), 
				"menu_price_ak74u", ("^1[^7AK74u^1]^7 - " + level.trade_ak74u_price), 
				"menu_price_p90", ("^1[^7P90^1]^7 - " + level.trade_p90_price),
				"menu_price_special4", ("^1[^7" + getDvar("btd_special4_weap_name") + "^1]^7 - " + level.trade_special4_price));

	wait( 0.25 );

	self setClientDvars("menu_price_m16", ("^1[^7M16^1]^7 - " + level.trade_m16_price), 
				"menu_price_ak47", ("^1[^7AK47^1]^7 - " + level.trade_ak47_price), 
				"menu_price_m4", ("^1[^7M4^1]^7 - " + level.trade_m4_price), 
				"menu_price_g3", ("^1[^7G3^1]^7 - " + level.trade_g3_price), 
				"menu_price_g36c", ("^1[^7G36C^1]^7 - " + level.trade_g36c_price),
				"menu_price_m14", ("^1[^7M14^1]^7 - " + level.trade_m14_price),
				"menu_price_mp44", ("^1[^7MP44^1]^7 - " + level.trade_mp44_price),
				"menu_price_special3", ("^1[^7" + getDvar("btd_special3_weap_name") + "^1]^7 - " + level.trade_special3_price));

	wait( 0.25 );

	self setClientDvars("menu_price_saw", ("^1[^7SAW^1]^7 - " + level.trade_saw_price), 
				"menu_price_rpd", ("^1[^7RPD^1]^7 - " + level.trade_rpd_price), 
				"menu_price_m60", ("^1[^7M60E4^1]^7 - " + level.trade_m60_price),
				"menu_price_special6", ("^1[^7" + getDvar("btd_special6_weap_name") + "^1]^7 - " + level.trade_special6_price));

	wait( 0.25 );

	self setClientDvars("menu_price_w1200", ("^1[^7W1200^1]^7 - " + level.trade_w1200_price), 
				"menu_price_m1014", ("^1[^7M1014^1]^7 - " + level.trade_m1014_price),
				"menu_price_special2", ("^1[^7" + getDvar("btd_special2_weap_name") + "^1]^7 - " + level.trade_special2_price));

	wait( 0.25 );

	self setClientDvars("menu_price_m40a3", ("^1[^7M40A3^1]^7 - " + level.trade_m40a3_price), 
				"menu_price_m21", ("^1[^7M21^1]^7 - " + level.trade_m21_price), 
				"menu_price_drag", ("^1[^7Dragunov^1]^7 - " + level.trade_drag_price), 
				"menu_price_r700", ("^1[^7Remington 700^1]^7 - " + level.trade_r700_price), 
				"menu_price_m82", ("^1[^7Barrett M82^1]^7 - " + level.trade_m82_price),
				"menu_price_special1", ("^1[^7" + getDvar("btd_special1_weap_name") + "^1]^7 - " + level.trade_special1_price));

	wait( 0.25 );
/*
	self setClientDvars( "menu_price_special1", ("^1[^7" + getDvar("btd_special1_weap_name") + "^1]^7 - " + level.trade_special1_price), 
				"menu_price_special2", ("^1[^7" + getDvar("btd_special2_weap_name") + "^1]^7 - " + level.trade_special2_price), 
				"menu_price_special3", ("^1[^7" + getDvar("btd_special3_weap_name") + "^1]^7 - " + level.trade_special3_price), 
				"menu_price_special4", ("^1[^7" + getDvar("btd_special4_weap_name") + "^1]^7 - " + level.trade_special4_price), 
				"menu_price_special5", ("^1[^7" + getDvar("btd_special5_weap_name") + "^1]^7 - " + level.trade_special5_price),
				"menu_price_special6", ("^1[^7" + getDvar("btd_special6_weap_name") + "^1]^7 - " + level.trade_special6_price));

	wait( 0.25 );
*/
	self setClientDvars("menu_price_reddot", ("^1[^7Red Dot Sight^1]^7 - " + level.trade_reddot_price), 
				"menu_price_acog", ("^1[^7ACOG Scope^1]^7 - " + level.trade_acog_price), 
				"menu_price_silencer", ("^1[^7Silencer^1]^7 - " + level.trade_silencer_price), 
				"menu_price_gl", ("^1[^7Grenade Launcher^1]^7 - " + level.trade_gl_price), 
				"menu_price_grip", ("^1[^7Grip^1]^7 - " + level.trade_grip_price));

	wait( 0.25 );

	self setClientDvars("menu_price_inventory", level.trade_inventory_price, 
				"menu_price_perk", level.trade_perk_price);

	wait( 0.25 );

	self setClientDvars("menu_price_helicopter", ("^1[^7Helicopter^1]^7 - " + level.trade_helicopter_price), 
				"menu_price_airstrike", ("^1[^7Airstrike^1]^7 - " + level.trade_airstrike_price), 
				"menu_price_artillery", ("^1[^7Artillery^1]^7 - " + level.trade_artillery_price), 
				"menu_price_blackhawk", ("^1[^7Blackhawk^1]^7 - " + level.trade_blackhawk_price),
				"menu_price_ac130", ("^1[^7AC 130^1]^7 - " + level.trade_ac130_price),
				"menu_price_napalm", ("^1[^7Napalm Strike^1]^7 - " + level.trade_napalm_price), 
				"menu_price_woz", ("^1[^7Wrath of Zod^1]^7 - " + level.trade_woz_price),
				"menu_price_nuke", ("^1[^7Tactical Nuke^1]^7 - " + level.trade_nuke_price));
}
