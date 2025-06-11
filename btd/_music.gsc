#include btd\_dvardef;

main()
{	
	level.music_enable = createdvar("btd_music_enable",1,0,1,"int");
	level.music_autostart = createdvar("btd_music_autostart",0,0,1,"int");
	level.music_random = createdvar("btd_music_random",1,0,1,"int");
	level.music_tracks = createdvar("btd_music_tracks",0,0,8,"int");

	if(level.music_enable == 0)
	{ return; }

	level.trackname[0] = getDvar("btd_custom_track1");		
	level.trackname[1] = getDvar("btd_custom_track2");	
	level.trackname[2] = getDvar("btd_custom_track3");	
	level.trackname[3] = getDvar("btd_custom_track4");	
	level.trackname[4] = getDvar("btd_custom_track5");
	level.trackname[5] = getDvar("btd_custom_track6");	
	level.trackname[6] = getDvar("btd_custom_track7");	
	level.trackname[7] = getDvar("btd_custom_track8");	
	
	level.artistname[0] = getDvar("btd_custom_artist1");
	level.artistname[1] = getDvar("btd_custom_artist2");
	level.artistname[2] = getDvar("btd_custom_artist3");
	level.artistname[3] = getDvar("btd_custom_artist4");
	level.artistname[4] = getDvar("btd_custom_artist5");
	level.artistname[5] = getDvar("btd_custom_artist6");
	level.artistname[6] = getDvar("btd_custom_artist7");
	level.artistname[7] = getDvar("btd_custom_artist8");
	
	level.tracklength[0] = getDvarInt("btd_custom_length1");
	level.tracklength[1] = getDvarInt("btd_custom_length2");
	level.tracklength[2] = getDvarInt("btd_custom_length3");
	level.tracklength[3] = getDvarInt("btd_custom_length4");
	level.tracklength[4] = getDvarInt("btd_custom_length5");
	level.tracklength[5] = getDvarInt("btd_custom_length6");
	level.tracklength[6] = getDvarInt("btd_custom_length7");
	level.tracklength[7] = getDvarInt("btd_custom_length8");
}

// Send the client the list of tracks to be displayed in menu
music()
{
	self endon("disconnect");

	if(level.music_enable == 0)
	{ return; }
	
	mString1 = "";
	mString2 = "";
	mString3 = "";
	mString4 = "";
	mString5 = "";
	mString6 = "";
	mString7 = "";
	mString8 = "";	
	
	self setclientdvar("num_music_tracks", level.music_tracks);
	
	if(level.music_tracks >= 1)
	{
		mString1 = ("^3[^72^3] ^7- " + level.artistname[0] + ": " + level.trackname[0]);
		self setclientdvar("music1", mString1);
	}
	if(level.music_tracks >= 2)
	{
		mString2 = ("^3[^73^3] ^7- " + level.artistname[1] + ": " + level.trackname[1]);
		self setclientdvar("music2", mString2);
	}
	if(level.music_tracks >= 3)
	{
		mString3 = ("^3[^74^3] ^7- " + level.artistname[2] + ": " + level.trackname[2]);
		self setclientdvar("music3", mString3);
	}
	if(level.music_tracks >= 4)
	{
		mString4 = ("^3[^75^3] ^7- " + level.artistname[3] + ": " + level.trackname[3]);
		self setclientdvar("music4", mString4);
	}
	if(level.music_tracks >= 5)
	{
		mString5 = ("^3[^76^3] ^7- " + level.artistname[4] + ": " + level.trackname[4]);	
		self setclientdvar("music5", mString5);
	}
	if(level.music_tracks >= 6)
	{
		mString6 = ("^3[^77^3] ^7- " + level.artistname[5] + ": " + level.trackname[5]);	
		self setclientdvar("music6", mString6);
	}
	if(level.music_tracks >= 7)
	{
		mString7 = ("^3[^78^3] ^7- " + level.artistname[6] + ": " + level.trackname[6]);	
		self setclientdvar("music7", mString7);
	}
	if(level.music_tracks >= 8)
	{
		mString8 = ("^3[^79^3] ^7- " + level.artistname[7] + ": " + level.trackname[7]);	
		self setclientdvar("music8", mString8);
	}
}

playTrack(tracknum)
{
	self endon("mus_restart");
	self endon("disconnect");
	self endon("game_ended");

	if( level.music_enable == 0 )
	{ return; }

	if(self.music_isplaying)
	{
		self stopLocalSound(self.songplaying);
		self iPrintLn("^0[^1MUSIC^0] ^7: Track Cancelled");
	}

	wait 1.5;
	self iPrintLn("^3[^7TRACK^3] ^7: " + level.trackname[tracknum] + " by " + level.artistname[tracknum]);
	wait 1.5;
	self.chosentrack = tracknum;
	self playLocalSound("zom_track_cust_" + self.chosentrack);
	self.music_isplaying = true;
	self.songplaying = ("zom_track_cust_" + self.chosentrack);
	wait (level.tracklength[tracknum]);
	self iPrintLn("^3[^7MUSIC^3] ^7: Track Completed");
	self stopLocalSound(self.songplaying);
	self.music_isplaying = false;
	wait 1.5;

	if( level.music_random )
	{
		tracknum = randomInt( level.music_tracks );
	}
	else
	{
		tracknum++;
		if( tracknum > ( level.music_tracks - 1 ) )
		{
			tracknum = 0;
		}
	}
	self iPrintLn("^3[^7MUSIC^3] ^7: Track Rotating");
	wait 1;
	self thread playTrack(tracknum);
}
