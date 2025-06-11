#include btd\_dvardef;
#include btd\_hud_util;

main()
{
	level.msg_interval = createdvar("btd_msg_interval",10,1,120,"int");
	level.welcomemsg_interval = createdvar("btd_welcomemsg_interval",5,1,120,"int");

	thread domessages();

	// Rotating Message Of The Day, taken from X4 eXtreme Mod. http://www.mycallofduty.com
	level.btd_motd_rotate = createdvar("btd_motd_rotate", 1, 0, 1, "int");
	level.btd_motd_delay = createdvar("btd_motd_delay", 3, 3, 60, "int");

	// rotating motd
	if( level.btd_motd_rotate )
	{ thread motdRotate(); }
}

dowelcome()
{
	self endon("disconnect");

	self notify("stop_welcome_thread");
	waittillframeend;
	self endon("stop_welcome_thread");

	if(self.pers["donewelcome"])
	{ return; }

	if( isDefined( self.welcome_hud ) )
	{ self.welcome_hud destroy(); }

	self.welcome_hud = newclienthudelem(self);
	self.welcome_hud.alignX = "right";
	self.welcome_hud.alignY = "middle";
	self.welcome_hud.x = 635;
	self.welcome_hud.y = 10;
	self.welcome_hud.glowColor = (0, 0, 1);
	self.welcome_hud.glowAlpha = 0.5;
	self.welcome_hud.fontscale = 1.4;
	self.welcome_hud.alpha = 1;
	self.welcome_hud.sort = 9001;

	wait level.player_sp_time;

	num = 0;
	while(1)
	{
		msg = getdvar("btd_welcomemsg" + num);
		if(msg != "")
		{
			self.welcome_hud setText(msg);
			self.welcome_hud setPulseFX(100, 5000, 1000);

			//self thread dohud(msg);
			//self iPrintlnBold(msg);

			wait level.welcomemsg_interval;
			num++;
		}
		else
		{
			if( isDefined( self.welcome_hud ) )
			{ self.welcome_hud destroy(); }

			break;
		}
	}

	self.pers["donewelcome"] = true;
}

domessages()
{
	level endon("game_ended");
	num = 0;
	wait level.msg_interval;

	while(1)
	{
		msg = getdvar("btd_msg" + num);
		if(msg != "")
		{
			iPrintln(msg);
			wait level.msg_interval;
		}
		else if(msg == "" && num != 0)
		{
			num = 0;
			continue;
		}
		else if(msg == "" && num == 0)
		{
			break;
		}
		num++;
	}
}

//================================================================================================
// Rotating Message Of The Day, taken from X4 eXtreme Mod. http://www.mycallofduty.com

motdRotate()
{
	level.btd_motdmsg = [];

	count = 1;
	for(;;)
	{
		cvarname = "btd_motd_" + count;
		msg = getDvar(cvarname);
		if( !isDefined(msg) || msg == "" )
		{ break; }

		level.btd_motdmsg[level.btd_motdmsg.size] = msg;
		count++;
	}

	if( level.btd_motdmsg.size > 0 )
		thread motdOnPlayerConnect();
}

motdOnPlayerConnect()
{
	level endon("game_ended");

	for(;;)
	{
		level waittill("connected", player);
		//logprint("MOTD DEBUG: player connected\n");
		player thread motdStartRotation();
	}
}

motdStartRotation()
{
	level endon("game_ended");
	self endon("disconnect");

	self notify("stop_motd_rotation");
	waittillframeend;
	self endon("stop_motd_rotation");

	while(true)
	{
		for(i = 0; i < level.btd_motdmsg.size; i++)
		{
			self setClientDvar("ui_motd", level.btd_motdmsg[i]);
			wait(level.btd_motd_delay);
		}
	}
}
