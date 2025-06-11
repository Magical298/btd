#include btd\_dvardef;

main()
{
	level.prob_spawn_test = createdvar("btd_probspawn_test_zom",100,0,100,"int");
	level.prob_spawn_normal = createdvar("btd_probspawn_Boss_zom",0,0,100,"int");

	prob_total = level.prob_spawn_test + level.prob_spawn_normal;
	
	if(prob_total != 100)
	{
		level.prob_spawn_test = 80;
		level.prob_spawn_normal = 20;
	}
	
	level.prob_spawn_test2 = level.prob_spawn_test;		
	level.prob_spawn_normal2 = level.prob_spawn_test + level.prob_spawn_normal;	
}

choose()
{
	number = 0;
	number = randomInt(100);	
	probtospawn = number + 1;

	// spawns the randomly chosen zombie via the probabilty factor set by dvar in zombie.cfg
	if(level.prob_spawn_test != 0 && probtospawn <= level.prob_spawn_test2)
	{
		ent_zom = btd\_zombie_test::spawn_testzombie();
		//iprintln("spawning test zombie");
	}	
	else if(level.prob_spawn_normal != 0 && probtospawn > level.prob_spawn_test2 && probtospawn <= level.prob_spawn_normal2)
	{
		ent_zom = btd\_zombie_boss::spawn_bosszombie();
		//iprintln("spawning boss zombie");
	}
	else // shouldnt get here buy i expect it will
	{
		// something has gone wrong so we are just going to spawn a test zombie (hack fix lol)
		ent_zom = btd\_zombie_test::spawn_testzombie();
		println("spawning backup normal zombie");	
	}

	ent_zom thread btd\_pezbot_zombies::Connected();
	return( ent_zom );
}
