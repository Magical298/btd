init()
{
	precacheShader("overlay_low_health");
	
	level.healthOverlayCutoff = 0.55; // getting the dvar value directly doesn't work right because it's a client dvar getdvarfloat("hud_healthoverlay_pulseStart");
	
	regenTime = 5;
	
	level.playerHealth_RegularRegenDelay = regenTime * 1000;
	
	level.healthRegenDisabled = (level.playerHealth_RegularRegenDelay <= 0);
	
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);
		player thread onPlayerSpawned();
		player thread onPlayerKilled();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
		player thread onPlayerDisconnect();
	}
}

onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");
		self notify("end_healthregen");
	}
}

onJoinedSpectators()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");
		self notify("end_healthregen");
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		self thread playerHealthRegen();
	}
}

onPlayerKilled()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("killed_player");
		self notify("end_healthregen");
	}
}

onPlayerDisconnect()
{
	self waittill("disconnect");
	self notify("end_healthregen");
}

playerHealthRegen()
{
	self endon("end_healthregen");
	
	if ( self.health <= 0 )
	{
		assert( !isalive( self ) );
		return;
	}
	
	maxhealth = self.health;
	player = self;
	health_add = 0;
	
	regenRate = 0.1; // 0.017;
	veryHurt = false;
	
	player.breathingStopTime = -10000;
	
	thread playerBreathingSound(maxhealth * 0.35);
	
	lastSoundTime_Recover = 0;
	hurtTime = 0;
	newHealth = 0;
	
	for (;;)
	{
		wait 1;

		if (player.health == maxhealth)
		{
			veryHurt = false;
			self.atBrinkOfDeath = false;
			continue;
		}
					
		if (player.health <= 0)
			return;
//================================================================================================
// Zombotron: Changed
		if (player.health < maxhealth)
		{
			if(level.btd_healthRegen != 0)
			{
				player.health = player.health + level.btd_healthRegen;
			}
			
			if(player.health > maxhealth)
			{
				player.health = maxhealth;
			}
		}
//================================================================================================
		hurtTime = gettime();
		player.breathingStopTime = hurtTime + 6000;
	}
}

playerBreathingSound(healthcap)
{
	self endon("end_healthregen");
	
	wait (2);
	player = self;
	for (;;)
	{
		wait (0.2);
		if (player.health <= 0)
			return;
			
		// Player still has a lot of health so no breathing sound
		if (player.health >= healthcap)
			continue;
		
		if ( level.healthRegenDisabled && gettime() > player.breathingStopTime )
			continue;
			
		player playLocalSound("breathing_hurt");
		wait .784;
		wait (0.1 + randomfloat (0.8));
	}
}
