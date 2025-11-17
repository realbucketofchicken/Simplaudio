using Godot;
using System;
using System.Linq;

public partial class SourceManager : Node
{
	[Export] Control SourceRoot;
	[Export] AddDialog AddDialog;
	[Export] PackedScene SourceDisplayScene;
	public Song[] Songs = [];
	MultipleSourceLoader loader;
	public override void _Ready()
	{
		base._Ready();
		loader = new();
		AddDialog.NewSource += NewSource;
	}
	void NewSource(String Name,String Directory){
		SourceDisplay display = (SourceDisplay)SourceDisplayScene.Instantiate();
		SourceRoot.AddChild(display);
		Source newsource = new(Name,Directory);
		display.source = newsource;
		display.Changed += UpdateSongs;
		display.Update();
		UpdateSongs();
	}
	void UpdateSongs(){
		Song[] NewSongs = [];
		foreach(SourceDisplay display in SourceRoot.GetChildren()){
			if (display.Enabled){
				NewSongs = (Song[])NewSongs.Concat(display.source.Songs);
				display.source.LoadSource();
			}
			
		}
		Songs = NewSongs;
	}
}
