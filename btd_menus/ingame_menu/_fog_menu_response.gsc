#include btd\_admin;

init()
{	
	// the next values set the default menu fog levels
	
	if(getDvar("btd_fog_menu1") == "") 
	{
		setDvar("btd_fog_menu1", "100 6000");		
	}
	level.menu_fog1 = getDvar("btd_fog_menu1");
	
	if(getDvar("btd_fog_menu2") == "") 
	{
		setDvar("btd_fog_menu2", "100 4000");		
	}
	level.menu_fog2 = getDvar("btd_fog_menu2");
	
	if(getDvar("btd_fog_menu3") == "") 
	{
		setDvar("btd_fog_menu3", "100 2000");		
	}
	level.menu_fog3 = getDvar("btd_fog_menu3");
	
	if(getDvar("btd_fog_menu4") == "") 
	{
		setDvar("btd_fog_menu4", "100 1000");		
	}
	level.menu_fog4 = getDvar("btd_fog_menu4");
	
	if(getDvar("btd_fog_menu5") == "") 
	{
		setDvar("btd_fog_menu5", "100 500");		
	}
	level.menu_fog5 = getDvar("btd_fog_menu5");
	
	if(getDvar("btd_fog_menu6") == "") 
	{
		setDvar("btd_fog_menu6", "100 250");		
	}
	level.menu_fog6 = getDvar("btd_fog_menu6");
}

fogMenuResponse(response)
{
	// change vision settings
	switch(response)
	{
		// selection 1 - fog level 1
		case "1":
			setDvar("btd_fog", level.menu_fog1);
		break;	

		// selection 2 - fog level 2
		case "2":
			setDvar("btd_fog", level.menu_fog2); 
		break;	
				
		// selection 3 - fog level 3
		case "3":
			setDvar("btd_fog", level.menu_fog3);
		break;
				
		// selection 4 - fog level 4
		case "4":
			setDvar("btd_fog", level.menu_fog4);
		break;	
				
		// selection 5 - fog level 5
		case "5":
			setDvar("btd_fog", level.menu_fog5);					 			
		break;	

		// selection 6 - fog level 6
		case "6":
			setDvar("btd_fog", level.menu_fog6);					 
		break;
	}	
}
