using Godot;
using Instances;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;

public partial class Context : Node
{
	public Thread processingThread;
	public static Context instance;
	public IEnumerable<Song> Songs;
	AudioStreamPlayer[] StreamPlayers;
	DirectoryLoader manager = new();
	public event EventHandler SongsUpdated;
	public delegate void SongsUpdatedEventHandler(object sender, SongsUpdatedEventArgs e);

	public override void _Ready()
	{
		base._Ready();
		instance = this;
	}

	

	public void LoadDirectory(String path){
		GD.Print(path);
		Songs = manager.LoadDirectory(path);
		GD.Print("Songs loaded");
		SongsUpdatedEventArgs args = new();
		args.songs = Songs;
		OnSongsUpdated(args);
	}
	protected virtual void OnSongsUpdated(SongsUpdatedEventArgs e){
		SongsUpdated.Invoke(this,e);
	}

	AudioStreamPlayer Player;
	public void PlaySong(){
		GD.Print("PlaySongFromDisk");
		Player?.Play();
	}
	public void LoadSong(String Path){
		Player?.QueueFree();
		if (Path.ToLower().EndsWith(".mp3")){
			AudioStreamMP3 stream = AudioStreamMP3.LoadFromFile(Path);
			Player = new AudioStreamPlayer();
			Player.Stream = stream;
			AddChild(Player);
		}
		else if(Path.ToLower().EndsWith(".wav")){
			AudioStreamWav stream = AudioStreamWav.LoadFromFile(Path);
			Player = new AudioStreamPlayer();
			Player.Stream = stream;
			AddChild(Player);
		}
		else if(Path.ToLower().EndsWith(".ogg")){
			AudioStreamOggVorbis stream = AudioStreamOggVorbis.LoadFromFile(Path);
			Player = new AudioStreamPlayer();
			Player.Stream = stream;
			AddChild(Player);
		}
		Player.Bus = "Music";
	}
}

public class SongsUpdatedEventArgs : EventArgs
{
	public IEnumerable<Song> songs;
}
