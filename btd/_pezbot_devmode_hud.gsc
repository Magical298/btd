#include maps\mp\gametypes\_hud_util;

devhud_waypoints()
{
	level.waypointsword = newhudelem();
	level.waypointsword.alignX = "right";
	level.waypointsword.alignY = "middle";
	level.waypointsword.horzAlign = "fullscreen";
	level.waypointsword.vertAlign = "fullscreen";
	level.waypointsword.x = 600;
	level.waypointsword.y = 30;
	level.waypointsword.alpha = 1;
	level.waypointsword.sort = 2;
	level.waypointsword.fontscale = 1.4;
	level.waypointsword.color = (0,1,1);
	level.waypointsword setText("Waypoints: ");

	level.numwaypoints = newhudelem();
	level.numwaypoints.alignX = "right";
	level.numwaypoints.alignY = "middle";
	level.numwaypoints.horzAlign = "fullscreen";
	level.numwaypoints.vertAlign = "fullscreen";
	level.numwaypoints.x = 635;
	level.numwaypoints.y = 30;
	level.numwaypoints.alpha = 1;
	level.numwaypoints.sort = 2;
	level.numwaypoints.fontscale = 1.4;
	level.numwaypoints.color = (1,1,1);
	
	level.unlinkedword = newhudelem();
	level.unlinkedword.alignX = "right";
	level.unlinkedword.alignY = "middle";
	level.unlinkedword.horzAlign = "fullscreen";
	level.unlinkedword.vertAlign = "fullscreen";
	level.unlinkedword.x = 600;
	level.unlinkedword.y = 50;
	level.unlinkedword.alpha = 1;
	level.unlinkedword.sort = 2;
	level.unlinkedword.fontscale = 1.4;
	level.unlinkedword.color = (0,1,1);
	level.unlinkedword setText("Num Unlinked: ");

	level.numunlinked = newhudelem();
	level.numunlinked.alignX = "right";
	level.numunlinked.alignY = "middle";
	level.numunlinked.horzAlign = "fullscreen";
	level.numunlinked.vertAlign = "fullscreen";
	level.numunlinked.x = 635;
	level.numunlinked.y = 50;
	level.numunlinked.alpha = 1;
	level.numunlinked.sort = 2;
	level.numunlinked.fontscale = 1.4;
	level.numunlinked.color = (1,0,0);	
	
	level.deadendword = newhudelem();
	level.deadendword.alignX = "right";
	level.deadendword.alignY = "middle";
	level.deadendword.horzAlign = "fullscreen";
	level.deadendword.vertAlign = "fullscreen";
	level.deadendword.x = 600;
	level.deadendword.y = 70;
	level.deadendword.alpha = 1;
	level.deadendword.sort = 2;
	level.deadendword.fontscale = 1.4;
	level.deadendword.color = (0,1,1);
	level.deadendword setText("Num Dead Ends: ");

	level.numdeadend = newhudelem();
	level.numdeadend.alignX = "right";
	level.numdeadend.alignY = "middle";
	level.numdeadend.horzAlign = "fullscreen";
	level.numdeadend.vertAlign = "fullscreen";
	level.numdeadend.x = 635;
	level.numdeadend.y = 70;
	level.numdeadend.alpha = 1;
	level.numdeadend.sort = 2;
	level.numdeadend.fontscale = 1.4;
	level.numdeadend.color = (1,0,1);	
	
	level.linkedword = newhudelem();
	level.linkedword.alignX = "right";
	level.linkedword.alignY = "middle";
	level.linkedword.horzAlign = "fullscreen";
	level.linkedword.vertAlign = "fullscreen";
	level.linkedword.x = 600;
	level.linkedword.y = 90;
	level.linkedword.alpha = 1;
	level.linkedword.sort = 2;
	level.linkedword.fontscale = 1.4;
	level.linkedword.color = (0,1,1);
	level.linkedword setText("Num Linked: ");

	level.numlinked = newhudelem();
	level.numlinked.alignX = "right";
	level.numlinked.alignY = "middle";
	level.numlinked.horzAlign = "fullscreen";
	level.numlinked.vertAlign = "fullscreen";
	level.numlinked.x = 635;
	level.numlinked.y = 90;
	level.numlinked.alpha = 1;
	level.numlinked.sort = 2;
	level.numlinked.fontscale = 1.4;
	level.numlinked.color = (0,1,0);	
	
	while(1)
	{
		hud_single = 0;
		hud_deadend = 0;
		hud_linked = 0;
		
		for(z = 0; z < level.waypointCount; z++)
		{
			if(level.waypoints[z].childCount == 0) {hud_single ++;}
			else if(level.waypoints[z].childCount == 1) {hud_deadend ++;}
			else if(level.waypoints[z].childCount >= 2) {hud_linked ++;}
		}	
	
		level.numwaypoints setValue(level.waypointCount);
		level.numunlinked setValue(hud_single);
		level.numdeadend setValue(hud_deadend);
		level.numlinked setValue(hud_linked);
		
		wait 0.05;
	}
}

