using Godot;
using System;

public partial class AddDialog : Panel
{
	[Export] Control SourcesRoot;
	[Export] LineEdit NameEdit;
	[Export] FileDialog Dialog;
	[Export] Label DirectoryLabel;
	[Export] Button AddButton;
	String dir = "";

	// Name Dir
	public event Action<String,String> NewSource;

	public override void _Ready()
	{
		base._Ready();
		AddButton.Pressed += Add;
		NameEdit.TextChanged += Update;
		Dialog.DirSelected += DirectorySelected;
	}

	void Add(){
		NewSource?.Invoke(NameEdit.Text, dir);
		DirectorySelected("");
		AddButton.Disabled = true;
		NameEdit.Text = "";
	}

	void DirectorySelected(String Path){
		DirectoryLabel.Text = Path;
		dir = Path;
		Update();
	}

	void Update(String Newtext=""){
		AddButton.Disabled = (NameEdit.Text.Replace(" ", "") == "") || dir == "" ;
	}
}
