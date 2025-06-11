////////////////////////////////////////////////////////////////
// PeZBOT, version: 006p
// Author: PEZZALUCIFER
// Changed by AbneyPark & Kill3r for Before The Dawn
// Removed all that that wasnt needed
// Slightly mangled by Zod
////////////////////////////////////////////////////////////////

#include BTD\_dvardef;

////////////////////////////////////////////////////////////
// can we debugdraw???
///////////////////////////////////////////////////////////
CanDebugDraw()
{
	if(getdvarInt("svr_pezbots_drawdebug") >= 1)
	{
		return true;
	}
	else
	{
		return false;
	}
}

////////////////////////////////////////////////////////////
// resets a bot
////////////////////////////////////////////////////////////
// CHANGED FOR BEFORE THE DAWN
BotReset()
{
	self notify("BotReset");

	if( !isDefined( self ) )
	{ return; }

	self BotGoal_ClearGoals();
	self.vMoveDirection = (0,1,0);
	//self.moveSpeed = getdvarint("btd_test_zom_speed");
	self.bFaceNearestEnemy = true;
	self.buggyBotCounter = 0;
	self.lastOrigin = self.origin;
	self.vObjectivePos = self.origin;
	self.bClampToGround = true;
	self.currentStaticWp = -1;
	self.flankSide = (randomIntRange(0,2) - 0.5) * 2.0;
	self.fTargetMemory = gettime()-15000;
	self.rememberedTarget = undefined;
	self.bestTarget = undefined;
	self.bThreadsRunning = false;
	self.randomPosSet = false;
}

////////////////////////////////////////////////////////////
// called when bot connects, restarts threads if they were stopped by disconnect
////////////////////////////////////////////////////////////
//CHANGED FOR BEFORE THE DAWN
Connected()
{
	if( isDefined(self.bIsBot) && self.bIsBot )
	{
		if( !isdefined(self.bThreadsRunning) || (isdefined(self.bThreadsRunning) && self.bThreadsRunning == false) )
		{
			println("Restarting threads for " + self.name);
			self BotReset();
			self thread PeZBOTMainLoop();
		}
	}
}

//Zod: added
RemoveAllBots()
{
	zombies = getentarray("zom","targetname");
	for (i = 0; i < zombies.size; i++)
	{
		if( isDefined(zombies[i].bIsBot) && zombies[i].bIsBot )
		{
			//level notify("bugged_zom", zombies[i].health);
			zombies[i] notify("damage", zombies[i].maxhealth, undefined, (0,1,0), zombies[i].origin, "MOD_SUICIDE", "", "", "", 1);
		}
	}
}

////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
PrintPlayerPos()
{
	while(1)
	{
		if(isDefined(level.players))
		{
			for(i = 0; i < level.players.size; i++)
			{
				if(!isDefined(level.players[i].bIsBot))
				{
					iprintln("pos: " + level.players[i].origin[0] + ", " + level.players[i].origin[1] + ", " + level.players[i].origin[2]);
				}
			}
		}
		wait 2.0;
	}
}

////////////////////////////////////////////////////////////
// returns one of the buttons pressed
////////////////////////////////////////////////////////////
GetButtonPressed()
{
	if( isDefined(self) )
	{
		if(self attackbuttonpressed())
		{
			return "AddWaypoint";
		}
		else
		if(self adsbuttonpressed())
		{
			return "DeleteWaypoint";
		}
		else
		if(self usebuttonpressed())
		{
			return "LinkWaypoint";
		}
		else
		if(self fragbuttonpressed())
		{
			return "UnlinkWaypoint";
		}
		else
		if(self meleebuttonpressed())
		{
			return "SaveWaypoints";
		}
	}  
	return "none";
}

////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
VectorCross( v1, v2 )
{
	return ( v1[1]*v2[2] - v1[2]*v2[1], v1[2]*v2[0] - v1[0]*v2[2], v1[0]*v2[1] - v1[1]*v2[0] );
}

////////////////////////////////////////////////////////////
// offsets the eye pos a bit higher
///////////////////////////////////////////////////////////
GetEyePos()
{
	//Zod: Our zombies aren't players, so just return the origin since they have no "eye"
	if( isPlayer(self) )
		return (self getEye() + (0,0,20));
	else
		return (self GetOrigin() + (0,0,20));
}

////////////////////////////////////////////////////////////
// CanSeeTarget - Used for melee and target facing
///////////////////////////////////////////////////////////
CanSeeTarget()
{
	if(!isDefined(self.bestTarget))
	{
		return( false );
	}
 	dot = 1.0;

	if((gettime()-self.fTargetMemory) < 5000 && (isdefined(self.rememberedTarget) && self.rememberedTarget == self.bestTarget && self.rememberedTarget.sessionstate == "playing"))
	{
		return( true );
	}
	else
	{
		self.rememberedTarget = undefined;
	}

	//if selected target hasn't attacked me, check to see if it's in front of me
	if( !AttackedMe(self.bestTarget) )
	{
		targetPos = self.bestTarget GetEyePos();
		eyePos = self GetEyePos();
		fwdDir = anglestoforward(self.angles);
		dirToTarget = vectorNormalize(targetPos-eyePos);
		dot = vectorDot(fwdDir, dirToTarget);
	}
 
	//in front of me
	if( dot > 0.25 && self.bestTarget IsBeingObvious(self) )
	{
		//do a ray to see if we can see the target
		visTrace = bullettrace(self GetEyePos(), self.bestTarget GetEyePos(), false, self);
		if(visTrace["fraction"] == 1)
		{
			self.fTargetMemory = gettime(); //remember target
			self.rememberedTarget = self.bestTarget;
			return( true );
		}
		else
		{
			return( false );
		}
	}

	return false;
}

////////////////////////////////////////////////////////////
// returns true if shooting, moving over a certain speed (depending on skill) etc..
// obviousTo is the player they are being obvious to
////////////////////////////////////////////////////////////
IsBeingObvious(obviousTo)
{
	obviousDist = distance(obviousTo.origin, self.origin);
	if( obviousDist < 600.0 )
	{
		return true;    
	}

	if(self AttackButtonPressed())
	{
		return true;
	}

	if(isdefined(self.fVelSquared))
	{
		if(self.fVelSquared > (4.0*4.0))
		{
			return true;
		}
	}
	return false;
}

