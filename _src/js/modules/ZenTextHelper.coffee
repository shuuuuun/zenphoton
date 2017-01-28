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

    textToSegment: (text) ->
        console.log text
        svgPathD = @textToSVG.getD(text)
        pathList = SvgPathParser(svgPathD)
        last = { x: 0, y: 0 }
        pathList.forEach (path) =>
            path.y += 100 unless isNaN(path.y)
            path.y1 += 100 unless isNaN(path.y1)
            switch path.code
                # when 'M'
                #     @renderer.segments.push(new Segment(path.x, path.y, path.x, path.y, MATERIAL.diffuse, MATERIAL.reflective, MATERIAL.transmissive))
                when 'L'
                    # s = @renderer.segments[@renderer.segments.length - 1]
                    # [s.x1, s.y1] = [path.x, path.y] if s
                    @renderer.segments.push(new Segment(last.x, last.y, path.x, path.y, MATERIAL.diffuse, MATERIAL.reflective, MATERIAL.transmissive))
                when 'Q'
                    # @getPosOnBezje2D(last.x, last.y, path.x1, path.y1, path.x, path.y, 0.5))
                    # @renderer.segments.push(new Segment(last.x, last.y, path.x, path.y, MATERIAL.diffuse, MATERIAL.reflective, MATERIAL.transmissive))
                    @renderer.segments.push(new Segment(last.x, last.y, path.x1, path.y1, MATERIAL.diffuse, MATERIAL.reflective, MATERIAL.transmissive))
                    @renderer.segments.push(new Segment(path.x1, path.y1, path.x, path.y, MATERIAL.diffuse, MATERIAL.reflective, MATERIAL.transmissive))
                # when 'Z'
                    
            [last.x, last.y] = [path.x, path.y]
            console.log path
        @renderer.showSegments++
        # @renderer.trimSegments()
        @renderer.clear()
        @renderer.redraw()

    getPosOnBezje2D: ( x0, y0, x1, y1, cx, cy, t ) ->
      tp = 1.0 - t
      x = x0*tp*tp + 2*cx*t*tp + x1*t*t
      y = y0*tp*tp + 2*cy*t*tp + y1*t*t
      return [x, y]

module.exports = TextHelper

# parsed svg path example:
# { code:'M', command:'moveto', x:3, y:7 },
# { code:'L', command:'lineto', x:5, y:-6 },
# { code:'L', command:'lineto', x:1, y:7 },
# { code:'L', command:'lineto', x:100, y:-0.4 },
# { code:'m', command:'moveto', relative:true, x:-10, y:10 },
# { code:'l', command:'lineto', relative:true, x:10, y:0 },
# { code:'V', command:'vertical lineto', y:27 },
# { code:'V', command:'vertical lineto', y:89 },
# { code:'H', command:'horizontal lineto', x:23 },
# { code:'v', command:'vertical lineto', relative:true, y:10 },
# { code:'h', command:'horizontal lineto', relative:true, x:10 },
# { code:'C', command:'curveto', x1:33, y1:43, x2:38, y2:47, x:43, y:47 },
# { code:'c', command:'curveto', relative:true, x1:0, y1:5, x2:5, y2:10, x:10, y:10 },
# { code:'S', command:'smooth curveto', x2:63, y2:67, x:63, y:67 },
# { code:'s', command:'smooth curveto', relative:true, x2:-10, y2:10, x:10, y:10 },
# { code:'Q', command:'quadratic curveto', x1:50, y1:50, x:73, y:57 },
# { code:'q', command:'quadratic curveto', relative:true, x1:20, y1:-5, x:0, y:-10 },
# { code:'T', command:'smooth quadratic curveto', x:70, y:40 },
# { code:'t', command:'smooth quadratic curveto', relative:true, x:0, y:-15 },
# { code:'A', command:'elliptical arc', rx:5, ry:5, xAxisRotation:45, largeArc:true, sweep:false, x:40, y:20 },
# { code:'a', command:'elliptical arc', relative:true, rx:5, ry:5, xAxisRotation:20, largeArc:false, sweep:true, x:-10, y:-10 },
# { code:'Z', command:'closepath' }
