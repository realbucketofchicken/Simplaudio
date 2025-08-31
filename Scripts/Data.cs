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


public class Song{
	public String Name;
	public bool LoadedMetadata;
	public String Artist;
	public String Album;
	public float Length;
	public String Comment;
	public String URL;
	public String Directory;
	public void LoadMetadata(){
		var TLfile = TagLib.File.Create(Directory);
		Track theTrack = new Track(Directory);
		if (theTrack.AdditionalFields.ContainsKey("comment")){
			URL = theTrack.AdditionalFields["comment"];

		}
		Album ??= theTrack.Album;
		Artist ??= theTrack.Artist;
		Name = String.IsNullOrEmpty(TLfile.Tag.Title) ?  Name : theTrack.Title;
		Length = theTrack.Duration;
		Comment = theTrack.Comment;
	}
	public Image LoadImage(){
		var TLfile = TagLib.File.Create(Directory);
		if (TLfile.Tag.Pictures.Count() == 0){
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
