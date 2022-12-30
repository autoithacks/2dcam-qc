//+------+
//|player|
//+------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| The players animation and behavior is in this file.                        |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

$frame base1
$frame stand1
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11 walk12
$frame jump1 jump2 jump3 jump4
$frame jumpkick1
$frame puncha1 puncha2 puncha3
$frame punchb1 punchb2 punchb3 punchb4 punchb5
$frame kicka1 kicka2 kicka3 kicka4 kicka5
$frame kickb1 kickb2 kickb3 kickb4 kickb5 kickb6 kickb7
$frame pain1 pain2 pain3 pain4 pain5 pain6
$frame fly1 fly2 fly3 fly4
$frame getup1 getup2 getup3
$frame grab1 grab2
$frame grabbed1
$frame grabbedpain1
$frame grabpunch1 grabpunch2 grabpunch3
$frame grabknee1 grabknee2 grabknee3
$frame grabkick1 grabkick2 grabkick3 grabkick4
$frame grabcombo1 grabcombo2 grabcombo3 grabcombo4 grabcombo5 grabcombo6 grabcombo7 grabcombo8 grabcombo9
$frame bigpickup1 bigpickup2 bigpickup3
$frame bigthrow1 bigthrow2

void() player_spawn = {};
void() player_move;
void(float dmg, float dist) FireMelee;
void() player_grab2;
void() player_pain;
void() player_fly2;
void() player_fly3;
void() player_grabbedpain1;
void() player_grabcheck; // only grab when moving

void() Setup_Dummy =
{
	local entity dummy, spoint;

	dummy = spawn();
	spoint = find(world, classname, "player_spawn");

	setorigin(dummy, spoint.origin);
	setmodel(dummy, "progs/playr.mdl");
	setsize(dummy, VEC_HULL_MIN, VEC_HULL_MAX);
	dummy.solid = SOLID_SLIDEBOX;
	dummy.takedamage = DAMAGE_AIM;
	dummy.owner = self;
	dummy.classname = "player";
	dummy.netname = "player";
	dummy.speed = 120;
	dummy.health = 100;
	dummy.movetype = MOVETYPE_STEP;
	dummy.angles = '0 180 0';
	dummy.colormap = self.colormap; // set colors to the owners
	self.char = dummy;
	dummy.think = player_move;
	dummy.nextthink = time;
	dummy.ch_pain = player_pain;
	droptofloor();	
};

void() player_think =
{
	if (!self.char.flypain)
		player_attacks();

	if (self.char.flags & FL_ONGROUND)
	{	
		self.char.flags = self.char.flags - FL_ONGROUND;
		if (self.keyflags & (KEY_LEFT | KEY_RIGHT) && self.lock_finished < time && self.pain_finished < time && !self.char.flypain)
		{
			if (self.keyflags & KEY_RIGHT)
			{
				self.char.velocity_x = 0 - (self.char.speed);
				self.char.angles_y = 180;
			}
			else
			{
				self.char.velocity_x = self.char.speed;
				self.char.angles_y = 0;
			}
		}
		else
			self.char.velocity_x = 0;

		if (self.keyflags & (KEY_UP | KEY_DOWN) && self.lock_finished < time && self.pain_finished < time && !self.char.flypain)
		{
			if (self.keyflags & KEY_UP)
				self.char.velocity_y = 0 - (self.char.speed);
			else
				self.char.velocity_y = self.char.speed;
		}
		else
			self.char.velocity_y = 0;
	}
};

void() player_jumpframe;
void() player_move = [0 , player_move]
{
	if (self.velocity_x || self.velocity_y)
	{
		if (self.walkframe > 11)
			self.walkframe = 0;
		self.frame = $walk1 + self.walkframe;
		player_grabcheck();
	}
	else
		self.frame = $stand1;
	self.walkframe = self.walkframe + 1;

	if (!(self.flags & FL_ONGROUND))
		player_jumpframe();

	self.takedamage = DAMAGE_AIM;
	self.hitme = 0;
	self.touch = SUB_Null;
	self.owner.pain_finished = time;
	self.flypain = FALSE;
};

