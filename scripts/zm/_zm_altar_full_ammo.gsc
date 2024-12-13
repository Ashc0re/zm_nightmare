#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#namespace zm_altar_full_ammo;

function __init__()
{
	altarT = GetEnt( "altar_full_ammo_t", "targetname" );
	altarT SetHintString( "Hold ^3&&1^7 to give offering" );

	while(1)
	{
		altarT waittill( "trigger", player );
		
		if ( player.hasIdol == true )
		{
			player.hasIdol = false;

			altarT PlaySound( "zmb_powerup_grabbed" );
			altarT PlaySound( "zmb_hellhound_spawn" );

			level thread zm_powerup_full_ammo::full_ammo_powerup( self ,player );

			IPrintLn ( "Used Strange Idol." );

		} else {
			IPrintLn ( "You need a Strange Idol as an offering." );
		}
	}	
}