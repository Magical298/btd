#include maps\mp\gametypes\_hud_util;
#include btd\_sound_util;
#include btd\_hud_util;
#include btd\_dvardef;

init()
{
	if(level.btd_devmode != 0)
		return;

	precacheModel("boss");
	precacheShader("waypoint_bosses");

	level.BossZom_health = createdvar("btd_boss_zom_health",5000,500,500000,"int");
	level.BossZom_speed = createdvar("btd_boss_zom_speed",12,1,15,"int");
	level.BossZom_health_scale = createdvar("btd_boss_zom_hp_multiplier",1,0,50000,"int");
	level.BossZom_damage = createdvar("btd_boss_zom_damage",50,5,500,"int");
	level.BossZom_killpoints = createdvar("btd_boss_zom_points",500,50,5000,"int");
	level.BossZom_assistpoints = int(level.BossZom_killpoints / 3);
	level.BossZom_markers = createdvar("btd_boss_zom_markers",1,0,1,"int");
	level.fx_boss_expl = loadFx("explosions/gib");

	if(level.BossZom_assistpoints < 1)
	{ level.BossZom_assistpoints = 1; }

	level.BossZom_killmoney = createdvar("btd_boss_money",2000,500,10000,"int");
	level.BossZom_assitmoney = int(level.BossZom_killmoney / 2);

	if(level.BossZom_assitmoney < 1)
	{ level.BossZom_assitmoney = 5; }

	level.minimap_boss_count = 0; // Used to keep track of minimap icons
}

spawn_bosszombie()
{
	if ( level.zomspawns.size == 0 || !isDefined( level.currentspawnnum ) )
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( "axis" );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
		zom = spawn( "script_model", spawnPoint.origin );
		zom setModel("boss");
		zom.angles = spawnPoint.angles;
	}
	else
	{
		num = level.currentspawnnum;
		level.currentspawnnum++;
		if(level.currentspawnnum >= level.zomspawns.size)
			level.currentspawnnum = 0;

		zom = spawn("script_model", level.zomspawns[num].origin);
		zom setModel("boss");
		zom.angles = (0,0,0);
	}

	zom.targetname = "zom";
	zom.name = "^1Boss Zombie";
	zom.isTestZom = false;
	zom.isNormalzom = true;
	zom.pers["isBot"] = true;
	zom.bIsBot = true;
	zom.pers["team"] = "axis";
	zom.currentsurface = "default";
	zom.wasbugged = false;
	zom.attacksoundplaying = false;
	zom.timesreset = 0;
	zom.can_attack = true;
	zom.attackRange = 50;
	zom.attack_damage = level.BossZom_damage;
	zom.inFlareVisionArea = false;

	if( level.number_of_waves > 1 && level.currentwave > 1 && level.BossZom_health_scale > 0 )
	{
		healthScale = int( level.BossZom_health + (level.currentwave * level.BossZom_health_scale) );
		if( healthScale < 500000 )
		{ zom.maxhealth = healthScale; }
		else
		{ zom.maxhealth = 500000; }
	}
	else
	{ zom.maxhealth = level.BossZom_health; }

	zom.health = zom.maxhealth;
	zom.moveSpeed = level.BossZom_speed;
	zom.poisoned = false;

	zom thread moveparts("tag_l_arm_",12);
	zom thread moveparts("tag_r_arm_",12);
	zom thread moveparts("tag_l_leg_",11);
	zom thread moveparts("tag_r_leg_",11);
	zom thread dmg();
	zom thread undermap();
	zom thread boss_sounds();
	zom thread boss_steps();

	level.zombies[level.zombies.size] = zom;

	if( level.BossZom_markers == 1 )
	{
		zom.iconmount = spawn("script_model", zom.origin + (0,0,80));
		zom.iconmount setModel("tag_origin");
		zom.iconmount linkto(zom);
		zom.icon = newHudElem();
		zom.icon.hideWhenInMenu = true;
		zom.icon SetTargetEnt(zom.iconmount);
		zom.icon.sort = 1;
		zom.icon setWayPoint(true, "waypoint_bosses");
	}

	if( level.minimap_boss_count <= 15 ) // 15 max
	{
		level.minimap_boss_count++; // Start at index 1, not 0
		zom.obj_count = level.minimap_boss_count;
		objective_add( zom.obj_count, "active", zom getOrigin(), game["headicon_axis"] ); // Index 0 - 15, origin, material
		objective_team( zom.obj_count, "allies" ); //sets the team who can view the icon
		objective_onEntity( zom.obj_count, zom ); //binds an icon to an entity position
	}

	return zom;
}

