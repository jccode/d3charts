
class BubbleChart
	constructor: (@el, @data, @xTitle, @yTitle) ->
		@margin =
			top: 20
			right: 20
			bottom: 30
			left: 50
		@width = $(@el).width() - @margin.left - @margin.right
		@height = $(@el).height() - @margin.top - @margin.bottom
		@color = d3.scale.category20c()
		@r = 20
		
		@x = d3.scale.linear()
			.range [0, @width]
			# .domain d3.extent @data, (d)-> d.value1
			.domain [0, (d3.max @data, (d)-> d.value1) + @r*2]
		@y = d3.scale.linear()
			.range [@height, 0]
			# .domain d3.extent @data, (d)-> d.value2
			.domain [0, (d3.max @data, (d)-> d.value2) + @r*2]

		@xAxis = d3.svg.axis()
			.scale @x
			.orient "bottom"
		@yAxis = d3.svg.axis()
			.scale @y
			.orient "left"

		@svg = d3.select @el
			.append "svg"
			.attr {
				width: @width + @margin.left + @margin.right
				height: @height + @margin.top + @margin.bottom
				}
			.append "g"
			.attr "transform", "translate(#{@margin.left}, #{@margin.top})"

		@svg.append "g"
			.attr {
				"class": "x axis"
				transform: "translate(0, #{@height})"
				}
			.call @xAxis
			.append "text"
			.attr {
				x: @width
				y: -12
				dx: ".71em"
				}
			.style "text-anchor", "end"
			.text @xTitle

		@svg.append "g"
			.attr "class", "y axis"
			.call @yAxis
			.append "text"
			.attr {
				transform: "rotate(-90)"
				y: 6
				dy: ".71em"
				}
			.style "text-anchor", "end"
			.text @yTitle

		@node = @svg.selectAll ".node"
			.data @data
			.enter()
			.append "g"
			.attr {
				"class": "node"
				transform: (d)=> "translate(#{@x(d.value1)}, #{@y(d.value2)})"
				}

		@node.append "title"
			.text (d)-> "#{d.name} (#{d.value1}, #{d.value2})"

		@node.append "circle"
			.attr "r", (d)=> @r
			.style "fill", (d)=> @color d.name

		@node.append "text"
			.attr "dy", ".3em"
			.style "text-anchor", "middle"
			.text (d)-> d.name # d.name.substring 0, d.r/3
		


		
window.BubbleChart = BubbleChart
