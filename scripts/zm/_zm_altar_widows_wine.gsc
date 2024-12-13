#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_perks;

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

			playsoundatposition( "zmb_hellhound_spawn", altarT.origin );

			player TakeWeapon( player zm_utility::get_player_lethal_grenade() );
			player GiveWeapon( level.w_widows_wine_grenade );

			IPrintLn ( "Used Strange Idol." );

		} else {
			IPrintLn ( "You need a Strange Idol as an offering." );
		}
		

		player TakeWeapon( player zm_utility::get_player_lethal_grenade() );
		player GiveWeapon( level.w_widows_wine_grenade );

		/*
		if( level.w_widows_wine_grenade != player zm_utility::get_player_lethal_grenade() )
		{
			player.w_widows_wine_prev_grenade = player zm_utility::get_player_lethal_grenade();
		} else{
			player GiveWeapon( level.w_widows_wine_grenade );
		}
		*/
	}	
}