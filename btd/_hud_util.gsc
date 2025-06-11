#include maps\mp\gametypes\_hud_util;

inithud()
{
	if( level.btd_devmode != 0 )
	{ return; }

	numzomsx = 228;
	zomsleftx = 328;
	currentwavex = 426; 
	level.wave_barsize = 260;

	x = 600; // Left/Right
	y = 30;  // Top/Bottom lower = higher
	level.numzombiesword = newhudelem();
	level.numzombiesword.alignX = "right";
	level.numzombiesword.alignY = "middle";
	level.numzombiesword.horzAlign = "fullscreen";
	level.numzombiesword.vertAlign = "fullscreen";
	level.numzombiesword.x = x;
	level.numzombiesword.y = y;
	level.numzombiesword.alpha = 1;
	level.numzombiesword.glowAlpha = 0.1;
	level.numzombiesword.glowColor = (1, 0, 0);
	level.numzombiesword.sort = 2;
	level.numzombiesword.hideWhenInMenu = true;
	level.numzombiesword.fontscale = 1.4;
	level.numzombiesword.color = (1,1,1);
	level.numzombiesword setText("Zombies:");

	level.numzombies = newhudelem();
	level.numzombies.alignX = "right";
	level.numzombies.alignY = "middle";
	level.numzombies.horzAlign = "fullscreen";
	level.numzombies.vertAlign = "fullscreen";
	level.numzombies.x = x + 35;
	level.numzombies.y = y;
	level.numzombies.alpha = 1;
	level.numzombies.glowAlpha = 0.1;
	level.numzombies.glowColor = (0, 1, 0);
	level.numzombies.sort = 2;
	level.numzombies.hideWhenInMenu = true;
	level.numzombies.fontscale = 1.4;
	level.numzombies.color = (1,1,1);

	y = 50; // Top/Bottom lower = higher
	level.zombiesleftword = newhudelem();
	level.zombiesleftword.alignX = "right";
	level.zombiesleftword.alignY = "middle";
	level.zombiesleftword.horzAlign = "fullscreen";
	level.zombiesleftword.vertAlign = "fullscreen";
	level.zombiesleftword.x = x;
	level.zombiesleftword.y = y;
	level.zombiesleftword.alpha = 1;
	level.zombiesleftword.glowAlpha = 0.1;
	level.zombiesleftword.glowColor = (1, 0, 0);
	level.zombiesleftword.sort = 2;
	level.zombiesleftword.hideWhenInMenu = true;
	level.zombiesleftword.fontscale = 1.4;
	level.zombiesleftword.color = (1,1,1);
	level.zombiesleftword setText("Remaining:");

	level.zombiesleft = newhudelem();
	level.zombiesleft.alignX = "right";
	level.zombiesleft.alignY = "middle";
	level.zombiesleft.horzAlign = "fullscreen";
	level.zombiesleft.vertAlign = "fullscreen";
	level.zombiesleft.x = x + 35;
	level.zombiesleft.y = y;
	level.zombiesleft.alpha = 1;
	level.zombiesleft.glowAlpha = 0.1;
	level.zombiesleft.glowColor = (0, 1, 0);
	level.zombiesleft.sort = 2;
	level.zombiesleft.hideWhenInMenu = true;
	level.zombiesleft.fontscale = 1.4;
	level.zombiesleft.color = (1,1,1);

	y = 70;
	level.currentwaveword = newhudelem();
	level.currentwaveword.alignX = "right";
	level.currentwaveword.alignY = "middle";
	level.currentwaveword.horzAlign = "fullscreen";
	level.currentwaveword.vertAlign = "fullscreen";
	level.currentwaveword.x = x;
	level.currentwaveword.y = y;
	level.currentwaveword.alpha = 1;
	level.currentwaveword.glowAlpha = 0.1;
	level.currentwaveword.glowColor = (1, 0, 0);
	level.currentwaveword.sort = 2;
	level.currentwaveword.hideWhenInMenu = true;
	level.currentwaveword.fontscale = 1.4;
	level.currentwaveword.color = (1,1,1);
	level.currentwaveword setText("Wave:");

	level.currentwavenum = newhudelem();
	level.currentwavenum.alignX = "right";
	level.currentwavenum.alignY = "middle";
	level.currentwavenum.horzAlign = "fullscreen";
	level.currentwavenum.vertAlign = "fullscreen";
	level.currentwavenum.x = x + 13;
	level.currentwavenum.y = y;
	level.currentwavenum.alpha = 1;
	level.currentwavenum.glowAlpha = 0.1;
	level.currentwavenum.glowColor = (0, 1, 0);
	level.currentwavenum.sort = 2;
	level.currentwavenum.hideWhenInMenu = true;
	level.currentwavenum.fontscale = 1.4;
	level.currentwavenum.color = (1,1,1);

	level.currentwavenumslash = newhudelem();
	level.currentwavenumslash.alignX = "right";
	level.currentwavenumslash.alignY = "middle";
	level.currentwavenumslash.horzAlign = "fullscreen";
	level.currentwavenumslash.vertAlign = "fullscreen";
	level.currentwavenumslash.x = x + 20;
	level.currentwavenumslash.y = y;
	level.currentwavenumslash.alpha = 1;
	level.currentwavenumslash.glowAlpha = 0.1;
	level.currentwavenumslash.glowColor = (1, 0, 0);
	level.currentwavenumslash.sort = 2;
	level.currentwavenumslash.hideWhenInMenu = true;
	level.currentwavenumslash.fontscale = 1.4;
	level.currentwavenumslash.color = (1,1,1);
	level.currentwavenumslash setText("/");

	level.currentwavenummax = newhudelem();
	level.currentwavenummax.alignX = "right";
	level.currentwavenummax.alignY = "middle";
	level.currentwavenummax.horzAlign = "fullscreen";
	level.currentwavenummax.vertAlign = "fullscreen";
	level.currentwavenummax.x = x + 35;
	level.currentwavenummax.y = y;
	level.currentwavenummax.alpha = 1;
	level.currentwavenummax.glowAlpha = 0.1;
	level.currentwavenummax.glowColor = (0, 1, 0);
	level.currentwavenummax.sort = 2;
	level.currentwavenummax.hideWhenInMenu = true;
	level.currentwavenummax.fontscale = 1.4;
	level.currentwavenummax.color = (1,1,1);
	level.currentwavenummax setValue(level.number_of_waves);

	y = 90; // Top/Bottom lower = higher
	level.zombiewavelife = newhudelem();
	level.zombiewavelife.alignX = "right";
	level.zombiewavelife.alignY = "middle";
	level.zombiewavelife.horzAlign = "fullscreen";
	level.zombiewavelife.vertAlign = "fullscreen";
	level.zombiewavelife.x = x - 14;
	level.zombiewavelife.y = y;
	level.zombiewavelife.alpha = 1;
	level.zombiewavelife.glowAlpha = 0.1;
	level.zombiewavelife.glowColor = (1, 0, 0);
	level.zombiewavelife.sort = 4;
	level.zombiewavelife.hideWhenInMenu = true;
	level.zombiewavelife.fontscale = 1.4;
	level.zombiewavelife.color = (1,1,1);
	level.zombiewavelife setText("HP:");

	level.zombiewavelifeback = newhudelem();
	level.zombiewavelifeback.alignX = "right";
	level.zombiewavelifeback.alignY = "middle";
	level.zombiewavelifeback.horzAlign = "fullscreen";
	level.zombiewavelifeback.vertAlign = "fullscreen";
	level.zombiewavelifeback.x = x + 35;
	level.zombiewavelifeback.y = y;
	level.zombiewavelifeback.alpha = 1;
	level.zombiewavelifeback.glowAlpha = 0.1;
	level.zombiewavelifeback.glowColor = (0, 1, 0);
	level.zombiewavelifeback.sort = 3;
	level.zombiewavelifeback.hideWhenInMenu = true;
	level.zombiewavelifeback.fontscale = 1.4;
	level.zombiewavelifeback.color = (1,1,1);
	level.zombiewavelifeback setValue(level.totalzomsinwave);
/*
	level.zombiewavelife = newhudelem();
	level.zombiewavelife.alignX = "left";
	level.zombiewavelife.alignY = "top";
	level.zombiewavelife.horzAlign = "fullscreen";
	level.zombiewavelife.vertAlign = "fullscreen";
	level.zombiewavelife.x = 320 - (level.wave_barsize / 2.0);
	level.zombiewavelife.y = 6;
	level.zombiewavelife.alpha = 1;
	level.zombiewavelife.sort = 4;
	level.zombiewavelife.hideWhenInMenu = true;
	level.zombiewavelife.color = (1,0,0);
	level.zombiewavelife setShader("white",1,8);

	level.zombiewavelifeback = newhudelem();
	level.zombiewavelifeback.alignX = "center";
	level.zombiewavelifeback.alignY = "top";
	level.zombiewavelifeback.horzAlign = "fullscreen";
	level.zombiewavelifeback.vertAlign = "fullscreen";
	level.zombiewavelifeback.x = 320;
	level.zombiewavelifeback.y = 4;
	level.zombiewavelifeback.alpha = 0.6;
	level.zombiewavelifeback.sort = 3;
	level.zombiewavelifeback.hideWhenInMenu = true;
	level.zombiewavelifeback.color = (0,0,0);
	level.zombiewavelifeback setShader("white",(level.wave_barsize + 4),12);

	oldwidth = 1;
	scaletime = 0.5;
*/
	while(1)
	{
		level.numzombies setValue(level.zombies.size);
		level.zombiesleft setValue(level.wavetospawn);
		level.currentwavenum setValue(level.currentwave);
		wait 0.05;

		strength = 0;
		for(i=0;i<level.zombies.size;i++)
		{
			if( isDefined(level.zombies[i]) )
			{ strength += level.zombies[i].health; }
		}
		level.zombiewavelifeback setValue(strength);

		if(level.zombies.size <= level.markernum)
		{
			for(i=0;i<level.zombies.size;i++)
			{
				if( isDefined(level.zombies[i]) )
				{ level.zombies[i] thread btd\_markers::marker(); }
			}
		}
/*
		if(!level.zombies.size)
		{
			level.zombiewavelife scaleOverTime(0.5,1,8);
			continue;
		}

		totalhealth = 0;		
		maxhealth = 0;
		for(i=0;i<level.totalzomsinwave;i++)
		{			
			if(isDefined(level.zombies[i]))
			{
				totalhealth += level.zombies[i].health;
				maxhealth += level.zombies[i].maxhealth;
			}
		}

		//maxhealth = level.totalzomsinwave * level.zommaxhealth;
		//maxhealth = level.totalzomsinwave * 200;
		
		width = int(totalhealth / maxhealth * (level.wave_barsize + 4));
		if(width <= 0)
		{ width = 1; }

		if(width != oldwidth)
		{ level.zombiewavelife scaleOverTime(scaletime,width,8); }

		oldwidth = width;
*/
	}
}

