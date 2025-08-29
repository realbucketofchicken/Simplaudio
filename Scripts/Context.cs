using Godot;
using System;

public partial class Context : Node
{
	
	Song[] Songs;
	AudioStreamPlayer[] StreamPlayers;
	DirectoryManager manager = new();

	

	public void LoadDirectory(String path){
		GD.Print(path);
		Songs = manager.LoadDirectory(path);
		GD.Print("got here");
		foreach (Song song in Songs){
			GD.Print("got ", song.Name);
		}

	}
}
