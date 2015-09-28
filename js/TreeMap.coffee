

class TreeMap
	constructor: (@el, @data)->
		@margin =
			top: 40
			right: 10
			bottom: 10
			left: 10
		@width = $(@el).width() - @margin.left - @margin.right
		@height = $(@el).height() - @margin.top - @margin.bottom
		@color = d3.scale.category20c()

		@treemap = d3.layout.treemap()
			.size([@width, @height])
			.sticky(true)
			.value((d) -> d.size)

		@div = d3.select(@el).append("div")
			.style({
				"position": "relative"
				"width": (@width)+"px"
				"height": (@height)+"px"
				"left": @margin.left+"px"
				"top": @margin.top+"px"
			})

		@node = @div.datum(@data).selectAll(".node")
			.data(@treemap.nodes)
			.enter().append("div")
			.attr("class", "node")
			.call(@position)
			.style("background", (d)=> if d.children then @color(d.name) else null)
			.text((d) -> if d.children then null else d.name)

	position: ->
		@style({
			left: (d) -> d.x+"px"
			top: (d) -> d.y+"px"
			width: (d) -> Math.max(0, d.dx-1)+"px"
			height: (d) -> Math.max(0, d.dy-1)+"px"
		})

	dimension_changed: (valFn) ->
		@node.data(@treemap.value(valFn).nodes)
			.transition()
			.duration(1500)
			.call(@position)



window.TreeMap = TreeMap
