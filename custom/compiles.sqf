
if (!isDedicated) then {
	player_build = compile preprocessFileLineNumbers "custom\snap_pro\player_build.sqf";
	snap_build = compile preprocessFileLineNumbers "custom\snap_pro\snap_build.sqf";
	dayz_spaceInterrupt = compile preprocessFileLineNumbers "custom\snap_pro\dayz_spaceInterrupt.sqf";
	
	fnc_usec_selfActions =			compile preprocessFileLineNumbers "custom\fn_selfActions.sqf";		//Checks which actions for self
	player_unlockVault =			compile preprocessFileLineNumbers "custom\BuildVectors\compile\player_unlockVault.sqf";
	player_lockVault =			compile preprocessFileLineNumbers "custom\BuildVectors\compile\player_lockVault.sqf";
	fnc_SetPitchBankYaw =       compile preprocessFileLineNumbers "custom\BuildVectors\fnc_SetPitchBankYaw.sqf";
	DZE_build_vector_file =         "custom\BuildVectors\build_vectors.sqf";
	build_vectors =                 compile preprocessFileLineNumbers DZE_build_vector_file;
};
