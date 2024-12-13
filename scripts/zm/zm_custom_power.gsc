#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_power;

function autoexec setup_power()
{
	thread monitor_power();
	thread precache_fx();

	// Set Hint Strings for Rituals
	power_ritual_triggers = GetEntArray( "power_ritual_trigger", "targetname" );

	foreach( trigger in power_ritual_triggers )
	{
		trigger SetHintString( "Hold ^3&&1^7 to begin Ritual [Cost:500]" );
		thread acivate_ritual( trigger );
	}

	// Set Hint Strings for Power Doors
	level.power_door_components = GetEntArray( "power_door_component", "targetname" );

	foreach( component in level.power_door_components )
	{
		if( component.script_string == "hint" )
		{
			component SetHintString( "Something needs to be done...");
		}
	}

	level.library_ritual_state = 0;
	level.warehouse_ritual_state = 0;
	level.rituals_completed = 0;

	level util::set_lighting_state(0);
}

function monitor_power()
{
	level flag::wait_till("power_on");

	level util::set_lighting_state(1);
}

function precache_fx()
{
	level._effect["fx_barrier"] = "zombie/fx_ritual_barrier_defend_door_wide_zod_zmb";
}

function acivate_ritual( trigger )
{
	while(1)
	{
		trigger waittill( "trigger", player );

		if( trigger.script_string == "library_altar" && level.library_ritual_state == 0 && player.score >= 500 )
		{	
			player.score -=  500;

			level.library_ritual_trigger = trigger;
			level.library_ritual_volumes = GetEntArray( "library_ritual_volume", "targetname" );

			library_ritual();
		}
		if( trigger.script_string == "warehouse_altar" && level.warehouse_ritual_state == 0 && player.score >= 500 )
		{
			player.score -=  500;

			level.warehouse_ritual_trigger = trigger;
			level.warehouse_ritual_volumes = GetEntArray( "warehouse_ritual_volume", "targetname" );

			warehouse_ritual_door = GetEnt( "warehouse_ritual_door", "targetname" );

			warehouse_ritual();
		}
	}	
}

function library_ritual()
{
	if( level.library_ritual_state == 0 )
	{
		level.library_ritual_state = 1; // Set Ritual State from "Inactive" to "Started"

		library_ritual_doors = GetEntArray( "library_ritual_door", "targetname" );
		level.library_ritual_barriers = []; // Create an array to store the fx in

		// Loop through all doors and fill array with fx
		i = 0;
		foreach( clip in library_ritual_doors )
		{
			clip MoveZ(-96,0.25);

			level.library_ritual_barriers[i] = util::spawn_model( "tag_origin", clip.origin + ( 0, 0, -135 ), clip.angles );
			fx = PlayFXOnTag( level._effect["fx_barrier"], level.library_ritual_barriers[i], "tag_origin" );

			i++;
		}

		// Play Sound and Change Hint String
		level.library_ritual_trigger PlaySound( "zmb_powerup_grabbed" );
		level.library_ritual_trigger SetHintString( "Ritual ongoing ..." );
	}
	if( level.library_ritual_state == 2 )
	{
		library_ritual_doors = GetEntArray( "library_ritual_door", "targetname" );	
		
		foreach( clip in library_ritual_doors )
		{
			clip MoveZ(96,0.25);
		}

		foreach( barrier in level.library_ritual_barriers )
		{
			barrier Delete();
		}

		level.library_ritual_trigger PlaySound( "zmb_powerup_grabbed" );
		level.library_ritual_trigger SetHintString( "" );

		//Dockside Door
		//Delete triggers and stuff, move model
		power_door_components = GetEntArray( "power_door_component", "targetname" );

		foreach( component in power_door_components )
		{
			if( component.script_int == 1 )
			{
				if( component.script_string != "model" )
				{
					component Delete();
				} else {
					component MoveY( 132, 1 );
				}
			}	
		}

		// Enable Power
		if( level.rituals_completed == 2 )
		{
			thread zm_custom_power::activatePower();
		}
	}
}

function warehouse_ritual( trigger ) 
{
	if(level.warehouse_ritual_state == 0)
	{
		level.warehouse_ritual_state = 1;

		// Move Door
		warehouse_ritual_door = GetEnt( "warehouse_ritual_door", "targetname" );
		warehouse_ritual_door MoveX( 128,0.25 );

		// Spawn FX
		wait 0.25; // Wait untill the door is in place
		level.warehouse_ritual_barrier = util::spawn_model( "tag_origin", warehouse_ritual_door.origin + ( 0, 0, -135 ), ( 0, 90, 0 ) );
		fx = PlayFXOnTag( level._effect["fx_barrier"], level.warehouse_ritual_barrier, "tag_origin" );

		// Play Sound and Change Hint String
		level.warehouse_ritual_trigger PlaySound( "zmb_powerup_grabbed" );

		level.warehouse_ritual_trigger SetHintString( "Ritual ongoing" );
	}
	if(level.warehouse_ritual_state == 2)
	{
		warehouse_ritual_door = GetEntArray( "warehouse_ritual_door", "targetname" );	
		
		warehouse_ritual_door MoveX( -128,0.25 );
		level.warehouse_ritual_barrier Delete();

		level.warehouse_ritual_trigger PlaySound( "zmb_powerup_grabbed" );

		level.warehouse_ritual_trigger SetHintString( "Ritual completed" );

		// ToDo! Move this to Elevator Script

		// Elevator Door
		// Delete triggers and stuff, move model
		power_door_components = GetEntArray( "power_door_component", "targetname" );

		foreach( component in power_door_components )
		{
			if( component.script_int == 2 )
			{
				if( component.script_string != "model" )
				{
					component Delete();
				} else {
					component MoveY( 132, 1 );
				}
			}
		}

		// Enable Power
		if( level.rituals_completed == 2 )
		{
			thread zm_custom_power::activatePower();
		}
	}
}

function activatePower()
{
	power_zone = undefined;

	if(isDefined(self.script_int))
	{
		power_zone = self.script_int;
	}

	level thread zm_perks::perk_unpause_all_perks( power_zone );
	level thread zm_power::turn_power_on_and_open_doors( power_zone );

	sewers_entrances = GetEntArray( "sewers_entrance", "targetname" );
	bridge_meshes = GetEntArray( "bridge", "targetname" );

	foreach(entrance in sewers_entrances)
	{
		entrance Delete();
	}

	foreach(mesh in bridge_meshes)
	{
		mesh Delete();
	}

	level flag::init( "activate_sewers_zone" );
	level flag::set( "activate_sewers_zone" );

	level flag::init( "test" );
	level flag::set( "test" );

	IPrintLn("Power Activated");
}