moveparts(tag, frames)                      
{
	self endon("death");

	if(!isDefined(tag) || !isDefined(frames))
		return;

	wait 0.05;

	show = 1;
	forward = true;

	while(1)
	{
		if(forward)
		{
			self showPart(tag + show);
			for(i=1;i<frames + 1;i++)
			{
				if(i == show)
					continue;
				self hidePart(tag + i);
			}
			wait 0.05;
			show++;
			if(show > (frames - 1))
			{
				forward = false;
			}
		}
		else
		{
			show--;
			if(show < 2)
			{
				forward = true;
				show = 1;
				wait 0.05;
				continue;
			}
			self showPart(tag + show);
			for(i=1;i<frames + 1;i++)
			{
				if(i == show)
					continue;
				self hidePart(tag + i);
			}
			wait 0.05;
		}
	}
}

dmg()
{
	wait 0.05;

	self setCanDamage(1);
	oldhealth = self.health;
	self.attackers = [];

	while(1)
	{
		self waittill("damage", iDamage, attacker, vDir, vPoint, sMeansOfDeath, modelName, tagName, partName, iDFlags);

		if( isDefined( attacker ) )
		{
			if( attacker.classname == "script_vehicle" && isDefined( attacker.owner ) )
			{ attacker = attacker.owner; }
		}

		if( self.health == oldhealth )
		{ self.health = self.health - iDamage; }

		if( isPlayer( attacker ) )
		{
			newattacker = true;
			for(i=0;i<self.attackers.size;i++)
			{
				if(!isDefined(self.attackers[i]))
				{ continue; }

				if(self.attackers[i] != attacker)
				{ continue; }

				newattacker = false;
			}

			if(newattacker)
			{ self.attackers[self.attackers.size] = attacker; }

			extradmg = iDamage;

			attacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback(false);

			if(attacker maps\mp\gametypes\_class::cac_hasSpecialty("specialty_bulletdamage") && maps\mp\gametypes\_class::isPrimaryDamage(sMeansOfDeath))
			{ extradmg = iDamage * (100 + level.cac_bulletdamage_data) / 100; }
			else if(attacker maps\mp\gametypes\_class::cac_hasSpecialty("specialty_explosivedamage") && maps\mp\gametypes\_class::isExplosiveDamage(sMeansOfDeath))
			{ extradmg = iDamage * (100 + level.cac_explosivedamage_data) / 100; }

			extradmg = int(extradmg - iDamage);

			////////////////////////////////////////////////////////////////////////////////////////////
			//Zod: Added for one hit knife kills regardless of Zombie health
			////////////////////////////////////////////////////////////////////////////////////////////
			//if(sMeansofDeath == "MOD_MELEE")
			//{
				//extradmg = self.maxhealth;
				//earthquake(0.7,1,self.origin + (0,0,40),60);
			//}

			self.health = self.health - extradmg;
		}
		oldhealth = self.health;
		self playSound("zom_pain_" + randomInt(2));

		if(self.health <= 0)
		{ break; }
	}

	self notify("death");

	// May have been picked up by an admin. Cleanup..
	if( isDefined( self.linker ) )
	{ self.linker delete(); }

//Zod: Delete icon
	if( isDefined( self.iconmount ) )
	{
		self.icon clearTargetEnt();
		self.icon destroy();
		self.iconmount unlink();
		self.iconmount delete();
	}

	// Remove the minimap icon for this boss
	if( isDefined( self.obj_count ) )
	{
		objective_delete( self.obj_count );

		if( level.minimap_boss_count > 0 )
		{ level.minimap_boss_count--; }
	}

	if(isPlayer(attacker))
	{
		if( level.killsprees )
		{ attacker thread btd\_killspree::check_for_rampage(self); }

		if( level.multikill )
		{ attacker thread btd\_multikill::multikill(); }

		value = maps\mp\gametypes\_rank::getScoreInfoValue("bosszomkill");

		if(sMeansofDeath == "MOD_MELEE")
		{ value = value * 2; }

		attacker thread maps\mp\gametypes\_rank::giveRankXP( "kill", value );
		attacker maps\mp\gametypes\_globallogic::incPersStat( "kills", 1 );
		attacker.kills = attacker maps\mp\gametypes\_globallogic::getPersStat( "kills" );
		attacker maps\mp\gametypes\_globallogic::updatePersRatio( "kdratio", "kills", "deaths" );

		if( level.traderon == 1 )
		{ attacker.money = attacker.money + level.BossZom_killmoney; }

		if ( isAlive( attacker ) )
		{ attacker.cur_kill_streak++; }

		if ( isDefined( level.hardpointItems ) && isAlive( attacker ) )
		{ attacker thread maps\mp\gametypes\_hardpoints::giveHardpointItemForStreak(); }

		attacker.cur_death_streak = 0;

		if ( attacker.cur_kill_streak > attacker.kill_streak )
		{
			attacker maps\mp\gametypes\_persistence::statSet( "kill_streak", attacker.cur_kill_streak );
			attacker.kill_streak = attacker.cur_kill_streak;
		}

		attacker maps\mp\gametypes\_globallogic::givePlayerScore( "bosszomkill", attacker, self );

		maps\mp\gametypes\_globallogic::giveTeamScore( "win", "allies",  attacker, self );
		level thread maps\mp\gametypes\_battlechatter_mp::sayLocalSoundDelayed( attacker, "kill", 0.75 );
	}	

	if( !self.wasbugged )
	{
		for( i=0; i < self.attackers.size; i++ )
		{
			if(!isPlayer(self.attackers[i]))
			{ continue; }

			if(isPlayer(attacker) && self.attackers[i] == attacker)
			{ continue; }

			self.attackers[i] thread maps\mp\gametypes\_globallogic::processAssist( self, level.BossZom_assistpoints );

			if(level.traderon == 1)
			{ self.attackers[i].money += level.BossZom_assitmoney; }
		}
	}

	if(isDefined(attacker))
	{ sWeapon = attacker GetCurrentWeapon(); }
	else
	{ sWeapon = "defaultweapon_mp"; }

	sHitLoc = "torso_upper";	
	self thread maps\mp\gametypes\_globallogic::zombieKilled(attacker, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc );

	////////////////////////////////////////
	// Zod: Need this for survival end round
	if( level.boss > 0 )
	{
		if( isDefined(attacker) )
		{ iPrintlnBold("^3" + attacker.name + " ^7has killed a boss!"); }

		level.boss--;
	}
	////////////////////////////////////////

	origin = self.origin + (0,0,10);
	playfx(level.fx_boss_expl, origin);

	thread playsoundatlocation("zombie_kill_" + randomInt(4), origin, 3);

	for ( zom = 0; zom < level.zombies.size; zom++ )
	{
		if ( level.zombies[zom] == self )
		{
			while ( zom < level.zombies.size-1 )
			{
				level.zombies[zom] = level.zombies[zom+1];
				zom++;
			}
			level.zombies[zom] = undefined;
			break;
		}
	}

	self delete();
/*
	zombies = level.zombies;
	level.zombies = [];
	for(i=0;i<zombies.size;i++)
	{
		if(isDefined(zombies[i]))
		{ level.zombies[level.zombies.size] = zombies[i]; }
	}
*/
}

