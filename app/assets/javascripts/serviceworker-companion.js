if ('serviceWorker' in navigator) {
  navigator.serviceWorker
    .register('/serviceworker.js')
    .then(function() {
      console.log('[Companion]', 'Serviceworker registered.');
    })
    .catch(function() {
      console.log('[Companion]', 'Serviceworker registration failed.');
    });
}
