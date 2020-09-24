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

var while_binds = {
	"label_name" : "wrap_to"
}

var var_table = {
	"variable_name" : "value",
}

var operators = [
	"+",
	"-",
	"/",
	"*",

	">",
	"<",

	"==",
	"<=",
	">=",
]

var query_table = [
	"GD_U",
	"GD_D",
	"GD_L",
	"GD_R",
]

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
		
		if current_line_processed and\
			((not _DELAY_ACTIVE) or line_timer.time_left < 0.01): 
			# go to next line
			
			current_line_processed = false
#			prints("current line: [%s]" % current_line)
			line_timer.start(_LINE_TIME)
			run_instruction(current_line)
			current_line_processed = true
#	elif current_line == lines.size():
#		current_line = 0

func run_instruction(line_number:int) -> void:

	# line is flag -> skip
	if flag_lines.has(line_number):
		if while_binds.has(lines[line_number]):
			current_line = while_binds[lines[line_number]]
		else:
			current_line += 1
		return

	# instruction argument count assumed to be maximum 3
	var args = lines[line_number].split(" ", 3)
	var op = args[0]
	
	match op:
		"JU": # Jump Unconditionally [JU] [TARGET:FLAG]
			var jump_target = args[1]
			if !while_binds.has(jump_target) and jump_table.has(jump_target):
				current_line = jump_table[jump_target]
			else:
				assert(0)
		"JI", "JN": # Jump If | Jump Not If
			var target_truth_val = (op == "JI")
			var jump_target = args[2] # [JI] [EXP] [TARGET]
			if !while_binds.has(jump_target) and jump_table.has(jump_target):
				var evaluation = evaluate_expression(args[1])
				if bool(evaluation) == target_truth_val:
					current_line = jump_table[jump_target]
				else:
					current_line += 1
			else:
				assert(0)
		"PUT": # Assignment operation A = 5, A = B, A = B + 5
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

		"WHILE": # WHILE EXPRESSION LABEL
			var jump_target = args[2] # [JI] [EXP] [TARGET]
			var evaluation = evaluate_expression(args[1])
			
			if while_binds.has(jump_target):
				if bool(evaluation):
					current_line += 1
				else:
					current_line = (jump_table[jump_target] + 1)
			else:
				assert(0)
				
		_:
#			prints("Warning: line skipped [%s]" % line_number)
			evaluate_expression(op)
			current_line += 1
			pass
	


"""
	analyze:
		take the code from input window and start processing
"""
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
					prints("duplicate jump_flags at [%s, %s] Flag:{%s}" %\
					[i, jump_table[args[0]], args[0]])
					assert(0)
				else:
					jump_table[args[0]] = i
					GLOBAL.input_text_editor.\
						add_keyword_color(args[0], Color.green)
					flag_lines.append(i)
	
	for i in line_count:
		prints("%s :: %s" % [i, lines[i]])
		var line = lines[i]
		var args = line.split(" ")
		if args[0] == "WHILE":
			var label = args[2]
			
			if not jump_table.has(label):
				assert(0)
			else:
				while_binds[label] = i

func is_keyword(word : String) -> bool:
	return GLOBAL.keywords.has(word)


func print_jump_table() -> void:
	prints("JUMP_TABLE: -----")
	for item in jump_table:
		prints("[%s] : [%s]" % [item, jump_table[item]])
	prints("---")


func evaluate_expression(expression : String):
	# base case:
	# expression is a var_ref or a basicval{int,float,string}
	if var_table.has(expression):
		return var_table[expression]
	
	if query_table.has(expression):
		var result = query(expression)
		prints("query %s result: %s" % [expression, result])
		return result
	
	if is_valid_basic(expression):
		return to_basic(expression)
	
	# recur
	# find last operator
	#var it = expression.length() - 1
	
	#while(it >= 0):
	#	if is_operator(expression[it]):
	#		break
	#	it-=1
	
	# if it == -1: # edge
		# return 0

	var it = -1
	var op
	var op_len = 1

	for operator in operators:
#		prints("operator: [%s]" % operator)
		var found = expression.find_last(operator)

		if (found > it):
			it = found
			op = operator
			op_len = operator.length()
			
	if it == -1:
		assert(0)

	var exp1 = expression.substr(0, it)
	var exp2 = expression.substr(it + op_len, -1)
	
	var eval_left = evaluate_expression(exp1)
	var eval_right = evaluate_expression(exp2)
	
	return eval(eval_left, eval_right, op)


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
				Player.throw_to_direction(\
					Vector2(float(args[0]), float(args[1])))
		_:
			pass


func query(qname:String):
	
	prints("query_called [%s]" % qname)
	
	match qname:
		"GD_U", "GD_L", "GD_D", "GD_R":
			var result = Player.get_dist(qname.lstrip("GD_"))
			prints("qname : %s" % result)
			return result
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
