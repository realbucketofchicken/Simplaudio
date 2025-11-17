using Godot;
using System;

public partial class SourceDisplay : Control
{
	public event Action Changed;
	public Source source;
	[Export] CheckBox EnabledCheck;
	[Export] Label NameLabel;
	[Export] Label PathLabel;
	public bool Enabled;
	public void Update(){
		PathLabel.Text = source.Path;
		NameLabel.Text = source.Name;
		EnabledCheck.Toggled += Toggled;
	}
	void Toggled(bool enabled){
		Enabled = enabled;
		Changed?.Invoke();
	}
	void Delete(){
		Enabled = false;
		Changed?.Invoke();
		QueueFree();
	}
}
