//+------+
//|aitest|
//+------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Testing out AI procedures to make the perfect enemy!!                      |
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

void() thug_stand1;
void() thug_walk1;
void() thug_pain;
void() thug_paina1;
void() thug_painb1;
void() thug_fly1;
void() thug_fly2;
void() thug_fly3;
void() thug_flyup1;
void() thug_grabbed;
void() thug_grabbedpain1;
void() thug_meleethink;
void() JumpKickCheck;

void() enemy_thug =
{
	setmodel(self, "progs/playr.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.th_stand = thug_stand1;
	self.ch_pain = thug_pain;
	self.ch_grabbed = thug_grabbed;
	self.th_walk = thug_walk1;
	self.skin = 1;
	self.touch = SUB_Null;
	self.ai_melee = thug_meleethink;
	self.ai_jumpkick = JumpKickCheck;
	self.health = 10;

	droptofloor();
	enemy_start();
};

void() thug_pain =
{
	//check the hitme counter and set the pain
	if (self.hitme == 1)
	{
		self.pain_finished = time + 1;
		thug_paina1();
	}
	if (self.hitme == 2)
	{
		self.pain_finished = time + 1;
		thug_painb1();
	}
	// 4-6 is reserved for grabbed hits
	if (self.hitme > 3 && self.hitme < 6)
	{
		self.pain_finished = time + 0.5;
		thug_grabbedpain1();
	}
	if (self.hitme == 3 || self.hitme == 6) // flying hurt
	{
		self.hitme = 0;
		self.movetype = MOVETYPE_TOSS;
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + 12 * v_forward * 7;
		self.velocity = self.velocity + 90 * '0 0 3';
		thug_fly1();
	}
	if (self.hitme == 7) // flying straight up on punch grab combo
	{
		self.hitme = 2; // fly after next hit
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity_z = self.velocity_z + 350;
		thug_flyup1();
	}


	//moi death
	self.health -=1;

	if(self.health <=0){
		remove(self);

	}

};

void() thug_stand1	=[	$stand1,	thug_stand1	] 
{
		self.velocity = '0 0 0';
		self.touch = SUB_Null;
		ai_stand();
		self.hitme = 0;
		self.takedamage = DAMAGE_AIM;
		self.movetype = MOVETYPE_STEP;
};

void() thug_walk1	=[	$walk1,	thug_walk2	] {ai_walk(4);};
void() thug_walk2	=[	$walk2,	thug_walk3	] {ai_walk(4);};
void() thug_walk3	=[	$walk3,	thug_walk4	] {ai_walk(4);};
void() thug_walk4	=[	$walk4,	thug_walk5	] {ai_walk(4);};
void() thug_walk5	=[	$walk5,	thug_walk6	] {ai_walk(4);};
void() thug_walk6	=[	$walk6,	thug_walk7	] {ai_walk(4);};
void() thug_walk7	=[	$walk7,	thug_walk8	] {ai_walk(4);};
void() thug_walk8	=[	$walk8,	thug_walk9	] {ai_walk(4);};
void() thug_walk9	=[	$walk9,	thug_walk10	] {ai_walk(4);};
void() thug_walk10	=[	$walk10,	thug_walk11	] {ai_walk(4);};
void() thug_walk11	=[	$walk11,	thug_walk12	] {ai_walk(4);};
void() thug_walk12	=[	$walk12,	thug_walk1	] {ai_walk(4);};

void() thug_paina1	=[	$pain1,	thug_paina2	] {};
void() thug_paina2	=[	$pain2,	thug_paina2	]
{
	if (self.pain_finished < time)
		thug_stand1();
};

void() thug_painb1	=[	$pain3,	thug_painb2	] 
{
	self.nextthink = time + 0.2;
	if (self.pain_finished < time)
		thug_stand1();
};
void() thug_painb2	=[	$pain4,	thug_painb3	] 
{self.nextthink = time + 0.2;};
void() thug_painb3	=[	$pain5,	thug_painb4	]
{self.nextthink = time + 0.2;};
void() thug_painb4	=[	$pain6,	thug_painb1	] 
{self.nextthink = time + 0.2;};


void() thug_fly1	=[	$fly1,	thug_fly1	] 
{
	self.takedamage = DAMAGE_NO;
	if (self.flags & FL_ONGROUND)
	{
		sound (self, CHAN_BODY, "hitground.wav", 1, ATTN_NORM);
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + 9 * v_forward * 7;
		self.velocity = self.velocity + 50 * '0 0 3';
		thug_fly2();
	}
};

void() thug_fly2	=[	$fly2,	thug_fly2	]
{
	if (self.flags & FL_ONGROUND)
		thug_fly3();
};

void() thug_fly3	=[	$fly3,	thug_fly4	] 
{
	sound (self, CHAN_BODY, "hitground.wav", 1, ATTN_NORM);
};
void() thug_fly4	=[	$fly3,	thug_getup1	] {self.nextthink = time + 0.5;};

void() thug_flyup1	=[	$fly4,	thug_flyup1	] 
{
	if (self.flags & FL_ONGROUND)
		thug_fly3();
};

void() thug_getup1	=[	$getup1,	thug_getup2	] {};
void() thug_getup2	=[	$getup2,	thug_getup3	] {};
void() thug_getup3	=[	$getup3,	thug_stand1	] {};

void() thug_grabbed	=[	$grabbed1,	thug_grabbed	] {};
void() thug_grabbedpain1	=[	$grabbedpain1,	thug_grabbed	] {};

void() thug_puncha1	=[	$puncha1,	thug_puncha2	] {};
void() thug_puncha2	=[	$puncha2,	thug_puncha3	]
{
	self.attack = W_PUNCH;
	FireMelee(1, 40);
};
void() thug_puncha3	=[	$puncha3,	thug_stand1	] {};

void() thug_jumpkick1 = [$jump1,	thug_jumpkick2 ] 
{
	self.hitme = 2; // can be knocked out of air
};
void() thug_jumpkick2 = [$jump2,	thug_jumpkick3 ] {};
void() thug_jumpkick3 = [$jump3,	thug_jumpkick4 ] {};

void() thug_jumpkick4 = [$jumpkick1,	thug_jumpkick4 ] 
{
	self.touch = jumpkick_touch;
	if (self.flags & FL_ONGROUND) // finish
	{
		thug_stand1();
		self.velocity = '0 0 0';
	}
};

void() JumpKickCheck =
{
	local float r;
	r = random();

	if (r > 0.20)
		return;
	if (!self.flags & FL_ONGROUND)
		return;

	if (checkbottom(self))
	{
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + 10 * v_forward * 12;
		self.velocity = self.velocity + 60 * '0 0 5';
		thug_jumpkick1();
	}
};

void() thug_kicka1	=[	$kicka1,	thug_kicka2	] {};
void() thug_kicka2	=[	$kicka2,	thug_kicka3	] {};
void() thug_kicka3	=[	$kicka3,	thug_kicka4	] 
{
	self.attack = W_KICK;
	FireMelee(1, 45);
};
void() thug_kicka4	=[	$kicka4,	thug_kicka5	] {};
void() thug_kicka5	=[	$kicka5,	thug_stand1	] {};

void() thug_meleethink =
{
	local float r;
	r = random();
	if (r < 0.50)
		thug_puncha1();
	else
		thug_kicka1();
};

