visionMenuResponse(response)
{
	// change vision settings
	switch(response)
	{
		// selection 1 - zombie vision
		case "1":
			setDvar("scr_setvisionmap", "zombie");
			visionSetNaked( "zombie", 2 );
			iprintln("^2" + self.name + " CHANGED VISION SETTINGS TO ^1ZOMBIE");
		break;

		// selection 2 - zombie turned vision
		case "2":
			setDvar("scr_setvisionmap", "zombie_turned");
			visionSetNaked( "zombie_turned", 2 );
			iprintln("^2" + self.name + " CHANGED VISION SETTINGS TO ^1ZOMBIE TURNED");
		break;

		// selection 3 - radioactive vision
		case "3":	
			setDvar("scr_setvisionmap", "radioactive");
			visionSetNaked( "radioactive", 2 );
			iprintln("^2" + self.name + " CHANGED VISION SETTINGS TO ^1RADIOACTIVE");
		break;

		// selection 4 - nuclear vision
		case "4":	
			setDvar("scr_setvisionmap", "nuclear");
			visionSetNaked( "nuclear", 2 );
			iprintln("^2" + self.name + " CHANGED VISION SETTINGS TO ^1NUCLEAR");
		break;

		// selection 5 - sepia vision
		case "5":	
			setDvar("scr_setvisionmap", "sepia");
			visionSetNaked( "sepia", 2 );
			iprintln("^2" + self.name + " CHANGED VISION SETTINGS TO ^1SEPIA");
		break;

		// selection 6 - armarda vision
		case "6":
			setDvar("scr_setvisionmap", "armada");
			visionSetNaked( "armada", 2 );
			iprintln("^2" + self.name + " CHANGED VISION SETTINGS TO ^1ARMADA");
		break;

		// selection 7 - grayscale vision
		case "7":
			setDvar("scr_setvisionmap", "grayscale");
			visionSetNaked( "grayscale", 2 );
			iprintln("^2" + self.name + " CHANGED VISION SETTINGS TO ^1GRAYSCALE");
		break;

		// selection 8 - grayscale contrast vision
		case "8":
			setDvar("scr_setvisionmap", "ac130_inverted");
			visionSetNaked( "ac130_inverted", 2 );
			iprintln("^2" + self.name + " CHANGED VISION SETTINGS TO ^1AC130 INVERTED");
		break;

		// selection 9 - map default vision
		case "9":
			map = getDvar("mapname");
			setDvar("scr_setvisionmap", map);
			visionSetNaked( map, 2 );
			iprintln("^2" + self.name + " CHANGED VISION SETTINGS TO ^1MAP DEFAULT");
		break;
	}
}
