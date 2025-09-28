using Godot;
using System;

public partial class SourcetabUI : Node
{
	[Export] public Button AddSourceButton;
	[Export] public Control Adder;
	[Export] public LineEdit Namer;
	[Export] public Button DirOpenButton;
	[Export] public RichTextLabel DirLabel;
	[Export] public Button AddButton;
	[Export] public FileDialog Dialog;
	[Export] public Control SourceContainer;
	[Export] public PackedScene SourceScene;
	String Directory;
	public override void _Ready()
	{
		base._Ready();
		AddSourceButton.Pressed += AddSource;
		Namer.TextChanged += TextChanged;
		Dialog.DirSelected += DirSelected;
		DirOpenButton.Pressed += ShowDialog;
		AddButton.Pressed += Add;
	}
	void AddSource(){
		Adder.Show();
		DirLabel.Text = "";
		Namer.Text = "";
		Dialog.Visible = false;
		Directory = "";
		AddButton.Disabled = true;

	}
	void ShowDialog(){
		Dialog.Show();
	}

	void DirSelected(String Dir){
		Directory = Dir;
		UpdateVisuals();
	}

	void TextChanged(String Text){
		UpdateVisuals();
	}
	void UpdateVisuals(){
		DirLabel.Text = Directory;
		AddButton.Disabled = !IsValid();
	}

	bool IsValid(){
		bool valid = true;
		if (Namer.Text == ""){
			valid = false;
		}
		if (Directory == ""){
			valid = false;
		}
		return valid;
	}
	void Add(){
		SourceDisplay NewSource = (SourceDisplay)SourceScene.Instantiate();
		SourceContainer.AddChild(NewSource);
		Adder.Hide();
	}
}
