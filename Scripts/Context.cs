using ATL;
using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

public partial class Context : Node
{
	public Thread processingThread;
	public static Context instance;
	public IEnumerable<Song> Songs;
	DirectoryLoader manager = new();
	static public SongPlayer ISongPlayer;
	public event Action<IEnumerable<Song>> SongsUpdated;
	public SimplaudioSettings Setting;

	public override void _Ready()
	{
		base._Ready();
		Setting = SaveManager.LoadSettings();
		GD.Print("keys: ", Setting.Sources.Keys);
		instance = this;
		ISongPlayer = new SongPlayer();
		AddChild(ISongPlayer);
		RichPresenceManager.instance = new();
		RichPresenceManager.instance.Setup();
	}
	public override void _Process(double delta)
	{
		base._Process(delta);
		RichPresenceManager.instance.Update();
	}


	
	

	public void LoadDirectory(String path){
		GD.Print("Loading ",path);
		Songs = manager.LoadDirectory(path);
		GD.Print("Songs loaded");
		
		// Just event stuff
		SongsUpdated(Songs);
	}
}
