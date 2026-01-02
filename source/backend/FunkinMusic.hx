package backend;
import flash.media.Sound;
import flixel.system.frontEnds.AssetFrontEnd;
import openfl.utils.Assets;
import lime.media.vorbis.VorbisFile;

class FunkinMusic extends FlxSound
{
    override public function loadStreamed(path:String, looped:Bool = false, autoDestroy:Bool = false, ?onComplete:Void->Void):FunkinMusic
    {
        trace(path);
	    cleanup(true);
		_sound = Ass.streamSoundUnsafe(path);
        trace(this);
		return this;
    }

  
}
class Ass extends AssetFrontEnd
{
  override public function streamSoundUnsafe(id:String):Sound
	{
        var vorbisFile:Null<VorbisFile> = VorbisFile.fromFile(id);
        if(FileSystem.exists(id)) return  Sound.fromAudioBuffer(lime.media.AudioBuffer.fromVorbisFile(vorbisFile));
		else return Assets.getMusic(addSoundExtIf(id));
	}
}
