function onInstall(event) {
  console.log('[Serviceworker]', "Installing!");
  event.waitUntil(
    caches.open('cached-assets-v1').then(function prefill(cache) {
      return cache.addAll([
        '/offline.html',
      ]);
    })
  );
}

function onActivate() {
  console.log('[Serviceworker]', "Activating!");
}

function onFetch(event) {
  // Fetch from network, fallback to cached content, then offline.html for same-origin GET requests
  var request = event.request;

  //if (!request.url.match(/^https?:\/\/example.com/) ) { return; }
  if (request.method !== 'GET') { return; }

  event.respondWith(
    fetch(request)                                       // first, the network
      .catch(function fallback() {
         caches.match(request).then(function(response) {  // then, the cache
           response || caches.match("/offline.html");     // then, /offline cache
         })
       })
  );
}

self.addEventListener('install', onInstall);
self.addEventListener('activate', onActivate);
self.addEventListener('fetch', onFetch);
