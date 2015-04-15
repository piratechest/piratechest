{_, $, Backbone, Marionette, win, nw } = require( '../common.coffee' )

class module.exports.PeerGraph extends Marionette.ItemView
    className: 'peer-graph'
    template: _.template """
        <style>
            .node {
              stroke: #fff;
              stroke-width: 1.5px;
            }

            .link {
              stroke: white;
              stroke-opacity: .6;
            }
        </style>
    """
    initialize: ({@nodes, @links}) ->
    onShow: ->
        console.log @nodes, @links
        d3 = window.d3

        width = 400
        height = 400

        color = d3.scale.category20()

        force = d3.layout.force()
            .charge(-70)
            .chargeDistance(100)
            .linkDistance(100)
            .size([width, height])

        svg = d3.select(".peer-graph").append("svg")
            .attr("width", width)
            .attr("height", height)

        force
            .nodes(@nodes)
            .links(@links)
            .start();

        link = svg.selectAll(".link")
            .data(@links)
          .enter().append("line")
            .attr("class", "link")
            .style("stroke-width", (d) -> Math.sqrt(d.value) )

        node = svg.selectAll(".node")
            .data(@nodes)
          .enter().append("circle")
            .attr("class", "node")
            .attr("r", 10)
            .style("fill", (d) -> color( d.group ) )
            .call(force.drag)

        node.append("title")
            .text (d) -> return d.name

        force.on "tick", ->
          link.attr("x1", (d) -> d.source.x )
              .attr("y1", (d) -> d.source.y )
              .attr("x2", (d) -> d.target.x )
              .attr("y2", (d) -> d.target.y )

          node.attr("cx", (d) -> d.x )
              .attr("cy", (d) -> d.y )
