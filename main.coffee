_ = require 'underscore'
coords = 
	1: [0,0]
	2: [0,1]
	3: [0,2]
	4: [1,0]
	5: [1,1]
	6: [1,2]
	7: [2,0]
	8: [2,1]
	9: [2,2]

nodes_between = (n1, n2) ->
	if n1 > n2 then [n1,n2] = [n2,n1]
	switch JSON.stringify [n1,n2]
		when JSON.stringify [1,3] then [1,2,3]
		when JSON.stringify [4,6] then [4,5,6]
		when JSON.stringify [7,9] then [7,8,9]
		when JSON.stringify [1,7] then [1,4,7]
		when JSON.stringify [2,8] then [2,5,8]
		when JSON.stringify [3,9] then [3,6,9]
		when JSON.stringify [1,9] then [1,5,9]
		when JSON.stringify [3,7] then [3,5,7]
		else [n1,n2]

moves = (route, remaining) ->
	if remaining.length is 0
		return [[route, []]]
	current = _.last route
	result = []
	for node in remaining
		route_copy = JSON.parse(JSON.stringify(route))
		route_copy.push node
		inters = _.difference (nodes_between current, node), [current, node]
		if (_.intersection inters, route_copy).length > 0 then continue
		result.push [route_copy, (_.difference remaining, (nodes_between current, node))]
	return result


dist = (p) ->
	current = p[0]
	total = 0
	for n in p[1..]
		dx = coords[n][0] - coords[current][0]
		dy = coords[n][1] - coords[current][1]
		total += Math.sqrt(dx*dx + dy*dy)
		current = n
	return total

poss = []

stage1 = moves [], [1,2,3,4,5,6,7,8,9]

for [route, remaining] in stage1
	stage2 = moves route, remaining
	
	for [route2, remaining2] in stage2
		stage3 = moves route2, remaining2

		for [route3, remaining3] in stage3
			stage4 = moves route3, remaining3

			for [route4, remaining4] in stage4
				stage5 = moves route4, remaining4

				for [route5, remaining5] in stage5
					stage6 = moves route5, remaining5

					for [route6, remaining6] in stage6
						stage7 = moves route6, remaining6

						for [route7, remaining7] in stage7
							stage8 = moves route7, remaining7

							for [route8, remaining8] in stage8
								stage9 = moves route8, remaining8
								poss = poss.concat stage9
poss = _.map poss, (x) -> _.head x
console.log _.head _.sortBy (_.map poss, (p) -> [p, dist p]), ([x,v]) -> -v

