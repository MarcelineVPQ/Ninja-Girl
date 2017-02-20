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



class Design_13_13_GroundPound extends ActorScript
{
	public var _CanPound:Bool;
	public var _GroundPoundKey:String;
	public var _DownKey:String;
	public var _DownKeyRequired:Bool;
	public var _Force:Float;
	public var _PoundRightAnimation:String;
	public var _PoundLeftAnimation:String;
	public var _OldX:Float;
	public var _AnimationCategory:String;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Can Pound?", "_CanPound");
		_CanPound = false;
		nameMap.set("Ground Pound Key", "_GroundPoundKey");
		nameMap.set("Down Key", "_DownKey");
		nameMap.set("Down Key Required?", "_DownKeyRequired");
		_DownKeyRequired = true;
		nameMap.set("Force", "_Force");
		_Force = 0.0;
		nameMap.set("Pound Right Animation", "_PoundRightAnimation");
		nameMap.set("Pound Left Animation", "_PoundLeftAnimation");
		nameMap.set("Old X", "_OldX");
		_OldX = 0.0;
		nameMap.set("Animation Category", "_AnimationCategory");
		_AnimationCategory = "Ground Pounding";
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		/* Inputs: ---------------------- */
		/* "On Ground?" -- <Boolean> Actor Level Attribute, from "On Ground" Behavior (required) */
		/* "Is Jumping?" -- <Boolean> Actor Level Attribute, from "Jumping" Behavior (required) */
		/* "Facing Right?" -- <Boolean> Actor Level Attribute, from "Walking" Behavior (required) */
		/* "Is Wall Sliding?" -- <Boolean> Actor Level Attribute, from "Wall Sliding" Behavior (NOT required) */
		/* Outputs: --------------------- */
		/* "Is Ground Pounding" -- <Boolean> Actor Level Attribute */
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(asBoolean(actor.getActorValue("Is Wall Sliding?")))
				{
					actor.setActorValue("Is Ground Pounding?", false);
					actor.say("Animation Manager", "_customBlock_ClearAnimCat", [_AnimationCategory]);
					_CanPound = false;
					propertyChanged("_CanPound", _CanPound);
					return;
				}
				if((!(asBoolean(actor.getActorValue("Is Jumping?"))) || asBoolean(actor.getActorValue("On Ground?"))))
				{
					if((asBoolean(actor.getActorValue("Is Ground Pounding?")) && asBoolean(actor.getActorValue("On Ground?"))))
					{
						startShakingScreen(1 / 100, 0.2);
					}
					_CanPound = false;
					propertyChanged("_CanPound", _CanPound);
					actor.setActorValue("Is Ground Pounding?", false);
					actor.say("Animation Manager", "_customBlock_ClearAnimCat", [_AnimationCategory]);
					return;
				}
				if(isKeyPressed(_GroundPoundKey))
				{
					if((_DownKeyRequired && !(isKeyDown(_DownKey))))
					{
						return;
					}
					_CanPound = false;
					propertyChanged("_CanPound", _CanPound);
					actor.setActorValue("Is Ground Pounding?", true);
					actor.applyImpulse(0, 1, _Force);
				}
				if(asBoolean(actor.getActorValue("Is Ground Pounding?")))
				{
					actor.setXVelocity(0);
					actor.setX(_OldX);
					if(asBoolean(actor.getActorValue("Facing Right?")))
					{
						actor.say("Animation Manager", "_customBlock_LoopAnim", [_PoundRightAnimation, _AnimationCategory]);
					}
					else
					{
						actor.say("Animation Manager", "_customBlock_LoopAnim", [_PoundLeftAnimation, _AnimationCategory]);
					}
				}
				_OldX = asNumber(actor.getX());
				propertyChanged("_OldX", _OldX);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}