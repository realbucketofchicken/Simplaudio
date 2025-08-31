using Godot;
using Instances;
using System;
using System.Collections.Generic;
using System.Linq;

public partial class UIManager : Node{
    [Export] Button PlayPauseButton;
    [Export] Texture2D PauseImage;
    [Export] Texture2D PlayImage;
    [Export] HSlider ProgressIndicator;
    [Export] Button SkipButton;
    [Export] Button GoBackButton;
    [Export] Button LoopButton;
    [Export] Button RandomizeButton;

    bool SliderDragging;

    static UIManager instance;
    public override void _Ready()
    {
        base._Ready();
        instance = this;
        ProgressIndicator.DragStarted += sliderDrag;
        ProgressIndicator.DragEnded += sliderDragEnded;
        PlayPauseButton.Toggled += PausePlay;
        Context.ISongPlayer.SongStateUpdated += UpdatePausePlay;
    }

    void PausePlay(bool Newstate){
        if (Newstate){
            Context.ISongPlayer.PauseSong();
            PlayPauseButton.Icon = PlayImage;
        }
        else{
            Context.ISongPlayer.UnpauseSong();
            PlayPauseButton.Icon = PauseImage;
        }
    }

    void UpdatePausePlay(bool paused){
        if (paused){
            PlayPauseButton.Icon = PlayImage;
            PlayPauseButton.ButtonPressed = true;
        }
        else{
            PlayPauseButton.Icon = PauseImage;
            PlayPauseButton.ButtonPressed = false;
        }
    }

    public override void _Process(double delta)
    {
        base._Process(delta);
        if (!SliderDragging){
            ProgressIndicator.Value = Context.ISongPlayer.GetPosition();
        }
    }

    void sliderDrag(){
        SliderDragging = true;
    }
    void sliderDragEnded(bool changed){
        SliderDragging = false;
        
        Context.ISongPlayer.SetPosition((float)ProgressIndicator.Value);
    }
}