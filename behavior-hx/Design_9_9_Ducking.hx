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



class Design_9_9_Ducking extends ActorScript
{
	public var _DuckKey:String;
	public var _DuckRightAnimation:String;
	public var _DuckLeftAnimation:String;
	public var _AnimationCategory:String;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Duck Key", "_DuckKey");
		nameMap.set("Duck Right Animation", "_DuckRightAnimation");
		nameMap.set("Duck Left Animation", "_DuckLeftAnimation");
		nameMap.set("Animation Category", "_AnimationCategory");
		_AnimationCategory = "Ducking";
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		/* Inputs:--------------------- */
		/* "Facing Right?" -- <Boolean> Actor Level Attribute, set in "Walking" Behavior (required) */
		/* Outputs:------------------- */
		/* "Is Ducking?" -- <Boolean> Actor Level Attribute */
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(isKeyDown(_DuckKey))
				{
					actor.setActorValue("Is Ducking?", true);
					if(asBoolean(actor.getActorValue("Facing Right?")))
					{
						actor.say("Animation Manager", "_customBlock_LoopAnim", [_DuckRightAnimation, _AnimationCategory]);
					}
					else
					{
						actor.say("Animation Manager", "_customBlock_LoopAnim", [_DuckLeftAnimation, _AnimationCategory]);
					}
				}
				else
				{
					actor.setActorValue("Is Ducking?", false);
					actor.say("Animation Manager", "_customBlock_ClearAnimCat", [_AnimationCategory]);
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}