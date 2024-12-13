#using scripts\codescripts\struct;

function MoveElevator()
{
	isElevatorUp = true;
	isElevatorMoving = false;

	elevatorPlattform = GetEnt( "elevator", "targetname" );
	elevatorControl = GetEnt( "elevator_control", "targetname" );
	elevatorOrigin = GetEnt( "elevator_origin", "targetname" );
	elevatorT = GetEnt( "elevator_t", "targetname" );

	elevatorT SetHintString("Hold ^3&&1^7 to move Elevator [Cost: 500]");
	elevatorT SetCursorHint("HINT_NOICON");

	elevatorT EnableLinkTo();
	elevatorT LinkTo(elevatorOrigin);
	elevatorControl LinkTo(elevatorOrigin);
	elevatorPlattform LinkTo(elevatorOrigin);

	while(1)
	{
		elevatorT waittill( "trigger", player );
		if(player.score >= 500 && !isElevatorMoving)
		{
			IPrintLn( "Boop" );

			player.score = player.score - 500;

			if(isElevatorUp)
			{
				
				elevatorOrigin MoveZ(-148, 3);

				isElevatorUp = false;
			} else {
				elevatorOrigin MoveZ(148, 3);
				
				isElevatorUp = true;
			}

			isElevatorMoving = true;
			elevatorT SetHintString("Moving");

			wait(3);

			elevatorT SetHintString("Cooling Down");

			wait(2);

			isElevatorMoving = false;
			elevatorT SetHintString("Hold ^3&&1^7 to move Elevator [Cost: 500]");

			IPrintLn( "Beep" );
		} else {
			wait(1.5);			
		}		
	}
}