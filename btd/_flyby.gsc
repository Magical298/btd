//**********************************************************************************
//                                                                                 
//        _   _       _        ___  ___      _        ___  ___          _             
//       | | | |     | |       |  \/  |     | |       |  \/  |         | |           
//       | |_| | ___ | |_   _  | .  . | ___ | |_   _  | .  . | ___   __| |___       
//       |  _  |/ _ \| | | | | | |\/| |/ _ \| | | | | | |\/| |/ _ \ / _` / __|     
//       | | | | (_) | | |_| | | |  | | (_) | | |_| | | |  | | (_) | (_| \__ \     
//       \_| |_/\___/|_|\__, | \_|  |_/\___/|_|\__, | \_|  |_/\___/ \__,_|___/     
//                       __/ |                  __/ |                               
//                      |___/                  |___/                               
//                                                                                 
//                       Website: http://www.holymolymods.com                       
//*********************************************************************************
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include btd\_dvardef;

init()
{
	// Get the main module's variable
	level.scr_flybys_enable = createdvar("btd_flyby_enable",1,0,1,"int");

	// If module is not enabled there's nothing else to do here
	if( level.scr_flybys_enable == 0 )
		return;

	// Precache the models being used
	//precacheModel( "vehicle_mig29_desert" );
	//precacheModel( "vehicle_mi17_woodland_fly" );

	// Get the main module's dvar
	level.scr_planeroll = createdvar("btd_flyby_roll",1,0,1,"int");
	level.scr_planedelay = createdvar("btd_flyby_delay",120,30,999,"float");
	level.scr_planenumber = createdvar("btd_flyby_number",3,1,3,"int");
	level.scr_planenumberandom = createdvar("btd_flyby_numberandom",0,0,1,"int");
	level.scr_planemodel = createdvar("btd_flyby_model",1,1,2,"int");
	level.scr_planemodelrandom = createdvar("btd_flyby_modelrandom",1,0,1,"int");
	level.scr_planecontrail_fx = createdvar("btd_flyby_contrails",2,0,2,"int");
	level.scr_planecontrail_fx_random = createdvar("btd_flyby_contrails_random",1,0,1,"int");

	// Load Fx for Planes and Heli
	level.fx_flyby_afterburner = loadfx("fire/jet_afterburner");
	level.fx_flyby_contrail_white = loadfx("smoke/jet_contrail");
	level.fx_flyby_contrail_red = loadfx("smoke/jet_red_contrail");
	level.fx_flyby_contrail_blue = loadfx("smoke/jet_blue_contrail");

	// Start Plane positioning
	level thread start();
}

start()
{
	level endon("game_ended");

	// Must wait till the game starts: RELAX
	level waittill("wave_start");

	for(;;)
	{
		// But wait for a determined number of seconds for the next flyby, to stop looping
		wait level.scr_planedelay;

		// Track map center for Plane position
		yaw = 90 * randomInt(4);

		// If there's already an airstrike active we'll just cancel this flyby
		if( isdefined( level.airstrikeInProgress ) || isDefined( level.ac130 ) || isDefined( level.chopper ) )
		{ wait level.scr_planedelay; }

		// Spawn Values for Planes
		startplane( level.mapCenter, yaw );
	}
}

startplane( center, yaw )
{
	if( level.scr_planemodelrandom == 1 )
	{ level.scr_planemodel = randomIntRange( 1, 3 ); }

	if( level.scr_planenumberandom == 1 )
	{ level.scr_planenumber = randomIntRange( 1, 6 ); }

	// Get coordinates for the plane
	direction = ( 0, yaw, 0 );
	planeHalfDistance = 24000;
	planeFlyHeight = 1500;

	// Fly Speeds
	if( level.scr_planemodel == 1 )
	{ planeFlySpeed = 1900; }
	else
	{ planeFlySpeed = 3800; }

	if( isdefined( level.airstrikeHeightScale ) )
	{ planeFlyHeight *= level.airstrikeHeightScale; }

        // Start and End Points
	startPoint = center + vector_scale( anglestoforward( direction ), -1 * planeHalfDistance );
	startPoint += ( 0, 0, planeFlyHeight );

	endPoint = center + vector_scale( anglestoforward( direction ), planeHalfDistance );
	endPoint += ( 0, 0, planeFlyHeight );

	d = length( startPoint - endPoint );
	flyTime = ( d / planeFlySpeed );

	// Number of planes
	planeamount = level.scr_planenumber;

	for( p = 0; p < planeamount; p++ )
	{
		level thread startplaneFlyBy( startPoint+(randomInt(250),randomInt(250),randomInt(500)), endPoint+(0,0,randomInt(500)), center, flyTime, direction, yaw );
		wait randomfloatrange( 0.5, 1 );
	}
}

