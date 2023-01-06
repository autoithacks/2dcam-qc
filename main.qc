//+----+
//|Main|
//+----+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Contains some 'base' subroutines. As a general rule nothing in this file   |
//| does much, except to setup basic variables and entities.                   |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+

void() main = {};
void() worldspawn = 
{
	//Forced Normal Quake precaches
	precache_model("progs/null.spr");
	precache_model("progs/s_explod.spr");
	precache_model("progs/player.mdl");
	precache_model("progs/missile.mdl");
	precache_model("progs/s_bubble.spr");	

	//moi puck from hockey mod
	precache_model("progs/puck.mdl");	

	precache_sound("demon/dland2.wav");
	precache_sound("weapons/sgun1.wav");
	//Forced Normal Quake precaches

	precache_model("progs/playr.mdl");
	precache_sound("hit1.wav");
	precache_sound("hit2.wav");
	precache_sound("bighit.wav");
	precache_sound("hitground.wav");
	precache_sound("crunch.wav");
};

void() SetNewParms = {};
void() SetChangeParms = {};

float framecount;
void() StartFrame = {};

// A list of entities that need to be made solid for gameplay purposes - Ugly hack
// but no other way around it.
void() MakeSolidList =
{
	local entity y;

	y = find(world, netname, "solid");
	while (y)
	{
		if(y.classname=="puck") continue;
		y.solid = SOLID_SLIDEBOX;
		setorigin(y, y.origin);
		y = find(y, netname, "solid");
	}
	y = find(world, netname, "solid");

};

void() UnmakeSolidList =
{
	local entity y;

	y = find(world, netname, "solid");
	while (y)
	{
		
		if(y.classname=="puck") continue;
		y.solid = SOLID_TRIGGER;
		setorigin(y, y.origin);
		y = find(y, netname, "solid");
	}
	y = find(world, netname, "solid");

};