using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.BluetoothLowEnergy as Bt;

class StepsGoalGraph extends Ui.Drawable {
    hidden var x, y, width, percentage = null;

    function initialize(params) {
        Drawable.initialize(params);

        x = params.get(:x);
        y = params.get(:y);
        width = params.get(:width);
    }
    
    function draw(dc) {    	
    	if (percentage == null || System.getClockTime().sec % 30 == 0) {
	    	var info = ActivityMonitor.getInfo();
	    	var steps = info.steps;
	    	var stepsGoal = info.stepGoal;
			
			if (stepsGoal != 0) {
				percentage = steps.toDouble() / stepsGoal.toDouble();
			}
			
			if (percentage > 1) {
				percentage = 1;
			}
    	}
    	
    	dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_DK_GRAY);
    	dc.setPenWidth(9);
    	dc.drawLine(x, y, x + width, y);
    	
    	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE);
    	dc.setPenWidth(5);
    	dc.drawLine(x, y, x + (width * percentage), y);

    	dc.setPenWidth(1);
    }
}