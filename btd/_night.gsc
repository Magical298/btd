main()
{
	precacheModel("night_sphere");

	btd\_dvardef::createdvar("btd_fog_night", "100 1000", "", "", "string");
	btd\_dvardef::createdvar("btd_fog_day", "100 6000", "", "", "string");
	btd\_dvardef::createdvar("btd_fog", "100 3000", "", "", "string");
	btd\_dvardef::createdvar("btd_night", 1, 0, 1, "int");
	btd\_dvardef::createdvar("btd_fog_nightchange", 1, 0, 1, "int");
	btd\_dvardef::createdvar("btd_fog_color", "0 0 0", "", "", "string");

	thread night();
	thread fog();
}

//================================================================================================
// Main Night Thread
//================================================================================================
night()
{
	wait 0.05;
	night_sphere = spawn("script_model",level.mapCenter);
	night_sphere setModel("night_sphere");
	
	if(getDvar("btd_fog_night") == "") 
	{
		setDvar("btd_fog_night", "100 1000");
	}
	nightfog = getDvar("btd_fog_night");
	
	if(getDvar("btd_fog_day") == "") 
	{
		setDvar("btd_fog_day", "100 6000");
	}	
	dayfog = getDvar("btd_fog_day");
	
	if(getDvar("btd_night") == "") 
	{
		setDvar("btd_night", 1)	;	
	}
	level.nighton = getDvarInt("btd_night");
		
	night_sphere show();
	level.isnight = true;	
	
	while(1)
	{			
		level.nighton = getDvarInt("btd_night");
		
		if(level.nighton == 1  && !level.isnight)
		{
			if(getDvarInt("btd_fog_nightchange") == 1) 
			{								
				setDvar("btd_fog", nightfog);
			}
			
			night_sphere show();
			level.isnight = true;		 
		}
		else if(level.nighton == 0 && level.isnight)
		{
			if(getDvarInt("btd_fog_nightchange") == 1) 
			{
				setDvar("btd_fog", dayfog);
			}
			
			night_sphere hide();	
			level.isnight = false;
		}	
		
		wait 0.5;
	}
} 

fog()
{
	wait 0.05;

	if(getDvar("btd_fog") == "" && getDvarInt("btd_fog_nightchange") != 1)
	{ setDvar("btd_fog", "100 3000"); }

	if(getDvar("btd_fog_color") == "" )
	{ setDvar("btd_fog_color", "0 0 0"); }

	//level.startfog = getDvar("btd_fog");
	fog = getDvar("btd_fog");
	fog = StrTok(fog, " ");

	color = getDvar("btd_fog_color");
	color = strtok(color, " ");

	setDvar("fog_red",color[0]);
	setDvar("fog_green",color[1]);
	setDvar("fog_blue",color[2]);

	red = getDvarFloat("fog_red");
	green = getDvarFloat("fog_green");
	blue = getDvarFloat("fog_blue");

	setExpFog( int(fog[0]), int(fog[1]), red, blue, green, 0 );

	oldfog = fog;	
	oldcolor = color;

	while(1)
	{
		fog = StrTok(getDvar("btd_fog"), " ");
		color = StrTok(getDvar("btd_fog_color"), " ");

		if( fog != oldfog || color != oldcolor )
		{
			setDvar("fog_red",color[0]);
			setDvar("fog_green",color[1]);
			setDvar("fog_blue",color[2]);

			red = getDvarFloat("fog_red");
			green = getDvarFloat("fog_green");
			blue = getDvarFloat("fog_blue");

			setExpFog( int(fog[0]), int(fog[1]), red, green, blue, 1 );	
		}

		wait 1;
	}
} 
