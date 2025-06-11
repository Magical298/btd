#include maps\mp\gametypes\_hud_util;
#include btd\_sound_util;
#include btd\_hud_util;
#include btd\_dvardef;

init()
{
	if(level.btd_devmode != 0)
		return;

	precacheModel("zombie");
	level.testzom_health = createdvar("btd_test_zom_health",70,30,500,"int");
	level.testzom_speed = createdvar("btd_test_zom_speed",7,1,15,"int");
	level.testzom_health_scale = createdvar("btd_test_zom_hp_multiplier",1,0,50,"int");
	level.testzom_damage = createdvar("btd_test_zom_damage",15,5,500,"int");
	level.testzom_killpoints = createdvar("btd_test_zom_points",10,5,500,"int");
	level.testzom_assistpoints = int(level.testzom_killpoints / 3);
	level.fx_gib = loadFx("explosions/zom_expl");

	if(level.testzom_assistpoints < 1)
	{
		level.testzom_assistpoints = 1;
	}

	level.testzom_killmoney = createdvar("btd_test_zom_money",50,5,1000,"int");
	level.testzom_assitmoney = int(level.testzom_killmoney / 2);

	if(level.testzom_assitmoney < 1)
	{
		level.testzom_assitmoney = 5;
	}
}

spawn_testzombie()
{
	if ( level.zomspawns.size == 0 || !isDefined( level.currentspawnnum ) )
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( "axis" );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
		zom = spawn( "script_model", spawnPoint.origin );
		zom setModel("zombie");
		zom.angles = spawnPoint.angles;
	}
	else
	{
		num = level.currentspawnnum;
		level.currentspawnnum++;
		if(level.currentspawnnum >= level.zomspawns.size)
			level.currentspawnnum = 0;		

		zom = spawn( "script_model", level.zomspawns[num].origin);
		zom setModel("zombie");
		zom.angles = (0,0,0);
	}

	zom.targetname = "zom";
	zom.name = "^1Zombie";
	zom.isTestZom = true;
	zom.isNormalzom = false;
	zom.pers["isBot"] = true;
	zom.bIsBot = true;
	zom.pers["team"] = "axis";
	zom.currentsurface = "default";
	zom.wasbugged = false;
	zom.attacksoundplaying = false;
	zom.timesreset = 0;
	zom.can_attack = true;
	zom.attackRange = 50;
	zom.attack_damage = level.testzom_damage;
	zom.inFlareVisionArea = false;

	if( level.number_of_waves > 1 && level.currentwave > 1 && level.testzom_health_scale > 0 )
	{
		healthScale = int( level.testzom_health + (level.currentwave * level.testzom_health_scale) );
		if( healthScale < 500 )
		{ zom.maxhealth = healthScale; }
		else
		{ zom.maxhealth = 500; }
	}
	else
	{ zom.maxhealth = level.testzom_health; }

	zom.health = zom.maxhealth;
	zom.moveSpeed = level.testzom_speed;
	zom.poisoned = false;

	zom thread moveparts("tag_l_arm_",12);
	zom thread moveparts("tag_r_arm_",12);
	zom thread moveparts("tag_l_leg_",11);
	zom thread moveparts("tag_r_leg_",11);
	zom thread dmg();
	zom thread undermap();
	zom thread test_sounds();
	zom thread test_steps();

	level.zombies[level.zombies.size] = zom;	

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
	//self endon("death");
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
			if(sMeansofDeath == "MOD_MELEE")
			{
				extradmg = self.maxhealth;
				earthquake(0.7,1,self.origin + (0,0,40),60);
			}

			self.health = self.health - extradmg;
		}
		oldhealth = self.health;
		self playSound("zom_pain_" + randomInt(2));

		if(self.health <= 0)
		{ break; }
	}

	self notify("death");

	if( isPlayer( attacker ) )
	{
		if( level.killsprees )
		{ attacker thread btd\_killspree::check_for_rampage(self); }

		if( level.multikill )
		{ attacker thread btd\_multikill::multikill(); }

		value = maps\mp\gametypes\_rank::getScoreInfoValue("testzomkill");
		if( level.number_of_waves > 1 && level.zom_point_scale > 0 )
		{
			if( level.currentwave > 1 )
			{ value += int( level.zom_point_scale * level.currentwave ); }
		}

		if(sMeansofDeath == "MOD_MELEE")
		{ value = value * 2; }

		attacker thread maps\mp\gametypes\_rank::giveRankXP( "kill", value );
		attacker maps\mp\gametypes\_globallogic::incPersStat( "kills", 1 );
		attacker.kills = attacker maps\mp\gametypes\_globallogic::getPersStat( "kills" );
		attacker maps\mp\gametypes\_globallogic::updatePersRatio( "kdratio", "kills", "deaths" );

		if( level.traderon == 1 )
		{ attacker.money = attacker.money + level.testzom_killmoney; }	

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

		//attacker maps\mp\gametypes\_globallogic::givePlayerScore( "testzomkill", attacker, self );

		attacker.pers["score"] += value;
		attacker maps\mp\gametypes\_persistence::statAdd( "score", (attacker.pers["score"] - value) );
		attacker.score = attacker.pers["score"];
		attacker notify ( "update_playerscore_hud" );

		maps\mp\gametypes\_globallogic::giveTeamScore( "win", "allies",  attacker, self );
		level thread maps\mp\gametypes\_battlechatter_mp::sayLocalSoundDelayed( attacker, "kill", 0.75 );
	}

	// May have been picked up by an admin. Cleanup..
	if( isDefined( self.linker ) )
	{ self.linker delete(); }

	if( !self.wasbugged )
	{
		for( i=0; i < self.attackers.size; i++ )
		{
			if( !isPlayer( self.attackers[i] ) )
			{ continue; }

			if( isPlayer( attacker ) && self.attackers[i] == attacker )
			{ continue; }

			self.attackers[i] thread maps\mp\gametypes\_globallogic::processAssist( self, level.testzom_assistpoints );

			if( level.traderon == 1 )
			{ self.attackers[i].money += level.testzom_assitmoney; }
		}
	}

	if( isDefined( attacker ) )
	{ sWeapon = attacker GetCurrentWeapon(); }
	else
	{ sWeapon = "defaultweapon_mp"; }

	sHitLoc = "torso_upper";
	self thread maps\mp\gametypes\_globallogic::zombieKilled(attacker, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc );

	origin = self.origin + (0,0,10);
	playfx(level.fx_gib, origin);

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
		if( isDefined( zombies[i] ) )
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

test_sounds()
{
	self endon("death");
	while(1)
	{
		wait 3 + randomInt(5);
		self playSound("zombie_moan_" + randomInt(6));
	}
}

test_steps()
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

