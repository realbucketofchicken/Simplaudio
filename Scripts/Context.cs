using Godot;
using System;

public partial class Context : Node
{
	
	String[] Songs;
	DirectoryManager manager = new();

	 

	public void LoadDirectory(String path){
		GD.Print(path);
		manager.LoadDirectory(path);
	}
}
