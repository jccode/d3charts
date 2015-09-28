

class TreeMap2
	constructor: (@el, @data) ->
		@width = $(@el).width()
		@height = $(@el).height()
		@x = d3.scale.linear().range([0, @width])
		@y = d3.scale.linear().range([0, @height])
		@color = d3.scale.category20c()
		@node = @root = @data

		@treemap = d3.layout.treemap()
			.round false
			.size [@width, @height]
			.sticky true
			.value (d)-> d.size

		@svg = d3.select(@el).append("div")
			.attr "class", "chart"
			.style {
				width: @width+"px"
				height: @height+"px"
				}
			.append "svg:svg"
			.attr "width", @width
			.attr "height", @height
			.append "svg:g"
			.attr "transform", "translate(.5,.5)"

		@nodes = @treemap.nodes(@data)
			.filter (d)-> not d.children

		cell = @svg.selectAll("g")
			.data @nodes
			.enter()
			.append "svg:g"
			.attr "class", "cell"
			.attr "transform", (d)-> "translate(#{d.x},#{d.y})"
			.on "click", (d)=> @zoom if @node is d.parent then @root else d.parent

		cell.append "svg:rect"
			.attr {
				width: (d)-> d.dx - 1
				height: (d)-> d.dy - 1
				fill: (d)=> @color d.parent.name
				}

		cell.append "svg:text"
			.attr {
				x: (d)-> d.dx / 2
				y: (d)-> d.dy / 2
				dy: ".35em"
				"text-anchor": "middle"
				}
			.text (d)-> d.name
			.style "opacity", (d)->
				d.w = @getComputedTextLength()
				if d.dx > d.w then 1 else 0

		d3.select(@el).on "click", ()=> @zoom @root
			

	zoom: (d) =>
		kx = @width / d.dx
		ky = @height / d.dy
		@x.domain [d.x, d.x + d.dx]
		@y.domain [d.y, d.y + d.dy]
		
		t = @svg.selectAll "g.cell"
			.transition()
			# .duration if d3.event.altKey then 7500 else 750
			.duration 750
			.attr "transform", (d)=> "translate( #{@x(d.x)}, #{@y(d.y)})"

		t.select "rect"
			.attr "width", (d)-> kx * d.dx - 1
			.attr "height", (d)-> ky * d.dy - 1

		t.select "text"
			.attr "x", (d)-> kx * d.dx / 2
			.attr "y", (d)-> ky * d.dy / 2
			.style "opacity", (d)-> if kx * d.dx > d.w then 1 else 0

		@node = d
		d3.event && d3.event.stopPropagation()

	dimension_changed: (valFn)->
		@treemap.value(valFn).nodes(@root)
		@zoom @node
		


window.TreeMap2 = TreeMap2
