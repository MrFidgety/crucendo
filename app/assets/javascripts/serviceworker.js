var CACHE_NAME = 'crucendo-cache-v1::';
var URLS_TO_CACHE = [
  '/offline.html'
];

self.addEventListener('install', function(event) {
  // Put `offline.html` page into cache
  // var offlineRequest = new Request('offline.html');
  // event.waitUntil(
  //   fetch(offlineRequest).then(function(response) {
  //     return caches.open(CACHE_NAME).then(function(cache) {
  //       console.log('[oninstall] Cached offline page', response.url);
  //       return cache.put(offlineRequest, response);
  //     });
  //   })
  // );
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(function(cache) {
        return cache.addAll(urlsToCache);
      })
  );
});

self.addEventListener('fetch', function(event) {
  // Only fall back for HTML documents.
  var request = event.request;
  // && request.headers.get('accept').includes('text/html')
  if (request.method === 'GET') {
    // `fetch()` will use the cache when possible, to this examples
    // depends on cache-busting URL parameter to avoid the cache.
    event.respondWith(
      fetch(request).catch(function(error) {
        // `fetch()` throws an exception when the server is unreachable but not
        // for valid HTTP responses, even `4xx` or `5xx` range.
        console.error(
          '[onfetch] Failed. Serving cached offline fallback ' +
          error
        );
        return caches.open(CACHE_NAME).then(function(cache) {
          return cache.match('offline.html');
        });
      })
    );
  }
  // Any other handlers come here. Without calls to `event.respondWith()` the
  // request will be handled without the ServiceWorker.
});