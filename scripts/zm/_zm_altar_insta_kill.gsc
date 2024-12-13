#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerups;

#namespace zm_altar_insta_kill;

function __init__()
{
	altarT = GetEnt( "altar_insta_kill_t", "targetname" );
	altarT SetHintString( "Hold ^3&&1^7 to give offering" );

	while(1)
	{
		altarT waittill( "trigger", player );

		if ( player.hasIdol == true )
		{
			player.hasIdol = false;

			altarT PlaySound( "zmb_powerup_grabbed" );
			altarT PlaySound( "zmb_hellhound_spawn" );
			
			zm_powerup_insta_kill::insta_kill_powerup(undefined, player);
			IPrintLn ( "Used Strange Idol." );

		} else {
			IPrintLn ( "You need a Strange Idol as an offering." );
		}
	}	
}