extends Node

onready var main = get_parent()
onready var text_edit = get_parent().get_node("UI/TextEdit")
onready var console = get_parent().get_node("UI/Panel/Output")
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
	
	"&",
	"&&",
	"|",
	"||",

	">",
	"<",

	"==",
	"<=",
	">=",
]

var symbols = [
	"+",
	"-",
	"/",
	"*",
	
	"&",
	"|",

	">",
	"<",
	
	"=",
	"==",
	"<=",
	">=",
	
	"(",
	")",
]

var query_table = [
	"GD_U",
	"GD_D",
	"GD_L",
	"GD_R",
	
	"GD_UL",
	"GD_UR",
	
	"GD_DL",
	"GD_DR",
	
	"GD_LU",
	"GD_LD",

	"GD_RU",
	"GD_RD",
	
	"ON_FLOOR",
	"POS",
]

var processing := false
var current_line_processed := true
var current_line :int= 1
var first_cycle := true
onready var line_timer = $Timer

var _LINE_TIME := 0.1
var _DELAY_ACTIVE := true


func reset() -> void:
	LOG.pr(2, "Analyzer RESET", "Analyzer::reset")
	stop()
	
	lines = PoolStringArray([])
	jump_table = {}
	flag_lines = []
	current_line_processed = true
	current_line = 1
	first_cycle = true
	
#	processing = false
#	text_edit.readonly = false
#	get_parent().Game.pause_mode = PAUSE_MODE_STOP


func stop() -> void:
	processing = false
	text_edit.readonly = false
	get_parent().Game.pause_mode = PAUSE_MODE_STOP


func _ready() -> void:
	add_to_group("should_reset")


func _physics_process(delta: float) -> void:
#func _process(delta: float) -> void:
	if processing:
		current_line = 0
		while current_line < lines.size():
			text_edit.cursor_set_line(current_line)
			if not run_instruction(current_line):
				break

	first_cycle = false


func run_instruction(line_number:int) -> bool:
#	LOG.pr(2, "LINE: %s" % line_number, "Analyzer::run_instruction")

	# check if comment
	if lines[line_number].begins_with("#"):
		current_line += 1
		return true

	# line is flag -> skip
	if flag_lines.has(line_number):
		if while_binds.has(lines[line_number]):
			current_line = while_binds[lines[line_number]]
		else:
			current_line += 1
		return true

	# instruction argument count assumed to be maximum 3
	var line = lines[line_number]
	var op = get_arg_left(line)
	line = strip_arg_left(line)
	
	match op:
		"JU": # Jump Unconditionally [JU] [TARGET:FLAG]
			var jump_target = get_arg_left(line)
			if !while_binds.has(jump_target) and jump_table.has(jump_target):
				current_line = jump_table[jump_target]
			else:
				LOG.pr(2, "JUMP target [%s] cannot found" % jump_target,\
				"Analyzer::run_instructions")
				assert(0)

		"JI", "JN": # Jump If | Jump Not If
			var expression = strip_arg_right(line)
			var jump_target = get_arg_right(line)
			
			var evaluation = evaluate_expression(expression)
			var target_truth_val = (op == "JI")
			
			if !while_binds.has(jump_target) and jump_table.has(jump_target):
				if bool(evaluation) == target_truth_val:
					current_line = jump_table[jump_target]
				else:
					current_line += 1
			else:
				LOG.pr(2, "jump target cannot found",\
				"Analyzer::run_instructions")
				assert(0)
		
		"VAR":
			if first_cycle:
				var target_ref = get_arg_left(line)
				var rvalue = strip_arg_left(line)
				
				if rvalue == "":
					rvalue = 0
				
				if not is_valid_var_name(target_ref):
					assert(0)
				
				if rvalue != "":
					if var_table.has(rvalue):
						var_table[target_ref] = var_table[rvalue]

					elif query_table.has(rvalue):
						var_table[target_ref] = query(rvalue)
					else:
						var_table[target_ref] =\
						evaluate_expression(rvalue)
				LOG.pr(1, "%s init as %s"\
				% [target_ref, var_table[target_ref]],\
				"Analyzer::run_instruction::match::op")
			
			current_line += 1

		"PUT": # Assignment operation A = 5, A = B, A = B + 5
			var target_ref = get_arg_left(line)
			var rvalue = strip_arg_left(line)
			if rvalue == "":
				rvalue = 0
			
			if not is_valid_var_name(target_ref):
				LOG.pr(2, "IDENTIFIER name is not valid [%s]" % target_ref,\
				"Analyzer::run_instructions")
				assert(0)
				
			if var_table.has(rvalue):
				var_table[target_ref] = var_table[rvalue]
			elif query_table.has(rvalue):
				var_table[target_ref] = query(rvalue)
			else:
				var_table[target_ref] = evaluate_expression(rvalue)
			
			current_line += 1

		"CALL":
			var func_name = get_arg_left(line)
			var func_args = strip_arg_left(line).split(" ")
			# console._print("Calling [%s]:[%s]" % [func_name, func_args])
			call_func(func_name, func_args)
			current_line += 1

		"WHILE": # WHILE EXPRESSION LABEL
			var jump_target = get_arg_right(line)
			var expression = strip_arg_right(line)
			var evaluation = evaluate_expression(expression)
			
			if while_binds.has(jump_target):
				if bool(evaluation):
					current_line += 1
				else:
					current_line = (jump_table[jump_target] + 1)
			else:
				LOG.pr(2, "WHILE BIND CANNOT FOUND: [%s]" % jump_target,\
				"Analyzer::run_instruction")
				assert(0)

		"CONTINUE":
			# go to next step
