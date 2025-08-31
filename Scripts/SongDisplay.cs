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
	[Export] Button OpenURLButton;
	public void Setup(Song info){
		SavedInfo = info;
		Image image = info.LoadImage();
		if (image != null){
			ImageTexture tex = ImageTexture.CreateFromImage(image);
			background.Texture = tex;
		}
		NameLabel.Text = SavedInfo.Name;
		ArtistLabel.Text = SavedInfo.Artist;

		PlayButton.Pressed += ButtonPressed;
		OpenURLButton.Pressed += URLOpen;
	}
	void ButtonPressed(){
		Context.ISongPlayer.LoadSong(SavedInfo);
		Context.ISongPlayer.PlaySong();
	}
	void URLOpen(){
		OS.ShellOpen(SavedInfo.URL);
	}
}
