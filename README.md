# ![alt text](https://dl.dropboxusercontent.com/u/14423790/snappro.png "Snap Building Pro")
___

## *Installation* `ver 1.4.1`

## Server Side
First thing you need to do is make a few edits to your dayz_server.pbo file.
Start by opening your **server_monitor.sqf**(Remove anything done from P4L installation) which is located in the system folder and find the following code block:

```
if (!_wsDone) then {
	if (count _worldspace >= 1) then { _dir = _worldspace select 0; };
	_pos = [getMarkerPos "center",0,4000,10,0,2000,0] call BIS_fnc_findSafePos;
	if (count _pos < 3) then { _pos = [_pos select 0,_pos select 1,0]; };
	diag_log ("MOVED OBJ: " + str(_idKey) + " of class " + _type + " to pos: " + str(_pos));
};
```

After that, insert this:
```
_vector = [[0,0,0],[0,0,0]];
_vecExists = false;
_ownerPUID = "0";	
if (count _worldspace >= 3) then{
	if(count _worldspace == 3) then{
			if(typename (_worldspace select 2) == "STRING")then{
				_ownerPUID = _worldspace select 2;
			}else{
				 if(typename (_worldspace select 2) == "ARRAY")then{
					_vector = _worldspace select 2;
					if(count _vector == 2)then{
						if(((count (_vector select 0)) == 3) && ((count (_vector select 1)) == 3))then{
							_vecExists = true;
						};
					};
				};					
			};
			
	}else{
		//Was not 3 elements, so check if 4 or more
		if(count _worldspace == 4) then{
			if(typename (_worldspace select 3) == "STRING")then{
				_ownerPUID = _worldspace select 3;
			}else{
				if(typename (_worldspace select 2) == "STRING")then{
					_ownerPUID = _worldspace select 2;
				};
			};
	
	
			if(typename (_worldspace select 2) == "ARRAY")then{
				_vector = _worldspace select 2;
				if(count _vector == 2)then{
					if(((count (_vector select 0)) == 3) && ((count (_vector select 1)) == 3))then{
						_vecExists = true;
					};
				};
			}else{
				if(typename (_worldspace select 3) == "ARRAY")then{
					_vector = _worldspace select 3;
					if(count _vector == 2)then{
						if(((count (_vector select 0)) == 3) && ((count (_vector select 1)) == 3))then{
							_vecExists = true;
						};
					};
				};
			};
			
		}else{
			//More than 3 or 4 elements found
			//Might add a search for the vector, ownerPUID will equal 0
		};
	};
}; 
```

Once that is complete, find this next line:
```
_object setVariable ["ObjectID", _idKey, true];
```
And place the following after it:
```
_object setVariable ["ownerPUID", _ownerPUID, true];
```
Now it's time to apply the vector to the object, so find the following line:
```
_object setdir _dir;
```
And place this after it:
```
if(_vecExists)then{
	_object setVectorDirAndUp _vector;
}; 
```
Last but not least, we need to save the objects direction to a variable. To do that, find:
```
if (DZE_GodModeBase) then {
```
And place the following above it:
```
_object setVariable["memDir",_dir,true];
```


The next file we need to edit is the **server_functions.sqf**.

Find the following function:
```
dayz_objectUID2 = {
```
And replace that code block with:
```
dayz_objectUID2 = {
	private["_position","_dir","_key","_element","_vector","_set","_vecCnt","_usedVec"];
	_dir = _this select 0;
	_key = "";
	_position = _this select 1;
	
	if((count _this) == 2) then{
		{
			_x = _x * 10;
			if ( _x < 0 ) then { _x = _x * -10 };
			_key = _key + str(round(_x));
		} count _position;
		_key = _key + str(round(_dir));
	}else{
		_vector = [];
		_usedVec = false;
		{
			_element = _x;
			if(typeName _element == "ARRAY") then{
				_vector = _element;
				if((count _vector) == 2)then{
					if(((count (_vector select 0)) == 3) && ((count (_vector select 1)) == 3))then{
							{
								_x = _x * 10;
								if ( _x < 0 ) then { _x = _x * -10 };
								_key = _key + str(round(_x));
							} count _position;
							
							_vecCnt = 0;
							{
								_set = _x;
								{
									_vecCnt = _vecCnt + (round (_x * 100));
									
								} foreach _set;
								
							} foreach _vector;
							if(_vecCnt < 0)then{
								_vecCnt = ((_vecCnt * -1) * 3);
							};
							_key = _key + str(_vecCnt);
							_usedVec = true;
					};
				};
			};
		} count _this;
		
		if!(_usedVec) then{
				{
					_x = _x * 10;
					if ( _x < 0 ) then { _x = _x * -10 };
					_key = _key + str(round(_x));
				} count _position;
				_key = _key + str(round(_dir));
		};
		
		
	};
	_key
};
```