#			LOG.pr(1, "Continue", "Analyzer::run_instruction")
			return false

		"PRINT":
			var items = line.split(" ")
			var result := ""
			
			for item in items:
				var eval = evaluate_expression(item)
				result += "%s:%s ||" % [item, eval]
			
			current_line += 1
			console._print(result)
#			console._print("%s: %s" % [line, String(eval)])

		_:
			LOG.pr(2, "Warning: line skipped [%s]" % line_number,\
			"Analyzer::run_instruction")
#			evaluate_expression(lines[line_number])
			current_line += 1
	
	# continue execution of lines
	return true

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
#	emit_signal("new_analysis", output_text)



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
		LOG.pr(0, "%s :: %s" % [i, lines[i]], "Analyzer::prepass")
		var line = lines[i]
		var args = line.split(" ")
		
		if args.size() == 1:
			if is_keyword(args[0]):
				pass
			else:
				if jump_table.has(args[0]):
					# return syntax error
					LOG.pr(2, "duplicate jump_flags at [%s, %s] Flag:{%s}" %\
					[i, jump_table[args[0]], args[0]], "Analyzer::prepass")
					assert(0)
				else:
					jump_table[args[0]] = i
					GLOBAL.input_text_editor.\
						add_keyword_color(args[0], Color.green)
					flag_lines.append(i)
	
	for i in line_count:
		LOG.pr(2, "%s :: %s" % [i, lines[i]], "Analyzer::prepass")
		var line = lines[i]
		if line.begins_with("WHILE"):
			var args = strip_arg_left(line)
			var last_space = args.rfind(" ")
			var label = args.right(last_space+1)
			if not jump_table.has(label):
				assert(0)
			else:
				while_binds[label] = i
	
	LOG.pr(1, "PREPASS OK", "Analyzer::prepass")


func is_keyword(word : String) -> bool:
	return GLOBAL.keywords.has(word)


func print_jump_table() -> void:
	prints("JUMP_TABLE: -----")
	for item in jump_table:
		prints("[%s] : [%s]" % [item, jump_table[item]])
	prints("---")


func match_paranthesis(expression, it :int) -> int:
	
	var n :int= expression.length()
	var ct :int= 0
	
	while(it < n):
		
		if expression[it] == "(":
			ct += 1
		elif expression[it] == ")":
			ct -= 1
			if ct == 0:
				return it
		
		it += 1
	
	return -1
	

func evaluate_expression(expression : String):
	# get rid of spaces
	expression = expression.split(" ").join("")
	
	if expression == "":
		return ""
	
	# replace '(a)' with eval(a) {get rid of paranthesis, recursively}
	var cur :int = 0
	
	while cur < expression.length():
		# first opening paranthesis
		var it = expression.find("(", cur)
		
		if it != -1:
			var end = match_paranthesis(expression, it)
			
			if end != -1:
				# inside paranthesis
				var par_exp = expression.substr(it + 1, end - it - 1)

				# evaluate inside
				var result = String(evaluate_expression(par_exp))
				
				expression = expression.substr(0, it) + result\
				 					+ expression.substr(end+1, -1)
				cur = it + result.length()

			else:
				LOG.err("unmatched paranthesis from idx[%s]" % it,\
				"Analyzer::evaluate_expression")
				assert(0)
		else:
			break
	
	# at this point all of the parenthesized expresssions resolved
	# do evaluation from rightmost operator 
	
	expression = replace_symbols(expression)
	
	# -------------------------------------------------------
	# base case:
	# expression is a var_ref or a basicval{int,float,string}

	if is_valid_basic(expression):	
		return to_basic(expression)

	if var_table.has(expression):
		return var_table[expression]

	if query_table.has(expression):
		var result = query(expression)
