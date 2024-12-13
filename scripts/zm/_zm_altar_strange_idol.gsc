#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_perks;

//#namespace zm_altar_strange_idol;

function autoexec __init__()
{
	/*for( i == 0; i < level.players.size; i++ )
	{
		level.players[i].id = i;
		level.players[i].has_idol = false;
	}*/

	altars = GetEntArray( "altar_strange_idol_trigger", "targetname" );
	offering_models = GetEntArray( "altar_strange_idol_model", "targetname" );

	foreach( player in level.players )
	{
		foreach ( altar in altars )
		{
			if( altar.script_int == player.id )
			{
				altar SetHintString( "Hold ^3&&1^7 to place Offering at Offering Pedestal." );

				thread monitor_altar( altar, offering_models );
			}
		}
	}

	foreach( model in offering_models )
	{
		model Hide();
	}

	test();
}

function test()
{	
	while(1)
	{
		wait 4;
		foreach( player in level.players )
		{
			IPrintLn( player.id  );
			IPrintLn( "uwu" );
		}
	}
}

function monitor_altar( trigger, offering_models )
{
	while(1)
	{
		IPrintLn( "uwu" );
		trigger waittill( "trigger", player );

		if( trigger.script_boolean == true )
		{
			trigger.script_boolean = false;
			player.has_idol = true;

			foreach (model in offering_models)
			{
				if( model.script_int == player.id )
				{
					model Hide();
				}
			}

			trigger PlaySound( "zmb_powerup_grabbed" );
		} else{
		IPrintLn( "uwu" );
		if( player.id == trigger.script_int )
			{
				if ( player.has_idol == true )
				{
					player.has_idol = false;
					trigger.script_boolean = true;

					trigger PlaySound( "zmb_powerup_grabbed" );

					foreach (model in offering_models)
					{
						if( model.script_int == player.id )
						{
							model Show();
						}
					}

					IPrintLn ( "Placed Strange Idol." );

				} else {
					IPrintLn ( "You need a Strange Idol for this." );
				}
			}
		}
	}
}