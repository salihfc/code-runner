extends Node

var q = []

var SIZE :int= 10
var THRESHOLD :float= 0.0001 

func push(f : float):
	q.push_back(f)
	
	if q.size() > SIZE:
		q.pop_front()

func is_same() -> bool:
	if q.size() != SIZE:
		return false
	
	for i in q:
		if abs(q[0] - i) > THRESHOLD:
			return false
	return true
