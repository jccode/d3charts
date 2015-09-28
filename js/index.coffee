


# init page
$ ->
	console.log 'bootstrap..'
	
	json = "data/pageclick.json" # "data/flare.json"
	d3.json json, (err, data)->
		if err
			console.log err
			return false

		# console.log data
		treemap = new TreeMap document.getElementById("treemap"), data
		treemap2 = new TreeMap2 document.getElementById("treemap2"), data

		$(".dimension input").on "change", ->
			valFn = switch @value
				when "count" then ()-> 1
				when "size" then (d)-> d.size
				else (d)-> d.size
			treemap.dimension_changed valFn
			treemap2.dimension_changed valFn
		
	# line-chart
	d3.json "data/pv.json", (err, data)->
		if err
			console.log err
			return false
			
		# console.log data
		_parse = d3.time.format("%Y-%m-%d").parse
		data.forEach (d)->
			d.date = _parse d.date
			d.value = +d.value
		linechart = new LineChart document.getElementById("linechart"), data

	# bubble chart
	d3.json "data/bubble.json", (err, data)->
		if err
			console.log err
			return false
			
		console.log data
		bubblechart = new BubbleChart document.getElementById("bubblechart"), data, "推广次数", "访问量"
		
