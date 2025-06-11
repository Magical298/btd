#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	level.flareVisionEffectRadius = flare_get_dvar_int( "flare_effect_radius", "600" );
	level.flareDuration = flare_get_dvar_int( "flare_duration", "10"); //in seconds
}

watchFlareDetonation( owner )
{
	self waittill( "explode", position );

	durationOfFlare = level.flareDuration;

	flareEffectArea = spawn("trigger_radius", position, 0, level.flareVisionEffectRadius, level.flareVisionEffectRadius*2);

	loopWaitTime = 0.5;

	while( durationOfFlare > 0 )
	{
		zombies = level.zombies;
		for (i = 0; i < zombies.size; i++)
		{
			zom = zombies[i];
			if( isDefined( zom ) )
			{
				if ( !isDefined(zom.inFlareVisionArea) || zom.inFlareVisionArea == false )
				{
					if ( zom istouching(flareEffectArea) )
					{
						//owner iPrintLn("^2Blinding Zombie!");
						zom thread flareVision( flareEffectArea );
					}
				}
			}
		}

		wait( loopWaitTime );
		durationOfFlare -= loopWaitTime;
	}

	flareEffectArea delete();	
}

flareVision( flareEffectArea )
{
	self notify( "flareVision" );
	self endon( "flareVision" );
	self endon( "death" );
	self endon( "game_ended" );

	self.inFlareVisionArea = true;
	self.bestTarget = undefined;

	wait( level.flareDuration ); // Better to just set a time per than below method.
/*
	while( isdefined(flareEffectArea) )
	{
		wait( 0.5 );
	}
*/
	self.inFlareVisionArea = false;	
}


// returns dvar value in int
flare_get_dvar_int( dvar, def )
{
	return int( flare_get_dvar( dvar, def ) );
}

// dvar set/fetch/check
flare_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
	{
		return getdvarfloat( dvar );
	}
	else
	{
		setdvar( dvar, def );
		return def;
	}
}