devhud_zombiespawns()
{
	level.set1word = newhudelem();
	level.set1word.alignX = "right";
	level.set1word.alignY = "middle";
	level.set1word.horzAlign = "fullscreen";
	level.set1word.vertAlign = "fullscreen";
	level.set1word.x = 600;
	level.set1word.y = 30;
	level.set1word.alpha = 1;
	level.set1word.sort = 2;
	level.set1word.fontscale = 1.4;
	level.set1word.color = (0,1,1);
	level.set1word setText("Zombie Spawns: ");

	level.numset1 = newhudelem();
	level.numset1.alignX = "right";
	level.numset1.alignY = "middle";
	level.numset1.horzAlign = "fullscreen";
	level.numset1.vertAlign = "fullscreen";
	level.numset1.x = 635;
	level.numset1.y = 30;
	level.numset1.alpha = 1;
	level.numset1.sort = 2;
	level.numset1.fontscale = 1.4;
	level.numset1.color = (1,0,0);
	
	while(1)
	{
		level.numset1 setValue(level.zomSpawnCount);

		wait 0.05;
	}
}

devhud_tradespawns()
{
	level.tradeword = newhudelem();
	level.tradeword.alignX = "right";
	level.tradeword.alignY = "middle";
	level.tradeword.horzAlign = "fullscreen";
	level.tradeword.vertAlign = "fullscreen";
	level.tradeword.x = 600;
	level.tradeword.y = 30;
	level.tradeword.alpha = 1;
	level.tradeword.sort = 2;
	level.tradeword.fontscale = 1.4;
	level.tradeword.color = (0,1,1);
	level.tradeword setText("Trade Locations: ");

	level.numtrade = newhudelem();
	level.numtrade.alignX = "right";
	level.numtrade.alignY = "middle";
	level.numtrade.horzAlign = "fullscreen";
	level.numtrade.vertAlign = "fullscreen";
	level.numtrade.x = 635;
	level.numtrade.y = 30;
	level.numtrade.alpha = 1;
	level.numtrade.sort = 2;
	level.numtrade.fontscale = 1.4;
	level.numtrade.color = (1,0,0);	
	
	while(1)
	{			
		level.numtrade setValue(level.tradeSpawnCount);
			
		wait 0.05;
	}
}

devhud_chopperspawns()
{
	level.chopperword = newhudelem();
	level.chopperword.alignX = "right";
	level.chopperword.alignY = "middle";
	level.chopperword.horzAlign = "fullscreen";
	level.chopperword.vertAlign = "fullscreen";
	level.chopperword.x = 600;
	level.chopperword.y = 30;
	level.chopperword.alpha = 1;
	level.chopperword.sort = 2;
	level.chopperword.fontscale = 1.4;
	level.chopperword.color = (0,1,1);
	level.chopperword setText("Drop Locations: ");

	level.numchopper = newhudelem();
	level.numchopper.alignX = "right";
	level.numchopper.alignY = "middle";
	level.numchopper.horzAlign = "fullscreen";
	level.numchopper.vertAlign = "fullscreen";
	level.numchopper.x = 635;
	level.numchopper.y = 30;
	level.numchopper.alpha = 1;
	level.numchopper.sort = 2;
	level.numchopper.fontscale = 1.4;
	level.numchopper.color = (1,0,0);	
	
	while(1)
	{			
		level.numchopper setValue(level.chopperSpawnCount);
			
		wait 0.05;
	}
}

