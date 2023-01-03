//+------+
//|aitest|
//+------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Scratch                                      Http://www.admdev.com/scratch |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
//| Testing out AI procedures to make the perfect enemy!!                      |
//+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+


//taken from Quake Soccer mod:
void() puck_touch =
{   if ( (other.classname == "player")  || (other.classname == "thug")     )    {
	self.goalentity=other;
	
	/*dprint ("puck owner: ");
	dprint (self.goalentity.classname);
	dprint ("\n");
	*/
	if ( (self.velocity_z < FALSE) ) {
	   self.velocity = (CONTENT_EMPTY * self.velocity);
	} 
	else {
	   if ( (self.flags & FL_ONGROUND) ) {
		  self.flags = (self.flags - FL_ONGROUND);
	   }
	   self.velocity = (self.velocity + (other.velocity * 0.250));
	   self.velocity_z = (self.velocity_z + 50.000);
	   self.enemy = other;

	}

 }

 if ( ((self.flags & FL_ONGROUND) || (self.velocity == VEC_ORIGIN)) ) {
	return ;
 }
 if ( (other.solid == SOLID_BSP) ) {
	//sound (self,CHAN_ITEM,"zombie/z_miss.wav",TRUE,ATTN_NORM);
 }



}

void() puck_think =
{

	if (self.goalentity.classname=="player"){
		dprint ("puck following owner: ");
		dprint (self.goalentity.netname);
		dprint ("\n");
	}


}

void() puck_stand =
{
		dprint ("puck stand: ");
		dprint (self.goalentity.netname);
		dprint ("\n");
}
void() puck_atta =
{
		dprint ("puck atta: ");
		dprint (self.goalentity.netname);
		dprint ("\n");
}


void() puck =
{

	local entity puck, spoint;

	puck = spawn();
	spoint = find(world, classname, "puck");
	setorigin(puck, spoint.origin);
	
	setmodel(puck, "progs/puck.mdl");
	puck.solid = SOLID_BBOX;
	puck.movetype = MOVETYPE_BOUNCE;
	puck.touch = puck_touch;
	puck.classname = "puck";
	puck.netname = "puck";
	puck.think=puck_think;
	puck.nextthink = time+0.5;
	puck.goalentity=puck;
	puck.th_stand = puck_stand;
	puck.th_melee = puck_atta;
	setsize (puck,'-16.000 -16.000 0.000',VEC_HULL_MAX);

	//puck.effects = EF_BRIGHTFIELD;

}; 



//unused    -------------------------------------------
void() kick_touch =
{
	local vector v;

	if ((other.classname != "player"))
	{
		if ((other.classname != "monster_ogre"))
		{
			if ((other.classname != "golie"))
			{
				return;
			}
		}
	}
	sound(other, CHAN_ITEM, "hockey/hitpuck.wav", AS_STRAIGHT, ATTN_NORM);
	v_x = ((other.velocity_x * AS_SLIDING) + (50 * random()));
	v_y = ((other.velocity_y * AS_SLIDING) + (50 * random()));
	v_z = ((250 + (160 * random())) + ((other.velocity_y + other.velocity_x) * 0.3));
	self.flags = (self.flags - (self.flags & FL_ONGROUND));
	self.velocity = v;
};


//taken from Quake Soccer mod
void (float strength) fire_kick = {

	local vector source;
 
	if ( (self.v_angle_x > CONTENT_SOLID) ) {
 
	   makevectors (self.angles);
	   source = (self.origin - '0.000 0.000 16.000');
 
	} else {
 
	   makevectors (self.v_angle);
	   source = (self.origin + self.view_ofs);
 
	}
	traceline (source,(source + (v_forward * FL_GODMODE)),FALSE,self);
	if ( (trace_fraction == TRUE) ) {
 
	   //sound (self,CHAN_WEAPON,"zombie/z_shot1.wav",TRUE,ATTN_NORM);
	   return ;
 
	}
	makevectors (self.v_angle);
	if ( (trace_ent.classname == "player") ) {
 
	   trace_ent.velocity = (trace_ent.velocity + (v_forward * strength));
	   if ( (trace_ent.flags & FL_ONGROUND) ) {
 
		  trace_ent.flags = (trace_ent.flags - FL_ONGROUND);
 
	   }
	  // sound (self,CHAN_WEAPON,"player/axhit1.wav",TRUE,ATTN_NORM);
 
	}
	if ( (trace_ent.classname != "puck") ) {
 
	   return ;
 
	}
	if ( (trace_ent.flags & FL_ONGROUND) ) {
 
	   trace_ent.flags = (trace_ent.flags - FL_ONGROUND);
 
	}
	local float str;
   str  = random();
 
	trace_ent.velocity_x = (trace_ent.velocity_x + (v_forward_x * strength * 5 * random() ));
	trace_ent.velocity_y = (trace_ent.velocity_y + (v_forward_y * strength));
	trace_ent.velocity_z = (trace_ent.velocity_z + strength);
	trace_ent.angles = vectoangles (trace_ent.velocity);
	trace_ent.avelocity = '100.000 100.000 100.000';  // 100 100 100
	trace_ent.enemy = self;
	//sound (trace_ent,CHAN_ITEM,"zombie/z_hit.wav",TRUE,ATTN_NORM);
 };

 //taken from Quake Soccer mod:
void() puck_touch_orig =
{   if ( (other.classname == "player") ) {

	if ( (self.velocity_z < FALSE) ) {

	   self.velocity = (CONTENT_EMPTY * self.velocity);

	} else {

	   if ( (self.flags & FL_ONGROUND) ) {

		  self.flags = (self.flags - FL_ONGROUND);

	   }
	   self.velocity = (self.velocity + (other.velocity * 0.250));
	   self.velocity_z = (self.velocity_z + 50.000);
	   self.enemy = other;

	}

 }

 if ( ((self.flags & FL_ONGROUND) || (self.velocity == VEC_ORIGIN)) ) {

	return ;

 }
 if ( (other.solid == SOLID_BSP) ) {
	//sound (self,CHAN_ITEM,"zombie/z_miss.wav",TRUE,ATTN_NORM);
 }
}