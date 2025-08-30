using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Godot;
using TagLib;
using TagLib.Riff;


public class Song{
	public String Name;
	public bool LoadedMetadata;
	public String[] Artists;
	public String Album;
	public float Length;
	public String Comment;
	public String Directory;
	public void LoadMetadata(){
		var TLfile = TagLib.File.Create(Directory);
		Album ??= TLfile.Tag.Album;
		Artists ??= TLfile.Tag.Performers;
		Name ??= TLfile.Tag.Title;
		Length = TLfile.Length;
		Comment ??= TLfile.Tag.Comment;
		TLfile.Dispose();
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
			//TLfile.Tag.CopyTo(Tag)
			

			//GD.Print("File Valid, file path ",song.Directory);
			Songs = Songs.Append(song);

			//if (file.EndsWith(".mp3"))
		}

		return Songs;
	}
}
