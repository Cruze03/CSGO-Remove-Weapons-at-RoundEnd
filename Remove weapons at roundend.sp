#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>


new const g_iaGrenadeOffsets[] = {15, 17, 16, 14, 18, 17};

public Plugin: myinfo =
{
	name = "[Any] Remove Weapons at Round End",
	author = "Cruze",
	description = "Remove all weapons from players and map",
	version = "1.0",
	url = ""
};

public void OnPluginStart()
{
	HookEvent("round_end", RoundEnd);
}
public Action RoundEnd(Handle event, const char[] name, bool dontBroadcast)
{
	for (new client=1; client<=MaxClients; ++client) 
	{
		if (IsClientInGame(client) && !IsClientObserver(client) && IsPlayerAlive(client)) 
		{
			for(int i = 0; i < 6; i++)
			{
				int weapon = GetPlayerWeaponSlot(client, i);
				if(weapon > 0)
				{
					RemovePlayerItem(client, weapon);
					RemoveEdict(weapon);
				}
				RemoveNades(client);
			}
		}
	}
	new String: buffer[64];
	for(new entity = MaxClients; entity < GetMaxEntities(); entity++)
	{
		if(IsValidEntity(entity))
		{
			GetEntityClassname(entity, buffer, sizeof(buffer));
			if(((StrContains(buffer, "weapon_", false) != -1) && (GetEntProp(entity, Prop_Data, "m_iState") == 0) && (GetEntProp(entity, Prop_Data, "m_spawnflags") != 1)) || StrEqual(buffer, "item_defuser", false) || (StrEqual(buffer, "chicken", false) && (GetEntPropEnt(entity, Prop_Send, "m_leader") == -1)))
			{
				AcceptEntityInput(entity, "Kill");
			}
		}
	}
	return Plugin_Continue;
}
stock RemoveNades(client)
{
	for(new i = 0; i < 6; i++)
		SetEntProp(client, Prop_Send, "m_iAmmo", 0, _, g_iaGrenadeOffsets[i]);
}