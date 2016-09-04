require('./header');
var ZenPhotonGarden = require('./modules/ZenPhotonGarden.coffee');

document.addEventListener('DOMContentLoaded', function() {

    var zen = new ZenPhotonGarden({
        canvasId: 'histogramImage',
    });

    zen.start();

}, false);
