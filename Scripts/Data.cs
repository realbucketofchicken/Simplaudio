using System;
using System.Collections;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Godot;
using TagLib;
using TagLib.Riff;


public class Song{
	public String Name;
	public String[] Artists;
	public String Album;
	public float Length;
	public String Comment;
	public String Directory;
}
public class DirectoryManager{
	Task LoadTask;
	Song[] LoadedSongs;
	public Song[] LoadDirectory(String Path){

		LoadTask = new Task(() => ParseDirectory(Path));
		LoadTask.Start();
		Task.WhenAll([LoadTask]).Wait();
		GD.Print("Finished");
		return LoadedSongs;
		//if (file.EndsWith(".mp3"))
	}
	private void ParseDirectory(String Path){
		System.Collections.Generic.IEnumerable<string> Files = Directory.EnumerateFiles(Path);
		Song[] Songs = [];
		foreach (String file in Files){
			if (!(file.EndsWith(".mp3") || file.EndsWith(".ogg") || file.EndsWith(".wav"))){
				continue;
			}
			var TLfile = TagLib.File.Create(file);

			Song song = new()
			{
				Album = TLfile.Tag.Album,
				Artists = TLfile.Tag.Performers,
				Name = TLfile.Tag.Title,
				Length = TLfile.Length,
				Directory = file,
				Comment = TLfile.Tag.Comment
			};
			if (file.EndsWith(".mp3")){
				song.Comment = TLfile.GetTag(TagLib.TagTypes.Id3v2, true).Comment;
			}
			//TLfile.Tag.CopyTo(Tag)
			

			//GD.Print("File Valid, file path ",song.Directory);
			Songs.Append(song);

			//if (file.EndsWith(".mp3"))
		}

		LoadedSongs = Songs;
	}
}
