package character;
import character.controllers.movement.MovementController;
import character.controllers.vision.VisionController;
import character.controllers.vision.VisionEvent;
import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxVector;
import flixel.util.loaders.TexturePackerData;
import nape.callbacks.CbType;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyList;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.shape.ShapeList;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author 
 */
class BaseCharacter extends FlxBasic
{
	public static inline var MAX_TIME_SPEND_ON_LIKE:Float = 4;
	public static inline var LONELY_LOSE_KARMA_TIME:Float = 10;
	public static inline var TOTAL_NIRVANA_POINTS:Int = 12;
	public static inline var STARTING_KARMA:Int = 5;
	
	public static inline var TIME_GET_BACK_IN_BOUNDS_MAX:Float = 3;
	
	public static var characterInteraction:CbType = new CbType();
	
	public var dispatcher:EventDispatcher;
	
	public var colorAm:Int;
	public var colorLike:Int;
	public var colorHate:Int;
	public var shy:Bool;
	
	public var viewBody:FlxSprite;
	public var viewMouth:FlxSprite;
	public var viewEye:FlxSprite;
	
	public var view:FlxNapeSprite;
	public var vision:Shape;
	public var visionColor:Int;
	
	//public var movementController:MovementController;
	//public var visionController:VisionController;
	
	public var angle:Float;
	
	public var currentLike:FlxNapeSprite;
	public var currentHate:FlxNapeSprite;
	
	private var _exLikes:Array<FlxNapeSprite>;
	
	private var _outOfBoundsTime:Float;
	
	public var karma:Int;
	
	private var _lonelyTimer:Float;
	
	private var _giveUpOnLikeTimer:Float;

