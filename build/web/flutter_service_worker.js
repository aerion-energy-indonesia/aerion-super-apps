'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "f85711b53113cb9f9f8aa4e2401d5405",
"assets/AssetManifest.bin.json": "7a64f2088efc9ed81487c1b745367ba2",
"assets/AssetManifest.json": "00346102a988b2e6ec8b9044d0669fca",
"assets/assets/images/icons/alert_triangle.png": "792c4afb4ab8b8b1e6f22b4181b719f6",
"assets/assets/images/icons/monitor.png": "cb34f5759f768958b682ecf9dbae0c9c",
"assets/assets/images/icons/user.png": "20d0795fa61ffe2d616ff9fc28dac879",
"assets/assets/images/logo/aerion-icon.png": "7e2d3f91d808606d88b7665d1a47417e",
"assets/assets/images/logo/aerion-logo.png": "b4bb1c4b2e0bc7e2c47d84e0ed904782",
"assets/assets/images/logo/aerion.png": "89ead0feddc71731b088fe953216ed0c",
"assets/assets/images/logo/hres.png": "b59b51c17e60f177ae18cdf45ca89ecf",
"assets/assets/images/logo/isuzu.png": "928ec889b98f410b6037aa6fe34efec6",
"assets/assets/images/logo/komatsu.png": "ee8e41582c0b8d85220400c39a7490c3",
"assets/assets/images/logo/kui.png": "bfba418ac3b7992caabb5cf73c7526d4",
"assets/assets/images/logo/pertamina.png": "5dbb83158f02be67b5cdec8fbb4bc499",
"assets/assets/images/logo/telkom.png": "8c30ea80c22c232ac5d9dbe314cb5766",
"assets/assets/images/placeholder/placeholder.png": "b2c10952dab7beddff5bed0986669c9b",
"assets/assets/svg/about.svg": "a9a7d479689dbf5f65dbb69c9244ab0f",
"assets/assets/svg/activity.svg": "6ebd8bacb6623faed654e2867d32f77b",
"assets/assets/svg/alert-triangle.svg": "26eaf5c8257d482b6b579c55fdb5fc15",
"assets/assets/svg/file.svg": "7886f882be982e4e2d0beeebacc55fe9",
"assets/assets/svg/grid.svg": "5d09b75863b459940c1d6b71f165a748",
"assets/assets/svg/help.svg": "fade9a31178540c6e0cbe5b1e8c22670",
"assets/assets/svg/language.svg": "668d34e87781a3d0f14d667601617582",
"assets/assets/svg/logout.svg": "22ae0baeac501d236e8279a64d1bb892",
"assets/assets/svg/maps.svg": "228d512cedbc5e3d23ce0d52784dfeb7",
"assets/assets/svg/password.svg": "0a0fff4244a4e29ff72a8f6f5e8fe6b7",
"assets/assets/svg/pie-chart.svg": "311be3c5f262d2161b34df5629c4fe0e",
"assets/assets/svg/profile.svg": "ae7dcd04a487b1355928fc3c6401b879",
"assets/assets/svg/settings.svg": "6befde1d98ccda039c47a82a9ec9bbda",
"assets/FontManifest.json": "caa123bf65d8d868bb835ed6da45f5a6",
"assets/fonts/Geist-Black.ttf": "9c5e56cb25165bfb0e8cc577d1d134e6",
"assets/fonts/Geist-Bold.ttf": "75147c6480e7a1bd4dc362d43e677477",
"assets/fonts/Geist-Medium.ttf": "3e3add4a622094346f14ed2e203f56a8",
"assets/fonts/Geist-Regular.ttf": "ecc9e05ed90c3ea002ff21a81164815a",
"assets/fonts/Geist-SemiBold.ttf": "d61af3611dd7e4fd9dd08f99e64ec943",
"assets/fonts/Inter-Italic-VariableFont_opsz,wght.ttf": "6dce17792107f0321537c2f1e9f12866",
"assets/fonts/Inter-VariableFont_opsz,wght.ttf": "0a77e23a8fdbe6caefd53cb04c26fabc",
"assets/fonts/MaterialIcons-Regular.otf": "a9acc92bfc571abf7fd07906ecb0298a",
"assets/fonts/Michroma-Regular.ttf": "8ec1f1c2b4c0477cb9356dd35957dca9",
"assets/fonts/ZenDots-Regular.ttf": "19aeeac90e47991dc39f5b75bd054dbd",
"assets/NOTICES": "738e62e7cd916490b60505ea17f4bca6",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Brands-Regular-400.otf": "1fcba7a59e49001aa1b4409a25d425b0",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Regular-400.otf": "b2703f18eee8303425a5342dba6958db",
"assets/packages/font_awesome_flutter/lib/fonts/Font-Awesome-7-Free-Solid-900.otf": "5b8d20acec3e57711717f61417c1be44",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "17177dfb0adfc311429ec901cfc023e7",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "68e6027fc020cf9304b750f2f35a9552",
"icons/Icon-192.png": "de54ba4e34266761007f5e18dd8bdaec",
"icons/Icon-512.png": "78806e78601659cf386e6b41dadc6269",
"icons/Icon-maskable-192.png": "de54ba4e34266761007f5e18dd8bdaec",
"icons/Icon-maskable-512.png": "78806e78601659cf386e6b41dadc6269",
"index.html": "4ef9f4e42a2459e62e214a4db993a113",
"/": "4ef9f4e42a2459e62e214a4db993a113",
"main.dart.js": "90e7eb7d977348f181beecb336154ebe",
"manifest.json": "36de8ec370f444bdb85ee0577ae5f3e8",
"version.json": "f726777075ee030b52e92d48b48680a4"};
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
