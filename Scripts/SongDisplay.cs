using Godot;
using System;
using System.Linq;

public partial class SongDisplay : Control
{
	public int DisplayId;
	Song SavedInfo;
	[Export] TextureRect background;
	[Export] Label NameLabel;
	[Export] Label ArtistLabel;
	[Export] Button PlayButton;
	public void Setup(Song info){
		SavedInfo = info;
		Image image = info.LoadImage();
		if (image != null){
			ImageTexture tex = ImageTexture.CreateFromImage(image);
			background.Texture = tex;
		}
		NameLabel.Text = SavedInfo.Name;
		if (SavedInfo.Artists.Any()){
			ArtistLabel.Text = SavedInfo.Artists[0];

		}
		PlayButton.Pressed += ButtonPressed;
	}
	void ButtonPressed(){
		Context.instance.LoadSong(SavedInfo.Directory);
		Context.instance.PlaySong();
	}
}
