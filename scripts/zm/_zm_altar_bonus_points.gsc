#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;

#namespace zm_altar_bonus_points;

function __init__()
{
	altarT = GetEnt( "altar_bonus_points_t", "targetname" );
	altarT SetHintString( "Hold ^3&&1^7 to give offering" );

	while(1)
	{
		altarT waittill( "trigger", player );

		if ( player.hasIdol == true )
		{
			player.hasIdol = false;

			altarT PlaySound( "zmb_powerup_grabbed" );

			player.score += 500;

			IPrintLn ( "Used Strange Idol." );

		} else {
			IPrintLn ( "You need a Strange Idol as an offering." );
		}
	}	
}