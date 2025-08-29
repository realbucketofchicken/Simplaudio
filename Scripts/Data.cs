using System;
using System.Collections;
using System.IO;
using System.Linq;
using Godot;
using TagLib.Riff;


public class Song{
	public String Name;
	public String[] Artists;
	public String Album;
	public float Length;
	public String Directory;
}
public class DirectoryManager{
	public Song[] LoadDirectory(String Path){
		System.Collections.Generic.IEnumerable<string> Files = Directory.EnumerateFiles(Path);
		Song[] Songs = [];
		foreach (String file in Files){
			if (!(file.EndsWith(".mp3") || file.EndsWith(".ogg") || file.EndsWith(".wav"))){
				continue;
			}
			var tfile = TagLib.File.Create(file);

			Song song = new();
			song.Album = tfile.Tag.Album;
			song.Artists = tfile.Tag.Performers;
			song.Name = tfile.Tag.Title;
			song.Length = tfile.Length;
			song.Directory = file;
			GD.Print("File Valid, file path ",tfile.Tag.Title);
			Songs.Append(song);

			//if (file.EndsWith(".mp3"))
		}

		return [];
	}
}
