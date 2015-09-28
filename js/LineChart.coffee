
#
# data: [{date:yyyy-MM-dd, value:xx}, ...]
# 
class LineChart
	constructor: (@el, @data) ->
		@margin =
			top: 20
			right: 20
			bottom: 30
			left: 50
		@width = $(@el).width() - @margin.left - @margin.right
		@height = $(@el).height() - @margin.top - @margin.bottom
		@x = d3.time.scale().range [0, @width]
		@y = d3.scale.linear().range [@height, 0]

		@xAxis = d3.svg.axis()
			.scale @x
			.orient "bottom"
			.tickFormat d3.time.format "%d"
		@yAxis = d3.svg.axis()
			.scale @y
			.orient "left"

		line = d3.svg.line()
			.x (d)=> @x d.date
			.y (d)=> @y d.value

		@svg = d3.select @el
			.append "svg"
			.attr {
				width: @width + @margin.left + @margin.right
				height: @height + @margin.top + @margin.bottom
				}
			.append "g"
			.attr "transform", "translate(#{@margin.left}, #{@margin.top})"

		@x.domain d3.extent @data, (d)-> d.date
		@y.domain d3.extent @data, (d)-> d.value

		@svg.append "g"
			.attr {
				"class": "x axis"
				transform: "translate(0, #{@height})"
				}
			.call @xAxis

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
			.text "pv (次数)"

		@svg.append "path"
			.datum @data
			.attr {
				"class": "line"
				"d": line
				}



window.LineChart = LineChart

