var version = 'v1::';

function onInstall(event) {
  event.waitUntil(
    caches.open(version + 'offline').then(function prefill(cache) {
      return cache.addAll([
        '/offline.html'
      ]);
    })
  );
};

function onActivate(event) {
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
};

function onFetch(event) {
  var request = event.request;

  if (!request.url.match(/^https?:\/\/bax.thecrucialteam.com/) ) { return; }
  if (request.method !== 'GET') { return; }

  event.respondWith(
    fetch(request)                                     
      .catch(function fallback() {
        caches.match(request).then(function(response) {
          response || caches.match("/offline.html");
        })
      })
  );
};

self.addEventListener('install', onInstall);
self.addEventListener('activate', onActivate);
self.addEventListener('fetch', onFetch);