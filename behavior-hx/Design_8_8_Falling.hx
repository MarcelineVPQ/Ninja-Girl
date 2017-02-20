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



class Design_8_8_Falling extends ActorScript
{
	public var _OldY:Float;
	public var _CanFall:Bool;
	public var _FallRightAnimation:String;
	public var _FallLeftAnimation:String;
	public var _GroundY:Float;
	public var _AnimationCategory:String;
	public function _customEvent_CheckFalling():Void
	{
		if((actor.getY() <= _OldY))
		{
			_CanFall = false;
			propertyChanged("_CanFall", _CanFall);
			return;
		}
		if(asBoolean(actor.getActorValue("Is Wall Sliding?")))
		{
			_CanFall = false;
			propertyChanged("_CanFall", _CanFall);
			return;
		}
		if((!(_CanFall) && (Math.abs((_GroundY - actor.getY())) <= 3)))
		{
			return;
		}
		_CanFall = true;
		propertyChanged("_CanFall", _CanFall);
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Old Y", "_OldY");
		_OldY = 0.0;
		nameMap.set("Can Fall?", "_CanFall");
		_CanFall = false;
		nameMap.set("Fall Right Animation", "_FallRightAnimation");
		nameMap.set("Fall Left Animation", "_FallLeftAnimation");
		nameMap.set("Ground Y", "_GroundY");
		_GroundY = 0.0;
		nameMap.set("Animation Category", "_AnimationCategory");
		_AnimationCategory = "Falling";
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		/* Inputs: */
		/* "Facing Right?" -- <Boolean> Actor Level Attribute, from "Walking" Behavior (required) */
		/* Outputs: */
		/* "Is Falling?" -- <Boolean> Actor Level Attribute */
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(!(asBoolean(actor.getActorValue("On Ground?"))))
				{
					_customEvent_CheckFalling();
					if(!(_CanFall))
					{
						actor.say("Animation Manager", "_customBlock_ClearAnimCat", [_AnimationCategory]);
					}
				}
				else
				{
					actor.say("Animation Manager", "_customBlock_ClearAnimCat", [_AnimationCategory]);
					return;
				}
				if(!(_CanFall))
				{
					actor.setActorValue("Is Falling?", false);
				}
				else
				{
					actor.setActorValue("Is Falling?", true);
					if(asBoolean(actor.getActorValue("Facing Right?")))
					{
						actor.say("Animation Manager", "_customBlock_LoopAnim", [_FallRightAnimation, _AnimationCategory]);
					}
					else
					{
						actor.say("Animation Manager", "_customBlock_LoopAnim", [_FallLeftAnimation, _AnimationCategory]);
					}
				}
				_OldY = asNumber(actor.getY());
				propertyChanged("_OldY", _OldY);
				if(asBoolean(actor.getActorValue("On Ground?")))
				{
					_GroundY = asNumber(actor.getY());
					propertyChanged("_GroundY", _GroundY);
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}