void() player_puncha1	=[	$puncha1,	player_puncha2	] {};
void() player_puncha2	=[	$puncha2,	player_puncha3	] 
{FireMelee(1, 40);};
void() player_puncha3	=[	$puncha3,	player_move	] {};

void() player_punchb1	=[	$punchb1,	player_punchb2	] {};
void() player_punchb2	=[	$punchb2,	player_punchb3	] 
{FireMelee(1, 40);};
void() player_punchb3	=[	$punchb3,	player_punchb4	] {};
void() player_punchb4	=[	$punchb4,	player_punchb5	] {};
void() player_punchb5	=[	$punchb5,	player_move 	] {};

void() player_kicka1	=[	$kicka1,	player_kicka2	] {};
void() player_kicka2	=[	$kicka2,	player_kicka3	] {};
void() player_kicka3	=[	$kicka3,	player_kicka4	] 
{FireMelee(1, 45);};
void() player_kicka4	=[	$kicka4,	player_kicka5	] {};
void() player_kicka5	=[	$kicka5,	player_move	] {};

void() player_kickb1	=[	$kickb1,	player_kickb2	] {};
void() player_kickb2	=[	$kickb2,	player_kickb3	] {};
void() player_kickb3	=[	$kickb3,	player_kickb4	] {};
void() player_kickb4	=[	$kickb4,	player_kickb5	] {};
void() player_kickb5	=[	$kickb5,	player_kickb6	]
{FireMelee(1, 45);};
void() player_kickb6	=[	$kickb6,	player_kickb7	] {};
void() player_kickb7	=[	$kickb7,	player_move	] {};

void() player_grabpunch1	=[	$grabpunch1,	player_grabpunch2	] {};
void() player_grabpunch2	=[	$grabpunch2,	player_grabpunch3	] {};
void() player_grabpunch3	=[	$grabpunch3,	player_grab2	] 
{
	self.grabhit = self.grabhit + 1; // count hits
	FireMelee(1, 40);
};

void() player_grabknee1	=[	$grabknee1,	player_grabknee2	] {};
void() player_grabknee2	=[	$grabknee2,	player_grabknee3	] 
{
	self.grabhit = self.grabhit + 1; // count hits
	FireMelee(1, 40);
};
void() player_grabknee3	=[	$grabknee3,	player_grab2	] {};

void() player_grabkick1	=[	$grabkick1,	player_grabkick2	] {};
void() player_grabkick2	=[	$grabkick2,	player_grabkick3	] 
{
	self.grabhit = self.grabhit + 1; // count hits
	FireMelee(1, 40);
};
void() player_grabkick3	=[	$grabkick3,	player_grabkick4	] 
{sound (self, CHAN_WEAPON, "crunch.wav", 1, ATTN_NORM);};
void() player_grabkick4	=[	$grabkick3,	player_grab2	] {};

void() player_grabcombo1	=[	$grabcombo1,	player_grabcombo2	] {};
void() player_grabcombo2	=[	$grabcombo2,	player_grabcombo3	] {};
void() player_grabcombo3	=[	$grabcombo3,	player_grabcombo4	] 
{
	self.attack = W_COMBO1;
	FireMelee(1, 40);
	self.grabhit = self.grabhit + 1; // count hits
};
void() player_grabcombo4	=[	$grabcombo4,	player_grabcombo5	] {};
void() player_grabcombo5	=[	$grabcombo5,	player_grabcombo6	] {};
void() player_grabcombo6	=[	$grabcombo6,	player_grabcombo7	] 
{self.nextthink = time + 0.5;};
void() player_grabcombo7	=[	$grabcombo7,	player_grabcombo8	] 
{
	self.grabhit = self.grabhit + 1; // count hits
	self.attack = W_PUNCH2;
	FireMelee(1, 40);
	self.nextthink = time + 0.5;
};
void() player_grabcombo8	=[	$grabcombo8,	player_grabcombo9	] {};
void() player_grabcombo9	=[	$grabcombo9,	player_grab2	] {};

