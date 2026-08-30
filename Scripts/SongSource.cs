using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using ATL;
using Godot;

public partial class SongSource : Node{
	public String TryGetSongUrl(String path){
		Track theTrack = new(path);
		if (theTrack.AdditionalFields.TryGetValue("comment", out string value)){
			return value;
		}
		return "";
	}
}
