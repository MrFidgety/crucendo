var version = 'v1::';
var CACHE_NAME = 'crucendo-cache-v1::';
var urlsToCache = [
  '/offline.html'
];

function onInstall(event) {
  console.log('[Serviceworker]', "Installing.");
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(function (cache) {
        console.log('[Serviceworker]',"Opened Cache.");
        return cache.addAll(urlsToCache);
    })
  );
}

// function onActivate(event) {
//   console.log('[Serviceworker]', "Activating!");
//   event.waitUntil(
//     caches.keys().then(function (cacheNames) {
//       return Promise.all(
//         cacheNames.filter(function(cacheName) {
//           return cacheName.indexOf(version) !== 0;
//         }).map(function(cacheName) {
//           return caches.delete(cacheName);
//         })
//       );
//     })
//   );
// }

function onFetch(event) {
  
  event.respondWith(
    caches.match(event.request).then(function(resp) {
      return resp || fetch(event.request).then(function(response) {
        caches.open(CACHE_NAME).then(function(cache) {
          cache.put(event.request, response.clone());
        });
        return response;
      });
    }).catch(function() {
      return caches.match('/offline.html');
    })
  );
  //var request = event.request;

  //if (!request.url.match(/^https?:\/\/example.com/) ) { return; }
  //if (request.method !== 'GET') { return; }

  // event.respondWith(
  //   fetch(request).catch(function () {
  //     caches.match(request).then(function(response) {
  //       response || caches.match("/offline.html");
  //     })
  //   })
  //);
}

self.addEventListener('install', onInstall);
//self.addEventListener('activate', onActivate);
self.addEventListener('fetch', onFetch);