devhud_pickupspawns()
{
	level.pickupword = newhudelem();
	level.pickupword.alignX = "right";
	level.pickupword.alignY = "middle";
	level.pickupword.horzAlign = "fullscreen";
	level.pickupword.vertAlign = "fullscreen";
	level.pickupword.x = 600;
	level.pickupword.y = 30;
	level.pickupword.alpha = 1;
	level.pickupword.sort = 2;
	level.pickupword.fontscale = 1.4;
	level.pickupword.color = (0,1,1);
	level.pickupword setText("PickUp Locations: ");

	level.numpickup = newhudelem();
	level.numpickup.alignX = "right";
	level.numpickup.alignY = "middle";
	level.numpickup.horzAlign = "fullscreen";
	level.numpickup.vertAlign = "fullscreen";
	level.numpickup.x = 635;
	level.numpickup.y = 30;
	level.numpickup.alpha = 1;
	level.numpickup.sort = 2;
	level.numpickup.fontscale = 1.4;
	level.numpickup.color = (1,1,1);	
	
	while(1)
	{			
		level.numpickup setValue(level.pickupSpawnCount);
			
		wait 0.05;
	}
}

devhud_anticampspawns()
{
	level.teleword = newhudelem();
	level.teleword.alignX = "right";
	level.teleword.alignY = "middle";
	level.teleword.horzAlign = "fullscreen";
	level.teleword.vertAlign = "fullscreen";
	level.teleword.x = 600;
	level.teleword.y = 30;
	level.teleword.alpha = 1;
	level.teleword.sort = 2;
	level.teleword.fontscale = 1.4;
	level.teleword.color = (0,1,1);
	level.teleword setText("Num Teleports: ");

	level.numtele = newhudelem();
	level.numtele.alignX = "right";
	level.numtele.alignY = "middle";
	level.numtele.horzAlign = "fullscreen";
	level.numtele.vertAlign = "fullscreen";
	level.numtele.x = 635;
	level.numtele.y = 30;
	level.numtele.alpha = 1;
	level.numtele.sort = 2;
	level.numtele.fontscale = 1.4;
	level.numtele.color = (1,0,0);
	
	level.gotoword = newhudelem();
	level.gotoword.alignX = "right";
	level.gotoword.alignY = "middle";
	level.gotoword.horzAlign = "fullscreen";
	level.gotoword.vertAlign = "fullscreen";
	level.gotoword.x = 600;
	level.gotoword.y = 50;
	level.gotoword.alpha = 1;
	level.gotoword.sort = 2;
	level.gotoword.fontscale = 1.4;
	level.gotoword.color = (0,1,1);
	level.gotoword setText("Num GoTos: ");

	level.numgoto = newhudelem();
	level.numgoto.alignX = "right";
	level.numgoto.alignY = "middle";
	level.numgoto.horzAlign = "fullscreen";
	level.numgoto.vertAlign = "fullscreen";
	level.numgoto.x = 635;
	level.numgoto.y = 50;
	level.numgoto.alpha = 1;
	level.numgoto.sort = 2;
	level.numgoto.fontscale = 1.4;
	level.numgoto.color = (0,0,1);	
	
	while(1)
	{			
		level.numtele setValue(level.trigCount);
		level.numgoto setValue(level.gotoCount);
		
		wait 0.05;
	}
}

devhud_playerspawns()
{
	level.playerword = newhudelem();
	level.playerword.alignX = "right";
	level.playerword.alignY = "middle";
	level.playerword.horzAlign = "fullscreen";
	level.playerword.vertAlign = "fullscreen";
	level.playerword.x = 600;
	level.playerword.y = 30;
	level.playerword.alpha = 1;
	level.playerword.sort = 2;
	level.playerword.fontscale = 1.4;
	level.playerword.color = (0,1,1);
	level.playerword setText("Player Spawns: ");

	level.numplayer = newhudelem();
	level.numplayer.alignX = "right";
	level.numplayer.alignY = "middle";
	level.numplayer.horzAlign = "fullscreen";
	level.numplayer.vertAlign = "fullscreen";
	level.numplayer.x = 635;
	level.numplayer.y = 30;
	level.numplayer.alpha = 1;
	level.numplayer.sort = 2;
	level.numplayer.fontscale = 1.4;
	level.numplayer.color = (1,0,0);	
	
	while(1)
	{			
		level.numplayer setValue(level.playerSpawnCount);
			
		wait 0.05;
	}
}
