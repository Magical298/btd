#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

check_scoped_weapon()
{
	weap = self getCurrentWeapon();
	
	if( weap == "m40a3_mp" || weap == "m21_mp" || weap == "dragunov_mp" || 
		weap == "remington700_mp" || weap == "barrett_mp" || weap == "special1_mp" )
	{
		return true;
	}
	else
	{
		return false;
	}
}

toggleZoomFOV()
{
	self endon("disconnect");
	self endon("death");
	self endon("joined_spectators");
	self endon("killed_player");

	if( !isDefined( self.zoomtext ) )
	{
		self.zoomtext = NewClientHudElem(self); 
		self.zoomtext.alignX = "right";
		self.zoomtext.alignY = "top";
		self.zoomtext.x = 418;
		self.zoomtext.y = 30;
		self.zoomtext.archived = true;
		self.zoomtext.fontScale = 1.4; 
		self.zoomtext.alpha = 0;
		self.zoomtext setText( "Press ^3[{+melee}] ^7to cycle zoom" );

		self.zoomnum = NewClientHudElem(self); 
		self.zoomnum.color = (1, 1, 0);
		self.zoomnum.alignX = "center";
		self.zoomnum.alignY = "top";
		self.zoomnum.x = 320;
		self.zoomnum.y = 46;
		self.zoomnum.archived = true;
		self.zoomnum.fontScale = 1.4; 
		self.zoomnum.alpha = 0;

		self.zoom = [];
		self.zoom[0] = "1x";
		self.zoom[1] = "2x";
		self.zoom[2] = "3x";
		self.zoom[3] = "4x";
		self.zoom[4] = "5x";
		self.zoom[5] = "6x";
		self.zoom[6] = "7x";
	}

	self.wasthridperson = false;
	zoom = 0;

	while(isAlive(self))
	{
		if( self ADSButtonPressed() && self playerADS() == 1 && check_scoped_weapon() )
		{
			if(self.thirdperson == true)
			{
				self.wasthridperson = true;				
				self setClientDvar("cg_thirdperson",0);				
			}

			self.zoomtext.alpha = 1;
			self.zoomnum.alpha = 1;

			if( self MeleeButtonPressed() )
			{
				zoom++;
				if( zoom > 6 )
				{ zoom = 0; }

				self playlocalsound("mouse_click");
				wait 0.2;
			}

			self update_zoom_fov(zoom);
			self.zoomnum setText( self.zoom[zoom] );
		}
		else
		{
			if(self.wasthridperson == true)
			{
				self.wasthridperson = false;				
				self setClientDvar("cg_thirdperson",1);	
				self.thirdperson = true;
			}

			self.zoomtext.alpha = 0;
			self.zoomnum.alpha = 0;
			self setclientDvar("cg_fovmin", "10");
		}
		wait 0.05;
	}
}

update_zoom_fov(zoom)
{
	zoomvalue = 70 - (zoom * 10);
	self setclientDvar("cg_fovmin", zoomvalue);
}
