musicMenuResponse(response)
{			
	switch(response)
	{		
		// Mo Music	
		case "1":
			if(self.music_isplaying)
			{
				self stopLocalSound(self.songplaying);
				self.music_isplaying = false;
				self iPrintLn("^0[^1MUSIC^0] ^7: Track Cancelled");
				self notify("mus_restart");
			}	
		break;	
				
		// Track 1
		case "2":
			if(self.music_isplaying)
			{
				self notify("mus_restart");
			}
			self thread btd\_music::playTrack(0);
			self closeMenu();			
		break;	
				
		// Track 2
		case "3":
			if(self.music_isplaying)
			{
				self notify("mus_restart");
			}
			self thread btd\_music::playTrack(1);
			self closeMenu();			
		break;
				
		// Track 3
		case "4":
			if(self.music_isplaying)
			{
				self notify("mus_restart");
			}
			self thread btd\_music::playTrack(2);
			self closeMenu();			
		break;
				
		// Track 4
		case "5":
			if(self.music_isplaying)
			{
				self notify("mus_restart");
			}
			self thread btd\_music::playTrack(3);
			self closeMenu();		
		break;
				
		// Track 5
		case "6":
			if(self.music_isplaying)
			{
				self notify("mus_restart");
			}
			self thread btd\_music::playTrack(4);
			self closeMenu();		
		break;	
				
		// Track 6
		case "7":
			if(self.music_isplaying)
			{
				self notify("mus_restart");
			}
			self thread btd\_music::playTrack(5);
			self closeMenu();		
		break;	
				
		// Track 7
		case "8":
			if(self.music_isplaying)
			{
				self notify("mus_restart");
			}
			self thread btd\_music::playTrack(6);
			self closeMenu();		
		break;	
				
		// Track 8
		case "9":
			if(self.music_isplaying)
			{
				self notify("mus_restart");
			}
			self thread btd\_music::playTrack(7);
			self closeMenu();		
		break;
	}
}
