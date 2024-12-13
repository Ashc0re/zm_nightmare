#using scripts\zm\zm_custom_power;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\shared\fx_shared;

function autoexec main()
{
	level._effect["fx_soul"] = "zombie/fx_powerup_on_green_zmb";

	level.sound1 = "zmb_hellhound_spawn";
	level.sound2 = "ph_soul";

	level.soulboxes = GetEntArray( "soulbox", "targetname" );
	
	foreach(soulbox in level.soulboxes)
	{
		soulbox.soulcount = 0;
	}
}

function checkSoulbox( zombie )
{
	zombie.is_inside_volume = false;

	if( level.library_ritual_state == 1 )
	{
		foreach( volume in level.library_ritual_volumes) {
			if ( zombie IsTouching( volume ) ) {
				is_inside_volume = true;
			}
		}
		if ( is_inside_volume == true )
		{
			foreach( soulbox in level.soulboxes )
			{
				if( soulbox.script_string == "library_altar" )
				{
					// Soul fx
					create_soul( zombie.origin, soulbox.origin );

					soulbox.soulcount++;
					level.x = soulbox.soulcount;
					
					if( soulbox.soulcount >= soulbox.script_int )
					{
						level.library_ritual_state = 2;
						level.rituals_completed++;

						zm_custom_power::library_ritual();
					}				
				}
			}
		}		
	}
	if( level.warehouse_ritual_state == 1 )
	{
		foreach( volume in level.warehouse_ritual_volumes ) {
			if ( zombie IsTouching( volume ) ) {
				is_inside_volume = true;
			}
		}
		if ( is_inside_volume == true )
		{
			foreach( soulbox in level.soulboxes )
			{
				if( soulbox.script_string == "warehouse_altar" )
				{
					// Soul fx
					create_soul( zombie.origin, soulbox.origin );

					soulbox.soulcount++;
					
					if( soulbox.soulcount == soulbox.script_int )
					{
						level.warehouse_ritual_state = 2;
						level.rituals_completed++;

						zm_custom_power::warehouse_ritual( undefined );

						// Delete triggers and stuff, move model
						foreach( component in level.elevator_door_components )
						{
							if( component.script_string != "model" )
							{
								component Delete();
							} else {
								component MoveY( -132, 1 );
							}
						}
					}				
				}
			}
		}
	}
}

function create_soul(zombieLocation, soulboxLocation )
{
	speed = 500;	// Speed of the soul
	traveltime = Distance( zombieLocation, soulboxLocation ) / speed;

	m_fx = util::spawn_model( "tag_origin", zombieLocation + ( 0,0,50 ), ( 0, 0, 0 ) );

	fx = PlayFXOnTag( level._effect["fx_soul"], m_fx, "tag_origin" );
	m_fx PlaySound(level.sound2);

	fx MoveTo( soulboxLocation + ( 0,0,50 ), traveltime );

	wait traveltime;

	m_fx Delete();
}