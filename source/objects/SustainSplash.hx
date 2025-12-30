package objects;
/*
  * Should probably also just redo most of this
*/
class SustainSplash extends FlxSprite {

  public static var startCrochet:Float;
  public static var frameRate:Int;
	public var strumNote:StrumNote;
	public var texture:String = 'noteSplashes/holdSplash';

  public function new():Void {
    super();
    frames = Paths.getSparrowAtlas(texture);
    animation.addByPrefix('start-0', 'holdCoverStartPurple', 16, false);
    animation.addByPrefix('hold-0', 'holdCoverPurple', 20, true);
    animation.addByPrefix('end-0', 'holdCoverEndPurple', 24, false);
    animation.addByPrefix('start-1', 'holdCoverStartBlue', 16, false);
    animation.addByPrefix('hold-1', 'holdCoverBlue', 20, true);
    animation.addByPrefix('end-1', 'holdCoverEndBlue', 24, false);
    animation.addByPrefix('start-2', 'holdCoverStartGreen', 16, false);
    animation.addByPrefix('hold-2', 'holdCoverGreen', 20, true);
    animation.addByPrefix('end-2', 'holdCoverEndGreen', 24, false);
    animation.addByPrefix('start-3', 'holdCoverStartRed', 16, false);
    animation.addByPrefix('hold-3', 'holdCoverRed', 20, true);
    animation.addByPrefix('end-3', 'holdCoverEndRed', 24, false);
  }

  override function update(elapsed) {
    super.update(elapsed);
    if(strumNote != null)
    {
        if(!animation.curAnim.name.startsWith("end-") && strumNote.animation.curAnim.name == "static") {
            visible = false;
        }
    }
  }

  public function setupSusSplash(strum:StrumNote, daNote:Note, ?playbackRate:Float = 1):Void {

    final lengthToGet:Int = !daNote.isSustainNote ? daNote.tail.length : daNote.parent.tail.length;
    if(lengthToGet <= 1 || strum.visible == false) //kill splash if size of hold is too small
    {
        kill();
        return;
    } 
    final timeToGet:Float = !daNote.isSustainNote ? daNote.strumTime : daNote.parent.strumTime;
    final timeThingy:Float = (startCrochet * lengthToGet + (timeToGet - Conductor.songPosition + ClientPrefs.data.ratingOffset)) / playbackRate * .001;
    var tailEnd:Note = !daNote.isSustainNote ? daNote.tail[daNote.tail.length - 1] : daNote.parent.tail[daNote.parent.tail.length - 1];
  
    clipRect = new flixel.math.FlxRect(0, !PlayState.isPixelStage ? 0 : -210, frameWidth, frameHeight);
    visible = true;
    strumNote = strum;
		alpha = ClientPrefs.data.susSplashAlpha - (1 - strumNote.alpha);

    trace(daNote.noteData);
    setPosition(strumNote.x, strumNote.y);

    offset.set(PlayState.isPixelStage ? 112.5 : 106.25, 100);
    animation.play('start-' + daNote.noteData);

    animation.finishCallback = (animationName:String)->{
      if(animationName == "start-"+ daNote.noteData)
      {
        animation.play('hold-'+ daNote.noteData, true, false, 0);
        animation.curAnim.looped = true;
      }
    }

    new FlxTimer().start(timeThingy, (idk:FlxTimer) -> {
      if (tailEnd.mustPress && !(daNote.isSustainNote ? daNote.parent.noteSplashData.disabled : daNote.noteSplashData.disabled)) {
        animation.play('end-'+ daNote.noteData, true, false, 0);
        animation.curAnim.frameRate = 24;
        clipRect = null;
        animation.finishCallback = (idkEither:Dynamic) -> {
          kill();
        }
        return;
      }
    
      kill();

    });

  }

}
