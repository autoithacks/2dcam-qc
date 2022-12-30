//+---------+
//|Weapons  |
//+---------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Damaging stuff goes here..                                                 |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

void() jumpkick_touch =
{
	if (other.classname == self.classname)
		return; // no jumpkicking the same kind

	if (other.takedamage && other.hitme != 3)
	{
		if (other.ch_pain)
		{
			other.hitme = 3;
			self.th_stand();
			self.attack = W_KICK;
			sound (self, CHAN_WEAPON, "hit2.wav", 1, ATTN_NORM);
			T_Damage (other, self, self, 1);
			spawn_touchblood (20);
		}
	}
};

void(float damg, float dist) FireMelee =
{
	local	vector	source, org, v;

	if (self.classname == "player")
		MakeSolidList();

	source = self.origin + '0 0 16';
	makevectors(self.angles);
	traceline (source, source + v_forward * dist, FALSE, self);
	if (trace_fraction == 1.0) return;
	org = trace_endpos - v_forward*4;
	if (trace_ent.takedamage)
	{
		if (self.attack == W_COMBO1)
		{
			trace_ent.hitme = 7;
			sound (self, CHAN_WEAPON, "crunch.wav", 1, ATTN_NORM);
		}
		else
			trace_ent.hitme = trace_ent.hitme + 1;
		T_Damage (trace_ent, self, self, damg);
		SpawnBlood (org, '0 0 0', 20);
		if (trace_ent.hitme == 2 || trace_ent.hitme == 5)
			self.bighit = TRUE; // finish 3 hit combo
		if (self.attack == W_PUNCH)
			sound (self, CHAN_WEAPON, "hit1.wav", 1, ATTN_NORM);
		else if (self.attack == W_KICK)
			sound (self, CHAN_WEAPON, "hit2.wav", 1, ATTN_NORM);
		else if (self.attack == W_PUNCH2 || self.attack == W_KICK2)
			sound (self, CHAN_WEAPON, "bighit.wav", 1, ATTN_NORM);
	}
	else if (trace_ent.solid == SOLID_BSP)
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};