RandomLocation()
{
	ranPoint = undefined;
	spawnPoints = undefined;
	if( isDefined( level.waypoints ) && level.waypointCount > 0 )
	{
		ranPoint = level.waypoints[randomInt(level.waypointCount - 1)];
	}
	else
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( "axis" );
		ranPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
	}

	if( isDefined( ranPoint ) )
	{
		self SetObjectivePos(ranPoint.origin);
		self.randomPosSet = true;
		self PathToObjective();
	}
}

////////////////////////////////////////////////////////////
// Decide whether to follow static waypoints or path dynamically
////////////////////////////////////////////////////////////
PathToObjective()
{
	//waypoints are closer to our objective so path using waypoints
	if(isDefined(level.waypoints) && level.waypointCount > 0 && self AnyWaypointCloserToObjectiveThanMe(self.vObjectivePos))
	{
		if(self.currentStaticWp == -1)
		{
			wpPos = level.waypoints[GetNearestStaticWaypoint(self.origin)].origin;
      		wpPos = (wpPos[0], wpPos[1], self.origin[2]);

			distance = Distance(self.origin, wpPos);
			if(distance <= (self.moveSpeed + 5.0)) //close enough to waypoint so start following
			{
				self BotGoal_EnterGoal("StaticWaypointFollowGoal");
			}
			else //too far from waypoint so move over to it
			{ 
				self.vObjectivePos = wpPos;
				self BotGoal_EnterGoal("DynWaypointFollowGoal");
			}
		}
	}
	else
	{
		self BotGoal_EnterGoal("DynWaypointFollowGoal");
	}
}

////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
// CHANGED FOR BEFORE THE DAWN
PeZBOTMainLoop()
{
	self endon( "death" );
	self endon( "game_ended" );

	if( !isDefined( self ) )
	{ return; }

	self.bThreadsRunning = true;    

	self.bMeleeAttacking = false;
	self.vObjectivePos = self.origin;
	self.currentGoal = "none";
	self.buggyBotCounter = 0;
	self.lastOrigin = self.origin;
	self.fTargetMemory = gettime()-15000;

	self.vMoveDirection = (0,1,0);
	//self.moveSpeed = getdvarint("btd_test_zom_speed");
	self.bFaceNearestEnemy = true;
	self.currentStaticWp = -1;
	self.bClampToGround = true;
	self.flankSide = (randomIntRange(0,2) - 0.5) * 2.0;
	self.randomPosSet = false;
	self.concussionEndTime = 0;

	self thread TargetBestEnemy();
	self thread FaceBestEnemy();
	self thread ClampToGround();
	self thread MonitorMovement();

	while( isDefined( self ) )
	{
		range = self.attackRange;

		if( isDefined( self.bestTarget ) )
		{
			//use position of nearest waypoint so not as to go wandering off
			//zombie mods probably want to just set the objective pos as self.bestTarget.origin so they can get into melee range
			self SetObjectivePos(self.bestTarget.origin);
			targetRange = DistanceSquared(self.bestTarget.origin, self.origin); 
			if( targetRange < (range*range) && self CanSeeTarget() )
			{
				self thread BotMelee();
			}
			else
			{
				self PathToObjective();
			}
		}
		else // Zod: Pick a random location to go to else bot will be declared bugged and be killed.
		{ if( !self.randomPosSet ) { self RandomLocation(); } }
/*
		if(CanDebugDraw())
		{
			//debug
			print3d(self.origin + (0, 0, 65), "GOAL: " + self.currentGoal, (1,0,0), 2);
			print3d(self.vObjectivePos, self.name + " ObjectivePos", (1,0,0), 2);
			print3d(self.origin + (0, 0, 95), "movespeed: " + self.moveSpeed, (1,0,0), 2);
			print3d(self.origin + (0, 0, 105), "currentStaticWP: " + self.currentStaticWp, (1,0,0), 2);
		}
*/
		wait 0.05;
	}
}

////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
CanMove(from, direction, distance)
{
/*
	//ray cast against everything
	trace = bulletTrace(from, from + (direction * distance), true, self);

	//line to collision is red
	//line(from, trace["position"], (1,0,0));
	//print3d( self.origin + ( 0, 0, 65 ),"Fraction " + trace["fraction"], (1,0,0), 2);
 
	return (trace["fraction"] == 1.0);
*/
	// Zod: Less costly method
	return( BulletTracePassed( from, from + (direction * distance), true, self) );
}

////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
// CHANGED FOR BEFORE THE DAWN
ClampToGround()
{
	self endon("death");
	self endon( "game_ended" );

	while( isDefined( self ) )
	{
		if( self.bClampToGround )
		{
			trace = bulletTrace(self.origin + (0,0,50), self.origin + (0,0,-40), false, self);
			if(isdefined(trace["entity"]) && isDefined(trace["entity"].targetname) && trace["entity"].targetname == "zom")
				trace = bulletTrace(self.origin + (0,0,50), self.origin + (0,0,-40), false, trace["entity"]);

//			line(self.origin + (0,0,50), trace["position"], (1,0,1));
//			if(trace["fraction"] < 1 && !isdefined(trace["entity"]))

			//smooth clamp
//			self.origin = ((trace["position"] * 0.5) + (self.origin * 0.5));
			self.origin = (trace["position"]);
			self.currentsurface = trace["surfacetype"];
			if(self.currentsurface == "none")
				self.currentsurface = "default";
		}
		wait 0.05;
	}
}

MonitorMovement()
{
	self endon("death");
	self endon( "game_ended" );

	while( isDefined( self ) )
	{
		if( !isdefined( self.lastOrigin ) )
		{
			self.lastOrigin = self.origin;
		}
		else
		{
			self.fVelSquared = DistanceSquared(self.origin, self.lastOrigin);
		}

		self.lastOrigin = self.origin;

		if( self.fVelSquared <= 4 )
		{
			self.buggyBotCounter++;
		}
		else
		{
			self.buggyBotCounter = 0;
		}

		//stuck so reset
		if( self.buggyBotCounter >= 50 )
		{
			self BotReset();
			self.timesreset = self.timesreset + 1;
		}

		if( self.timesreset >= 8 )
		{
			self BotReset();
			self.wasbugged = true;
			self notify("damage", self.maxhealth, undefined, (0,1,0), self.origin, "MOD_SUICIDE", "", "", "", 1);
			iprintln("^0[^1BTDz^0] ^7- Stuck Zombie Removed By Mod!");
			break;
		}

		wait 0.05;
	}
}