startplaneFlyBy( startPoint, endPoint, center, flyTime, direction, yaw )
{
	// plane spawning randomness = up to 125 units, biased towards 0
	startPathRandomness = 100;
	endPathRandomness = 150;

	pathStart = startPoint + ( (randomfloat(2) - 1)*startPathRandomness, (randomfloat(2) - 1)*startPathRandomness, 0 );
	pathEnd   = endPoint   + ( (randomfloat(2) - 1)*endPathRandomness  , (randomfloat(2) - 1)*endPathRandomness  , 0 );

	// Spawn the plane
	plane = spawn ("script_model", pathStart );

	// Hmmm, which model do we use?
	if( level.scr_planemodel == 1 )
	{ plane setmodel ("vehicle_cobra_helicopter_fly"); }

	if( level.scr_planemodel == 2 )
	{ plane setmodel ("vehicle_mig29_desert"); }

	plane.targetname = "plane";
	plane.angles = direction;
	plane moveTo( pathEnd, flyTime, 0, 0 );

	// Play Effects on Model
	if( level.scr_planemodel == 2 )
	{ plane thread planeFx(); }

	if( level.scr_planemodel == 1 )
	{ plane thread heliFx(); }

	// Random Plane Roll
	if( !randomInt(3) && level.scr_planemodel > 1 && level.scr_planeroll == 1 )
	{
		if( randomInt(2) )
		{ plane rotateroll( 360, 7 + randomFloat(3), 1, 1 ); }
		else
		{ plane rotateroll( -360, 7 + randomFloat(3), 1, 1 ); }
	}

	// Plane sound according to model
	if( level.scr_planemodel == 1 )
	{ plane thread maps\mp\gametypes\_hardpoints::play_loop_sound_on_entity("mp_hind_helicopter"); }
	else
	{ plane thread maps\mp\gametypes\_hardpoints::play_loop_sound_on_entity("veh_mig29_dist_loop"); }

	// Drop goodies at half the  flytime, that should be map center eh?
	//wait( flyTime * 0.5 );
	//dropGoodies();

	// Delete the plane after its flyby
	wait flyTime;
	plane notify( "delete" );
	plane delete();
}

heliFx()
{
	wait( 0.05 );

	playfxontag( level.fx_flyby_afterburner, self, "tag_engine_right" );
	playfxontag( level.fx_flyby_afterburner, self, "tag_engine_left" );
}

planeFx()
{
	wait( 0.05 );

	// Random Contrail Fx
	if ( level.scr_planecontrail_fx_random == 1 )
	{ level.scr_planecontrail_fx = randomIntRange( 0, 3 ); }

	wait( 0.05 );

	if( level.scr_planecontrail_fx == 0 )
	{
		playfxontag( level.fx_flyby_contrail_red, self, "tag_right_wingtip" );
		playfxontag( level.fx_flyby_contrail_red, self, "tag_left_wingtip" );
		playfxontag( level.fx_flyby_afterburner, self, "tag_engine_right" );
		playfxontag( level.fx_flyby_afterburner, self, "tag_engine_left" );
	}

	wait( 0.05 );

	if( level.scr_planecontrail_fx == 1 )
	{
		playfxontag( level.fx_flyby_contrail_blue, self, "tag_right_wingtip" );
		playfxontag( level.fx_flyby_contrail_blue, self, "tag_left_wingtip" );
		playfxontag( level.fx_flyby_afterburner, self, "tag_engine_right" );
		playfxontag( level.fx_flyby_afterburner, self, "tag_engine_left" );
	}

	wait( 0.05 );
   
	if( level.scr_planecontrail_fx == 2 )
	{
		playfxontag( level.fx_flyby_contrail_white, self, "tag_right_wingtip" );
		playfxontag( level.fx_flyby_contrail_white, self, "tag_left_wingtip" );
		playfxontag( level.fx_flyby_afterburner, self, "tag_engine_right" );
		playfxontag( level.fx_flyby_afterburner, self, "tag_engine_left" );
	}
}
