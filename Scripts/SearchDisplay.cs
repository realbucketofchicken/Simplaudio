using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

public partial class SearchDisplay : Node
{
	[Export] PackedScene display;
	[Export] Control UpperMargin;
	[Export] Control SongContainer;
	[Export] Control LowerMargin;
	[Export] ScrollContainer Scroll;

	public override void _Ready()
	{
		base._Ready();
		Context.instance.SongsUpdated += UpdateDisplay;

	}
	IEnumerable<Song> DisplayedSongs = [];
	void UpdateDisplay(IEnumerable<Song> songs){
		DisplayedSongs = songs;
		GD.Print("Updated, songs ",songs.Count());
		
	}

	public override void _Process(double delta)
	{
		base._Process(delta);
		int CurrentIndex = (int)(Scroll.ScrollVertical/ 75);
		int MaxIndex = (int)((Scroll.Size.Y / 75)+CurrentIndex+1);

		IEnumerable<SongDisplay> DisplayRemove =[];
		IEnumerable<int> ids = [];
		IEnumerable<SongDisplay> displays = [];

		foreach(Node child in SongContainer.GetChildren()){
			if (child is SongDisplay display1)
			{
				displays = displays.Append(display1);
			}
		}
		if (displays.Any())
		{
			foreach (SongDisplay display in displays){
				if (display.DisplayId < CurrentIndex || display.DisplayId > MaxIndex){
					DisplayRemove = DisplayRemove.Append(display);
				}
				else{
					ids = ids.Append(display.DisplayId);
				}
			}
		}
		for (int i = CurrentIndex; i >= CurrentIndex && i <= MaxIndex;i++)
		{
			if (!ids.Contains(i)){
				if (i > DisplayedSongs.Count()-1){
					break;
				}
				Song Songinfo = DisplayedSongs.ElementAt(i);
				if (!Songinfo.LoadedMetadata){
					Songinfo.LoadMetadata();
				}
				SongDisplay scene = (SongDisplay)display.Instantiate();
				SongContainer.AddChild(scene);
				scene.Setup(Songinfo);
				scene.DisplayId = i;
				SongContainer.MoveChild(scene,i - CurrentIndex);
				GD.Print("CurrentIndex ", CurrentIndex);
				displays = displays.Append(scene);
			}
		}

		foreach (SongDisplay display in DisplayRemove)
		{
			display.QueueFree();
		}	
		update_margins(CurrentIndex);
	}
	void update_margins(int CurrentIndex,int songsize = 75){
		int ChildSize = SongContainer.GetChildren().Count * songsize;
		int TotalSize = songsize * DisplayedSongs.Count();
		int TopMarginSize = CurrentIndex*songsize;
		int LowMarginSize = TotalSize-ChildSize-TopMarginSize;
		UpperMargin.CustomMinimumSize = new Vector2(0,TopMarginSize);
		LowerMargin.CustomMinimumSize = new Vector2(0, LowMarginSize);
	}

}