	public function new(p_colorAm:Int = -1, p_x:Float = -1, p_y:Float = -1 ) 
	{
		super();
		
		_exLikes = new Array<FlxNapeSprite>();
		
		if ( p_colorAm == -1)
		{
			colorAm = Reg.COLORS[FlxRandom.intRanged(0, Reg.COLORS.length - 1)];
		}
		else
		{
			colorAm = p_colorAm;
		}
		
		
		colorLike = Reg.COLORS[FlxRandom.intRanged(0, Reg.COLORS.length - 1)];
		colorHate = Reg.COLORS[FlxRandom.intRanged(0, Reg.COLORS.length - 1)];
		shy = (Math.round( Math.random()) == 1 ) ? true : false;
		
		visionColor = FlxRandom.color(180);
		
		dispatcher = new EventDispatcher();
		
		dispatcher.addEventListener( VisionEvent.FOUND_HATE, onFoundHate, false, 0, true );
		dispatcher.addEventListener( VisionEvent.FOUND_LIKE, onFoundLike, false, 0, true );
		
		viewBody = new FlxSprite( 0, 0 );
		viewBody.loadGraphic( "assets/images/character.png", false, 64, 64 );
		viewBody.offset.set( 32, 32 );
		viewBody.color = colorAm;
		
		
		var mouthData:TexturePackerData = new TexturePackerData( "assets/data/mouth_data.json", "assets/images/mouth_sheet.png");
		
		viewMouth = new FlxSprite(0, 0);
		viewMouth.loadGraphicFromTexture( mouthData );
		
		viewMouth.animation.addByPrefix("estatic", "mouth_estatic", 1, false);
		viewMouth.animation.addByPrefix("happy", "mouth_happy", 1, false);
		viewMouth.animation.addByPrefix("smile", "mouth_smile", 1, false);
		viewMouth.animation.addByPrefix("meh", "mouth_meh", 1, false);
		viewMouth.animation.addByPrefix("sad", "mouth_sad_", 12, true);
		
		viewMouth.offset.set( 32, 32 );
		
		
		
		
		viewEye = new FlxSprite(0, 0);
		viewEye.loadGraphic( "assets/images/eye.png" );
		viewEye.color = colorLike;
		viewEye.offset.set( 10, 24 );
		
		
		view = new FlxNapeSprite( 0, 0);
		view.makeGraphic( 64, 64, FlxColor.TRANSPARENT, true );
		
		
		
		//var bodyLinestyle:LineStyle = { color: colorHate, thickness: 5 };
		
		//var eyeLinestyle:LineStyle = { color: FlxColor.WHITE, thickness: 3 };
		//FlxSpriteUtil.drawCircle( view, -1, -1, 32, colorAm );
		//FlxSpriteUtil.drawCircle( view, 48, -1, 10, colorLike, eyeLinestyle );
		
		//view.antialiasing = true;
		
		view.createCircularBody( 32, BodyType.DYNAMIC );
		view.setBodyMaterial(3, 0.2, 0, 1);
		
		if ( p_x == -1 )
		{
			view.body.position.set( Vec2.weak( FlxRandom.intRanged(64, FlxG.width - 64), FlxRandom.intRanged(64, FlxG.height - 64) ) );
		}
		else
		{
			view.body.position.set( Vec2.weak( p_x, p_y ) );
		}
		
		view.body.userData.character = this;
		view.body.rotation = FlxAngle.asRadians( FlxRandom.intRanged( 0, 360 ) );
		
		//view.body.applyAngularImpulse( FlxRandom.floatRanged( -1000, 1000) );
		view.body.applyImpulse( Vec2.fromPolar( FlxRandom.floatRanged(100,300) , view.body.rotation, true ) );
		view.body.cbTypes.add( characterInteraction );
		
		
		Reg.VIEWS.add( view );
		
		Reg.VIEWS.add( viewEye );
		
		Reg.VIEWS.add( viewBody );
		
		Reg.VIEWS.add( viewMouth );
		
		
		
		
		//vision = new FlxNapeSprite(0, 0);
		
		//vision.body = 
		vision = new Polygon( Polygon.regular(128, 64, 3, Math.PI) );
		vision.body = new Body();
		
	
		
		karma = STARTING_KARMA;
		updateMouth();
		
		//Reg.VIEWS.add( view );
		//Reg.CHARACTER_COLORS[ colorAm ].add( view );
		
		//view.setPosition( FlxRandom.intRanged( 64, FlxG.width - 64), FlxRandom.intRanged( 64, FlxG.height - 64) );
		
		//movementController = new MovementController();
		//movementController.init( this, view );
		
		//view.origin.set( 32, 32 );
		//view.offset.set( -32, -32 );
		
		//FlxG.watch.addQuick( "lonely timer", _lonelyTimer);
		_lonelyTimer = 0;
		_giveUpOnLikeTimer = 0;
	}
	
	private function updateMouth():Void
	{
		var l_karmaPercent:Float = karma / TOTAL_NIRVANA_POINTS;
		
		if ( l_karmaPercent <= .2 )
		{
			viewMouth.animation.play("sad");
		}
		else if ( l_karmaPercent <= .4 )
		{
			viewMouth.animation.play("meh");
		}
		else if ( l_karmaPercent <= .6 )
		{
			viewMouth.animation.play("smile");
		}
		else if ( l_karmaPercent <= .8 )
		{
			viewMouth.animation.play("happy");
		}
		else
		{
			viewMouth.animation.play("estatic");
		}
	}
	
