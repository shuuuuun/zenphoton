TextToSVG = require 'text-to-svg'
SvgPathParser = require 'svg-path-parser'
Segment = require './ZenSegment.coffee'

FONT_URL = '/fonts/Noto_Sans/NotoSans-Regular.ttf'
MATERIAL = {
    diffuse: 1.0,
    reflective: 0.0,
    transmissive: 0.0,
}


class TextHelper
    constructor: (@renderer) ->

        TextToSVG.load(FONT_URL, (err, textToSVG) =>
            @textToSVG = textToSVG

            @textToSegment('hello')
        )

    lineToolBegin: (e) ->
        @undo.checkpoint()

        [x, y] = @mouseXY e
        @renderer.segments.push(new Segment(x, y, x, y, MATERIAL.diffuse, MATERIAL.reflective, MATERIAL.transmissive))

        @drawingSegment = true
        @renderer.showSegments++
        @renderer.redraw()

    lineToolMove: (e) ->
        # Update a line segment previously started with beginLine

        s = @renderer.segments[@renderer.segments.length - 1]
        [s.x1, s.y1] = @mouseXY e if s

        @renderer.clear()   # Asynchronously start rendering the new scene
        @renderer.redraw()  # Immediately draw the updated segments

    lineToolEnd: (e) ->
        @renderer.trimSegments()
        @renderer.showSegments--
        @renderer.redraw()
        # @updateLink()
        @drawingSegment = false

    textToSegment: (text) ->
        svgPathD = @textToSVG.getD(text)
        pathList = SvgPathParser(svgPathD)
        last = { x: 0, y: 0 }
        pathList.forEach (path) =>
            # path.x *= 100
            # path.y *= 100
            # path.x *= 100
            path.y += 100
            switch path.code
                when 'M'
                    @renderer.segments.push(new Segment(path.x, path.y, path.x, path.y, MATERIAL.diffuse, MATERIAL.reflective, MATERIAL.transmissive))
                when 'L'
                    s = @renderer.segments[@renderer.segments.length - 1]
                    [s.x1, s.y1] = [path.x, path.y] if s
                when 'Q'
                    # for ()
                    # @getPosOnBezje2D(last.x, last.y, path.x1, path.y1, path.x, path.y, 0.5))
                    @renderer.segments.push(new Segment(path.x1, path.y1, path.x, path.y, MATERIAL.diffuse, MATERIAL.reflective, MATERIAL.transmissive))
                    
            [last.x, last.y] = [path.x, path.y]
            console.log path, @renderer.segments
        @renderer.showSegments++
        # @renderer.trimSegments()
        @renderer.clear()
        @renderer.redraw()

    getPosOnBezje2D: ( x0, y0, x1, y1, cx, cy, t ) ->
      tp = 1.0 - t
      x = x0*tp*tp + 2*cx*t*tp + x1*t*t
      y = y0*tp*tp + 2*cy*t*tp + y1*t*t
      return [x, y]

# function getPosOnBezje2D(x0, y0, x1, y1, cx, cy, t) {
#   var tp = 1.0 - t;
#   return [x0*tp*tp + 2*cx*t*tp + x1*t*t, y0*tp*tp + 2*cy*t*tp + y1*t*t];
# }

module.exports = TextHelper
