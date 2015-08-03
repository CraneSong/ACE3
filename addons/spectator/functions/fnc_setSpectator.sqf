/*
 * Author: SilentSpike
 * Sets target player to the given spectator state (virtually)
 * To physically handle a spectator see ace_spectator_fnc_stageSpectator
 *
 * Player will be able to communicate in ACRE/TFAR as appropriate
 * The spectator interface will be opened/closed
 *
 * Arguments:
 * 0: Unit to put into spectator state <OBJECT>
 * 1: Spectator state <BOOL> <OPTIONAL>
 *
 * Return Value:
 * None <NIL>
 *
 * Example:
 * [player, true] call ace_spectator_fnc_setSpectator
 *
 * Public: Yes
 */

#include "script_component.hpp"

params ["_unit", ["_set",true,[true]]];

// Only run for player units
if !(isPlayer _unit) exitWith {};

if !(local _unit) exitwith {
    [[_unit, _set], QFUNC(setSpectator), _unit] call EFUNC(common,execRemoteFnc);
};

// Handle common addon audio
if (["ace_hearing"] call EFUNC(common,isModLoaded)) then {EGVAR(hearing,disableVolumeUpdate) = _set};
if (["acre_sys_radio"] call EFUNC(common,isModLoaded)) then {[_set] call acre_api_fnc_setSpectator};
if (["task_force_radio"] call EFUNC(common,isModLoaded)) then {[_unit, _set] call TFAR_fnc_forceSpectator};

if (_set) then {
    ["open"] call FUNC(handleInterface);
} else {
    ["close",_unit] call FUNC(handleInterface);
};

// Mark spectator state for reference
_unit setVariable [QGVAR(isSet), _set, true];
GVAR(isSet) = _set;

["spectatorSet",[_set,_unit]] call EFUNC(common,localEvent);