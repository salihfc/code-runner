extends Node

onready var main = get_parent()
onready var text_edit = get_parent().get_node("UI/TextEdit")
onready var output = get_parent().get_node("UI/Panel/Output")
onready var Player = get_parent().get_node("PlayerController")

signal new_analysis(text)

var lines := PoolStringArray([])

var jump_table = {
	"flag_name" : "line",
}

var flag_lines = []

var var_table = {
	"variable_name" : "value",
}

var processing := false
var current_line_processed := true
var current_line :int= 1
onready var line_timer = $Timer

var _LINE_TIME := 0.1
var _DELAY_ACTIVE := true

func reset() -> void:
	lines = PoolStringArray([])
	jump_table = {}
	flag_lines = []
	processing = false
	current_line_processed = true
	current_line = 1


func _process(delta: float) -> void:
	
	if processing and current_line < lines.size():
		text_edit.cursor_set_line(current_line)
		
		if current_line_processed and ((not _DELAY_ACTIVE) or line_timer.time_left < 0.01): # go to next line
			current_line_processed = false
			prints("current line: [%s]" % current_line)
			line_timer.start(_LINE_TIME)
			process_line(current_line)
			current_line_processed = true
	elif current_line == lines.size():
		current_line = 0

func process_line(line_number:int) -> void:

	if flag_lines.has(line_number): # line is flag line
		current_line += 1
		return

	var args = lines[line_number].split(" ", 3)
	var key = args[0]
	
	match key:
		"JU":
			var jump_target = args[1]
			if jump_table.has(jump_target):
				current_line = jump_table[jump_target]
			else:
				assert(0)
		"JI", "JN":
			var target_truth_val = (key == "JI")
			var jump_target = args[2]
			if jump_table.has(jump_target):
				if bool(evaluate_expression(args[1])) == target_truth_val:
					current_line = jump_table[jump_target]
				else:
					current_line += 1
			else:
				assert(0)
		"PUT":
			var target_ref = args[1]
			var source_ref_or_val = args[2]
			
			if not is_valid_var_name(target_ref):
				assert(0)
				
			if var_table.has(source_ref_or_val):
				var_table[target_ref] = var_table[source_ref_or_val]
			else:
				var_table[target_ref] = evaluate_expression(args[2])
			
			current_line += 1
			
		"CALL":
			var func_name = args[1]
			var func_args = args[2].split(" ")
			call_func(func_name, func_args)
			current_line += 1
		_:
			prints("line couldnot processed [%s]" % line_number)
			assert(0)
			pass
	

func analyze() -> void:
	var input_text = text_edit.text
	var output_text = ""
	
	lines = split(input_text, "\n")
	validate()
	prepass() # Readies Jump flags, evaluates constexprs
	print_jump_table()
	output_text = lines.join("\n")
#	prints("analyze : %s -> %s" % [input_text, output_text])
	emit_signal("new_analysis", output_text)



func split(text:String, delim:String) -> PoolStringArray:
	return text.split(delim, false)


func parse_line(line:String) -> void:
	
	var args = line.split(" ", false, 3)
	

func validate() -> void:
	# validate code
	pass


"""
Prepass:
	build flag_table
"""

func prepass() -> void:
	
	var line_count = lines.size()
	
	for i in line_count:
		prints("%s :: %s" % [i, lines[i]])
		var line = lines[i]
		var args = line.split(" ")
		
		if args.size() == 1:
			if is_keyword(args[0]):
				pass
			else:
				if jump_table.has(args[0]):
					# return syntax error
					prints("duplicate jump_flags at [%s, %s] Flag:{%s}" % [i, jump_table[args[0]], args[0]])
					assert(0)
				else:
					jump_table[args[0]] = i
					flag_lines.append(i)
		

func is_keyword(word : String) -> bool:
	
	return false


func print_jump_table() -> void:
	
	prints("JUMP_TABLE:\n")
	
	for item in jump_table:
		prints("[%s] : [%s]" % [item, jump_table[item]])
		
	prints("\n")


func evaluate_expression(expression : String):
	# base case:
	# expression is a var_ref or a basicval{int,float,string}
	if var_table.has(expression):
		return var_table[expression]
	
	if is_valid_basic(expression):
		return to_basic(expression)
	
	# recur
	# find last operator
	
	var it = expression.length() - 1
	
	while(it >= 0):
		if is_operator(expression[it]):
			break
		it-=1
	
	if it == -1: # edge
		return 0
	
	var exp2 = expression.substr(it+1, -1)
	var exp1 = expression.substr(0, it)
	
	var eval_left = evaluate_expression(exp1)
	var eval_right = evaluate_expression(exp2)
	
	return eval(eval_left, eval_right, expression[it])


func is_valid_basic(expression:String) -> bool:

	if expression.is_valid_integer():
		return true
		
	if expression.is_valid_float():
		return true
	
	return false


func to_basic(expression:String):
	
	if expression.is_valid_integer():
		return expression.to_int()

	if expression.is_valid_float():
		return expression.to_float()
	
	return


func is_valid_var_name(vname: String) -> bool:
	return vname.is_valid_identifier()


func call_func(fname:String, args:Array) -> void:

	match fname:
	
		"MOVE":
			Player.move(str(args[0]))
	
		"JUMP":
			Player.jump(to_basic(args[0]))
		
		"THROW":
			if args.size() == 1:
				Player.throw_to_angle(float(args[0]))
			else:
				Player.throw_to_direction(Vector2(float(args[0]), float(args[1])))
		_:
			pass


func query(qname:String):
	
	match qname:
		"GD_U":
			return Player.get_dist_up()
		"GD_L":
			return Player.get_dist_left()
		"GD_D":
			return Player.get_dist_down()
		"GD_R":
			return Player.get_dist_right()
		_:
			pass


func stv(var_str):
	return str2var(var_str)


func is_operator(a) -> bool:
	
	return (a == '+') \
		|| (a == '-') \
		|| (a == '/') \
		|| (a == '*') \
		|| (a == '>') \
		|| (a == '<') \
		|| (a == '==') \
		|| (a == '>=') \
		|| (a == '<=') \


func eval(val1, val2, operator):
	
	match operator:
		"+":
			return val1 + val2
		"-":
			return val1 - val2
		"/":
			return val1 / val2
		"*":
			return val1 * val2

		">":
			return (val1 > val2)
		"<":
			return (val1 < val2)

		">=":
			return (val1 >= val2)
		"<=":
			return (val1 <= val2)

		"==":
			return (val1 == val2)


func _on_Analyze_pressed() -> void:
	reset()
	analyze()
	text_edit.readonly = true
	get_parent().Game.pause_mode = PAUSE_MODE_INHERIT
	processing = true
	current_line = 0


func _on_Stop_pressed() -> void:
	reset()
	text_edit.readonly = false
	get_parent().Game.pause_mode = PAUSE_MODE_STOP
	processing = false
#	current_line = 0
