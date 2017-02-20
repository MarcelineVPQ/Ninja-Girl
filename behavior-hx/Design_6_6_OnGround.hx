package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class Design_6_6_OnGround extends ActorScript
{
	public var _HitGround:Bool;
	public var _LimitToTiles:Bool;
	public var _ExcludedGroups:Array<Dynamic>;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Hit Ground?", "_HitGround");
		_HitGround = false;
		nameMap.set("Limit To Tiles?", "_LimitToTiles");
		_LimitToTiles = false;
		nameMap.set("Excluded Groups", "_ExcludedGroups");
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		/* Inputs: */
		/* None */
		/* Outputs: */
		/* "On Ground?" -- <Boolean> Actor Level Attribute */
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				actor.setActorValue("On Ground?", _HitGround);
				_HitGround = false;
				propertyChanged("_HitGround", _HitGround);
			}
		});
		
		/* ======================== Something Else ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				/* Don't consider collisions with sensors as hitting the ground */
				if(event.collidedWithSensor)
				{
					return;
				}
				/* If we only want to detect collions with Tiles, and the Actor hit something other than the tile -- Quit */
				if((_LimitToTiles && !(event.collidedWithTile)))
				{
					return;
				}
				/* If we are excluding certain Actor Groups - check those here and quit if appropriate */
				if((_ExcludedGroups.length > 0))
				{
					for(item in cast(_ExcludedGroups, Array<Dynamic>))
					{
						if((("" + item) == ("" + internalGetGroup(event.otherActor, event.otherShape, event))))
						{
							return;
						}
					}
				}
				/* If we get here and detect a bottom collision, we're on the ground */
				for(point in event.points)
				{
					if((Math.abs(point.normal.y) > 0.1))
					{
						_HitGround = true;
						propertyChanged("_HitGround", _HitGround);
						return;
					}
				}
				if(event.FromBottom)
				{
					_HitGround = true;
					propertyChanged("_HitGround", _HitGround);
					return;
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}