#		prints("query %s result: %s" % [expression, result])
		return result


	
	# find LAST operator ---------------------------------------
	var n:int= expression.length()
	cur = -1
	var it = -1
	var op
	var op_len = 1

	while(cur < n):

		match expression[cur]:
			"+", "-", "/", "*":
				it = cur
				op = expression[cur]
				cur += 1

			"&", "|":
				var tmp = expression[cur]
				it = cur
				if cur<n-1 and expression[cur+1] == tmp:
					op = tmp + tmp
					cur += 2
				else:
					op = tmp
					cur += 1
			
			"=":
				it = cur
				if cur<n-1 and expression[cur+1] == "=":
					op = "=="
					cur += 2
				else:
					op = "="
					cur += 1
			
			"<", ">":
				it = cur
				var tmp = expression[cur]
				it = cur
				if cur<n-1 and expression[cur+1] == "=":
					op = tmp + "="
					cur += 2
				else:
					op = tmp
					cur += 1
			
			_:
				cur += 1
	
	if it < 0:
		return expression
		assert(0)

	## --------------------------------------------------

	# evaluate left and right of the operator
	var exp1 = expression.substr(0, it)
	var exp2 = expression.substr(it + op.length(), -1)

	var eval_left = evaluate_expression(exp1)
	var eval_right = evaluate_expression(exp2)

	return eval(eval_left, eval_right, op)


func replace_symbols(expression : String) -> String:
	var result := ""
	var s := expression
	var n :int= expression.length()
	var it :int= 0
	
	while(it < n):
		
		var first_letter :int= it
		
		while(first_letter < n and symbols.has(s[first_letter])):
			result += s[first_letter]
			first_letter +=1
		
		var last_letter := first_letter
		
		while(last_letter < n and not symbols.has(s[last_letter])):
			last_letter += 1
		
		# [first, last) last not included
		
		var identifier_name = s.substr(first_letter, last_letter - first_letter)
		
		if is_valid_basic(identifier_name):
			result += identifier_name
		
		elif var_table.has(identifier_name):
			result += String(var_table[identifier_name])
		
		elif query_table.has(identifier_name):
			result += String(query(identifier_name))
		
		elif identifier_name == "":
			break
		
		else:
			
			LOG.err("identifier cannot found [%s]" % identifier_name, "Analyzer::replace_symbols")
			assert(0)

		it = last_letter

	return result
	
	
func is_valid_basic(expression:String) -> bool:

	if expression.is_valid_integer():
		return true
		
	if expression.is_valid_float():
		return true

	if expression == "True" or expression == "False":
		return true
	
	return false


func to_basic(expression:String):
	
	if expression.is_valid_integer():
		return expression.to_int()

	if expression.is_valid_float():
		return expression.to_float()
	
	if expression == "True":
		return true
	elif expression == "False":
		return false
	
	return null


func is_valid_var_name(vname: String) -> bool:
	return vname.is_valid_identifier()


func call_func(fname:String, args:Array) -> void:

	match fname:
	
		"MOVE":
			Player.move(str(args[0]))
	
		"JUMP":
			Player.jump(to_basic(args[0]))
		
		"STOP":
			Player.stop()
		
		"THROW":
			if args.size() == 1:
				Player.throw_to_angle(float(args[0]))
			else:
				Player.throw_to_direction(\
					Vector2(float(args[0]), float(args[1])))
		_:
			pass


func query(qname:String):
	match qname:
		"GD_U", "GD_L", "GD_D", "GD_R", "GD_UL", "GD_LU", "GD_DR", "GD_RD",\
		"GD_UR", "GD_LD", "GD_DL", "GD_RU":
			qname = qname.right(3)
			var result :float= Player.get_dist(qname)
			if abs(result) < 0.02:
				result = 0
#			prints("query(%s) : %s" % [qname, result])
			return result
		
		"ON_FLOOR":
			return Player.on_floor()
		
		"POS":
			return GLOBAL.Player.global_position
		_:
			pass


func stv(var_str):
	return str2var(var_str)


"""
	Strip func tests:
		
	var expression = "WHILE (TESTING & ERROR ) ME"
	prints("strip_arg_left:[%s]" % strip_arg_left(expression))
	prints("get_arg_left:[%s]" % get_arg_left(expression))
	prints("strip_arg_right:[%s]" % strip_arg_right(expression))
	prints("get_arg_right:[%s]" % get_arg_right(expression))
"""

func strip_arg_left(expression : String) -> String:
	return expression.right(expression.find(" ") + 1)


func strip_arg_right(expression : String) -> String:
	return expression.substr(0, expression.rfind(" "))


func get_arg_left(expression : String) -> String:
	return expression.substr(0, expression.find(" "))


func get_arg_right(expression : String) -> String:
	return expression.right(expression.rfind(" ") + 1)


func is_operator(a) -> bool:
	return operators.has(a)


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
		
		"&" : 
			return (val1 & val2)
		
		"|" :
			return (val1 | val2)
		
		"&&":
			return (val1 && val2)
		
		"||":
			return (val1 || val2)


func _on_Analyze_pressed() -> void:
	reset()
	analyze()
	text_edit.readonly = true
	get_parent().Game.pause_mode = PAUSE_MODE_INHERIT
	processing = true
	current_line = 0


func _on_Stop_pressed() -> void:
	reset()


func _on_Reset_pressed() -> void:
	_on_Stop_pressed()
	current_line = 0
