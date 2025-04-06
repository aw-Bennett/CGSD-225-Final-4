/// @DnDAction : YoYo Games.Common.If_Expression
/// @DnDVersion : 1
/// @DnDHash : 66E55D96
/// @DnDArgument : "expr" "global.DistLevel == 0"
if(global.DistLevel == 0)
{
	/// @DnDAction : YoYo Games.Common.Set_Global
	/// @DnDVersion : 1
	/// @DnDHash : 0D0C172B
	/// @DnDParent : 66E55D96
	/// @DnDArgument : "value" "25"
	/// @DnDArgument : "value_relative" "1"
	/// @DnDArgument : "var" "global.DistLevel"
	global.DistLevel += 25;

	/// @DnDAction : YoYo Games.Instances.Change_Instance
	/// @DnDVersion : 1
	/// @DnDHash : 6F8E184C
	/// @DnDParent : 66E55D96
	/// @DnDArgument : "objind" "Dist1u"
	/// @DnDSaveInfo : "objind" "Dist1u"
	instance_change(Dist1u, true);
}