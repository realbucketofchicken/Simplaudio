using Godot;
using System;
using System.Diagnostics;
using TagLib;

public partial class Test : Node
{
	public override void _Ready()
	{
		base._Ready();
		DirectoryManager manager = new();
		manager.LoadDirectory("/run/media/bucket/Old Linux Drive/MainExternalBackup/Music/");
	}
}
