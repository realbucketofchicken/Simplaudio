using System;
using Godot;
using Godot.Collections;

[GlobalClass][Tool]
public partial class SimplaudioSettings : Resource{
	[Export] public bool Shuffled { get; set; }
	[Export] public Dictionary<String,bool> Sources { get; set; }

	public SimplaudioSettings(){
		Sources = new Dictionary<String, bool>();
	}
}
