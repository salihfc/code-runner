extends Node

var LEVEL :int= 1
# LOG LEVELS
# 0: All
# 1: TRACE
# 2: DEBUG
# 3: WARN
# 4: ERROR / FATAL

const msg_type = ["ALL  ", "TRACE", "DEBUG", "WARNING"]


func pr(level: int, log_msg, caller:String) -> void:
	if level < LEVEL: return

	var msg = str(log_msg) + " -- [%s]"%caller
	msg = msg_type[level] + " -- " + msg
	print(msg)


func err(err_msg, caller:String) -> void:

	var msg = str(err_msg) + (" [%s]"%caller)
	msg = "ERROR" + " -- " + msg
	print(msg)