hud_health()
{
	self notify("stop_healthbar_thread");
	self endon("disconnect");
	self endon( "game_ended" );
	self endon("stop_healthbar_thread");

	widthofbar = 120;
	x = 10;
	y = 420;

	if(isDefined(self.healthword))
		self.healthword destroy();

	if(isDefined(self.healthnum))
		self.healthnum destroy();

	if(isDefined(self.healthbar))
		self.healthbar destroy();

	if(isDefined(self.healthbarback))
		self.healthbarback destroy();
/*
	if(isDefined(self.healthwarning))
		self.healthwarning destroy();

	self.healthword = newclienthudelem(self);
	self.healthword.alignX = "left";
	self.healthword.alignY = "middle";
	self.healthword.horzAlign = "fullscreen";
	self.healthword.vertAlign = "fullscreen";
	self.healthword.x = x;
	self.healthword.y = y - 10;
	self.healthword.alpha = 1;
	self.healthword.sort = 2;
	self.healthword.foreground = false;
	self.healthword.hideWhenInMenu = true;
	self.healthword.fontscale = 1.4;
	self.healthword.color = (1,1,1);
	self.healthword setText("Health:");
*/
	self.healthnum = newclienthudelem(self);
	self.healthnum.alignX = "left";
	self.healthnum.alignY = "middle";
	self.healthnum.horzAlign = "fullscreen";
	self.healthnum.vertAlign = "fullscreen";
	self.healthnum.x = x + 40;
	self.healthnum.y = y - 10;
	self.healthnum.alpha = 1;
	self.healthnum.sort = 2;
	self.healthnum.foreground = false;
	self.healthnum.hideWhenInMenu = true;
	self.healthnum.fontscale = 1.4;
	self.healthnum.color = (1,1,1);
/*
	self.healthbar = newclienthudelem(self);
	self.healthbar.alignX = "left";
	self.healthbar.alignY = "middle";
	self.healthbar.horzAlign = "fullscreen";
	self.healthbar.vertAlign = "fullscreen";
	self.healthbar.x = x;
	self.healthbar.y = y;
	self.healthbar.alpha = 1;
	self.healthbar.sort = 2;
	self.healthbar.foreground = false;
	self.healthbar.hideWhenInMenu = true;
	self.healthbar.color = (1,1,1);
	self.healthbar setShader("white",widthofbar,3);

	self.healthbarback = newclienthudelem(self);
	self.healthbarback.alignX = "left";
	self.healthbarback.alignY = "middle";
	self.healthbarback.horzAlign = "fullscreen";
	self.healthbarback.vertAlign = "fullscreen";
	self.healthbarback.x = x;
	self.healthbarback.y = y;
	self.healthbarback.alpha = 0.5;
	self.healthbarback.sort = 1;
	self.healthbarback.foreground = false;
	self.healthbarback.hideWhenInMenu = true;
	self.healthbarback.color = (0,0,0);
	self.healthbarback setShader("white",widthofbar,6);

	self.healthwarning = newclienthudelem(self);
	self.healthwarning.alignX = "center";
	self.healthwarning.alignY = "middle";
	self.healthwarning.horzAlign = "fullscreen";
	self.healthwarning.vertAlign = "fullscreen";
	self.healthwarning.x = x + 140;
	self.healthwarning.y = y;
	self.healthwarning.alpha = 0;
	self.healthwarning.sort = 2;
	self.healthwarning.foreground = false;
	self.healthwarning.hideWhenInMenu = true;
	self.healthwarning.color = (1,1,1);
	self.healthwarning setShader("hud_lowhealth_warning",32,32);

	self thread pulsesize();
*/
	while(1)
	{
		if(self.sessionstate != "playing" || !isDefined(self.health) || !isDefined(self.maxhealth))
		{
			//self.healthword.alpha = 0;
			self.healthnum.alpha = 0;
			//self.healthbar.alpha = 0;
			//self.healthbarback.alpha = 0;
			//self.healthwarning.alpha = 0;
			wait 0.05;
			continue;
		}
		//self.healthword.alpha = 1;
		self.healthnum.alpha = 1;
		//self.healthbar.alpha = 1;
		//self.healthbarback.alpha = 0.5;
/*
		warninghealth = int(self.maxhealth / 3);
		if(self.health <= warninghealth)
		{ self.healthwarning.alpha = 1; }
		else
		{ self.healthwarning.alpha = 0; }

		width = int(self.health/self.maxhealth*widthofbar);
		if(width <= 0)
		{ width = 1; }

		self.healthbar setShader("white", width, 3);

		green = (self.health/self.maxhealth);
		red = (1 - green);
		self.healthbar.color = (red,green,0);
		self.healthnum.color = (red,green,0);
*/
		self.healthnum setValue(self.health);
		wait 0.05;
	}
}