////////////////////////////////////////////////////////////
// returns true if attacker attacked me
///////////////////////////////////////////////////////////
AttackedMe(attacker)
{
	if(!isDefined(self.attackers))
	{
		return false;
	}

	for(i = 0; i < self.attackers.size; i++)
	{
		if(isDefined(self.attackers[i]) && self.attackers[i] == attacker)
		{
			return true;
		}
	}
	return false;
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
// CHANGED FOR BEFORE THE DAWN
SetBotAngles(angles)
{
	self.angles = (0,angles[1],0);
}

////////////////////////////////////////////////////////////
// Will try to target nearest enemy
///////////////////////////////////////////////////////////
// CHANGED FOR BFORE THE DAWN

choosePlayerTarget()
{
	nearestTarget = undefined;
	nearestDistance = 9999999999;

	// Blinded
	if( isDefined(self.inFlareVisionArea) && self.inFlareVisionArea == true )
	{
		return( nearestTarget );
	}

	players = getentarray("player","classname");
	if( players.size > 0 )
	{
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];

			// Dismiss these immediately
			if( !isDefined( player ) )
			{
				continue;
			}

			if( !isdefined(player.pers["team"]) || !isdefined(player.sessionstate) )
			{
				continue;
			}

			if( !isAlive(players[i]) || player.pers["team"] != "allies" || player.sessionstate != "playing" )
			{
				continue;
			}

			if( player.sp_active == true || player.inHelicopter == true || player.isarty == true || player.inAc130 == true || player.inAdminMenu == true )
			{
				continue;
			}

			tempDist = Distance(self.origin, player.origin);
			//iprintln("Distance to potential target: " + tempDist);
			if( player hasPerk( "specialty_gpsjammer" ) && tempDist > 1500.0 && !AttackedMe(player) ) // 125ft or 125m?
			{
				continue;
			}

			if( tempDist < nearestDistance )
			{
				nearestDistance = tempDist;
				nearestTarget = player;
			}
		}
	}

	return( nearestTarget );
}

TargetBestEnemy()
{
	self endon( "death" );
	self endon( "game_ended" );

	while( isDefined( self ) )
	{
		//if( !isDefined( self.bestTarget ) ) // un-relenting
		//{ self.bestTarget = self choosePlayerTarget(); }
		self.bestTarget = self choosePlayerTarget();

		wait 0.75;
	}
}

FaceBestEnemy()
{
	self endon( "death" );
	self endon( "game_ended" );

	while( isDefined( self ) )
	{
		//only face if allowed
		if( isdefined(self.bestTarget) && self.bFaceNearestEnemy )
		{
			targetPos = self.bestTarget GetOrigin();

			//calc direction of nearest target
			targetDirection = VectorNormalize(targetPos - self GetEyePos());

			//turn to face target
			self SetBotAngles(vectorToAngles(VectorNormalize(VectorSmooth(anglesToForward(self.angles), targetDirection, 0.25))));
		}

		wait 0.10;
	}
}

////////////////////////////////////////////////////////////
// melee a target
///////////////////////////////////////////////////////////
// CHANGED FOR BEFORE THE DAWN
BotMelee()
{
	self endon( "death" );
	self endon( "game_ended" );

	if( !isDefined(self) || self.bMeleeAttacking )
	{
		return;
	}

	//clear static waypoint usage so we dont get stuck  
	self.currentStaticWp = -1;

	//cancel any previous moves
	self notify("BotMovementComplete");
	self endon ("detah");
	self endon ("BotMeleeComplete");
	self endon ("killed_player");
	self.bMeleeAttacking = true;

	vMoveTarget = self.bestTarget.origin + (VectorNormalize(self.origin - self.bestTarget.origin) * 10);

	damage = self.attack_damage;

	while( self.bMeleeAttacking )
	{
		moveTarget = (vMoveTarget[0], vMoveTarget[1], self.origin[2]);
		distance = DistanceSquared(moveTarget, self.origin);

		killer = self;

		//kill target
		if( isAlive(self.bestTarget) )
		{
			self.bestTarget thread [[level.callbackPlayerDamage]](self,self.bestTarget,damage,0,"MOD_MELEE","",self.bestTarget.origin,VectorNormalize(self.bestTarget.origin - self.origin),"none",0);
		}

		if(!self.attacksoundplaying)
		{
			if(isDefined(self.isTestZom) && self.isTestZom)
			{
				self thread btd\_zombie_test::attacksound();
			}
			else if(isDefined(self.isNormalzom) && self.isNormalzom)
			{
				self thread btd\_zombie_boss::attacksound();
			}
		}

		//self PushOutOfPlayers();
		self PushOutOfTarget();

		wait level.zom_attack_wait_time;

		self.bMeleeAttacking = false;
		self notify("BotMeleeComplete");

		if(distance <= 25 || !isDefined(self.bestTarget) || (isDefined(self.bestTarget) && self.bestTarget.sessionstate != "playing" || self.bestTarget.sp_active == true))
		{
			self.bMeleeAttacking = false;
			self notify("BotMeleeComplete");
		} 
	}
}

////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
// CHANGED FOR BEFORE THE DAWN
BotMove(_vMoveTarget)
{
	//cancel any previous moves
	self notify( "BotMovementComplete" );

	//regular cheap movement
	self.vMoveTarget = _vMoveTarget;
	
	//calc move direction
	moveDirection = VectorNormalize(self.vMoveTarget - self.origin);
	
	//get forward direction
	forward = anglesToForward(self.angles);	
  
	//get dot between forward and our move direction
	dot = vectordot(forward, moveDirection);
 
	//start move thread
	self thread BotMoveThread(); 

	//start movement monitor thread
	//self thread MonitorMovement();
}

////////////////////////////////////////////////////////////
// push self out of other players
///////////////////////////////////////////////////////////
PushOutOfTarget()
{
	self endon( "death" );
	self endon( "game_ended" );
	self endon ("BotMeleeComplete");

	if( isDefined( self.bestTarget ) )
	{
		if( self.bMeleeAttacking )
		{
			distance = distance(self.bestTarget.origin, self.origin);
			minDistance = 30;
			if(distance < minDistance) //push out
			{
				pushOutDir = VectorNormalize((self.origin[0], self.origin[1], 0)-(self.bestTarget.origin[0], self.bestTarget.origin[1], 0));
				//trace = bulletTrace(self.origin + (0,0,20), (self.origin + (0,0,20)) + (pushOutDir * ((minDistance-distance)+10)), false, self);

				//collision, so push out
				//if(trace["fraction"] == 1)

				// Zod: Less costly method
				trace =  BulletTracePassed( self.origin + (0,0,20), (self.origin + (0,0,20)) + (pushOutDir * ((minDistance-distance)+10)), false, self);
				if(trace)
				{
					pushoutPos = self.origin + (pushOutDir * (minDistance-distance));
					self.origin = (pushoutPos[0], pushoutPos[1], self.origin[2]);
				}
			}
		}
	}
}