void() player_jumpframe =
{
	if (self.velocity_z <  400) self.frame = $jump1;
	if (self.velocity_z <  180) self.frame = $jump2;
	if (self.velocity_z <  100) self.frame = $jump3;
	if (self.velocity_z <   20) self.frame = $jump4;
};

void() player_jump1 = [$jump1,	player_jump1 ]
{
	self.touch = SUB_Null;
	player_jumpframe();
	if (self.flags & FL_ONGROUND) player_move();
};

void() player_jumpkick1 = [$jumpkick1,	player_jumpkick1 ] 
{
	local vector org;
	local entity head;

	org = self.origin;
	MakeSolidList();
	head = findradius(self.origin, 50);
	while (head)
	{
		if (head.takedamage && head != self)
		{
			if (head.ch_pain)
			{
				head.hitme = 3;
				player_jump1();
				self.attack = W_KICK;
				sound (self, CHAN_WEAPON, "hit2.wav", 1, ATTN_NORM);
				T_Damage (head, self, self, 1);
				spawn_touchblood (20);
			}
		}
		head = head.chain;  // cycle to next head (entity)
	}
	UnmakeSolidList();

	if (self.flags & FL_ONGROUND || self.owner.attack_finished < time) // finish
		player_jump1();
};

void() player_attacks =
{
	if (self.attack_finished > time)
		return;
	if (self.pain_finished > time)
		return;

	if (self.button0)
	{
		if (self.char.grab == FALSE)
		{
			if (!(self.char.flags & FL_ONGROUND))
				return;

			if (self.char.bighit == TRUE)
			{
				self.char.attack = W_PUNCH2;
				self.char.think = player_punchb1;
				self.char.bighit = FALSE;
			}
			else
			{
				self.char.think = player_puncha1;
				self.char.attack = W_PUNCH;
			}

			self.attack_finished = time + 0.5;
			self.lock_finished = time + 0.5;
		}
		else
		{
			if (self.char.bighit == FALSE)
			{
				self.char.attack = W_PUNCH;
				self.char.think = player_grabpunch1;
				self.attack_finished = time + 0.4;
				self.lock_finished = time + 0.4;
			}
			else
			{
				self.char.think = player_grabcombo1;
				self.attack_finished = time + 1.8;
				self.lock_finished = time + 1.8;
			}
		}
	}
	if (self.button2)
	{
		if (self.char.flags & FL_ONGROUND)
		{
			if (self.char.grab == FALSE)
			{
				if (self.char.bighit == TRUE)
				{
					self.char.attack = W_KICK2;
					self.char.think = player_kickb1;
					self.attack_finished = time + 0.9;
					self.lock_finished = time + 0.9;
					self.char.bighit = FALSE;
				}
				else
				{
					self.char.attack = W_KICK;
					self.char.think = player_kicka1;
					self.attack_finished = time + 0.7;
					self.lock_finished = time + 0.7;
				}
			}
			else
			{
				if (self.char.bighit == TRUE)
				{
					self.char.think = player_grabkick1;
					self.attack_finished = time + 0.5;
					self.lock_finished = time + 0.5;
					self.char.bighit = FALSE;
				}
				else
				{
					self.char.attack = W_KICK;
					self.char.think = player_grabknee1;
					self.attack_finished = time + 0.5;
					self.lock_finished = time + 0.5;
				}
			}
		}
		else
		{
				self.char.think = player_jumpkick1;
				self.attack_finished = time + 0.5;
				self.lock_finished = time + 0.5;
		}		
	}
};

