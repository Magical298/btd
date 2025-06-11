devMenuResponse(response)
{
	switch(response)
	{
		case "1":
			if( self.usedevmodel )
			{
				self.usedevmodel = false;
				self iprintlnbold("^3Developer ^7model is ^3Disabled.");
			}
			else
			{
				self.usedevmodel = true;
				self iprintlnbold("^3Developer ^7model ^3Enabled.");
			}

			if( isPlayer(self) && isAlive(self) && self.sessionstate == "playing" )
			{
				self maps\mp\gametypes\_teams::playerModelForWeapon( self.pers["primaryWeapon"] );
				self maps\mp\gametypes\_weapons::stow_on_back();
				self maps\mp\gametypes\_weapons::stow_on_hip();
			}
		break;

		// admin menu
		case "2":
			if( self.countentities )
			{
				self.countentities = false;

				if(isDefined(self.entityhud))
				{ self.entityhud destroy(); }

				if(isDefined(self.entity_num))
				{ self.entity_num destroy(); }

				self iprintlnbold("^3Entity ^7Hud ^3Disabled.");
			}
			else
			{
				self.countentities = true;
				self iprintlnbold("^3Entity ^7Hud ^3Enabled.");
			}
		break;

		// dev menu
		case "3":
			if( isPlayer(self) && isAlive(self) && self.sessionstate == "playing" )
			{
				if( self.devheadicon )
				{
					self.headicon = "";
					self.devheadicon = false;
					self iprintlnBold("^7DEV HEAD ICON: ^3DISABLED");
				}
				else
				{
					self.headicon = "headicon_devl";
					self.headiconteam = self.team;
					self.devheadicon = true;
					self iprintlnBold("^7DEV HEAD ICON: ^3ENABLED");
				}
			}				
		break;
	}
}
