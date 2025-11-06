using Godot;
using System;

public partial class SourceDisplay : Control
{
	[Export] public Label NameLabel;
	[Export] public Label PathLabel;
	[Export] public CheckBox CheckButtonButton;
	public Source source;
	public override void _Ready()
	{
		base._Ready();
		if (source != null){
			NameLabel.Text = source.Name;
			PathLabel.Text = source.Path;
		}
		
	}
}
