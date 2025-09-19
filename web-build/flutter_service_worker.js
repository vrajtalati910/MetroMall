'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "dc14b05a5563d90d3024e2acf87f59df",
"version.json": "567e1f6339d878d5b3379cb3ebdc1147",
"index.html": "bb9acd43f2475886e6a8eb9db7897dcc",
"/": "bb9acd43f2475886e6a8eb9db7897dcc",
"main.dart.js": "e00fc8d4de7d1aad51774c1ca76daca7",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"favicon.png": "bb92623364269c23d5ae48306684d0ae",
"icons/Icon-192.png": "a66c91ef3b46d9581eb856bffeb47da8",
"icons/Icon-maskable-192.png": "779020f2be19f42864b6198cf0e1e07f",
"icons/Icon-maskable-512.png": "12d2d761458990afe7ede681cc2ede3e",
"icons/Icon-512.png": "2855448ae48b136e4b62cd072cafe135",
"manifest.json": "61f209fbcbd7401d3b83abf66a662d22",
"assets/AssetManifest.json": "0270fccf2585a1c9070001658423fb58",
"assets/NOTICES": "206b18a25738179588dafedd0fc7e71d",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "a1d3154160e3ed7c6ec77450b996f4c2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "a084a59c4aec78eeafff4aeb44135d05",
"assets/fonts/MaterialIcons-Regular.otf": "9a416f9438f3f8865a46d66b5deca45f",
"assets/assets/images/app_icon.png": "1126f8c25e8ca793a2b03925a3c3c632",
"assets/assets/icon/items.png": "8b712ba6a0014db2ba3f5d30d1d5f292",
"assets/assets/icon/alarm_icon.png": "7d117686c9c81c905410a3d7dd6ed43e",
"assets/assets/icon/resources_icon.svg": "fd44f870a07bd15a7929672de63fb158",
"assets/assets/icon/close_eye.svg": "df99ca2303ca1735bb6a528c894fe198",
"assets/assets/icon/down_arrow_icon.svg": "900ddaff7eb80c7eaa81c694f945749d",
"assets/assets/icon/certificate_icon.svg": "90ef5a751278edd10449f0b9b21b55cd",
"assets/assets/icon/home_icon.svg": "0db36f8bca00677f509eed65a27c8f88",
"assets/assets/icon/edit_icon.svg": "62c0a97603245152caee7792c25c9180",
"assets/assets/icon/terms_icon.png": "ede4fb17230e13cf149ba6878a9d5e2a",
"assets/assets/icon/success_icon.png": "a61184e86240ee030a8fc22e2af48ee1",
"assets/assets/icon/download_icon.svg": "35279beedf3a1db5f18a68090635f5e8",
"assets/assets/icon/customer.png": "13fa7c5eecd7c68dd21e7e622a98cf49",
"assets/assets/icon/close_icon.svg": "4169a72235544e8da7aee30c4100336d",
"assets/assets/icon/notification_icon.png": "f9ef7b0cb68f280347dbf4ea1042c619",
"assets/assets/icon/message_question_icon.png": "41d83c0dd795b7b6b1dbb0d236f1b4dc",
"assets/assets/icon/measurement.png": "b791566c1459bffb88256c6209509595",
"assets/assets/icon/profile.png": "732caf2623e6fabfa9160b2960dff2ab",
"assets/assets/icon/history_icon.svg": "a346110806a1de2ed89c987fb3110bc7",
"assets/assets/icon/clock_icon.svg": "50a91bfbd49c7fd96065a321d05833f7",
"assets/assets/icon/achievemnet_icon.svg": "b772c199107d0eaeb0e85170b44e5639",
"assets/assets/icon/share.svg": "47f503a1614573a395df09bab93f0c9b",
"assets/assets/icon/setting_icon.png": "3aebf8efce5ded284eb16bf62a34997a",
"assets/assets/icon/right_arrow_icon.svg": "419a792e961fad82cd2fd7827b0cfbfd",
"assets/assets/icon/left_arrow_icon.svg": "de3501d6d8eef344b2638d03ada464ae",
"assets/assets/icon/crown_icon.png": "b43705c91d392798a3d8eda7863bea03",
"assets/assets/icon/open_eye.svg": "e7fa59f835ea23e2d9f317f68933f387",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
