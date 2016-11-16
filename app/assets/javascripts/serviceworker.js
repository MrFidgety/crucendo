var version = 'v1::';

function onInstall(event) {
  console.log('[Serviceworker]', "Installing!");
  event.waitUntil(
    caches.open(version + 'offline').then(function prefill(cache) {
      return cache.addAll([
        '/offline.html'
      ]);
    })
  );
}

function onActivate(event) {
  console.log('[Serviceworker]', "Activating!");
  event.waitUntil(
    caches.keys().then(function deleteOldCache(cacheNames) {
      return Promise.all(
        cacheNames.filter(function(cacheName) {
          return key.indexOf(version) !== 0;
        }).map(function(cacheName) {
          return caches.delete(cacheName);
        })
      );
    })
  );
}

function onFetch(event) {
  var request = event.request;

  if (!request.url.match(/^https?:\/\/example.com/) ) { return; }
  if (request.method !== 'GET') { return; }

  event.respondWith(
    fetch(request)                                      // first, the network
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