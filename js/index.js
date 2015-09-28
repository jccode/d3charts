// Generated by CoffeeScript 1.10.0
(function() {
  $(function() {
    var json;
    console.log('bootstrap..');
    json = "data/pageclick.json";
    d3.json(json, function(err, data) {
      var treemap, treemap2;
      if (err) {
        console.log(err);
        return false;
      }
      treemap = new TreeMap(document.getElementById("treemap"), data);
      treemap2 = new TreeMap2(document.getElementById("treemap2"), data);
      return $(".dimension input").on("change", function() {
        var valFn;
        valFn = (function() {
          switch (this.value) {
            case "count":
              return function() {
                return 1;
              };
            case "size":
              return function(d) {
                return d.size;
              };
            default:
              return function(d) {
                return d.size;
              };
          }
        }).call(this);
        treemap.dimension_changed(valFn);
        return treemap2.dimension_changed(valFn);
      });
    });
    d3.json("data/pv.json", function(err, data) {
      var _parse, linechart;
      if (err) {
        console.log(err);
        return false;
      }
      _parse = d3.time.format("%Y-%m-%d").parse;
      data.forEach(function(d) {
        d.date = _parse(d.date);
        return d.value = +d.value;
      });
      return linechart = new LineChart(document.getElementById("linechart"), data);
    });
    return d3.json("data/bubble.json", function(err, data) {
      var bubblechart;
      if (err) {
        console.log(err);
        return false;
      }
      console.log(data);
      return bubblechart = new BubbleChart(document.getElementById("bubblechart"), data, "推广次数", "访问量");
    });
  });

}).call(this);
