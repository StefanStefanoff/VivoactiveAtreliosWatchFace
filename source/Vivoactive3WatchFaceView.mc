using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Activity as Activity;
using Toybox.Math as Math;

class Vivoactive3WatchFaceView extends WatchUi.WatchFace {
	var moonPhase = false;
	var pressure = null;
	var altitude = null;
	var lastHr = 0;
	var hrText = null;
	var hrUpdateInterval = 20;//seconds

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
    	dc.clearClip();
        // Get and show the current time
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour.format("%02d"), clockTime.min.format("%02d")]);
        var time = View.findDrawableById("time");
        time.setText(timeString);

		// Get current heartRate and show it
		hrText = View.findDrawableById("hr");
		var currentHr = Activity.getActivityInfo().currentHeartRate;
		if (currentHr != null) {
			hrText.setText(Lang.format("$1$", [currentHr]));
		} else {
			hrText.setText("-");
		}
		
		var info = ActivityMonitor.getInfo();
		var distance = (info != null && info.distance != null) ? info.distance.toFloat() : 0;
		var distanceKm = (distance/100000).format("%2.1f");
		var diText = View.findDrawableById("dist");
		diText.setText(distanceKm);
		
		// Get current pressure and show it
		if (pressure == null || System.getClockTime().min == 0 && System.getClockTime().sec == 0) {
			var prText = View.findDrawableById("pressure");
			pressure = Activity.getActivityInfo().ambientPressure;
			if (pressure != null) {
				prText.setText(Lang.format("$1$", [Math.floor(pressure/100).toLong()]));
			} else {
				prText.setText("-");
			}
		}
		
		// Get current altitude and show it
		if (altitude == null || System.getClockTime().min == 0 && System.getClockTime().sec == 0) {
			var alText = View.findDrawableById("altitude");
			altitude = Activity.getActivityInfo().altitude;
			if (altitude != null) {
				alText.setText(Lang.format("$1$", [Math.floor(altitude).toLong()]));
			} else {
				alText.setText("-");
			}
		}
		
		// Get MoonPhase and show it
		if (moonPhase == false || System.getClockTime().min == 0 && System.getClockTime().sec == 0) {
			var moon = View.findDrawableById("moon");
			moon.setText((getMoonPhase(Time.now())).toChar().toString());
		}    
		
		var stepsGoal = View.findDrawableById("stepsGoal");
		stepsGoal.setText(info.stepGoal.toString());
		var steps = View.findDrawableById("steps");
		steps.setText(info.steps.toString());
		
		var date = View.findDrawableById("date");
		var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
		var dateString = Lang.format(
		    "$1$ $2$ $3$ $4$",
		    [
		        today.day_of_week,
		        today.month,
		        today.day,
		        today.year
		    ]
		);
		date.setText(dateString);
		    
	    var battery = View.findDrawableById("batteryPercent");
	    battery.setText(Lang.format("$1$%", [System.getSystemStats().battery.toLong()]));
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

	function onPartialUpdate(dc) {	
		// Get current heartRate and show it
		if ((System.getClockTime().sec % hrUpdateInterval) == 0) {
			var currentHr = Activity.getActivityInfo().currentHeartRate;
			if (currentHr != lastHr) {
				lastHr = currentHr;
				if (hrText == null) {
					hrText = View.findDrawableById("hr");
				}
				var w = 40;
			    var h = hrText.height;
			    var y = hrText.locY;
			    // The text is aligned to the right, so subtract the width to get x.
			    var x = hrText.locX;
			    dc.setClip(x, y, w, h);
			
			    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
			    dc.fillRectangle(x, y, w, h);
				if (currentHr != null) {
					hrText.setText(Lang.format("$1$", [currentHr]));
					hrText.draw(dc);
				} else {
					hrText.setText("-");
					hrText.draw(dc);
				}
			}
		}
	}

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

	function getMoonPhase(timeNow) {
		var JD = timeNow.value().toDouble() / Gregorian.SECONDS_PER_DAY.toDouble() + 2440587.500d;
    	var IP = Normalize((JD.toDouble() - 2451550.1d) / 29.530588853d);
    	var Age = IP * 29.53d;
    	var phase = 0;

        return Math.floor(96 + 26*(Age/29.53)).toNumber();
	}
	
	static function Normalize(value)
    {
    	var nValue = value - Math.floor(value);
    	if (nValue < 0)
    	{
    		nValue = nValue + 1;
    	}
    	return nValue;
    }
}
