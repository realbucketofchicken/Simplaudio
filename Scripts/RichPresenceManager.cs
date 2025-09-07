using System;
using System.Collections.Generic;
using System.Linq;
using DiscordRPC;
using Godot;

public class RichPresenceManager{
	public static RichPresenceManager instance;
	public static DiscordRpcClient client;
	public const string DISCORD_APP_ID = "1276916292170809426";
	RichPresence CurrentPresence;
	public void Setup(){
		client = new DiscordRpcClient(DISCORD_APP_ID,autoEvents:false);
		client.Initialize();
		client.SetPresence(new RichPresence()
		{
			Details = "Just started up...",
			State = "Listening",
			DetailsUrl = "https://realbucketofchicken.github.io/SimplSite/simplaudio.html",
			StatusDisplay = StatusDisplayType.State,
			Type = DiscordRPC.ActivityType.Listening,
			Assets = new DiscordRPC.Assets()
			{
				SmallImageText = "Simpaudio",
				
			}
		});	
		client.OnReady += (sender, msg) =>
			{
				//Create some events so we know things are happening
				GD.Print("Connected to discord with user ", msg.User.Username);
				GD.Print("Avatar: ", msg.User.GetAvatarURL(User.AvatarFormat.WebP));
				GD.Print("Decoration: ", msg.User.GetAvatarDecorationURL());
			};

	}
	public void SetPresence(Song song){
		if (!song.LoadedMetadata){
			song.LoadMetadata();
		}
		Timestamps SongTimespan = Timestamps.FromTimeSpan(song.Length);
		List<DiscordRPC.Button> buttons = [new DiscordRPC.Button(){
					Label = "About Simplaudio",
					Url = "https://realbucketofchicken.github.io/SimplSite/simplaudio.html"
				}];
		if (song.URL != ""){
			buttons.Add(new DiscordRPC.Button(){

					Label = "Open song",
					Url = song.URL
				});
		}
		GD.Print("Song end rpc set to ", SongTimespan.EndUnixMilliseconds/1000);
		GD.Print("artist is : ", song.Artist);
		CurrentPresence = new RichPresence()
		{
			Details = song.Name,
			State = song.Artist ,
			StatusDisplay = (!String.IsNullOrEmpty(song.Artist)) ? StatusDisplayType.State : StatusDisplayType.Details,
			Type = DiscordRPC.ActivityType.Listening,
			Assets = new DiscordRPC.Assets()
			{
				LargeImageKey = URLImageGetter.GetImageURL(song.URL),
				SmallImageKey = (URLImageGetter.GetImageURL(song.URL) != "") ? "logo" : "",
				SmallImageText = "Simpaudio",
			},
			Timestamps = SongTimespan,
			Buttons = buttons.ToArray()
		};
		client.SetPresence(CurrentPresence);
	}
	public void UpdateTime(double progress,double totaltime,bool paused) {
		GD.Print("total ", totaltime, " progess", progress," without ",totaltime-progress);
		Timestamps stamps = Timestamps.FromTimeSpan(totaltime-progress);
		Timestamps newstamps = new()
		{
			Start = stamps.Start.Value.AddSeconds(-progress),
			End = stamps.End.Value
		};
		CurrentPresence.Timestamps = newstamps;
		client.SetPresence(CurrentPresence);
		GD.Print(CurrentPresence.Timestamps.StartUnixMilliseconds/1000," Song end rpc set to ", CurrentPresence.Timestamps.EndUnixMilliseconds/1000);
	}
	public void Update() {
		//Invoke the events once per-frame. The events will be executed on calling thread.
		client?.Invoke();
	}
}