**Optional:** Install [Precise Base Building](http://epochmod.com/forum/index.php?/topic/15813-release-v103-precise-base-building-persistent-bases-after-restart/). HIGHLY RECOMMENDED and necessary if you ran it previously.  

That completes everything server side :)

## Mission Side
Create and add new **compiles.sqf** file (you can reuse an old one if you already have it) and add this to **init.sqf** file:

Find:
```c++
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";	
```

Add this line right after, like so:
```c++
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";				//Compile regular functions
call compile preprocessFileLineNumbers "custom\compiles.sqf";							 //Compile custom compiles
```

**compiles.sqf** can be either found in project folder here on github or you can just create new file and add these lines:

```c++
if (!isDedicated) then {
	player_build = compile preprocessFileLineNumbers "custom\snap_pro\player_build.sqf";
	snap_build = compile preprocessFileLineNumbers "custom\snap_pro\snap_build.sqf";
	dayz_spaceInterrupt = compile preprocessFileLineNumbers "custom\snap_pro\dayz_spaceInterrupt.sqf";
	
	fnc_usec_selfActions =			compile preprocessFileLineNumbers "custom\fn_selfActions.sqf";		
	player_unlockVault =			compile preprocessFileLineNumbers "custom\BuildVectors\compile\player_unlockVault.sqf";
	player_lockVault =			compile preprocessFileLineNumbers "custom\BuildVectors\compile\player_lockVault.sqf";
	fnc_SetPitchBankYaw =       compile preprocessFileLineNumbers "custom\BuildVectors\fnc_SetPitchBankYaw.sqf";
	DZE_build_vector_file =         "custom\BuildVectors\build_vectors.sqf";
	build_vectors =                 compile preprocessFileLineNumbers DZE_build_vector_file;
};
```
Open your **description.ext** (root of your MPMissions folder), add this to the very bottom:
```c++
#include "custom\snap_pro\snappoints.hpp"
```

Copy **snap_pro** folder inside your **custom** folder and you are done. Simple as that!

### Infistar Antihack
##### Newest Infistar AH (13/07/2014) comes with actions whitelisted by default

That's it , Congratulations, you are done!
---

###### (Optional)

To adjust ranges, change this variable (negative values will reduce detection range, positive will increase). Will affect performance
Default value is 0. Safe values are -5, 5, 10 or anything in between.
Simply add this to your init.sqf somewhere on top:

```c++
DZE_snapExtraRange = 0;
```

To disable tutorial text on bottom-right corner, add this to your **init.sqf**:
```c++
snapTutorial = false;
```

To only show tutorial text once (per log-in), add this right before closing bracket in line #236 in *snap_build.sqf*:

```c++
				] spawn bis_fnc_dynamicText;
			};
		};
	snapTutorial = false;	
};
```
## Changelog
|Notes										|Date				|Version	|
| ------------------------------------------|:-----------------:| ---------:|
|Rare bug fix								|30/08/2014			|1.4.1		|
|ASL based player/snap_build, fixes, extras	|21/08/2014			|1.4		|
|Full support for water bases				|15/08/2014			|1.3.1		|
|Fixed defines, adjustable snap ranges		|09/08/2014			|1.3		|
|Anti-grief temporarily removed				|23/07/2014			|1.2.1		|
|CMD menus removed and pushed to a new repo	|21/07/2014			|1.2.0		|
|Snap point radius is now config based		|18/07/2014			|1.1.6		|
|Build range and anti-grief fix				|16/07/2014			|1.1.5		|
|Missing stairs with support in config		|14/07/2014			|1.1.4		|
|Code optimization, vault points added		|12/07/2014			|1.1.3		|
|Ghost fix for metal floor (GenCamoUGL)		|10/07/2014			|1.1.2		|
|CMD/Action menu toggle						|09/07/2014			|1.1.1		|
|CMD menu added	(mudzerelli)				|09/07/2014			|1.1.0		|
|Missing objects added						|07/07/2014			|1.0.1		|
|SBP release								|06/07/2014			|1.0.0		|
