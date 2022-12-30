entity	sight_entity;
float	sight_entity_time;
.float		show_hostile;	// set to time+0.2 whenever a client fires a
							// weapon or takes damage.  Used to alert
							// monsters that otherwise would let the player go
float	movedist;
.float backtime;

/*
=============
infront

returns 1 if the entity is in front (in sight) of self
=============
*/
float(entity targ) infront =
{
	local vector	vec;
	local float		dot;
	
	makevectors (self.angles);
	vec = normalize (targ.origin - self.origin);
	dot = vec * v_forward;
	
	if ( dot > 0.9)
	{
		return TRUE;
	}
	return FALSE;
};

/*
=============
range

returns the range catagorization of an entity reletive to self
0	melee range, will become hostile even if back is turned
1	visibility and infront, or visibility and show hostile
2	infront and show hostile
3	only triggered by damage
=============
*/

float(entity targ) range =
{
	local vector	spot1, spot2;
	local float		r;

	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	
	r = vlen (spot1 - spot2);
	if (r < 40)
		return RANGE_CLOSE;
	if (r < 60)
		return RANGE_MELEE;
	if (r < 120 && r > 100)
		return RANGE_NEAR;
	if (r < 1000)
		return RANGE_MID;
	return RANGE_FAR;
};

/*
=============
visible

returns 1 if the entity is visible to self, even if not infront ()
=============
*/
float (entity targ) visible =
{
	local vector	spot1, spot2;
	
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline (spot1, spot2, TRUE, self);	// see through other monsters
	
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};

void() HuntTarget =
{
	self.goalentity = self.enemy;
	self.think = self.th_walk;
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	self.nextthink = time + 0.1;
};

/*
===========
FindTarget

Self is currently not attacking anything, so try to find a target
============
*/

void() FindTarget =
{
	local entity	player;
	local float		r;

	player = find(world, classname, "player");

	while (player)
	{
		if (!self.enemy)
		{
			r = range (player);
			if (r < 500 && visible (player))
				self.enemy = player;
		}
		player = find(player, classname, "player");
	}
};

/*
=============
ai_stand - waiting for player
=============
*/

void() ai_stand =
{
	if (!self.enemy)
		FindTarget();
	else
		HuntTarget();
};

void() CombatThink =
{
	local float r;

	if (self.enemy.owner.attack_finished > time) // no cheap shots
		return;
	if (self.enemy.grab == TRUE) // can't attack if player is grabbing enemy
		return;

	r = range (self.enemy);
	if (infront(self.enemy))
	{
		if (r == RANGE_MELEE)
		{
			if (self.ai_melee)
				self.ai_melee();
		}
		else if (r == RANGE_NEAR)
		{
			if (self.ai_jumpkick)
				self.ai_jumpkick();
		}
//		else if (r == RANGE_MID)
//			bprint ("AI: Projectile Attack\n");
	}
};

/*
=============
ai_walk - the monster is walking it's beat
=============
*/
void(float dist) ai_walk =
{
	local float r;
	r = range(self.enemy);

	if (self.origin_x < self.enemy.origin_x)
		self.angles_y = 0;
	else
		self.angles_y = 180;

	if (r >= RANGE_MELEE)
		CombatThink();

	if (self.enemy.grab == TRUE && r <= RANGE_MELEE)
		self.backtime = time + 0.6;

	// Sequences for the AI to wait giving the player a chance
	if (self.enemy.flypain || self.enemy.grab == TRUE && r > RANGE_MELEE)
		self.th_stand();
	else
	{
		 if (self.backtime > time)
			dist = dist * -1;

		if (r == RANGE_CLOSE)
			self.backtime = time + 1 * random()+3; // back away .. too close to the player
		else
			movedist = dist;

		movetogoal (dist);
	}
};

void() enemy_start =
{
	total_monsters = total_monsters + 1;
	self.origin_z = self.origin_z + 1;	// raise off floor by 1 unit
	droptofloor();
	
	if (!walkmove(0,0))
	{
		dprint ("walkmonster in wall at: ");
		dprint (vtos(self.origin));
		dprint ("\n");
	}

	self.classname = "enemy";
	self.netname = "solid"; // this netname allows to become solid
	self.movetype = MOVETYPE_STEP;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT; // monsters aren't solid till told to
	self.flags = self.flags | FL_MONSTER;
	self.th_stand();
};