// Amok Runner Load Remover & Autosplitter Version 1.0 30/12/2022
// Supports Load Remover IGT
// Splits for campaigns can be obtained from 
// Script by TheDementedSalad
// Levels found by by yobson


state("Amok-Win64-Shipping", "SteamRelease")
{
	byte Loading 		:	0x46A6B10, 0x168, 0x8, 0x2218, 0x8;
	byte Level 			:	0x4BAC550, 0x8, 0x8, 0x990, 0x250, 0x30;
	byte Final			:	0x498A010, 0x118, 0x280, 0x480, 0x78, 0x0, 0x0, 0x88, 0x8;
	byte Blackscreen	:	0x4989A18, 0xD2;
	float X				:   0x4989A18, 0x98, 0x8C8, 0x3E8, 0x130, 0x10;
	float Y				:	0x4989A18, 0x98, 0x8C8, 0x3E8, 0x130, 0x18;
	float Z				:	0x4989A18, 0x98, 0x8C8, 0x3E8, 0x130, 0x14;
	string128 Map 		:	0x4BAC598, 0xD28, 0x30, 0xF8, 0x20;

}

init
{
	switch (modules.First().ModuleMemorySize)
	{
		case (84217856):
			version = "SteamRelease";
			break;
	}
}

startup
{
	vars.ASLVersion = "ASL Version 1.0.6 - 31/12/22";
	
	if (timer.CurrentTimingMethod == TimingMethod.RealTime){ // stolen from dude simulator 3, basically asks the runner to set their livesplit to game time
		var timingMessage = MessageBox.Show (
			"This game uses Time without Loads (Game Time) as the main timing method.\n"+
			"LiveSplit is currently set to show Real Time (RTA).\n"+
			"Would you like to set the timing method to Game Time? This will make verification easier",
			"LiveSplit | Amok Runner",
		MessageBoxButtons.YesNo,MessageBoxIcon.Question);
		
		if (timingMessage == DialogResult.Yes){
			timer.CurrentTimingMethod = TimingMethod.GameTime;
		}
	}
	
	vars.completedSplits = new List<byte>();
	
	settings.Add(vars.ASLVersion, false);
	
	settings.Add("Auto", false, "Enable Autosplitter");
	vars.Levels = new Dictionary<string,string>
	{
		{"1","Begin Clinic"},
		{"2","Finish Clinic"},
		{"3","Reach Train Station"},
		{"5","Reach House"},
		{"6","Reach Abandoned House Grounds"},
		{"7","Start Lowering Ladder"},
		{"8","Enter Abandoned House"},
		{"9","Leave Abandoned House"},
		{"10","Finish Encounter"},
		{"11","Reach Mansions Grounds"},
		{"12","Enter Planet Building"},
		{"13","Enter Mansion"},
		{"14","Exit Mansion"},
		{"15","Reach Town"},
		{"16","Reach Clinic"},
		{"17","Help Lady"},
		{"18","RIP Lady"},
		{"19","Begin Car Escape"},
		{"20","Begin Cemetery"},
		{"21","Begin Final Boss"},
		{"22","Killed Final Boss"},
		{"23","Reached Ship"},
	};
	
	 foreach (var Tag in vars.Levels)
		{
			settings.Add(Tag.Key, false, Tag.Value, "Auto");
    	};

		settings.CurrentDefaultParent = null;

	
	settings.Add("End", true, "End Split - Always Active");
}

update
{
	// Uncomment debug information in the event of an update.
	//print(modules.First().ModuleMemorySize.ToString());
	
	if(timer.CurrentPhase == TimerPhase.NotRunning)
	{
		vars.completedSplits.Clear();
	}
}

start
{
	return current.Loading == 2 && old.Loading == 3 && current.Level == 0;
}

split
{
	vars.LevelStr = current.Level.ToString();
	
		if(settings["Auto"]){
		if((settings[vars.LevelStr]) && (!vars.completedSplits.Contains(current.Level))){
			vars.completedSplits.Add(current.Level);
			return true;
		}
	}

	
	if(current.Level == 23 && current.X > -57145f && current.X < -57140f && current.Final == 1 && old.Final == 6){
			return true;
		}
	
	else return false;
}

isLoading
{
	return current.Loading == 3 || current.Map == "AmokEntry" || current.Blackscreen == 23;
}

reset
{
	return current.Map == "Amoktown" && old.Map == "AmokEntry" && current.Level == 0;
}
