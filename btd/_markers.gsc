#include maps\mp\gametypes\_hud_util;

marker()
{
	if( isDefined( self.markerent ) || self.isNormalzom )
		return;

	self.markerent = spawn("script_model", self.origin + (0,0,80));
	self.markerent setModel("tag_origin");
	wait 0.05;
	if(!isDefined(self))
	{
		self.markerent delete();	// NEED TO FIX
		return;
	}
	self.markerent linkto(self);

	self.marker = newHudElem();
	self.marker.hideWhenInMenu = true;
	self.marker SetTargetEnt(self.markerent);
	self.marker.sort = 1;
	self.marker setWayPoint(true, "waypoint_target");
	self thread deletemarkerondeath();
	self thread deletemarkeronmorezoms();
}

deletemarkerondeath()
{
	self endon("markers_deleted");

	self waittill("death");

	self.marker clearTargetEnt();
	self.marker destroy();
	self.markerent unlink();
	self.markerent delete();
}

deletemarkeronmorezoms()
{
	self endon("death");

	while(1)
	{
		zombies = getentarray("zom","targetname");
		if( zombies.size > level.markernum )
			break;

		wait 0.15;
	}

	self notify("markers_deleted");

	self.marker clearTargetEnt();
	self.marker destroy();
	self.markerent unlink();
	self.markerent delete();
}
