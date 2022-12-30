/*
+--------+
|Impulses|
+--------+-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Scratch                                      Http://www.admdev.com/scratch |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
| Handle and execute "Impulse" commands - as entered from console.           |
+=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-+
*/      

void() CheckImpulses =
{
	if (self.impulse == 1)
	{
		if (self.char.flags & FL_ONGROUND && self.lock_finished < time && self.pain_finished < time)
			self.char.velocity_z = 375;
	}
	self.impulse = 0;
};


