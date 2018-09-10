#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>

#pragma semicolon 1
#pragma newdecls required


public Plugin myinfo =
{
	name = "[Any] Remove Weapons at Round End",
	author = "Cruze",
	description = "Remove all weapons from players and map",
	version = "1.1",
	url = ""
};

public void OnPluginStart()
{
	HookEvent("round_end", RoundEnd);
}
public Action RoundEnd(Handle event, const char[] name, bool dontBroadcast)
{
	for (int client = 1; client<=MaxClients; ++client) 
	{
		if (IsClientInGame(client) && !IsClientObserver(client) && IsPlayerAlive(client)) 
		{
			for(int i = 0; i < 6; i++)
			{
				int weapon = -1;
				while((weapon = GetPlayerWeaponSlot(client, i)) != -1)
				{
					if(IsValidEntity(weapon))
					{
						RemovePlayerItem(client, weapon);
					}
				}
			}
			SetEntProp(client, Prop_Send, "m_bHasDefuser", 0);
			SetEntProp(client, Prop_Send, "m_bHasHeavyArmor", 0);
			SetEntProp(client, Prop_Send, "m_ArmorValue", 0);
			SetEntProp(client, Prop_Send, "m_bHasHelmet", 0);
		}
	}

	char buffer[64];
	for(int entity = MaxClients; entity < GetMaxEntities(); entity++)
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
