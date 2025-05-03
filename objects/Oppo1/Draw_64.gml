/// @desc draws distraction bar

draw_sprite_stretched(sDistBar, 0, DistBar_x, DistBar_y, (global.DistLevel/global.DistLevelMax)*DistBar_width, DistBar_height);
// fills in the distraction bar

//draw_sprite(sDistBarFrame, 0, DistBar_x, DistBar_y);
// draws the distraction bar's frame