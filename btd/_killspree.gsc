#include btd\_hud_util;

check_for_rampage(victim)
{
	self.kill_spree++;

	if(self.kill_spree == 25)
	{
		wait 0.9;
		iprintln(self.name +"^2 is on a ^1KILLING SPREE^2 with ^125 ^2kills in a row!");
		self thread dohud("^2You're on a ^1KILLING SPREE!", "killingspree");
	}
	else if(self.kill_spree == 50)
	{ 
		wait 0.9;
		iprintln(self.name +"^2 is on a ^1RAMPAGE^2 with ^150 ^2kills in a row!");
		self thread dohud("^2You're on a ^1RAMPAGE!", "rampage");
	}
	else if(self.kill_spree == 75)
	{
		wait 0.9;
		iprintln(self.name +"^2 is ^1DOMINATING^2 with ^175 ^2kills in a row!");
		self thread dohud("^2You're ^1DOMINATING!", "dominating");
	}
	else if(self.kill_spree == 100)
	{
		wait 0.9;
 		iprintln(self.name +"^2 is ^1UNSTOPPABLE^2 with ^1100 ^2kills in a row!");
		self thread dohud("^2You're ^1UNSTOPPABLE!", "unstoppable");
	}
	else if(self.kill_spree == 150)
	{
		wait 0.9;
 		iprintln(self.name +"^2 is ^1SLAUGHTERING^2 with ^1150 ^2kills in a row!");
		self thread dohud("^2You're ^1SLAUGHTERING!", "slaughter");
	}
	else if(self.kill_spree == 200)
	{
		wait 0.9;
  		iprintln(self.name +" ^2is a ^1MONSTER^2 with ^1200 ^2kills in a row!");
		self thread dohud("^1MONSTER KILLER!", "monster");
	}
	else if(self.kill_spree == 250)
	{
		wait 0.9;
 		iprintln("^1Mega Kill! ^7"+ self.name +" ^2has ^1250 ^2kills in a row!");
		self thread dohud("^1Mega Kill!", "holyshit");
	}
	else if(self.kill_spree == 500)
	{
		wait 0.9;
		iprintln(self.name +"^2 is ^1GODLIKE^2 with ^1500 ^2kills in a row!");
		self thread dohud("^1GOD LIKE!", "godlike");
	}
}
// Zod: Rewrite to reduce size.
check_for_endoframpage(eInflictor,attacker)
{
	if(self.kill_spree >= 25 && self.kill_spree <= 50)
		msg = "^1KILLING SPREE";
	else if(self.kill_spree >= 50 && self.kill_spree <= 75)
		msg = "^1RAMPAGE";
	else if(self.kill_spree >= 75 && self.kill_spree <= 100)
		msg = "^1DOMINATION";
	else if(self.kill_spree >= 100 && self.kill_spree <= 150)
		msg = "^1UNSTOPPABLE KILLING SPREE!";
	else if(self.kill_spree >= 150 && self.kill_spree <= 200)
		msg = "^1SLAUGHTERING KILLING SPREE!";
	else if(self.kill_spree >= 200 && self.kill_spree <= 250)
		msg = "^1MONSTER KILLING SPREE!";
	else if(self.kill_spree >= 250 && self.kill_spree <= 500)
		msg = "^1MEGA KILL KILLING SPREE!";
	else if(self.kill_spree >= 500)
		msg = "^1GOD LIKE KILLING SPREE!";
	else
		msg = "^1SPREE";

	self.kill_spree = 0;

	iprintln("^2 " + self.name + "'s " + msg + " ^1has come to an end.");
}
