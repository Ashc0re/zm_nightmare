#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_utility.gsh;

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#using scripts\shared\ai\zombie_utility;
#using scripts\zm\_zm_utility;

//Perks
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perk_additionalprimaryweapon;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_deadshot;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_widows_wine;

//Powerups
//#using scripts\zm\_zm_powerup_double_points;
//#using scripts\zm\_zm_powerup_carpenter;
//#using scripts\zm\_zm_powerup_fire_sale;
//#using scripts\zm\_zm_powerup_free_perk;
//#using scripts\zm\_zm_powerup_full_ammo;
//#using scripts\zm\_zm_powerup_insta_kill;
//#using scripts\zm\_zm_powerup_nuke;
//#using scripts\zm\_zm_powerup_weapon_minigun;
#using scripts\zm\_zm_powerups;

//Altars
#using scripts\zm\_zm_altar_bonus_points;
#using scripts\zm\_zm_altar_double_points;
#using scripts\zm\_zm_altar_full_ammo;
#using scripts\zm\_zm_altar_insta_kill;
//#using scripts\zm\_zm_altar_strange_idol;

//Traps
#using scripts\zm\_zm_trap_electric;

#using scripts\zm\zm_usermap;

//Ritual Power
#using scripts\zm\zm_custom_power;
#using scripts\zm\zm_zombie_death;
#using scripts\zm\_zm_powerup_strange_idol;

//Elevator
#using scripts\zm\zm_elevator;

#precache( "fx", "zombie/fx_ritual_barrier_defend_door_wide_zod_zmb" );

//*****************************************************************************
// MAIN
//*****************************************************************************

function main()
{
	zm_usermap::main();
	
	level.player_starting_points = 100000;

	level._zombie_custom_add_weapons =&custom_add_weapons;
	
	//Setup the levels Zombie Zone Volumes
	level.zones = [];
	level.zone_manager_init_func =&usermap_test_zone_init;
	init_zones[0] = "start_zone";
	level thread zm_zonemgr::manage_zones( init_zones );

	level.pathdist_type = PATHDIST_ORIGINAL;

	//thread zm_custom_power::monitor_power();
	thread zm_zombie_death::MonitorZombies();
	thread zm_elevator::MoveElevator();

	//Altars
	thread zm_altar_bonus_points::__init__();
	thread zm_altar_double_points::__init__();
	thread zm_altar_full_ammo::__init__();
	thread zm_altar_insta_kill::__init__();

	//Drops
	thread zm_powerup_strange_idol::__init__();

	//i == 0;
	//foreach(player in level.players)
	//{
	//	player.hasIdol = false;
	//	player.id = i;
	//	i++;
	//}

	ArrayRemoveValue(level.zombie_powerup_array,"fire_sale");
	ArrayRemoveValue(level.zombie_powerup_array,"nuke");
	ArrayRemoveValue(level.zombie_powerup_array,"insta_kill");
	ArrayRemoveValue(level.zombie_powerup_array,"double_points");
	//ArrayRemoveValue(level.zombie_powerup_array,"carpenter");
	ArrayRemoveValue(level.zombie_powerup_array,"full_ammo");
	ArrayRemoveValue(level.zombie_powerup_array,"powerup_mini_gun");

	zombie_utility::set_zombie_var( "zombie_powerup_drop_increment",		2000 );	// 2000, lower this to make drop happen more often
	zombie_utility::set_zombie_var( "zombie_powerup_drop_max_per_round",	4 );	// 4, raise this to make drop happen more often

	thread test();
	
	level flag::wait_till("initial_blackscreen_passed");

	//zombie_utility::set_zombie_var( "zombie_new_runner_interval", 		 10,	false,	column );	//	Interval between changing walkers who are too far away into runners
	//zm::get_zombie_count_for_round(<round>, level.players.size);	
}

function test()
{
	while(1)
	{
		wait 2;
		foreach( player in level.players )
		{
			IPrintLn( "uwu" );
		}
		IPrintLn( "owo" );
	}
}

function usermap_test_zone_init()
{
	//level flag::init( "always_on" );
	//level flag::set( "always_on" );

	zm_zonemgr::add_adjacent_zone( "start_zone", "junction_zone", "activate_junction_zone" );
	zm_zonemgr::add_adjacent_zone( "junction_zone", "mainstreet_zone", "activate_mainstreet_zone" );
	zm_zonemgr::add_adjacent_zone( "mainstreet_zone", "upper_mainstreet_zone" );
	zm_zonemgr::add_adjacent_zone( "mainstreet_zone", "loadingbay_zone", "activate_loadingbay_zone" );
	zm_zonemgr::add_adjacent_zone( "mainstreet_zone", "warehouse_zone", "activate_warehouse_zone" );
	zm_zonemgr::add_adjacent_zone( "loadingbay_zone", "warehouse_zone" );
	zm_zonemgr::add_adjacent_zone( "junction_zone", "backalley_zone", "activate_backalley_zone" );
	zm_zonemgr::add_adjacent_zone( "backalley_zone", "upper_backalley_zone" );
	zm_zonemgr::add_adjacent_zone( "backalley_zone", "market_zone", "activate_dockside_zone" );
	zm_zonemgr::add_adjacent_zone( "backalley_zone", "library_zone", "activate_library_zone" );
	zm_zonemgr::add_adjacent_zone( "market_zone", "library_zone" );
	zm_zonemgr::add_adjacent_zone( "market_zone", "dockside_zone" );
	zm_zonemgr::add_adjacent_zone( "dockside_zone", "sewers_left_zone", "activate_sewers_zone" );
	zm_zonemgr::add_adjacent_zone( "warehouse_zone", "sewers_right_zone", "activate_sewers_zone" );
	zm_zonemgr::add_adjacent_zone( "sewers_left_zone", "sewers_ritual_zone" );
	zm_zonemgr::add_adjacent_zone( "sewers_right_zone", "sewers_ritual_zone" );
	zm_zonemgr::add_adjacent_zone( "dockside_zone", "start_zone", "test" );
	zm_zonemgr::add_adjacent_zone( "warehouse_zone", "start_zone", "test" );
	
}	

function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_nightmare_weapons.csv", 1);
}

