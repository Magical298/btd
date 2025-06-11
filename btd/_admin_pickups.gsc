#include btd\_dvardef;
#include btd\_admin;

pickups()
{
	self endon("disconnect");

	while(1)
	{
		wait 0.05;
		if( !isPlayer(self) )
			break;

		if( !self.can_admin_pickup )
			continue;

		if(!self useButtonPressed())
			continue;

		if(self getStance() == "prone")
			start = self.origin + (0,0,11);
		else if(self getStance() == "crouch")
			start = self.origin + (0,0,40);
		else
			start = self.origin + (0,0,60);

		end = start + maps\mp\_utility::vector_Scale(anglestoforward(self getPlayerAngles()),999999);
		trace = bulletTrace(start,end,true,self);
		dist = distance(start,trace["position"]);

		ent = trace["entity"];

		if(!isDefined(ent))
			continue;

		if(ent.classname != "player" && (ent.classname != "script_model" || !isDefined(ent.targetname) || (isDefined(ent.targetname) && ent.targetname != "zom")))
			continue;

		if(isPlayer(ent))
		{
			if( ent.isarty || ent.inHelicopter || ent.inAc130 )
				continue;
			else
				ent iPrintlnBold("You were picked up by admin ^3" + self btd\_admin::getAdminName() + "^7!");
		}

		self iPrintlnBold("You picked up ^3" + ent.name);

		ent.linker = spawn("script_origin",trace["position"]);

		ent linkto(ent.linker);

		while(isPlayer(self) && self useButtonPressed())
		{
			wait 0.05;
		}

		while(isPlayer(self) && !self useButtonPressed())
		{
			wait 0.05;

			if(!isPlayer(self) || !isDefined(ent))
				break;

			if(self getStance() == "prone")
				start = self.origin + (0,0,11);
			else if(self getStance() == "crouch")
				start = self.origin + (0,0,40);
			else
				start = self.origin + (0,0,60);

			end = start + maps\mp\_utility::vector_Scale(anglestoforward(self getPlayerAngles()),dist);
			trace = bulletTrace(start,end,false,ent);
			dist = distance(start,trace["position"]);

			if(self meleeButtonPressed() && !self adsButtonPressed())
				dist -= 15;
			else if(self meleeButtonPressed() && self adsButtonPressed())
				dist += 15;

			end = start + maps\mp\_utility::vector_Scale(anglestoforward(self getPlayerAngles()),dist);
			trace = bulletTrace(start,end,false,ent);
			ent.linker.origin = trace["position"];
		}

		if( isDefined( ent ) )
		{
			ent unlink();
			if( isPlayer( ent ) )
				ent iPrintlnBold("You were dropped by ^3" + self btd\_admin::getAdminName() + "!");

			self iPrintlnBold("You dropped ^3" + ent.name);

			ent.linker delete();
		}

		while(isPlayer(self) && self useButtonPressed())
		{
			wait 0.05;
		}
	}
}