PushOutOfPlayers()
{
	self endon( "death" );
	self endon( "game_ended" );

	//Commented out as of 006p to prevent bots getting stuck
	//zombie mods probably want to re-enable this

	//push out of other players
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];

		// Dismiss these immediately
		if( player == self || !isdefined(player.sessionstate) || !isAlive(player) || player.inHelicopter || player.isarty || player.inAc130 == true )
		{ continue; }

		if( player.sessionstate != "playing" )
		{ continue; }

		distance = distance(player.origin, self.origin);
		minDistance = 30;
		if(distance < minDistance) //push out
		{
			pushOutDir = VectorNormalize((self.origin[0], self.origin[1], 0)-(player.origin[0], player.origin[1], 0));
			trace = bulletTrace(self.origin + (0,0,20), (self.origin + (0,0,20)) + (pushOutDir * ((minDistance-distance)+10)), false, self);
/*
			//debug
			if(CanDebugDraw())
			{
				print3d(self.origin + (0, 0, 85), "PUSHOUT " + distance, (1,0,0), 2);
				line(self.origin + (0,0,20), (self.origin + (0,0,20)) + (pushOutDir * ((minDistance-distance)+10)), (1,0,0));
			}
*/
			//no collision, so push out
			if(trace["fraction"] == 1)
			{
				pushoutPos = self.origin + (pushOutDir * (minDistance-distance));
				self.origin = (pushoutPos[0], pushoutPos[1], self.origin[2]);
				//self SetOrigin((pushoutPos[0], pushoutPos[1], self.origin[2])); 
				//self.attachmentMover.origin = (pushoutPos[0], pushoutPos[1], self.origin[2]);
			}
		}
	}
}
/*
////////////////////////////////////////////////////////////
// Monitors the movement speed and anim based on direction
///////////////////////////////////////////////////////////
MonitorMovement()
{
	self endon("BotMovementComplete");
	self endon("death");
	self endon("killed_player");
	self endon("BotReset");
	self endon( "game_ended" );

	while( isDefined( self ) )
	{
		//calc move direction
		moveDirection = VectorNormalize(self.vMoveTarget - self.origin);

		//get forward direction
		forward = anglesToForward(self.angles);	

		//get dot between forward and our move direction
		dot = vectordot(forward, moveDirection);

		wait 0.2;
	}
}
*/
////////////////////////////////////////////////////////////
// 
///////////////////////////////////////////////////////////
// CHANGED FOR BEFORE THE DAWN
BotMoveThread()
{	
	self endon("BotMovementComplete");
	self endon("death");
	self endon("killed_player");
	self endon("BotReset");	
	self endon( "game_ended" );

	speed = 0;	
	if( isDefined( self.moveSpeed ) )
	{ speed = self.moveSpeed; }
	else
	{ speed = 6; }

	while( isDefined( self ) )
	{
		moveTarget = (self.vMoveTarget[0], self.vMoveTarget[1], self.origin[2]);
		distance = DistanceSquared(moveTarget, self.origin);
		if(distance <= (speed*speed))
		{
			self.origin = moveTarget;
			self notify( "BotMovementComplete" );
		}
		else
		{
			self.origin = (self.origin + (VectorNormalize(moveTarget-self.origin) * ( speed )));
			// Zod: Not sure this is needed
			//self PushOutOfPlayers();
		}
		wait 0.005;
	}
}

////////////////////////////////////////////////////////////
// smooth between two vectors by factor 'fFactor' in the form (vC = (vA * (1-factor)) + (vB * factor));)
///////////////////////////////////////////////////////////
VectorSmooth(vA, vB, fFactor)
{
	fFactorRecip = 1.0-fFactor;
	vRVal = ((vA * fFactorRecip) + (vB * fFactor));
	return vRVal;
}

////////////////////////////////////////////////////////////
// finds a safe spot to move to in the direction specified
///////////////////////////////////////////////////////////
FindSafeMoveToPos(direction, distance)
{
	from = self.origin + (0,0,20);
	bCanMove = false;
	//try move in direction 
	if(CanMove(from, direction, distance))
	{
		bCanMove = true;
	}
	else // try strafe
	{
		//get right direction from cross product
		direction = VectorCross(direction, (0,0,1));

		//dont always strafe right
		direction = direction * ((RandomInt(2) - 0.5) * 2.0);

		//halve distance for tight areas
		distance = distance * 0.5;

		//try strafe 
		if(CanMove(from, direction, distance))
		{
			bCanMove = true;
		}
		else //try strafe opposite direction
		{
			direction = direction * -1.0;
			if(CanMove(from, direction, distance))
			{
				bCanMove = true;
			}
		}
	}

	safePos = self.origin;

	//woohoo, i can move
	if(bCanMove)
	{
		safePos = self.origin + (direction*distance);
	}

	return (safePos);
}

////////////////////////////////////////////////////////////
// Starts a bot goal thread
///////////////////////////////////////////////////////////
BotGoal_EnterGoal(goal)
{
	if(isdefined(self.currentGoal) && self.currentGoal == goal)
	{
		return;
	}

	//println("Entering Goal" + goal);

	//clear all active goals so they dont fight with eachother (can probably fix this)
	self BotGoal_ClearGoals();

	//make sure we know what goal we are in  
	self.currentGoal = goal;

	switch(goal)
	{
		case "MeleeCombatGoal":
			self thread BotGoal_MeleeCombatGoal();
			break;

		case "DynWaypointFollowGoal":
			self thread BotGoal_DynWaypointFollowGoal();
			break;

		case "StaticWaypointFollowGoal":
			self thread BotGoal_StaticWaypointFollowGoal();
			break;
	};
}

////////////////////////////////////////////////////////////
// Ends all current goal threads
///////////////////////////////////////////////////////////
BotGoal_ClearGoals()
{
	self notify ( "MeleeCombatGoalComplete" );
	self notify ( "AttackDogCombatGoalComplete" );
	self notify ( "DynWaypointFollowGoalComplete" );
	self notify ( "StaticWaypointFollowGoalComplete" );

	if( isDefined( self ) )
	{
		self.currentStaticWp = -1;
		self.currentGoal = "none";
	}
}