void() player_grab1	=[	$grab1,	player_grab2	] 
{self.owner.lock_finished = time + 0.2;};
void() player_grab2	=[	$grab2,	player_grab2	] 
{
	self.owner.lock_finished = time + 0.2;
	if (self.grabhit > 2)
	{
		player_move();
		self.grab = FALSE;
		self.grabhit = 0;
		self.bighit = FALSE;
	}
};

//called from movement frames
void() player_grabcheck =
{
	local	vector source, org, v;
	local entity oldself, newself;

	if (!self.flags & FL_ONGROUND)
		return;

	MakeSolidList();
	source = self.origin + '0 0 16';
	makevectors(self.angles);
	traceline (source, source + v_forward * 25, FALSE, self);
	if (trace_fraction == 1.0) return;
	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage && trace_ent.hitme > 1)
	{
		self.bighit = FALSE; // stop finish hit on grab
		oldself = self;
		self = trace_ent;

		if (self.ch_grabbed)
		{
			if (oldself.angles_y != self.angles_y && self.flags & FL_ONGROUND && self.origin_z == oldself.origin_z)
			{
				setorigin (self, oldself.origin + v_forward * 45);
				self.ch_grabbed();
				self.hitme = 3; // set to grabbed hits
				oldself.grab = TRUE;
				oldself.think = player_grab1;
			}
		}
		self = oldself;
	}
};

void() player_paina1	=[	$pain1,	player_paina2	] {};
void() player_paina2	=[	$pain2,	player_paina2	]
{
	if (self.owner.pain_finished < time)
		player_move();
};

void() player_painb1	=[	$pain3,	player_painb2	] 
{
	self.nextthink = time + 0.2;
	if (self.owner.pain_finished < time)
		player_move();
};
void() player_painb2	=[	$pain4,	player_painb3	] 
{self.nextthink = time + 0.2;};
void() player_painb3	=[	$pain5,	player_painb4	]
{self.nextthink = time + 0.2;};
void() player_painb4	=[	$pain6,	player_painb1	] 
{self.nextthink = time + 0.2;};


void() player_fly1	=[	$fly1,	player_fly1	] 
{
	self.owner.pain_finished = time + 99;
	self.takedamage = DAMAGE_NO;
	if (self.flags & FL_ONGROUND)
	{
		sound (self, CHAN_BODY, "hitground.wav", 1, ATTN_NORM);
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + 9 * v_forward * 7;
		self.velocity = self.velocity + 50 * '0 0 3';
		player_fly2();
	}
};

void() player_fly2	=[	$fly2,	player_fly2	]
{
	if (self.flags & FL_ONGROUND)
		player_fly3();
};

void() player_fly3	=[	$fly3,	player_fly4	] 
{
	sound (self, CHAN_BODY, "hitground.wav", 1, ATTN_NORM);
};
void() player_fly4	=[	$fly3,	player_getup1	] {self.nextthink = time + 0.5;};

void() player_getup1	=[	$getup1,	player_getup2	] {};
void() player_getup2	=[	$getup2,	player_getup3	] {};
void() player_getup3	=[	$getup3,	player_move	] 
{};

void() player_grabbed	=[	$grabbed1,	player_grabbed	] {};
void() player_grabbedpain1	=[	$grabbedpain1,	player_grabbed	] {};

void() player_pain =
{
	//check the hitme counter and set the pain
	if (self.hitme == 1)
	{
		self.owner.pain_finished = time + 0.8;
		player_paina1();
	}
	if (self.hitme == 2)
	{
		self.owner.pain_finished = time + 0.8;
		player_painb1();
	}
	// 4-6 is reserved for grabbed hits
	if (self.hitme > 3 && self.hitme < 6)
	{
		self.owner.pain_finished = time + 0.5;
		player_grabbedpain1();
	}
	if (self.hitme == 3 || self.hitme == 6) // flying hurt
	{
		self.flypain = TRUE;
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + 9 * v_forward * 7;
		self.velocity = self.velocity + 90 * '0 0 3';
		player_fly1();
	}
};