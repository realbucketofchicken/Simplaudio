using Godot;
using System;
using System.Reflection.Metadata;
using System.Data.Common;
using System.Reflection.PortableExecutable;
using System.IO;

public partial class Metadatatest : Control
{

	public override void _Ready()
	{
		base._Ready();
		URLImageGetter.GetImageURL("https://www.youtube.com/watch?v=ImqhHLlPfZg&list=WL");
	}
}
