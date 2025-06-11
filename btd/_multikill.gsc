#include btd\_hud_util;

multikill()
{
	if(getDvarInt("btd_multikill") == 1)
	{
		self.multi++;
		wait 0.2;
		if(self.multi > 1)
		{
			iprintln("^3" + self.name + " ^7got a multikill with ^3" + self.multi + " ^7kills!");
			self playlocalsound("multikill");
			//self dohud("^2You got a multikill with ^1" + self.multi + " ^2kills.", "multikill", 1, 0);
		}
		self.multi = 0;
	}
}