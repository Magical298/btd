mainMenuResponse(response)
{
	switch(response)
	{
		case "2":
			if( level.music_enable != 0 )
			{
				self openmenu(game["menu_music"]);					 			
			}		
			else
			{						
				self iprintlnbold("^3Music ^7menu has been disabled on this server.");
			}					
		break;

		// admin menu
		case "4":
			if( self.isadmin )
			{
				self openmenu(game["menu_admin"]);					 			
			}		
			else
			{						
				self iprintlnbold("Access to the ^3Admin ^7menu is denied!");
			}					
		break;
	}
}


