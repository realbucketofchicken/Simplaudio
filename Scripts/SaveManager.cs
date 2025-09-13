using System;
using DiscordRPC;
using Godot;

public class SaveManager{
    const String SaveLocation = "user://Saved.tres";
    public static SimplaudioSettings LoadSettings(){
        SimplaudioSettings loaded = GD.Load<SimplaudioSettings>(SaveLocation);
        if (loaded == null){
            return new SimplaudioSettings();
        }
        return loaded;
    }
}