	override public function update():Void 
	{
		super.update();
		
		_lonelyTimer += FlxG.elapsed;
		if ( _lonelyTimer > LONELY_LOSE_KARMA_TIME )
		{
			updateKarma();
			_lonelyTimer = 0;
		}
		
		if ( _giveUpOnLikeTimer > MAX_TIME_SPEND_ON_LIKE )
		{
			currentLike = null;
			_giveUpOnLikeTimer = 0;
		}
		
		
		if ( karma / TOTAL_NIRVANA_POINTS <= .2 )
		{
			if ( view.isOnScreen() == false )
			{
				if ( Reg.strikes < 3 )
				{
					++Reg.strikes;
				}
				FlxG.sound.play("assets/sounds/Sad_Offscreen.wav", .33 );
				destroy();
				return;
			}
		}
		
		
		view.body.velocity.rotate( view.body.rotation - view.body.velocity.angle );
		if ( view.body.velocity.length < .5 ) 
		{
			view.body.applyImpulse( Vec2.fromPolar( FlxRandom.floatRanged(500, 1000) , view.body.rotation, true ) );
		
		}
		
		viewBody.setPosition( view.body.position.x, view.body.position.y );
		
		viewMouth.setPosition( view.body.position.x, view.body.position.y );
		
		var l_eyeVec:Vec2 = view.body.position.copy(true);
		l_eyeVec = l_eyeVec.add( Vec2.fromPolar( 5, view.body.rotation, true ) );
		
		viewEye.setPosition( l_eyeVec.x, l_eyeVec.y );
		
		
		if ( _outOfBoundsTime > 0 )
		{
			FlxG.log.add( "angular velo: " + view.body.angularVel );
			//view.body.angularVel *= .98;
			
			var l_angleToCenter:Float = (FlxAngle.getAngle( FlxPoint.weak( view.body.position.x, view.body.position.y ), FlxPoint.weak( FlxG.width * .5, FlxG.height * .5 ) ) - 90) * FlxAngle.TO_RAD;
			var l_vectorToCenter:Vec2 = Vec2.fromPolar( 1, l_angleToCenter, true );
			var l_curVector:Vec2 = Vec2.fromPolar( 1, view.body.rotation, true );
			
			var l_distanceToCenterAngle:Float = Math.abs( Math.acos( FlxMath.dotProduct( l_curVector.x, l_curVector.y, l_vectorToCenter.x, l_vectorToCenter.y ) ) );
			
			while ( l_distanceToCenterAngle < Math.abs( view.body.angularVel / 60 ) )
			{
				view.body.angularVel = 0;
				//view.body.angularVel *= .5;
			}
			
			_outOfBoundsTime -= FlxG.elapsed;
		}
		else
		{
			if ( currentLike == null )
			{
		
				//FlxNapeState.debug.drawCircle( view.body.position, 128, visionColor );
				var l_bodyList:BodyList = FlxNapeState.space.bodiesInCircle( view.body.position, 150);
				for ( body in l_bodyList )
				{
					if ( body == view.body )
					{
						continue;
					}
					var l_character:BaseCharacter = body.userData.character;
					if ( l_character != null && l_character.colorAm == colorLike && _exLikes.indexOf( l_character.view ) == -1 )
					{
						currentLike = l_character.view;
						//view.body.applyImpulse( Vec2.fromPolar( FlxRandom.floatRanged(500,1000) , view.body.rotation, true ) );
					}
				}
			}
			else if ( currentLike.body == null )
			{
				currentLike = null;
			}
			else 
			{
				_giveUpOnLikeTimer += FlxG.elapsed;
				
				var l_angleToLike:Float = (FlxAngle.getAngle( FlxPoint.weak( view.body.position.x, view.body.position.y), FlxPoint.weak(currentLike.body.position.x, currentLike.body.position.y) ) - 90 ) * FlxAngle.TO_RAD;
				
				
				var l_vectorToLike:Vec2 = Vec2.fromPolar( 1, l_angleToLike, true );
				var l_curVector:Vec2 = Vec2.fromPolar( 1, view.body.rotation, true );
				
				var l_angleDistanceToLike:Float =  Math.abs( Math.acos( FlxMath.dotProduct(  l_curVector.x, l_curVector.y, l_vectorToLike.x, l_vectorToLike.y ) ) );
				
				if ( l_angleDistanceToLike > .05 )
				{
					
					var pos_source:Vec2 = view.body.position.copy(true);
					var dir_source:Vec2 = Vec2.fromPolar(1, view.body.rotation, true);
					var pos_target:Vec2 = Vec2.weak( currentLike.body.position.x, currentLike.body.position.y );
				
					if ( (pos_source.x - pos_target.x) * dir_source.y > (pos_source.y - pos_target.y) * dir_source.x )
					{
						// clockwise
						l_angleDistanceToLike *= .1;
					}
					else
					{
						// counterclockwise
						l_angleDistanceToLike *= -.1;
					}
				
					
					view.body.rotation += l_angleDistanceToLike;
				}
				
				//FlxNapeState.debug.drawLine( view.body.position, currentLike.body.position, visionColor );
			}
		}
	}
	
