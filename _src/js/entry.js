require('./header');
var ZenPhotonGarden = require('./modules/ZenPhotonGarden.coffee');

var zen;

document.addEventListener('DOMContentLoaded', function() {

    zen = new ZenPhotonGarden({
        canvasId: 'histogramImage',
    });

    zen.start();

}, false);

window.addEventListener('blur', function() {

    console.log('stop');
    zen.stop();

}, false);

window.addEventListener('focus', function() {

    console.log('start');
    zen.start();

}, false);