hud_player_stuff()
{
	self notify("stop_playerstuff_thread");
	self endon("disconnect");
	self endon( "game_ended" );
	self endon("stop_playerstuff_thread");
/*
	if(isDefined(self.surword))
	{ self.surword destroy(); }

	if(isDefined(self.surnum))
	{ self.surnum destroy(); }
*/
	if(isDefined(self.streakword))
	{ self.streakword destroy(); }

	if(isDefined(self.streaknum))
	{ self.streaknum destroy(); }

	if(isDefined(self.livesword))
	{ self.livesword destroy(); }

	if(isDefined(self.livesnum))
	{ self.livesnum destroy(); }

	if(isDefined(self.moneyhud))
	{ self.moneyhud destroy(); }

	if(isDefined(self.money_num))
	{ self.money_num destroy(); }

	if(isDefined(self.entityhud))
	{ self.entityhud destroy(); }

	if(isDefined(self.entity_num))
	{ self.entity_num destroy(); }

	if(isDefined(self.artyhud))
	{ self.artyhud destroy(); }

	if(isDefined(self.arty_num))
	{ self.arty_num destroy(); }

	// Survivors
	x = 600; // Left/Right
/*
	y = 130; // Top/Bottom lower = higher
	self.surword = newclienthudelem(self);
	self.surword.alignX = "right";
	self.surword.alignY = "middle";
	self.surword.horzAlign = "fullscreen";
	self.surword.vertAlign = "fullscreen";
	self.surword.x = x;
	self.surword.y = y;
	self.surword.alpha = 1;
	self.surword.sort = 2;
	self.surword.hideWhenInMenu = true;
	self.surword.glowAlpha = 0.1;
	self.surword.glowColor = (0, 0, 1);
	self.surword.fontscale = 1.4;
	self.surword.color = (1,1,1);
	self.surword setText("Survivors:");

	self.surnum = newclienthudelem(self);
	self.surnum.alignX = "right";
	self.surnum.alignY = "middle";
	self.surnum.horzAlign = "fullscreen";
	self.surnum.vertAlign = "fullscreen";
	self.surnum.x = x + 35;
	self.surnum.y = y;
	self.surnum.alpha = 1;
	self.surnum.glowAlpha = 0.1;
	self.surnum.glowColor = (1, 1, 0);
	self.surnum.sort = 2;
	self.surnum.hideWhenInMenu = true;
	self.surnum.fontscale = 1.4;
	self.surnum.color = (1,1,1);
*/
	// Killstreak
	y = 130; // Top/Bottom lower = higher
	self.streakword = newclienthudelem(self);
	self.streakword.alignX = "right";
	self.streakword.alignY = "middle";
	self.streakword.horzAlign = "fullscreen";
	self.streakword.vertAlign = "fullscreen";
	self.streakword.x = x;
	self.streakword.y = y;
	self.streakword.alpha = 1;
	self.streakword.sort = 2;
	self.streakword.hideWhenInMenu = true;
	self.streakword.glowAlpha = 0.1;
	self.streakword.glowColor = (0, 0, 1);
	self.streakword.fontscale = 1.4;
	self.streakword.color = (1,1,1);
	self.streakword setText("Killstreak:");

	self.streaknum = newclienthudelem(self);
	self.streaknum.alignX = "right";
	self.streaknum.alignY = "middle";
	self.streaknum.horzAlign = "fullscreen";
	self.streaknum.vertAlign = "fullscreen";
	self.streaknum.x = x + 35;
	self.streaknum.y = y;
	self.streaknum.alpha = 1;
	self.streaknum.sort = 2;
	self.streaknum.hideWhenInMenu = true;
	self.streaknum.glowAlpha = 0.1;
	self.streaknum.glowColor = (1, 1, 0);
	self.streaknum.fontscale = 1.4;
	self.streaknum.color = (1,1,1);

	// Lives
	y = 150; // Top/Bottom lower = higher
	self.livesword = newclienthudelem(self);
	self.livesword.alignX = "right";
	self.livesword.alignY = "middle";
	self.livesword.horzAlign = "fullscreen";
	self.livesword.vertAlign = "fullscreen";
	self.livesword.x = x;
	self.livesword.y = y;
	self.livesword.alpha = 1;
	self.livesword.sort = 2;
	self.livesword.hideWhenInMenu = true;
	self.livesword.glowAlpha = 0.1;
	self.livesword.glowColor = (0, 0, 1);
	self.livesword.fontscale = 1.4;
	self.livesword.color = (1,1,1);
	self.livesword setText("Lives Left:");

	self.livesnum = newclienthudelem(self);
	self.livesnum.alignX = "right";
	self.livesnum.alignY = "middle";
	self.livesnum.horzAlign = "fullscreen";
	self.livesnum.vertAlign = "fullscreen";
	self.livesnum.x = x + 35;
	self.livesnum.y = y;
	self.livesnum.alpha = 1;
	self.livesnum.sort = 2;
	self.livesnum.hideWhenInMenu = true;
	self.livesnum.glowAlpha = 0.1;
	self.livesnum.glowColor = (1, 1, 0);
	self.livesnum.fontscale = 1.4;
	self.livesnum.color = (1,1,1);

	y = 170;
	self.artyhud = newClientHudElem(self);
	self.artyhud.alignX = "right";
	self.artyhud.alignY = "middle";
	self.artyhud.horzAlign = "fullscreen";
	self.artyhud.vertAlign = "fullscreen";
	self.artyhud.x = x;
	self.artyhud.y = y;
	self.artyhud.sort = 2;
	self.artyhud.hideWhenInMenu = true;
	self.artyhud.alpha = 1;
	self.artyhud.glowAlpha = 0.1;
	self.artyhud.glowColor = (0, 0, 1);
	self.artyhud.fontscale = 1.4;
	self.artyhud.color = (1,1,1);
	self.artyhud setText("Artillery:");

	self.arty_num = newClientHudElem(self);
	self.arty_num.alignX = "right";
	self.arty_num.alignY = "middle";
	self.arty_num.horzAlign = "fullscreen";
	self.arty_num.vertAlign = "fullscreen";
	self.arty_num.x = x + 35;
	self.arty_num.y = y;
	self.arty_num.sort = 2;
	self.arty_num.hideWhenInMenu = true;
	self.arty_num.alpha = 1;
	self.arty_num.glowAlpha = 0.1;
	self.arty_num.glowColor = (1, 1, 0);
	self.arty_num.fontscale = 1.4;
	self.arty_num.color = (1,1,1);

	if( level.traderon == 1 )
	{
		y = 190; // Top/Bottom lower = higher
		self.moneyhud = newClientHudElem(self);
		self.moneyhud.alignX = "right";
		self.moneyhud.alignY = "middle";
		self.moneyhud.horzAlign = "fullscreen";
		self.moneyhud.vertAlign = "fullscreen";
		self.moneyhud.x = x - 15;
		self.moneyhud.y = y;
		self.moneyhud.alpha = 1;
		self.moneyhud.sort = 2;
		self.moneyhud.hideWhenInMenu = true;
		self.moneyhud.glowAlpha = 0.1;
		self.moneyhud.glowColor = (0, 0, 1);
		self.moneyhud.fontscale = 1.4;
		self.moneyhud.color = (1,1,1);
		self.moneyhud setText("Money:");

		self.money_num = newClientHudElem(self);
		self.money_num.alignX = "right";
		self.money_num.alignY = "middle";
		self.money_num.horzAlign = "fullscreen";
		self.money_num.vertAlign = "fullscreen";
		self.money_num.x = x + 35;
		self.money_num.y = y;
		self.money_num.alpha = 1;
		self.money_num.hideWhenInMenu = true;
		self.money_num.fontscale = 1.4;
		self.money_num.glowAlpha = 0.1;
		self.money_num.glowColor = (1, 1, 0);
		self.money_num.sort = 2;
		self.money_num.color = (1,1,1);
		self.money_num setValue(0);
	}

	//Debug entity count
	if( self.countentities )
	{
		y = 210;
		self.entityhud = newClientHudElem(self);
		self.entityhud.alignX = "right";
		self.entityhud.alignY = "middle";
		self.entityhud.horzAlign = "fullscreen";
		self.entityhud.vertAlign = "fullscreen";
		self.entityhud.x = x;
		self.entityhud.y = y;
		self.entityhud.alpha = 1;
		self.entityhud.sort = 2;
		self.entityhud.hideWhenInMenu = true;
		self.entityhud.fontscale = 1.4;
		self.entityhud.glowAlpha = 0.1;
		self.entityhud.glowColor = (0, 0, 1);
		self.entityhud.color = (1,1,1);
		self.entityhud.archived = false;
		self.entityhud setText("Entities:");

		self.entity_num = newClientHudElem(self);
		self.entity_num.alignX = "right";
		self.entity_num.alignY = "middle";
		self.entity_num.horzAlign = "fullscreen";
		self.entity_num.vertAlign = "fullscreen";
		self.entity_num.x = x + 35;
		self.entity_num.y = y;
		self.entity_num.alpha = 1;
		self.entity_num.sort = 2;
		self.entity_num.hideWhenInMenu = true;
		self.entity_num.glowAlpha = 0.1;
		self.entity_num.glowColor = (1, 1, 0);
		self.entity_num.fontscale = 1.4;
		self.entity_num.color = (1,1,1);
		self.entity_num.archived = false;
	}

	while(1)
	{
		self.streaknum setValue( self.cur_kill_streak );
		//self.surnum setValue( get_survivor_count() );
		self.livesnum setValue( self.pers["lives"] );
		self.arty_num setValue(self.num_arty);

		if( level.traderon == 1 )
		{ self.money_num setValue(self.money); }

		if( self.countentities )
		{
			ents = getEntArray();
			self.entity_num setValue(ents.size);
		}
		wait 0.5;
	}
}