	override public function destroy():Void 
	{
		view.kill();
		view.destroy();
		
		viewBody.kill();
		viewBody.destroy();
		
		viewEye.kill();
		viewEye.destroy();
		
		viewMouth.kill();
		viewMouth.destroy();
		
		kill();
		
		super.destroy();
	}
	
	public function headingOutOfBounds():Void
	{
		if ( _outOfBoundsTime >= 0 )
		{
			return;
		}
		
		_outOfBoundsTime = TIME_GET_BACK_IN_BOUNDS_MAX;
		
		//view.body.rotation = 
		
		var pos_source:Vec2 = view.body.position.copy(true);
		var dir_source:Vec2 = Vec2.fromPolar(1, view.body.rotation, true);
		var pos_target:Vec2 = Vec2.weak( FlxG.width * .5, FlxG.height * .5 );
		
		if ( (pos_source.x - pos_target.x) * dir_source.y > (pos_source.y - pos_target.y) * dir_source.x )
		{
			// clockwise
			view.body.applyAngularImpulse( 10000  );
		}
		else
		{
			// counterclockwise
			view.body.applyAngularImpulse( -10000  );
		}
		//view.body.applyImpulse( Vec2.fromPolar( FlxRandom.floatRanged(250,500) , view.body.rotation, true ) );
		
		currentLike = null;
	}
	
	private function onBump( p_collider:FlxNapeSprite ):Void
	{
		if ( p_collider != null && p_collider == currentLike )
		{
			FlxG.sound.play("assets/sounds/Bump_" + FlxRandom.intRanged(1, 3) + ".wav", .1);
			
			_exLikes.push( p_collider );
			currentLike = null;
			updateKarma(1);
		}
	}
	
	public function updateKarma( p_amount:Int = -1, p_fromChain:Bool = false ):Void
	{
		if ( alive == false )
		{
			return;
		}
		if ( karma <= 0 )
		{
			karma = 0;
			return;
		}
		
		karma += p_amount;
		updateMouth();
		
		if ( karma >= TOTAL_NIRVANA_POINTS )
		{
			Reg.NIRVANA_EMITTER.setPosition( view.body.position.x, view.body.position.y );
			Reg.NIRVANA_EMITTER.start( true, .5, 0.1, 75, .75 );
			
			Reg.score += 10;
			if (p_fromChain == false ) // lighten the chaining a bit
			{
				if ( Reg.strikes > 0 )
				{
					--Reg.strikes;
				}
				var l_bodyList:BodyList = FlxNapeState.space.bodiesInCircle( view.body.position, 150);
				for ( body in l_bodyList )
				{
					if ( body == view.body )
					{
						continue;
					}
					var l_character:BaseCharacter = body.userData.character;
					if ( l_character != null && l_character.karma <= TOTAL_NIRVANA_POINTS )
					{
						l_character.updateKarma(1,true);
					}
				}
			}
			
			FlxG.sound.play("assets/sounds/Reach_Nirvana.wav", .33 );
			destroy();
		}
		else if ( p_amount > 0 )
		{
			Reg.BUMP_EMITTER.setPosition( view.body.position.x, view.body.position.y );
			Reg.BUMP_EMITTER.start( true, .25, 0.1, 20, .5 );
		}
	}
	
	private function onFoundHate( e:VisionEvent ):Void
	{
		// probaby start a new view 
		/*currentHate = e.seenView;
		movementController.newAvoidFound();*/
	}
	
	private function onFoundLike( e:VisionEvent ):Void
	{
		/*if ( currentLike == null)
		{
			currentLike = e.seenView;
			movementController.newLikeFound();
		}*/
		// e.seenView;
	}
}