undermap()
{
	self endon("death");

	under = 100;
	if( getdvar("mapname") == "mp_overgrown" ) // Special case for overgrown because of creekbed
	{ under = 160; }

	while(1)
	{
		wait 0.05;
		undermap = 0;
		if(self.origin[2] >= level.spawnMins[2])
			continue;

		while(1)
		{
			if( distance( self.origin,( self.origin[0],self.origin[1],level.spawnMins[2] ) ) < under )
			{
				break;
			}

			undermap++;
			if(undermap > 50)
			{
				break;
			}
			wait 0.05;
		}
		if(undermap >= 25)
		{
			break;
		}
	}

	self.wasbugged = true;
	self notify("damage", self.maxhealth, undefined, (0,1,0), self.origin, "MOD_SUICIDE", "", "", "", 1);
}

boss_sounds()
{
	self endon("death");
	while(1)
	{
		wait 3 + randomInt(5);
		self playSound("zombie_moan_1");
	}
}

boss_steps()
{
	self endon("death");
	while(1)
	{
		wait 0.4 + randomFloat(0.2);
		self playSound("step_run_" + self.currentsurface);
	}
}

attacksound()
{
	self playSound("zom_attack_" + randomInt(2));
	self.attacksoundplaying = true;
	self thread attacksoundwait();
}

attacksoundwait()
{
	self endon("death");
	wait 2;
	self.attacksoundplaying = false;
}
