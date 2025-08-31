using Godot;
using System;
public partial class SongPlayer : Node{
	AudioStreamPlayer Player;

	public Action<Song> SongChanged;
	public Action<bool> SongStateUpdated;
	public void PlaySong(){
		GD.Print("PlaySong");
		Player?.Play();
		SongStateUpdated?.Invoke(false);
	}
	public void PauseSong(){
		GD.Print("PauseSong");
		if (Player == null){
			return;
		}
		Player.StreamPaused = true;
		SongStateUpdated?.Invoke(true);
	}
	public void UnpauseSong(){
		GD.Print("UnpauseSong");
		if (Player == null){
			return;
		}
		Player.StreamPaused = false;
		SongStateUpdated?.Invoke(false);
	}
	public void LoadSong(Song song){
		Player?.QueueFree();
		if (song.Directory.ToLower().EndsWith(".mp3")){
			AudioStreamMP3 stream = AudioStreamMP3.LoadFromFile(song.Directory);
			Player = new AudioStreamPlayer();
			Player.Stream = stream;
			AddChild(Player);
		}
		else if(song.Directory.ToLower().EndsWith(".wav")){
			AudioStreamWav stream = AudioStreamWav.LoadFromFile(song.Directory);
			Player = new AudioStreamPlayer();
			Player.Stream = stream;
			AddChild(Player);
		}
		else if(song.Directory.ToLower().EndsWith(".ogg")){
			AudioStreamOggVorbis stream = AudioStreamOggVorbis.LoadFromFile(song.Directory);
			Player = new AudioStreamPlayer();
			Player.Stream = stream;
			AddChild(Player);
		}
		GD.Print("Playing ", song.Directory);
		SongChanged?.Invoke(song);
		Player.Bus = "Music";
	}
	// 0 - 1 range
	public void SetPosition(float Position){
		if (Player == null || Player.Stream == null){
			return;
		}
		float length = (float)Player.Stream.GetLength();
		Player.Play(length*Position);
	}
	public float GetPosition(){
		if (Player == null || Player.Stream == null){
			return 0f;
		}
		float length = (float)Player.Stream.GetLength();
		return (float)Player.GetPlaybackPosition()/length;
	}
}
