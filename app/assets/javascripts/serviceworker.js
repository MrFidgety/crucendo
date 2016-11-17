var CACHE_NAME = 'crucendo-cache-v1::';
var URLS_TO_CACHE = [
  '/offline.html'
];

self.addEventListener('install', function(event) {
  // Perform install step:  loading each required file into cache
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(function(cache) {
        // Add all offline dependencies to the cache
        return cache.addAll(URLS_TO_CACHE);
      })
      .then(function() {
      	// At this point everything has been cached
        return self.skipWaiting();
      })
  );
});

self.addEventListener('fetch', function(event) {
  event.respondWith(
    fetch(event.request)
      .catch(function () {
        caches.match(event.request)
          .then(function (response) {
            return response
          })
          .catch(function () {
            return caches.match("/offline.html")
          })
      })
    // caches.match(event.request)
    //   .then(function(response) {
    //     // Cache hit - return the response from the cached version
    //     if (response) {
    //       return response;
    //     }

    //     // Not in cache - return the result from the live server
    //     // `fetch` is essentially a "fallback"
    //     return fetch(event.request);
    //   }
    // )
  );
});