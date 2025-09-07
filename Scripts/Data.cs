using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Godot;

using ATL.AudioData;
using ATL;
using System.Net.Http;


public class Song{
	public String Name = "";
	public bool LoadedMetadata;
	public String Artist = "";
	public String Album = "";
	public double Length;
	public String Comment = "";
	public String URL = "";
	public String Directory = "";
	public void LoadMetadata(){
		if (Directory == ""){
			return;
		}
		Track theTrack = new(Directory);
		if (theTrack.AdditionalFields.TryGetValue("comment", out string value)){
			URL = value;
		}
		Album = theTrack.Album;
		Artist = theTrack.Artist;
		Name = String.IsNullOrEmpty(theTrack.Title) ?  Name : theTrack.Title;
		Length = theTrack.Duration;
		Comment = theTrack.Comment;
	}
	public AudioStream LoadSong(){
		AudioStream Stream = new();
		if (Directory.ToLower().EndsWith(".mp3")){
			AudioStreamMP3 stream = AudioStreamMP3.LoadFromFile(Directory);
			Stream = stream;
		}
		else if(Directory.ToLower().EndsWith(".wav")){
			AudioStreamWav stream = AudioStreamWav.LoadFromFile(Directory);
			Stream = stream;
		}
		else if(Directory.ToLower().EndsWith(".ogg")){
			AudioStreamOggVorbis stream = AudioStreamOggVorbis.LoadFromFile(Directory);
			Stream = stream;
		}
		Length = Stream.GetLength();
		return Stream;
	}
	public Image LoadImage(){
		var TLfile = TagLib.File.Create(Directory);
		if (TLfile.Tag.Pictures.Length == 0){
			return null;
		}
		String type = TLfile.Tag.Pictures[0].MimeType;
		byte[] pictureData = TLfile.Tag.Pictures[0].Data.Data;
		Image image = new Image();
		Error error = Error.Failed;
		switch (type)
		{
			case "image/jpeg":
				error = image.LoadJpgFromBuffer(pictureData);
				break;
			case "image/png":
				error = image.LoadPngFromBuffer(pictureData);
				break;
			case "image/webp":
				error = image.LoadWebpFromBuffer(pictureData);
				break;
		}
		GD.Print(image);
		return image;
	}
}
public class DirectoryLoader{
	Task LoadTask;
	IEnumerable<Song> LoadedSongs;
	public IEnumerable<Song> LoadDirectory(String Path){

		
		GD.Print("Finished");
		return ParseDirectory(Path);
		//if (file.EndsWith(".mp3"))
	}
	private IEnumerable<Song> ParseDirectory(String Path){
		System.Collections.Generic.IEnumerable<string> Files = Directory.EnumerateFiles(Path);
		IEnumerable<Song> Songs = [];
		foreach (String file in Files){
			if (!(file.EndsWith(".mp3") || file.EndsWith(".ogg") || file.EndsWith(".wav"))){
				continue;
			}
			Song song = new()
			{
				Directory = file,
			};
			String[] parts = file.Split("/");
			String LastPart = parts[^1 ];
			song.Name = LastPart;
			Songs = Songs.Append(song);


		}

		return Songs;
	}
}

class URLImageGetter{
	public static String GetImageURL(String source){
		String cleansource = source;
		String ImageURL = "";
		if (cleansource.StartsWith("https://")){
			cleansource = cleansource.Remove(0,8);
		}
		GD.Print(cleansource);
		if (cleansource.StartsWith("www.youtube")){
			ImageURL = "https://i.ytimg.com/vi/";
			ImageURL += cleansource.Split("?")[1].Split("&")[0].Replace("v=","");
			ImageURL += "/hq720.jpg";
		}
		else{
			GD.Print("Dosent start wi yt ");
		}
		GD.Print("converted ", source, " to ", ImageURL);
		return ImageURL;
	}
}
