#using scripts\zm\zm_soulboxes;

function MonitorZombies()
{
	while(1){
		zombies = GetAiSpeciesArray( "axis", "all" );		
		for(i=0;i<zombies.size;i++){
			if(isdefined(zombies[i].mytracking)) continue;
			else zombies[i] thread WatchMe();
		}
		wait(.05);
	}
}

function WatchMe()
{
	self.mytracking = true;

	self waittill("death");

	//Prevents nuked zombies from counting towards ritual kill. There might be a better way to do this.
	if( !isdefined(self.marked_for_death) )
	{
		zm_soulboxes::checkSoulbox(self);
	}
}