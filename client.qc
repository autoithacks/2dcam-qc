//+------+
//|Client|
//+------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Handle's "clients" (eg, Players) connecting, disconnecting, etc.           |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

void() CheckImpulses;        // From Misc/Impulses.QC
void() player_think;

void() ClientKill = {};
void() ClientConnect = {};

void() ClientDisconnect =
{
	if (self.lock_view)
		remove(self.lock_view);
	if (self.char)
		remove(self.char);
};

float KEY_UP = 1;
float KEY_DOWN = 2;
float KEY_LEFT = 4;
float KEY_RIGHT = 8;

float(float v) anglemod =
{
	return v - floor(v/360) * 360;
};

float (float y1, float y2) angcomp = 
{
	local float answer;
	
	y1 = anglemod(y1);
	y2 = anglemod(y2);

	answer = y1 - y2;
	if (answer > 180)
		answer = answer - 360;
	else if (answer < -180)
		answer = answer + 360;
	return answer;
};

void() PlayerPreThink = 
{
	local vector view, ot;
	local float dif;

	self.flags = FL_CLIENT;
	if (self.spawntime)
	{
		if (time > self.spawntime)
		{
			msg_entity = self;
			WriteByte(MSG_ONE, 5);
			WriteEntity(MSG_ONE, self.lock_view);
			stuffcmd(self, "scr_centertime 900000; sensitivity 0; crosshair 0\n");
			self.spawntime = 0;
		}
	}

      // make sure the char is inside the view of the camera, 
	// if it isn't, move it - simple fov
	if (self.char)
	{
		view = vectoangles(self.char.origin - self.origin);
		
		ot = normalize(self.char.origin - self.origin);
		ot = ot * 3000 * frametime; // the speed
		dif = angcomp(view_y, self.v_angle_y);

		if (fabs(dif) > 0.1) // 20 is the fov
		{
			dif = angcomp(view_x * -1, self.v_angle_x);
			view = self.lock_view.origin;
			view_x = ot_x + view_x;
		}
		else	
		{
			dif = angcomp(view_x * -1, self.v_angle_x);
			view = self.lock_view.origin;
		}
		if (fabs(dif) > 0.1)	
			view_z = ot_z + view_z;	
		setorigin(self, view);
		setorigin(self.lock_view, view);
	}
	self.test_org = self.origin;
};

void() player_attacks;
void() player_pain;
void() PlayerPostThink =
{
	// Fix me, continual messages cram client
	// cuase lag/fixme/ we only need this maybe once or twice during
	// game
	local vector tree;

	// FrikaC: keyflag control system begin
	if (self.origin != self.test_org)
	{
		self.keyflags = 0;
		if (self.test_org_z < self.origin_z)
			self.keyflags = self.keyflags | KEY_UP;
		else if (self.test_org_z > self.origin_z)
			self.keyflags = self.keyflags | KEY_DOWN;
		tree = self.test_org - self.origin;
		if (tree_x || tree_y)
		{
			tree = vectoangles(tree);
			if (angcomp(tree_y, self.v_angle_y) > 80)
				self.keyflags = self.keyflags | KEY_RIGHT;
			else if (angcomp(tree_y, self.v_angle_y) < -80)
				self.keyflags = self.keyflags | KEY_LEFT;
		}
	}
	else
		self.keyflags = 0;


	// now do the movement
	// read keyflags and move appropriately
	if (self.char != world)
	{
		UnmakeSolidList(); // called each frame
		CheckImpulses();
		player_think(); // player.qc

		setorigin(self, self.test_org);
		self.velocity = '0 0 0';
		self.health = self.char.health; // dummys health to show on status bar
		if (self.v_angle != self.lock_view.angles)
		{
			self.angles = self.lock_view.angles;
			self.fixangle = TRUE;
		}
	}

};

//----
// Spawning the Player
//----

void() Setup_Dummy;
void() PutClientInServer =
{
	local entity spawn_spot;
	spawn_spot = find (world, classname, "info_player_start");

	self.classname = "camera";
	self.health = self.max_health = 100;
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NOCLIP; 
	if (!self.lock_view)
		self.lock_view = spawn(); // used to remove jitters
	self.flags = FL_CLIENT;
	self.origin = spawn_spot.origin;
	setorigin(self.lock_view, spawn_spot.origin);
	setmodel(self.lock_view, "progs/null.spr");
	self.lock_view.angles = '0 -90 0'; 
	self.angles = '0 -90 0';
	self.fixangle = TRUE;
	setmodel (self, "progs/null.spr");
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.view_ofs = '0 0 22';
	self.velocity = '0 0 0';
	self.modelindex = 0;
	self.spawntime = time + 0.1;
	Setup_Dummy();
};