get_survivor_count()
{
	count = 0;
	players = getentarray("player","classname");
	for( p = 0; p < players.size; p++ )
	{
		if( ( isAlive(players[p]) || players[p].sessionstate == "playing" ) && players[p].team == "allies" )
		{
			count++;
		}
	}
	return count;
}

pulsesize()
{
	self notify("stop_pulse_thread");
	self endon("disconnect");
	self endon("stop_pulse_thread");
	while(1)
	{
		self.healthwarning scaleOverTime(0.5,64,64);
		wait 0.5;
		self.healthwarning scaleOverTime(0.5,32,32);
		wait 0.5;
	}
}

dohud(msg, sound, msgdelay, sounddelay, type)
{
	if(!isPlayer(self))
		return;

	if(!isDefined(msgdelay))
		msgdelay = 0;

	if(!isDefined(sounddelay))
		sounddelay = 0;

	if(!isDefined(type))
		type = self.notifyText;

	hudstuff = spawnstruct();
	hudstuff.msg = msg;
	hudstuff.sound = sound;
	hudstuff.msgdelay = msgdelay;
	hudstuff.sounddelay = sounddelay;
	hudstuff.type = type;

	self thread nowdohud(hudstuff);
}

nowdohud(hudstuff)
{
	self endon("disconnect");

	if(self.doinghud)
	{
		self.btdhudQueue[self.btdhudQueue.size] = hudstuff;
		return;
	}

	self.doinghud = true;

	duration = 5.0;
	glowColor = (1,0,0);
	glowAlpha = 1;
	hudstuff.type setPoint( "CENTER", "CENTER", 0, 100);
	hudstuff.type setPulseFX(40, int(duration*1000), 1000);
	hudstuff.type.glowColor = glowColor;
	hudstuff.type.glowAlpha = glowAlpha;
	hudstuff.type.alpha = 1;
	hudstuff.type.label = &"";

	if(isDefined(hudstuff.msg))
		self.notifyText setText(hudstuff.msg);
	if(isDefined(hudstuff.sound))
	{
		wait hudstuff.sounddelay;
		self playlocalsound(hudstuff.sound);
	}

	wait 2;

	self.doinghud = false;

	if(self.btdhudQueue.size > 0)
	{
		hudstuff = self.btdhudQueue[0];
		
		newQueue = [];
		for (i=1;i<self.btdhudQueue.size;i++)
			self.btdhudQueue[i-1] = self.btdhudQueue[i];
		self.btdhudQueue[i-1] = undefined;

		self thread nowdohud(hudstuff);
	}
}