////////////////////////////////////////////////////////////
// Melee combat goal for bot (Stabs, keeps in range etc)
///////////////////////////////////////////////////////////
BotGoal_MeleeCombatGoal()
{
	self endon ( "MeleeCombatGoalComplete" );
	self endon( "death" );
	self endon("killed_player");
	self endon( "game_ended" );

	while( isDefined( self ) )
	{
		//stay in range
		if( isDefined( self.bestTarget ) )
		{
			//FIXME: should do both of these in the one function
			targetRange = Distance(self.bestTarget.origin, self.origin);
			direction = VectorNormalize(self.bestTarget.origin - self.origin);

			safeMoveToPos = self.origin;    
      
			//too far away get closer
			// if(targetRange > 100)
			if( targetRange > self.attackRange || self.can_attack == false )
			{
				safeMoveToPos = self FindSafeMoveToPos(direction, 50.0);
				//move
				self BotMove(safeMoveToPos);
			}
			else //in range & can attack so stabbage
			{
				self thread BotMelee();
			}
		}
		wait 1;
	}
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
ClampWpToGround(wpPos)
{
	trace = bulletTrace(wpPos, wpPos + (0,0,-300), false, undefined);

	if(trace["fraction"] < 1)
	{
		return trace["position"] + (0,0,30);
	}
	else
	{
		//probably under the ground, trace up
		trace = bulletTrace(wpPos, wpPos + (0,0,20), false, undefined);
		if(trace["fraction"] < 1)
		{
			return trace["position"] + (0,0,30);
		}
		else
		{
			return wpPos;
		}
	}
}

////////////////////////////////////////////////////////////
// Clamp a in between min and max
////////////////////////////////////////////////////////////
Clamp(min, a, max)
{
	return max(min(a, max), min);
}

////////////////////////////////////////////////////////////
// Builds a dynamic list of waypoints for the bot to follow, uses brute force wall following, 
// looks for exits nearest target direction, HAX!!! etc... ;)
// This function is still kinda bruteforce and dodgy but it will do for now :D
////////////////////////////////////////////////////////////
BuildDynWaypointList()
{
	self.dynWaypointCount = 0;
	self.currDynWaypoint = 0;

	from = self.origin + (0,0,30);
	//direction = anglesToForward(self.angles);
	enemydirection = VectorNormalize(self.vObjectivePos - from);
	direction = enemydirection;
	distance = 30.0;
	self.dynWaypointList = [];
	bCanTurnToTarget = true; // if true we can turn to try go towards our target
	maxWaypointCount = randomintrange(40, 60);
	lastWallDirection = (1,0,0);
	bValidLastWallDirection = false;

	while(self.dynWaypointCount < maxWaypointCount)
	{
		//add a waypoint
		self.dynWaypointList[self.dynWaypointCount] = ClampWpToGround(from);
		self.dynWaypointCount++;

		trace = bulletTrace(from, from + (direction * distance), false, self);

		enemydirection = VectorNormalize(self.vObjectivePos - from);

		//didnt hit keep moving
		if(trace["fraction"] == 1)
		{
			from = trace["position"];

			//add a waypoint
			self.dynWaypointList[self.dynWaypointCount] = ClampWpToGround(from);
			self.dynWaypointCount++;

			//move towards target
			if(bCanTurnToTarget)
			{
				direction = enemydirection;
				bValidLastWallDirection = false;
			}
			else //see if we need to keep following wall
			{
				//try keep following wall
				if(bValidLastWallDirection)
				{
					//trace
					trace = bulletTrace(from, from + (lastWallDirection * distance * 2.0), false, self);

					//wall no longer there, head that way
					if(trace["fraction"] == 1)
					{
						direction = lastWallDirection;
						from = trace["position"];
						dot = vectorDot(enemydirection, direction);
						if(dot > 0.5)
						{
							bCanTurnToTarget = true;
						}
						bValidLastWallDirection = false;
					}
				}
				else //still next to wall keep going straight ahead
				{
					bCanTurnToTarget = false;
				}
			}
		}
		else // hit something, navigate around it
		{
			//dont turn to target we need to navigate around collision    
			bCanTurnToTarget = false;

			//get collision normal and position    
			colNormal = trace["normal"];
			colPos = trace["position"];
        
			//move out from collision
			//from = colPos + (colNormal * 20.0);
			from = colPos + (VectorNormalize(VectorSmooth(direction * -1.0, colNormal, 0.5)) * 20.0); //normals are dodgy, especially on corrigated iron, use a fake normal

			tanDirection = VectorCross(direction * -1.0, (0,0,1));
			//tanDirection = VectorCross(colNormal, (0,0,1));

			//we were already traveling along a wall, pick tangent direction that keeps us going forwards
			if(bValidLastWallDirection)
			{
				dot = vectordot(lastWallDirection * -1.0, tanDirection);

				if(dot < 0)
				{
					tanDirection = tanDirection * -1.0;
				}

				lastWallDirection = colNormal * -1.0;
				bValidLastWallDirection = true;
				direction = tanDirection;
			}
			else //choose direction that best matches target dir
			{
				dot = vectordot(enemydirection, tanDirection);

				if(dot < 0)
				{
					tanDirection = tanDirection * -1.0;
				}

				lastWallDirection = colNormal * -1.0;
				bValidLastWallDirection = true;
				direction = tanDirection;
			}
		}

		//end of waypoint list
		if(Distance(self.vObjectivePos, from) <= (distance+5.0))
		{
			return true; 
		}
	}
	return true;
}

////////////////////////////////////////////////////////////
// Dynamic waypoint follow goal, follows a dynamically generated list of waypoints
///////////////////////////////////////////////////////////
BotGoal_DynWaypointFollowGoal()
{
	self endon ( "DynWaypointFollowGoalComplete" );
	self endon( "death" );
	self endon("killed_player");
  	self endon( "game_ended" );

	//build waypoint list
	self BuildDynWaypointList();

	while( isDefined( self ) )
	{
		tempWp = (self.dynWaypointList[self.currDynWaypoint][0], self.dynWaypointList[self.currDynWaypoint][1], self.origin[2]);

		//prevent enemy facing

		if( self CanSeeTarget() )
		{
			self.bFaceNearestEnemy = true;
		}
		else
		{
			self.bFaceNearestEnemy = false;
			//face movement direction        
			self SetBotAngles(vectorToAngles(VectorNormalize(VectorSmooth(anglesToForward(self.angles), VectorNormalize(tempWp-self.origin), 0.5))));
		}

		distToWp = Distance(tempWp, self.origin);

		if(distToWp <= (self.moveSpeed +5.0))
		{
			self.currDynWaypoint++;

			if(self.currDynWaypoint >= self.dynWaypointCount)
			{
				self.currentGoal = "none";
				self notify ( "DynWaypointFollowGoalComplete" );
			}
			else
			{
				tempWp = (self.dynWaypointList[self.currDynWaypoint][0], self.dynWaypointList[self.currDynWaypoint][1], self.origin[2]);
				self BotMove(tempWp);
			}
		}
		//draw waypointlist
		self DrawDynWaypointList();
		wait 0.01;
	}
}

////////////////////////////////////////////////////////////
// debug draw dynamic waypoint list
////////////////////////////////////////////////////////////
DrawDynWaypointList()
{
	if(CanDebugDraw())
	{
		for(i = 0; i < self.dynWaypointCount-1; i++)
		{
			line(self.dynWaypointList[i], self.dynWaypointList[i] + (0,0,200), (1,1,0));
			line(self.dynWaypointList[i], self.dynWaypointList[i+1], (0,1,1));
		}
		line(self.dynWaypointList[self.dynWaypointCount-1], self.dynWaypointList[self.dynWaypointCount-1] + (0,0,200), (1,1,0));
	}
}


////////////////////////////////////////////////////////////
// static waypoint implementation
// 1. Array of waypoints, each waypoint has a type (stand, crouch, prone, camp, climb, etc), and a position on the ground.
// 2. Array of connectivity, list of children for each waypoint
// Reasoning: Easy to find closest waypoint, and traverse children using connectivity
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// debug draw spawns, domination flags, hqs, bombs etc..
////////////////////////////////////////////////////////////
DrawLOI(pos, code)
{
	line(pos + (20,0,0), pos + (-20,0,0), (1,0.75, 0));
	line(pos + (0,20,0), pos + (0,-20,0), (1,0.75, 0));
	line(pos + (0,0,20), pos + (0,0,-20), (1,0.75, 0));

	Print3d(pos, code, (1,0,0), 4);
}

////////////////////////////////////////////////////////////
// debug draw static waypoint list
////////////////////////////////////////////////////////////
DrawStaticWaypoints()
{
	while(1)
	{
		if(CanDebugDraw() && isDefined(level.waypoints) && isDefined(level.waypointCount) && level.waypointCount > 0)
		{
			wpDrawDistance = getdvarint("svr_pezbots_WPDrawRange");

			for(i = 0; i < level.waypointCount; i++)
			{
				if(isdefined(level.players) && isdefined(level.players[0]))
				{
					distance = distance(level.players[0].origin, level.waypoints[i].origin);
					if(distance > wpDrawDistance)
					{
						continue;
					}
				}
      
				color = (0,0,1);

				//red for unlinked wps
				if(level.waypoints[i].childCount == 0)
				{
					color = (1,0,0);
				}
				else if(level.waypoints[i].childCount == 1) //purple for dead ends
				{
					color = (1,0,1);
				}
				else //green for linked
				{
					color = (0,1,0);
				}

				if(isdefined(level.players) && isdefined(level.players[0]))
				{
					distance = distance(level.waypoints[i].origin, level.players[0].origin);
					if(distance <= 30.0)
					{
						strobe = abs(sin(gettime()/10.0));
						color = (color[0]*strobe,color[1]*strobe,color[2]*strobe);
					}
				}

				line(level.waypoints[i].origin, level.waypoints[i].origin + (0,0,80), color);

				for(x = 0; x < level.waypoints[i].childCount; x++)
				{
					line(level.waypoints[i].origin + (0,0,5), level.waypoints[level.waypoints[i].children[x]].origin + (0,0,5), (0,0,1));
				}
				//print3d(level.waypoints[i].origin + (0,0,90), "Type: " + level.waypoints[i].type, (1,1,1), 2);
				//print3d(level.waypoints[i].origin + (0,0,100), "Pos: " + level.waypoints[i].origin[0] + ", " + level.waypoints[i].origin[1] + ", " + level.waypoints[i].origin[2], (1,1,1), 2);
				//print3d(level.waypoints[i].origin + (0,0,110), "Index: " + i, (1,1,1), 2);
			}

			//draw spawnpoints  
			DrawSpawnPoints(getentarray("mp_sab_spawn_axis", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_allies", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_axis_start", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sab_spawn_allies_start", "classname"), "sabS");
			DrawSpawnPoints(getentarray("mp_sd_spawn_attacker", "classname"), "sdS");
			DrawSpawnPoints(getentarray("mp_sd_spawn_defender", "classname"), "sdS");

			DrawSpawnPoints(getentarray("mp_dm_spawn", "classname"), "dmS");
			DrawSpawnPoints(getentarray("mp_tdm_spawn", "classname"), "tdmS");
			DrawSpawnPoints(getentarray("mp_dom_spawn", "classname"), "domS");

			//draw domination flags
			DrawSpawnPoints(getEntArray("flag_primary", "targetname"), "F");
			DrawSpawnPoints(getEntArray("flag_secondary", "targetname"), "F");

			//draw radios
			DrawSpawnPoints(getentarray("hq_hardpoint", "targetname"), "R");

			//draw bombzones
			DrawSpawnPoints(getEntArray("bombzone", "targetname"), "B");
			DrawSpawnPoints(getEntArray("sab_bomb_axis", "targetname"), "B");
			DrawSpawnPoints(getEntArray("sab_bomb_allies", "targetname"), "B");
		}
		wait 0.001;
	}
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
DrawSpawnPoints(spawnpoints, code)
{
	if(isdefined(spawnpoints))
	{
		for(i = 0; i < spawnpoints.size; i++)
		{
			spawnpoint = spawnpoints[i];

			DrawLOI(spawnpoint.origin, code);
		}
	}
}

////////////////////////////////////////////////////////////
// returns an index to the nearest static waypoint
////////////////////////////////////////////////////////////
GetNearestStaticWaypoint(pos)
{
	if(!isDefined(level.waypoints) || level.waypointCount == 0)
	{
		return -1;
	}

	nearestWaypoint = -1;
	nearestDistance = 9999999999;
	nearestZ = 9999999999;
	nearestXY = 9999999999;
  
	for(i = 0; i < level.waypointCount; i++)
	{
		distance = Distance(pos, level.waypoints[i].origin);
		distanceX = level.waypoints[i].origin[0] - Pos[0];
		distanceY = level.waypoints[i].origin[1] - Pos[1];
		distanceZ = level.waypoints[i].origin[2] - Pos[2];

		if(distance < nearestDistance)
		{              
			if(nearestZ < distanceZ && (distanceX < 175 || distanceY < 175) && (distanceX < nearestXY || distanceY < nearestXY))
			{
				if(distanceX < distanceY)
				{
					nearestXY = distanceX;
				}
				else
				{
					nearestXY = distanceY;
				}
				nearestDistance = distance;  
				nearestZ = distanceZ;    
				nearestWaypoint = i;
			}     
			else
			{
				nearestDistance = distance;    
				nearestWaypoint = i;
			}       
		}
	}
	return nearestWaypoint;
}



////////////////////////////////////////////////////////////
// returns true if there is any waypoint closer to pos than wpIndex
////////////////////////////////////////////////////////////
AnyWaypointCloser(pos, wpIndex)
{
	if(!isDefined(level.waypoints) || level.waypointCount == 0)
	{
		return false;
	}
	nearestWaypoint = wpIndex;
	nearestDistance = Distance(pos, level.waypoints[wpIndex].origin);
	for(i = 0; i < level.waypointCount; i++)
	{
		distance = Distance(pos, level.waypoints[i].origin);

		if(distance < nearestDistance)
		{
			nearestDistance = distance;
			nearestWaypoint = i;
		}
	}

	//  Print3d(level.waypoints[nearestWaypoint].origin, "CLOSEST", (1,0,0), 3);
	if(nearestWaypoint == wpIndex)
	{
		return false;
	}
	else
	{
		return true;  
	}
}


////////////////////////////////////////////////////////////
// returns true if there is any waypoint closer to objPos than self.origin
////////////////////////////////////////////////////////////
AnyWaypointCloserToObjectiveThanMe(objPos)
{
	if(!isDefined(level.waypoints) || level.waypointCount == 0)
	{
		return false;
	}

	meToObjPosDistance = Distance(objPos, self.origin);
	for(i = 0; i < level.waypointCount; i++)
	{
		distance = Distance(objPos, level.waypoints[i].origin);

		if((distance+50) < meToObjPosDistance)
		{
			return true;
		}
	}
	return false;  
}

////////////////////////////////////////////////////////////
// static waypoint follow goal, follows static waypoints
///////////////////////////////////////////////////////////
BotGoal_StaticWaypointFollowGoal()
{
	self endon("StaticWaypointFollowGoalComplete");
	self endon("death");
	self endon("killed_player");
	self endon( "game_ended" );

	if(!isDefined(level.waypoints) || level.waypointCount == 0)
	{
		self.currentGoal = "none";
		self.currentStaticWp = -1;
		self notify("StaticWaypointFollowGoalComplete");
	}

	//reset flank direction
	self.flankSide = (randomIntRange(0,2) - 0.5) * randomFloatRange(0.2, 2.0);

	while( isDefined( self ) )
	{
		//get waypoint nearest to ourselves  
		if(self.currentStaticWp == -1)
		{
			//print3d(self.origin + (0,0,40), "invalid WP", (1,0,0), 2);
			self.currentStaticWp = GetNearestStaticWaypoint(self.origin);
		}

		//get waypoint pos
		tempWp = level.waypoints[self.currentStaticWp].origin;

		//prevent enemy facing
		if(self CanSeeTarget())
		{
			self.bFaceNearestEnemy = true;
		}
		else
		{
			self.bFaceNearestEnemy = false;

			//face movement direction        
			self SetBotAngles(vectorToAngles(VectorNormalize(VectorSmooth(anglesToForward(self.angles), VectorNormalize(tempWp-self.origin), 0.5))));
		}

		//clamp to xz plane    
		distToWp = Distance((tempWp[0], tempWp[1], self.origin[2]), self.origin);

		if(distToWp <= (self.moveSpeed + 5.0))
		{
			//if there isn't any waypoint that is closer than our current waypoint then end our goal
			if(!AnyWaypointCloser(self.vObjectivePos, self.currentStaticWp))
			{
				//fixme: should do a check to make sure that one of the child paths doesn't get us closer
				self.currentGoal = "none";
				self.currentStaticWp = -1;

				self notify("StaticWaypointFollowGoalComplete");
			}
			else
			{
				//get waypoint nearest our target
				targetWpIdx = GetNearestStaticWaypoint(self.vObjectivePos);

				//find shortest path to our destination
				self.currentStaticWp = AStarSearch(self.currentStaticWp, targetWpIdx);

				//invalid waypoint, get outta here        
				if(!isdefined(self.currentStaticWp) || self.currentStaticWp == -1)
				{
					self.currentGoal = "none";
					self.currentStaticWp = -1;
					self notify("StaticWaypointFollowGoalComplete");
				}
 
				tempWp = level.waypoints[self.currentStaticWp].origin;
        
				//move there
				self BotMove(tempWp);
			}
		}
		wait 0.1;
	}
}


////////////////////////////////////////////////////////////
// AStarSearch, performs an astar search
///////////////////////////////////////////////////////////
/*

The best-established algorithm for the general searching of optimal paths is A* (pronounced “A-star”). 
This heuristic search ranks each node by an estimate of the best route that goes through that node. The typical formula is expressed as:

f(n) = g(n) + h(n)

where: f(n)is the score assigned to node n g(n)is the actual cheapest cost of arriving at n from the start h(n)is the heuristic 
estimate of the cost to the goal from n 

priorityqueue Open
list Closed


AStarSearch
   s.g = 0  // s is the start node
   s.h = GoalDistEstimate( s )
   s.f = s.g + s.h
   s.parent = null
   push s on Open
   while Open is not empty
      pop node n from Open  // n has the lowest f
      if n is a goal node 
         construct path 
         return success
      for each successor n' of n
         newg = n.g + cost(n,n')
         if n' is in Open or Closed,
          and n'.g < = newg
	       skip
         n'.parent = n
         n'.g = newg
         n'.h = GoalDistEstimate( n' )
         n'.f = n'.g + n'.h
         if n' is in Closed
            remove it from Closed
         if n' is not yet in Open
            push n' on Open
      push n onto Closed
   return failure // if no path found 
*/
AStarSearch(startWp, goalWp)
{
	pQOpen = [];
	pQSize = 0;
	closedList = [];
	listSize = 0;
	s = spawnstruct();
	s.g = 0; //start node
	s.h = distance(level.waypoints[startWp].origin, level.waypoints[goalWp].origin);
	s.f = s.g + s.h;
	s.wpIdx = startWp;
	s.parent = spawnstruct();
	s.parent.wpIdx = -1;
  
	//push s on Open
	pQOpen[pQSize] = spawnstruct();
	pQOpen[pQSize] = s; //push s on Open
	pQSize++;

	//while Open is not empty  
	while(!PQIsEmpty(pQOpen, pQSize))
	{
		//pop node n from Open  // n has the lowest f
		n = pQOpen[0];
		highestPriority = 9999999999;
		bestNode = -1;
		for(i = 0; i < pQSize; i++)
		{
			if(pQOpen[i].f < highestPriority)
			{
				bestNode = i;
				highestPriority = pQOpen[i].f;
			}
		} 

		if(bestNode != -1)
		{
			n = pQOpen[bestNode];
			//remove node from queue    
			for(i = bestNode; i < pQSize-1; i++)
			{
				pQOpen[i] = pQOpen[i+1];
			}
			pQSize--;
		}
		else
		{
			return -1;
		}

		//if n is a goal node; construct path, return success
		if(n.wpIdx == goalWp)
		{
			x = n;
			for(z = 0; z < 1000; z++)
			{
				parent = x.parent;
				if(parent.parent.wpIdx == -1)
				{
					return x.wpIdx;
				}
				//line(level.waypoints[x.wpIdx].origin, level.waypoints[parent.wpIdx].origin, (0,1,0));
				x = parent;
			}
			return -1;      
		}

		//for each successor nc of n
		for(i = 0; i < level.waypoints[n.wpIdx].childCount; i++)
		{
			//newg = n.g + cost(n,nc)
			newg = n.g + distance(level.waypoints[n.wpIdx].origin, level.waypoints[level.waypoints[n.wpIdx].children[i]].origin);
      
			//if nc is in Open or Closed, and nc.g <= newg then skip
			if(PQExists(pQOpen, level.waypoints[n.wpIdx].children[i], pQSize))
			{
				//find nc in open
				nc = spawnstruct();
				for(p = 0; p < pQSize; p++)
				{
					if(pQOpen[p].wpIdx == level.waypoints[n.wpIdx].children[i])
					{
						nc = pQOpen[p];
						break;
					}
				}

				if(nc.g <= newg)
				{
					continue;
				}
			}
			else if(ListExists(closedList, level.waypoints[n.wpIdx].children[i], listSize))
			{
				//find nc in closed list
				nc = spawnstruct();
				for(p = 0; p < listSize; p++)
				{
					if(closedList[p].wpIdx == level.waypoints[n.wpIdx].children[i])
					{
						nc = closedList[p];
						break;
					}
				}
        
				if(nc.g <= newg)
				{
					continue;
				}
			}
      
			//nc.parent = n
			//nc.g = newg
			//nc.h = GoalDistEstimate( nc )
			//nc.f = nc.g + nc.h
      
			nc = spawnstruct();
			nc.parent = spawnstruct();
			nc.parent = n;
			nc.g = newg;
			nc.h = distance(level.waypoints[level.waypoints[n.wpIdx].children[i]].origin, level.waypoints[goalWp].origin);
			nc.f = nc.g + nc.h;
			nc.wpIdx = level.waypoints[n.wpIdx].children[i];

			//if nc is in Closed,
			if(ListExists(closedList, nc.wpIdx, listSize))
			{
				//remove it from Closed
				deleted = false;
				for(p = 0; p < listSize; p++)
				{
					if(closedList[p].wpIdx == nc.wpIdx)
					{
						for(x = p; x < listSize-1; x++)
						{
							closedList[x] = closedList[x+1];
						}
						deleted = true;
						break;
					}
					if(deleted)
					{
						break;
					}
				}
				listSize--;
			}

			//if nc is not yet in Open, 
			if(!PQExists(pQOpen, nc.wpIdx, pQSize))
			{
				//push nc on Open
				pQOpen[pQSize] = spawnstruct();
				pQOpen[pQSize] = nc;
				pQSize++;
			}
		}

		//Done with children, push n onto Closed
		if(!ListExists(closedList, n.wpIdx, listSize))
		{
			closedList[listSize] = spawnstruct();
			closedList[listSize] = n;
			listSize++;
		}
	}
}

////////////////////////////////////////////////////////////
// PQIsEmpty, returns true if empty
////////////////////////////////////////////////////////////
PQIsEmpty(Q, QSize)
{
	if(QSize <= 0)
	{
		return true;
	}
	return false;
}

////////////////////////////////////////////////////////////
// returns true if n exists in the pQ
////////////////////////////////////////////////////////////
PQExists(Q, n, QSize)
{
	for(i = 0; i < QSize; i++)
	{
		if(Q[i].wpIdx == n)
		{
			return true;
		}
	}
	return false;
}

////////////////////////////////////////////////////////////
// returns true if n exists in the list
////////////////////////////////////////////////////////////
ListExists(list, n, listSize)
{
	for(i = 0; i < listSize; i++)
	{
		if(list[i].wpIdx == n)
		{
			return true;
		}
	}
	return false;
}

////////////////////////////////////////////////////////////
// Sets a bot's objective position
///////////////////////////////////////////////////////////
SetObjectivePos(pos)
{
	//FIXME: optimize
	dirToObjective = VectorNormalize(pos - self.origin);
	distToObj = distance(pos, self.origin); 

	//if a long way away from our objective, flank it
	minDistToObj = 1000;
	if(distToObj >= minDistToObj)
	{
		flankDir = VectorCross((0,0,1), dirToObjective);

		//project position out along tangent by distance to target
		self.vObjectivePos = pos + ((flankDir * ((distToObj / minDistToObj) * minDistToObj)) * self.flankSide);

		//set to pos of nearest waypoint so that we dont try walk out of the level
		if(isDefined(level.waypoints) && level.waypointCount)
		{
			self.vObjectivePos = level.waypoints[GetNearestStaticWaypoint(self.vObjectivePos)].origin;
		}
	}  
	else
	{
		self.vObjectivePos = pos;
	}
}



