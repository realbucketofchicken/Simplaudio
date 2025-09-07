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
	[Export] MenuButton OpenURLButton;
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
		//OpenURLButton.GetPopup().Connect("id_pressed", new Callable(this, "id_pressed"));
	}
	void ButtonPressed(){
		Context.ISongPlayer.LoadSong(SavedInfo);
		Context.ISongPlayer.PlaySong();
	}
	void URLOpen(){
		OS.ShellOpen(SavedInfo.URL);
	}
	public void id_pressed(int idx){

	}
}
