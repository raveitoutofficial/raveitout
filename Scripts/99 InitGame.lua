function Setup()

-- HOME MODE OPTIONS
--PREFSMAN:SetPreference("CoinMode",'Home');
--PREFSMAN:SetPreference("EventMode",1);
--PREFSMAN:SetPreference("AllowW1",'AllowW1_Never');
--PREFSMAN:SetPreference("VideoRenderers","d3d");
--PREFSMAN:SetPreference("Vsync",0);
	--forced prefs by game design
	--//copied and modified from NIKK's DDRS2KHD theme
	--THEME:ReloadMetrics();
	--redundante dejarlo aquí, dejar en theme default ScreenTitleMenu overlay o probar en ScreenOptions overlay
	--PREFSMAN:SetPreference("Theme","RioTI"); --appearance op --ok [sólo al iniciar]
	
	PREFSMAN:SetPreference("SuperMeterPercentChangeCheckpointHit",0);
	PREFSMAN:SetPreference("SuperMeterPercentChangeCheckpointMiss",0);
	PREFSMAN:SetPreference("SuperMeterPercentChangeHeld",6);
	PREFSMAN:SetPreference("SuperMeterPercentChangeHitMine",-8);
	PREFSMAN:SetPreference("SuperMeterPercentChangeLetGo",0);
	PREFSMAN:SetPreference("SuperMeterPercentChangeMiss",-2);
	PREFSMAN:SetPreference("SuperMeterPercentChangeW1",10);
	PREFSMAN:SetPreference("SuperMeterPercentChangeW2",8);
	PREFSMAN:SetPreference("SuperMeterPercentChangeW3",6);
	PREFSMAN:SetPreference("SuperMeterPercentChangeW4",2);
	PREFSMAN:SetPreference("SuperMeterPercentChangeW5",-2);
	
	PREFSMAN:SetPreference("TimeMeterSecondsChangeCheckpointHit",0);
	PREFSMAN:SetPreference("TimeMeterSecondsChangeCheckpointMiss",0);
	PREFSMAN:SetPreference("TimeMeterSecondsChangeHeld",3);
	PREFSMAN:SetPreference("TimeMeterSecondsChangeHitMine",-2);
	PREFSMAN:SetPreference("TimeMeterSecondsChangeLetGo",0);
	PREFSMAN:SetPreference("TimeMeterSecondsChangeMiss",-2);
	PREFSMAN:SetPreference("TimeMeterSecondsChangeW1",10);
	PREFSMAN:SetPreference("TimeMeterSecondsChangeW2",8);
	PREFSMAN:SetPreference("TimeMeterSecondsChangeW3",6);
	PREFSMAN:SetPreference("TimeMeterSecondsChangeW4",2);
	PREFSMAN:SetPreference("TimeMeterSecondsChangeW5",-2);
			--note end
	PREFSMAN:SetPreference("TimingWindowAdd",0);
	PREFSMAN:SetPreference("TimingWindowScale",THEME:GetMetric("CustomRIO","ForcedTimingScale"));
	PREFSMAN:SetPreference("TimingWindowSecondsAttack",0.135000);
	-- When checkpoints are used (normal gameplay), use a short lifetime.  When
	-- draining holds are used, use a longer lifetime.
	PREFSMAN:SetPreference("TimingWindowSecondsHold",0.350);
	PREFSMAN:SetPreference("TimingWindowSecondsMine",0.070);
	PREFSMAN:SetPreference("TimingWindowSecondsRoll",0.350);
	PREFSMAN:SetPreference("TimingWindowSecondsW1",0.026);
	PREFSMAN:SetPreference("TimingWindowSecondsW2",0.055);
	PREFSMAN:SetPreference("TimingWindowSecondsW3",0.100);
	PREFSMAN:SetPreference("TimingWindowSecondsW4",0.145);
	PREFSMAN:SetPreference("TimingWindowSecondsW5",0);
	--	PREFSMAN:SetPreference("TimingWindowSecondsHoldCheckpoint",0.060);	--this value doesn't exist in SM5
	
	--PREFSMAN:SetPreference("TimingWindowStrum",0.060);	--Replacement for PRO's XXXHoldCheckpoint?
	PREFSMAN:SetPreference("MaxInputLatencySeconds",0);

	--Forcing deleted options from operator
		--recordatorio, los valores son los enum en el luadoc, no los valores del preferences.ini
			--Input Options
	PREFSMAN:SetPreference("AutoMapOnJoyChange",false);
	PREFSMAN:SetPreference("DelayedBack",false);	--not verified
	PREFSMAN:SetPreference("MusicWheelSwitchSpeed",15);
			--Appearance Options
	PREFSMAN:SetPreference("DefaultModifiers","rio,2x");
	PREFSMAN:SetPreference("Announcer",nil); 		--not verified
	PREFSMAN:SetPreference("PercentageScoring",true);	--doesn't work?
	PREFSMAN:SetPreference("RandomBackgroundMode","RandomBackgroundMode_RandomMovies");
	PREFSMAN:SetPreference("ShowDancingCharacters","ShowDancingCharacters_Off");
	PREFSMAN:SetPreference("ShowBeginnerHelper",false);
	PREFSMAN:SetPreference("NumBackgrounds",5);
	--PREFSMAN:SetPreference("UseUnlockSystem",THEME:GetMetric("CustomRIO","LockSongs"));	--Linked with metrics so we can execute debug from commandline.
	--Graphic/Sound options
	PREFSMAN:SetPreference("SmoothLines",true);
	PREFSMAN:SetPreference("CelShadeModels",false);
	PREFSMAN:SetPreference("FastNoteRendering",true);
	PREFSMAN:SetPreference("DisableUploadDir",true);
	
	--UI Options
	PREFSMAN:SetPreference("ShowBanners",false);
	PREFSMAN:SetPreference("ShowInstructions",false);
	PREFSMAN:SetPreference("ShowNativeLanguage",false); --Other language characters don't display properly
	PREFSMAN:SetPreference("ShowSongOptions","Yes"); --Only visible when in Debug mode

	--Steps and music select related
	PREFSMAN:SetPreference("HiddenSongs",true); --To hide Easy Mode and OMES songs.
	PREFSMAN:SetPreference("AutogenSteps",false);
	PREFSMAN:SetPreference("AutogenGroupCourses",false);
	PREFSMAN:SetPreference("HideIncompleteCourses",true);
	
	--Lights related
	PREFSMAN:SetPreference("BlinkGameplayButtonLightsOnNote",true);
	PREFSMAN:SetPreference("LightsStepsDifficulty","medium,hard");
	PREFSMAN:SetPreference("OITGStyleLights",true);
	
	PREFSMAN:SetPreference("FastLoad",false);
	PREFSMAN:SetPreference("FastLoadAdditionalSongs",false);
	
	--FORCED OPERATOR CONFIG END

	--Preferences.ini Exclusive START
	PREFSMAN:SetPreference("FailOffForFirstStageEasy",false);	--TODO: Need verify
	PREFSMAN:SetPreference("FailOffInBeginner",false);	--TODO: needs confirm if works
	--Preferences.ini Exclusive END

	--no sirve, aun con esto aun hay que relanzar el programa para que disablesong tenga efecto.
	--GAMESTATE:SaveLocalData();	--nope
	
	--Init PIU_HEARTS_SYSTEM
	Reset_PIU_Hearts();
	
	--Reset PlayerOptions
	ActiveModifiers = {
		P1 = table.shallowcopy(PlayerDefaults),
		P2 = table.shallowcopy(PlayerDefaults),
		P3 = table.shallowcopy(PlayerDefaults),
		P4 = table.shallowcopy(PlayerDefaults),
		--MACHINE = table.shallowcopy(PlayerDefaults),
		--Save values here if editing profile
	}
	PerfectionistMode = {
		PlayerNumber_P1 = false,
		PlayerNumber_P2 = false,
		PlayerNumber_P3 = false,
		PlayerNumber_P4 = false
	};
	
	--It's global because musicwheel doesn't have a constructor and this needs to be loaded somewhere
	MUSICWHEEL_SONG_NAMES = (ReadPrefFromFile("ShowSongNames") == "true");
	
	--Just in case? There's probably no need to make this global.
	USING_RFID = (ReadPrefFromFile("SaveType") == "RFID");
end
