var CACHE_NAME = 'crucendo-cache-v1::';
var URLS_TO_CACHE = [
  '/offline.html'
];

self.addEventListener('install', function(event) {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(function(cache) {
        //console.log('[Serviceworker]', '[Install] Cached URLs required offline.');
        return cache.addAll(URLS_TO_CACHE);
      })
  );
});

self.addEventListener('fetch', function(event) {
  var request = event.request;
  if (request.method === 'GET') {
    event.respondWith(
      caches.match(event.request).then(function(response) {
        return response || fetch(event.request);
      }).catch(function() {
        return caches.match('offline.html');
      })
    );
  }
});