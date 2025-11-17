using System.Collections.Generic;
using System.IO;
using System.Linq;
using System;
using Godot;
using System.Diagnostics;
using System.Collections;

public partial class SourceLoader : Node
{
	AudioStreamPlayer player;
	Song CurrentSong;

	bool ModifyingProgressbar;

	RichPresenceManager RichPresence;

	[Export] SourceManager manager;

	[ExportSubgroup("UI Elements")]
	[Export] Button playbutton;
	[Export] Button backbutton;
	[Export] Button skipbutton;
	[Export] Button loopbutton;
	[Export] HSlider progressbar;
	[Export] Label progresslabel;
	[Export] Label TitleLabel;
	[Export] Label ArtistLabel;
	[Export] Label AlbumLabel;
	[Export] TextureRect CoverArt;

	[ExportSubgroup("Resources")]
	[Export] Texture2D PausedIcon;
	[Export] Texture2D PlayingIcon;
	event Action<Song> UpdatedSong;
	int last_time;
	public override void _Ready()
	{
		base._Ready();
		playbutton.Pressed += PausePlay;
		backbutton.Pressed += PlayLast;
		skipbutton.Pressed += PlayNext;
		RichPresence = new();
		RichPresence.Setup();
		progressbar.DragStarted += StartInteractionProgressbar;
		progressbar.DragEnded += StopInteractionProgressbar;
	}

	public override void _Process(double delta)
	{
		base._Process(delta);
		if (player != null && player.Stream != null){
			if (!ModifyingProgressbar){
				progressbar.Value = player.GetPlaybackPosition()/player.Stream.GetLength();
				
			}
			else{
				if (last_time != (int)(progressbar.Value * player.Stream.GetLength())){
					player.Play((float)(progressbar.Value * player.Stream.GetLength()));
				}
				last_time = (int)(progressbar.Value * player.Stream.GetLength());
			}
			progresslabel.Text = GetTimeFormattedString((float)(progressbar.Value * player.Stream.GetLength()),(float)(player.Stream.GetLength())) + " / " + GetTimeFormattedString((float)(player.Stream.GetLength()));
		}
	}

	static String GetTimeFormattedString(float time,float maxTime = 0){
		if (maxTime == 0){
			maxTime = time;
		}
		int seconds = (int)time % 60;
		int minutes = (int)time / 60 % 60;
		int hours = (int)time / 3600 % 60;
		String SecondsString = seconds < 10 ? "0"+  seconds.ToString() :  seconds.ToString();
		String MinutesString = maxTime > 60 ? minutes.ToString() + ":" : "";
		String HoursString = maxTime > 3600 ? hours.ToString() + ":" : "";
		return HoursString + MinutesString + SecondsString;
	}

	public IEnumerable<Song> GetSongs(){
		return manager.Songs;
	}

	public int GetCurrentIndex(){
		int index = -1;
		for (int i = 0; i < manager.Songs.Length - 1;i++){
			if (CurrentSong == manager.Songs[i]){
				index = i;
				break;
			}
		}
		Debug.WriteLine("GOt: " + index.ToString());
		return index;
	}

	void PausePlay(){
		if (playbutton.ButtonPressed){
			player.StreamPaused = true;
			RichPresence.UpdateTime(progressbar.Value * player.Stream.GetLength(),player.Stream.GetLength(),true);
			playbutton.Icon = PausedIcon;
		}
		else{
			player.StreamPaused = false;
			RichPresence.UpdateTime(progressbar.Value * player.Stream.GetLength(),player.Stream.GetLength(),false);
			playbutton.Icon = PlayingIcon;
		}
	}

	void PlayNext(){
		int index = (GetCurrentIndex()+1) % manager.Songs.Length;
		ref Song newSong = ref manager.Songs[index];
		CurrentSong = newSong;
		PlaySong(ref CurrentSong);
	}
	void PlayLast(){
		int index = (GetCurrentIndex()-1) % manager.Songs.Length;
		if (index < 0){
			index += manager.Songs.Length;
		}
		ref Song newSong = ref manager.Songs[index];
		CurrentSong = newSong;
		PlaySong(ref CurrentSong);
	}

	void PlaySong(ref Song song){
		player?.QueueFree();
		player = new();
		GetTree().Root.CallDeferred("add_child",player);
		player.Stream = song.LoadSong();
		player.CallDeferred("play");
		player.Finished += SongEnded;
		RichPresence.SetPresence(song);
		playbutton.ButtonPressed = false;
		UpdatedSong?.Invoke(song);
		if (!song.LoadedMetadata){
			song.LoadMetadata();
		}
		TitleLabel.Text = song.Name;
		ArtistLabel.Text = song.Artist;
		AlbumLabel.Text = song.Album;
		ImageTexture adfj = ImageTexture.CreateFromImage(song.LoadImage());
		CoverArt.Texture = adfj;
		playbutton.Icon = PlayingIcon;
	}
	void SongEnded(){
		if (loopbutton.ButtonPressed){
			player.Play();
		}
		else{
			PlayNext();
		}
	}
	void StartInteractionProgressbar(){
		ModifyingProgressbar = true;
	}
	void StopInteractionProgressbar(bool changed){
		ModifyingProgressbar = false;
		playbutton.ButtonPressed = false;
		playbutton.Icon = PlayingIcon;
		RichPresence.UpdateTime(progressbar.Value * player.Stream.GetLength(),player.Stream.GetLength(),false);
		last_time = -1;
	}
}
